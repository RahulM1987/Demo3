
import XCTest
@testable import Demo3

class Demo3Tests: XCTestCase {
    
    var jsondata: RootClass?

    func testGettingJSON() {
        let expect = expectation(description: "JSON data not nil")
        MakeHttpRequest.sharedInstance.dataRequest({ (result) in
            XCTAssertNotNil(result)
            expect.fulfill()
        })
        waitForExpectations(timeout: 10) { (error) in
            if let error = error {
                XCTFail("error: \(error)")
            }
        }
    }
    
    
    func testMockResponseIsNotNil() {
        let bundle = Bundle(for: Demo3Tests.self)
        guard let path = Bundle.path(forResource: "mockdata", ofType: "json", inDirectory: bundle.bundlePath) else {
            XCTFail("Missing file: mockdata.json")
            return
        }
        guard let jsonString = try? String(contentsOfFile: path, encoding: .utf8) else {
            fatalError("Unable to convert UnitTestData.json to String")
        }
        print("The JSON string is: \(jsonString)")
        var root: RootClass?
        let expectation = self.expectation(description: "RootClass")
        MakeHttpRequest.sharedInstance.dataRequest({ (result) in
            XCTAssertNotNil(result)
            root = result
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 5)
        XCTAssertNotNil(root)
    }
    
    
    func testJSONMapping() throws {
        let bundle = Bundle(for: Demo3Tests.self)
        guard let url = bundle.url(forResource: "mockdata", withExtension: "json") else {
            XCTFail("Missing file:mockdata.json")
            return
        }
        let jsondata = try Data(contentsOf: url)
        let json = try JSONSerialization.jsonObject(with: jsondata, options: []) as! [String: Any]
        if let title = json["title"] as? String {
            XCTAssertEqual(title, "About Canada")
        }
                
    }
    
    //Phase 2
    func checkForNilDescription() throws {
        let bundle = Bundle(for: Demo3Tests.self)
        guard let url = bundle.url(forResource: "mockdata", withExtension: "json") else {
            XCTFail("Missing file:mockdata.json")
            return
        }
        let jsondata = try Data(contentsOf: url)
        if let value = String(data: jsondata, encoding: String.Encoding.ascii) {
            if let jsonData = value.data(using: String.Encoding.utf8) {
                
                do {
                    let flash = try! JSONDecoder().decode(RootClass.self, from: jsonData)
                    self.jsondata = flash
                    XCTAssertNil(self.jsondata!.rows?[1].description!)
                }
            }
        }
    }
    
    func checkForNilimageURL() throws {
        let bundle = Bundle(for: Demo3Tests.self)
        guard let url = bundle.url(forResource: "mockdata", withExtension: "json") else {
            XCTFail("Missing file:mockdata.json")
            return
        }
        let jsondata = try Data(contentsOf: url)
        if let value = String(data: jsondata, encoding: String.Encoding.ascii) {
            if let jsonData = value.data(using: String.Encoding.utf8) {
                
                do {
                    let flash = try! JSONDecoder().decode(RootClass.self, from: jsonData)
                    self.jsondata = flash
                    XCTAssertNil(self.jsondata!.rows?[4].imageHref!)
                }
            }
        }
    }
    
    func checkForNilIndex() throws {
        let bundle = Bundle(for: Demo3Tests.self)
        guard let url = bundle.url(forResource: "mockdata", withExtension: "json") else {
            XCTFail("Missing file:mockdata.json")
            return
        }
        let jsondata = try Data(contentsOf: url)
        if let value = String(data: jsondata, encoding: String.Encoding.ascii) {
            if let jsonData = value.data(using: String.Encoding.utf8) {
                
                do {
                    let flash = try! JSONDecoder().decode(RootClass.self, from: jsonData)
                    self.jsondata = flash
                    XCTAssertNil(self.jsondata!.rows?[7])
                }
            }
        }
    }
    
    
}



