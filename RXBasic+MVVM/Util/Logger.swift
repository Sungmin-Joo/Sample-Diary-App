//
//  Logger.swift
//  RXBasic+MVVM
//
//  Created by Sungmin on 2020/10/04.
//  Copyright © 2020 sungmin.joo. All rights reserved.
//

import Foundation

enum LogLevel: Error {
    case debug, warning, error
}

class Logger {
    static let logTag = "--Logger--"
    static func log(_ message: String,
                    _ item: Any,
                    level: LogLevel = .debug,
                    file: String = #file,
                    function: String = #function,
                    line: Int = #line ) {

        let logText = "[\(level)] time: \(Date()), file: \(file), function: \(function), line: \(line), message: \(message)"
        debugPrint(logTag)

        guard level == .error else {
            debugPrint(logText)
            return
        }

        assertionFailure(logText)
    }
}
