//
//  ThreadUtil.swift
//  RXBasic+MVVM
//
//  Created by Sungmin on 2020/09/25.
//  Copyright © 2020 sungmin.joo. All rights reserved.
//

import Foundation

public func executeOnMUainThread(_ execute: @escaping () -> Void) {
    if Thread.isMainThread {
        execute()
    }
    else {
        DispatchQueue.main.async(execute: execute)
    }
}

public func executeOnMainThread(delay: Float64, _ execute: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: execute)
}
