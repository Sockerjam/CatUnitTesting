//
//  MockURLProtocol.swift
//  CatUnitTestingTests
//
//  Created by Niclas Jeppsson on 29/04/2021.
//

import Foundation

class MockURLProtocol:URLProtocol{
    
    static var stubResponseData:Data?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        self.client?.urlProtocol(self, didLoad: MockURLProtocol.stubResponseData ?? Data())
        
        self.client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {
    }
}
