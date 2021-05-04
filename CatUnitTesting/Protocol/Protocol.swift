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


// The name of the protocol and the signature were already generic (taking a T: Codable).
// I therefore went all in changing the name of the func
// Also, I removed the number of items - it is realy no standard to find such indicaiton in a APICall etc.considering it is esier to get ti from the received array count (see my change in the VC).
// I didn't touch the signature, but an improvement would be imo: func getItems<T: [Codable]>(...) so you can omit the [] later on and also it sounds a bit more clear this way since it already state we;l get an array of Codable
protocol APICall {
    func getItems<T:Codable>(url:String, resultType:[T].Type, completion: @escaping (Result<[T], NetworkError>) -> Void)
}
