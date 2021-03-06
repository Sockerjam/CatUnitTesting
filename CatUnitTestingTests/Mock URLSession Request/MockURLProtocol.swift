//
//  MockURLProtocol.swift
//  CatUnitTestingTests
//
//  Created by Niclas Jeppsson on 29/04/2021.
//

import Foundation

class MockURLProtocol: URLProtocol{
  
  static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data) )?
  
  override class func canInit(with request: URLRequest) -> Bool {
    return true
  }
  
  override class func canonicalRequest(for request: URLRequest) -> URLRequest {
    return request
  }
  
  // Added a proper handler so that now we can also test the unhappy paths (errors and such)
  override func startLoading() {
    guard let handler = MockURLProtocol.requestHandler else {
      
      return
    }
    do {
      let (response, data)  = try handler(request)
      client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
      client?.urlProtocol(self, didLoad: data)
      client?.urlProtocolDidFinishLoading(self)
    } catch  {
      client?.urlProtocol(self, didFailWithError: error)
    }
  }
  
  override func stopLoading() {
  }
}
