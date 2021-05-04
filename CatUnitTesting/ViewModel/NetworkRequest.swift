//
//  CatInfoViewModel.swift
//  CatUnitTesting
//
//  Created by Niclas Jeppsson on 28/04/2021.
//

import Foundation

class NetworkRequest {
    
    //Used when Mocking URLSession. Otherwise .shared
    private var urlSession:URLSession!
    
    init(urlSession:URLSession = .shared){
        self.urlSession = urlSession
    }
}

extension NetworkRequest:APICall {
    
    func getItems<T>(url: String, resultType: [T].Type, completion: @escaping (Result<[T], NetworkError>) -> Void) where T : Decodable, T : Encodable {
        
        guard let url = URL(string: url) else {
            completion(.failure(.noURL))
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("connect.sid=s%3AAmNG7fpO5_vAeLQAn_WeAagId3VXcqOI.JWVkh0VmVzHJYYe90rqypWT91pKEMpoIUsIOGF489Zw", forHTTPHeaderField: "Cookie")
        urlRequest.httpMethod = "GET"
        
        let dataTask = urlSession.dataTask(with: urlRequest) { (data, response, error) in
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            print(response.debugDescription)
            
            var decodedData:[T]?
            do {
                decodedData = try JSONDecoder().decode(resultType.self, from: data)
            }
            catch {
                completion(.failure(.badModel))
                return
            }
            
            guard let successData = decodedData else {
                completion(.failure(.noData))
                return
            }
            completion(.success(successData))
        }
        
        dataTask.resume()
    }
}
