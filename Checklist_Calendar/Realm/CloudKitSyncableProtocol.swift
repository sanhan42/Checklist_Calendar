//
//  CloudKitSyncableProtocol.swift
//  Checklist_Calendar
//
//  Created by 한상민 on 2023/05/02.
//

import Foundation
import CloudKit
import RealmSwift

protocol CloudKitSyncable {
    var recordID: CKRecord.ID { get }
    var synced: Date? { get }
    var modified: Date { get }
    var deleted: Date? { get }
    var record: CKRecord { get }
    var recordChangeTag: String? { get }
    var recordOwnerName: String? { get }
}
