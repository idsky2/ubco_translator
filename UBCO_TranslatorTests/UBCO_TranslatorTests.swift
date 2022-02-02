//
//  UBCO_TranslatorTests.swift
//  UBCO_TranslatorTests
//
//  Created by Bruce Webster on 2/02/22.
//

import XCTest
@testable import UBCO_Translator

class UBCO_TranslatorTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testTranslationModel() throws {
        XCTAssert(Translation(translateText: "Hello World").text == "UBCO Jeemmoo Xoosmf2", "UBCO Hello World Translation matches spec example")
        
        let loremText = "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
        let loremInUBCO = Translation(translateText: loremText).text
        XCTAssert(loremInUBCO == "UBCO Mooseen iiqtuun foomoos tiiv aaneev, doopteedveevuus aafiiqiitdiiph eemiiv.8", "UBCO Lorem Ipsum Translation matches spec example")
        
        XCTAssert(Translation(translateText: loremInUBCO, intoUBCO: false).text == loremText, "Round-trip translation matches original string")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
