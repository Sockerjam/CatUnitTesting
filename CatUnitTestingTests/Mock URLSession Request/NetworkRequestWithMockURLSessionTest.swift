//
//  NetworkRequestWithMockURLSessionTest.swift
//  CatUnitTestingTests
//
//  Created by Niclas Jeppsson on 29/04/2021.
//

import XCTest
@testable import CatUnitTesting

class NetworkRequestWithMockURLSessionTest: XCTestCase {

    var sut:NetworkRequest!
    
    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
       sut = nil
    }

    func testNetworkRequest_WithMockURLProtocol(){
        
        //given
        
        //Setting Up URLSession Using A Mock Protocol
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession(configuration: config)
        let jsonString = "[{\"text\":\"ok\"}]"
        MockURLProtocol.stubResponseData = jsonString.data(using: .utf8)
        
        //Injecting Mock URLSession to SUT
        sut = NetworkRequest(urlSession: urlSession)
        
        let url = "https://cat-fact.herokuapp.com/facts"
        let response = "ok"
        
        let expectation = self.expectation(description: "NetworkRequest Reponse Expectaion")
        
        //when
        sut.getCatFacts(url: url, resultType: [CatModel].self) { (result) in
            
            let textResult = result.map{$0[0].text}
            
            //then
            switch textResult {
            case .success(let text):
                XCTAssertEqual(text, response)
                expectation.fulfill()
            default:
                return
            }
        }
        
        self.wait(for: [expectation], timeout: 5)
    }

}
