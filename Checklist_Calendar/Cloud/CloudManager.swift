//
//  CloudManager.swift
//  Checklist_Calendar
//
//  Created by 한상민 on 2023/05/01.
//

import Foundation
import UIKit
import CloudKit

enum RecordType: String {
    case Event, Todo, Template
}

enum Config {
    /// iCloud container identifier.
    static let containerIdentifier = "iCloud.Checklist_Calendar"
}

@available(iOS 15.0, *)
final class CloudManager {
    // MARK: CloudKit Properties
    /// The CloudKit container we'll use.
    private lazy var container = CKContainer(identifier: Config.containerIdentifier)
    /// For this sample we use the iCloud user's private database.
    private lazy var database = container.privateCloudDatabase
    /// We use a custom record zone to support fetching only changed records.
    private let zone = CKRecordZone(zoneName: "Cherry")
    /// Each subscription requires a unique ID.
    private let subscriptionID = "iCloud.Checklist_Calendar.Subscription"
    /// We use a change token to inform the server of the last time we had the most recent remote data.
    private(set) var lastChangeToken: CKServerChangeToken?

    // MARK: - Public Functions
    /// Loads any stored cache and change token, and creates custom zone and subscription as needed.
    func initialize() async throws {
//        await loadLocalCache()
        loadLastChangeToken()

        try await createZoneIfNeeded()
        try await createSubscriptionIfNeeded()
    }


    func addTask(record: CKRecord, recordType: RecordType, vc: ViewController?) {
        let newRecordID = CKRecord.ID(zoneID: zone.zoneID)
        let newRecord = CKRecord(recordType: recordType.rawValue, recordID: newRecordID)

        container.accountStatus { [unowned self] accountStatus, error in
            if let error = error {
                print(error.localizedDescription)
            }

            // TODO: accountStatus (.couldNotDetermine .available .restricted .noAccount .temporarilyUnavailable)에 따른 분기처리
            if accountStatus == .noAccount {
                DispatchQueue.main.async {
                    let message =
                        """
                        Sign in to your iCloud account to write records.
                        On the Home screen, launch Settings, tap Sign in to your
                        iPhone/iPad, and enter your Apple ID. Turn iCloud Drive on.
                        """
                    let alert = UIAlertController(
                        title: "Sign in to iCloud",
                        message: message,
                        preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                    vc?.present(alert, animated: true)
                }
            } else {
                self.database.save(newRecord) { record, error in
                    if let error = error {
                        // Handle error
                        return
                    }
                    // Record saved successfully
                }
            }
        }
    }

    // MARK: - Local Caching

//    private func loadLocalCache() async {
//        await MainActor.run {
//            UserDefaults.standard.dictionary(forKey: "contacts") as? [String: String] ?? [:]
//        }
//    }
//
//    private func saveLocalCache() async {
//        await MainActor.run {
//            UserDefaults.standard.set(contacts, forKey: "contacts")
//        }
//    }

    private func loadLastChangeToken() {
        guard let data = UserDefaults.standard.data(forKey: "lastChangeToken"),
              let token = try? NSKeyedUnarchiver.unarchivedObject(ofClass: CKServerChangeToken.self, from: data) else {
            return
        }

        lastChangeToken = token
    }

    private func saveChangeToken(_ token: CKServerChangeToken) {
        let tokenData = try! NSKeyedArchiver.archivedData(withRootObject: token, requiringSecureCoding: true)

        lastChangeToken = token
        UserDefaults.standard.set(tokenData, forKey: "lastChangeToken")
    }

    // MARK: - CloudKit Initialization Helpers

    /// Creates the custom zone defined by the `zone` property if needed.
    func createZoneIfNeeded() async throws {
        // Avoid the operation if this has already been done.
        guard !UserDefaults.standard.bool(forKey: "isZoneCreated") else {
            return
        }

        do {
            _ = try await database.modifyRecordZones(saving: [zone], deleting: [])
        } catch {
            print("ERROR: Failed to create custom zone: \(error.localizedDescription)")
            throw error
        }

        UserDefaults.standard.setValue(true, forKey: "isZoneCreated")
    }

    /// Creates a subscription if needed that tracks changes to our custom zone.
    func createSubscriptionIfNeeded() async throws {
        guard !UserDefaults.standard.bool(forKey: "isSubscribed") else {
            return
        }

        // First check if the subscription has already been created.
        // If a subscription is returned, we don't need to create one.
        let foundSubscription = try? await database.subscription(for: subscriptionID)
        guard foundSubscription == nil else {
            UserDefaults.standard.setValue(true, forKey: "isSubscribed")
            return
        }

        // No subscription created yet, so create one here, reporting and passing along any errors.
        let subscription = CKRecordZoneSubscription(zoneID: zone.zoneID, subscriptionID: subscriptionID)
        let notificationInfo = CKSubscription.NotificationInfo()
        notificationInfo.shouldSendContentAvailable = true
        subscription.notificationInfo = notificationInfo

        _ = try await database.modifySubscriptions(saving: [subscription], deleting: [])
        UserDefaults.standard.setValue(true, forKey: "isSubscribed")
    }
}
