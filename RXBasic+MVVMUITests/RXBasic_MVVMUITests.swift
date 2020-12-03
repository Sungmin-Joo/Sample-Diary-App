//
//  RXBasic_MVVMUITests.swift
//  RXBasic+MVVMUITests
//
//  Created by Sungmin on 2020/09/22.
//  Copyright © 2020 sungmin.joo. All rights reserved.
//

import XCTest

class RXBasic_MVVMUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }

    func testMockData() {
        let testModel: [MemoModel] = decodeJsonData(jsonFileName: "mockData")
        testModel.forEach {
            XCTAssertFalse($0.id < 0, "id value must be greater than zero")
        }
    }

    func decodeJsonData<T: Codable>(jsonFileName fileName: String) -> T {
        var data = Data()
        let filename = "\(fileName).json"

        guard let file = Bundle(for: type(of: self)).url(forResource: filename, withExtension: nil) else {
            fatalError("[Error]: decodeJsonData - Json File Not Found")
        }

        do {
            data = try Data(contentsOf: file)
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            fatalError("[Error]: \(error)")
        }
    }
}

