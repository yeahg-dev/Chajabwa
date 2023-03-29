//
//  app_show_roomUITests.swift
//  app-show-roomUITests
//
//  Created by Moon Yeji on 2022/09/12.
//

import XCTest

class app_show_roomUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_AppDetailViewModel_performace() throws {
    
        let measureOption = XCTMeasureOptions()
        measureOption.invocationOptions = [.manuallyStop]
        
        let app = XCUIApplication()
        app.launch()
        
        let searchField = app.navigationBars["Search App"].searchFields["ID를 입력해주세요"]
        searchField.tap()
        searchField.typeText("544007664")
        
        let searchButton = app/*@START_MENU_TOKEN@*/.buttons["Search"]/*[[".keyboards",".buttons[\"search\"]",".buttons[\"Search\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/
        searchButton.tap()
        
        measure(metrics: [
            XCTOSSignpostMetric.scrollingAndDecelerationMetric, XCTCPUMetric.init()],
                options: measureOption) {
            let appDetailCollectionView = app.collectionViews.firstMatch

            appDetailCollectionView.swipeUp(velocity: .fast)
            appDetailCollectionView.swipeDown(velocity: .fast)
            appDetailCollectionView.swipeUp(velocity: .slow)
            appDetailCollectionView.swipeDown(velocity: .slow)
          
            stopMeasuring()
        }

    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
