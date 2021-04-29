//
//  Protocol.swift
//  CatUnitTesting
//
//  Created by Niclas Jeppsson on 28/04/2021.
//

import Foundation

enum NetworkError:Error {
    case badUrl
    case badModel
    case noData
    case noURL
}

protocol APICall {
    var numberOfCatFacts:Int { get set }
    func getCatFacts<T:Codable>(url:String, resultType:[T].Type, completion: @escaping (Result<[T], NetworkError>) -> Void)
}
