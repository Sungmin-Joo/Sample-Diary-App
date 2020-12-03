//
//  DBManager.swift
//  RXBasic+MVVM
//
//  Created by Sungmin on 2020/10/04.
//  Copyright © 2020 sungmin.joo. All rights reserved.
//

import RxSwift
import SQLite3

final class MemoDBManager {

    static let shared = MemoDBManager()

    private var db: OpaquePointer?
    private var dbPath: String
    var memoObservable = BehaviorSubject<[MemoModel]>(value: [])

    private init() {
        db = nil
        dbPath = "Memo.sqlite"

        openDatabase()
        create()

        updateCurrentModel()
    }

    deinit {
        closeDatabase()
    }

    private func openDatabase() {
        do {
            let fileURL = try FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: false
            ).appendingPathComponent(dbPath)

            guard sqlite3_open(fileURL.path, &db) == SQLITE_OK else {
                Logger.log("DB Open FAIL", db as Any, level: .error)
                return
            }
        } catch {
            Logger.log("fileUrl", error, level: .error)
        }
    }

    private func closeDatabase() {
        sqlite3_close(db)
        db = nil
    }

    func create() {
        let query = createQuery
        var createStatement: OpaquePointer?

        guard sqlite3_prepare_v2(db, query, -1, &createStatement, nil) == SQLITE_OK else {
            Logger.log("CREATE TABLE: statement could not be prepared", query, level: .warning)
            return
        }

        guard sqlite3_step(createStatement) == SQLITE_DONE else {
            Logger.log("CREATE TABLE: table could not be created", query, level: .warning)
            return
        }

        sqlite3_finalize(createStatement)
    }

    func read() -> [MemoModel] {
        let query = readQuery
        var readStatement: OpaquePointer?
        var result: [MemoModel] = []

        guard sqlite3_prepare_v2(db, query, -1, &readStatement, nil) == SQLITE_OK else {
            Logger.log("READ TABLE: statement could not be prepared", query, level: .warning)
            return result
        }

        while sqlite3_step(readStatement) == SQLITE_ROW {
            let id = Int(sqlite3_column_int(readStatement, 0))
            let updateDate = Date(timeIntervalSinceReferenceDate: sqlite3_column_double(readStatement, 1))
            let title = String(cString: sqlite3_column_text(readStatement, 2))
            let body = String(cString: sqlite3_column_text(readStatement, 3))
            let tag: [String] = String(
                cString: sqlite3_column_text(readStatement, 4)
            ).split(separator: ",")
                .map { String($0) }
            let isPinned = sqlite3_column_int(readStatement, 5) != 0 ? true : false
            let pinnedIndex = Int(sqlite3_column_int(readStatement, 6))

            let memo = MemoModel(
                id: id,
                updateDate: updateDate,
                title: title,
                body: body,
                tag: tag,
                isPinned: isPinned,
                pinnedIndex: pinnedIndex
            )

            result.append(memo)
        }

        sqlite3_finalize(readStatement)

        return result
    }

    func insert(
        title: String,
        body: String,
        tag: [String],
        isPinned: Bool,
        pinnedIndex: Int
    ) {
        let query = insertQuery
        let isPinnedData = isPinned ? 1 : 0
        var insertStatement: OpaquePointer?

        guard sqlite3_prepare_v2(db, query, -1, &insertStatement, nil) == SQLITE_OK else {
            Logger.log("INSERT TABLE: statement could not be prepared", query, level: .warning)
            return
        }

        // TODO: - DB에 대한 전반적인 공부 후 수정이 필요
        // updateDate, title, body, tag, isPinned, pinnedIndex
        sqlite3_bind_double(insertStatement, 1, Date().timeIntervalSinceReferenceDate)
        sqlite3_bind_text(insertStatement, 2, strdup(title), -1, nil)
        sqlite3_bind_text(insertStatement, 3, strdup(body), -1, nil)
        sqlite3_bind_text(insertStatement, 4, tag.joined(separator: ","), -1, nil)
        sqlite3_bind_int(insertStatement, 5, Int32(isPinnedData))
        sqlite3_bind_int(insertStatement, 6, Int32(pinnedIndex))

        guard sqlite3_step(insertStatement) == SQLITE_DONE else {
            Logger.log("Could not insert row", query, level: .warning)
            return
        }

        updateCurrentModel()

        sqlite3_finalize(insertStatement)
    }

    func delete(memoModel: MemoModel) {
        let query = String(format: deleteQuery, memoModel.id)
        var deleteStatement: OpaquePointer?

        guard sqlite3_prepare_v2(db, query, -1, &deleteStatement, nil) == SQLITE_OK else {
            Logger.log("DELETE TABLE: statement could not be prepared", query, level: .warning)
            return
        }
        guard sqlite3_step(deleteStatement) == SQLITE_DONE else {
            Logger.log("DELETE TABLE: table could not be created", query, level: .warning)
            return
        }

        updateCurrentModel()

        sqlite3_finalize(deleteStatement)
    }

    private func updateCurrentModel() {
        let modelList = read()
        memoObservable
            .onNext(modelList)
    }
}

extension MemoDBManager: Storable {
    var tableName: String {
        "Memo"
    }

    var createQuery: String {
        "CREATE TABLE IF NOT EXISTS \(tableName) (id INTEGER PRIMARY KEY AUTOINCREMENT, updateDate DATE, title TEXT, body TEXT, tag TEXT, isPinned BOOL, pinnedIndex INTEGER)"
    }

    var readQuery: String {
        "SELECT * FROM \(tableName)"
    }

    var insertQuery: String {
        "INSERT INTO \(tableName) (updateDate, title, body, tag, isPinned, pinnedIndex) VALUES (?, ?, ?, ?, ?, ?)"
    }

    var updateQuery: String {
        "UPDATE \(tableName) SET updateDate = '%@' title = '%@', body = '%@', tag = '%@', isPinned = '%@', pinnedIndex = '%@' WHERE identity = '%@'"
    }

    var truncateQuery: String {
        "DELETE FROM \(tableName)"
    }

    var deleteQuery: String {
        "DELETE FROM \(tableName) WHERE identity = '%@'"
    }
}
