//
//  CatsDataProvider.swift
//  CatUnitTesting
//
//  Created by Alessandro Manni on 09/05/2021.
//

protocol CatsDataProvider {
  func getCatFacts(maxItems: Int, completion: @escaping (Result<[CatModel], NetworkError>) -> Void)
}

struct CatsDataProviderImpl: CatsDataProvider {
  
  let apiService: APIService
  
  func getCatFacts(maxItems: Int, completion: @escaping (Result<[CatModel], NetworkError>) -> Void) {
    apiService.getItems(url: "https://cat-fact.herokuapp.com/facts",
                        resultType: [CatModel].self) { result in
      completion(result.map {
        Array($0.prefix(maxItems))
      })
    }
  }
  
}
