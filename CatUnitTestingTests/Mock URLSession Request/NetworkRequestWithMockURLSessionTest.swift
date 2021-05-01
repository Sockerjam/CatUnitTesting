//
//  NetworkRequestWithMockURLSessionTest.swift
//  CatUnitTestingTests
//
//  Created by Niclas Jeppsson on 29/04/2021.
//

import XCTest
@testable import CatUnitTesting

class NetworkRequestWithMockURLSessionTest: XCTestCase {
  
  private var encoder: JSONEncoder!
  
  override func setUp() {
    super.setUp()
    encoder = JSONEncoder()
  }
  
  override func tearDown() {
    encoder = nil
    super.tearDown()
  }
  
  func testNetworkRequest_200Response() throws {
    //GIVEN
    
    //Setting Up URLSession Using A Mock Protocol
    let model = CatModel(text: "Hello cats")
    let encodedModel = try encoder.encode([model])
    let config = URLSessionConfiguration.ephemeral
    config.protocolClasses = [MockURLProtocol.self]
    let urlSession = URLSession(configuration: config)
    MockURLProtocol.requestHandler = { request in
      let response = HTTPURLResponse(url: request.url!,
                                     statusCode: 200,
                                     httpVersion: "2.0",
                                     headerFields: nil)!
      return (response, encodedModel)
    }
    
    //Injecting Mock URLSession to SUT
    let sut = NetworkRequest(urlSession: urlSession)
    
    let url = "https://cat-fact.herokuapp.com/facts"
    
    let expect = expectation(description: "NetworkRequest Response Expectation")
    
    // WHEN
    sut.getItems(url: url, resultType: [CatModel].self) { result in
      
      switch result {
      case let .success(receivedModels):
        XCTAssertEqual(receivedModels.count, 1)
        XCTAssertEqual(receivedModels.first, model)
      case .failure:
        XCTFail("Request failed but while expecting .success result")
      }
      expect.fulfill()
      
    }
    
    self.waitForExpectations(timeout: 01)
  }
  
  func testNetworkRequest_400Response_withBadModelError() throws {
    
    // GIVEN
    
    //Setting Up URLSession Using A Mock Protocol
    let config = URLSessionConfiguration.ephemeral
    config.protocolClasses = [MockURLProtocol.self]
    let urlSession = URLSession(configuration: config)
    let unexpectedErrorData = try encoder.encode("Hi! I am some random error from the server :P")
    MockURLProtocol.requestHandler = { request in
      let response = HTTPURLResponse(url: request.url!,
                                     statusCode: 400,
                                     httpVersion: "2.0",
                                     headerFields: nil)!
      return (response, unexpectedErrorData)
    }
    
    //Injecting Mock URLSession to SUT
    let sut = NetworkRequest(urlSession: urlSession)
    
    let url = "https://cat-fact.herokuapp.com/facts"
    
    let expect = expectation(description: "NetworkRequest Response Expectation")
    
    // WHEN
    sut.getItems(url: url, resultType: [CatModel].self) { result in
      
      switch result {
      case .success:
        XCTFail("Request succeded but was expected to fail")
      case let .failure(error):
        XCTAssertEqual(error, .badModel)
      }
      expect.fulfill()
      
    }
    self.waitForExpectations(timeout: 01)
  }
  
  // Oh look: this test actually fails, highlighting an issue with the implementation of the NetworkRequest -  which ws otherwise going undetected.
  func testNetworkRequest_400Response_withBadURL() throws {
    
    // GIVEN
    
    //Setting Up URLSession Using A Mock Protocol
    let config = URLSessionConfiguration.ephemeral
    config.protocolClasses = [MockURLProtocol.self]
    let urlSession = URLSession(configuration: config)
    let unexpectedErrorData = try encoder.encode("Hi! I am some random error from the server :P")
    MockURLProtocol.requestHandler = { request in
      let response = HTTPURLResponse(url: request.url!,
                                     statusCode: 400,
                                     httpVersion: "2.0",
                                     headerFields: nil)!
      return (response, unexpectedErrorData)
    }
    
    //Injecting Mock URLSession to SUT
    let sut = NetworkRequest(urlSession: urlSession)
    
    let badUrlString = "http://cats.facebook.com/||?!"
    
    let expect = expectation(description: "NetworkRequest Response Expectation")
    
    // WHEN
    sut.getItems(url: badUrlString, resultType: [CatModel].self) { result in
      
      switch result {
      case .success:
        XCTFail("Request succeded but was expected to fail")
      case let .failure(error):
        XCTAssertEqual(error, .badUrl)
      }
      expect.fulfill()
      
    }
    self.waitForExpectations(timeout: 01)
  }
  
}
