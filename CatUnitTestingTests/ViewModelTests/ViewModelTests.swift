//
//  ViewModelTests.swift
//  CatUnitTestingTests
//
//  Created by Alessandro Manni on 09/05/2021.
//

import XCTest
import Combine
@testable import CatUnitTesting

class ViewModelTests: XCTestCase {
  private var dataProvider: MokcCatsDataProvider!
  private var viewModel: ViewModel!
  private var cancellables: Set<AnyCancellable>!
  
  override func setUp() {
    super.setUp()
    cancellables = Set<AnyCancellable>()
    dataProvider = MokcCatsDataProvider()
    viewModel = ViewModel(dataProvider: dataProvider)
  }

  override func tearDown() {
    viewModel = nil
    dataProvider = nil
    cancellables = nil
    super.tearDown()
  }
  
  func test_WhenStartIsInvoked_hitsDataProvider() {
    viewModel.start()
    XCTAssertEqual(dataProvider.didInvokeGetCatFacts, 1)
  }
  
  // Little note for Niclas: We immediately receive the initial value and then the one from the DataProvider - hence we need the expectation and fullfilmentCount in order to wait till the 2nd value is received. But a part the little complication there are no complex networking mocks to handle etc. all is done with a rather dumb MokcCatsDataProvider thanks to dependency inversion (confomrance to protocol atsDataProvider). How convenient is that?
  func test_WhenDataProviderResultIsSuccess_ViewModelPropertiesAreSetAccordingly() {
    let numberOfItems = 2
    let ext = expectation(description: "Waiting to receive first fetched value")
    ext.expectedFulfillmentCount = 2
    dataProvider.result = .success(catModels(number: numberOfItems))
    viewModel.start()
    viewModel.$numberOfFacts.sink { _ in
      ext.fulfill()
    }.store(in: &cancellables)
    waitForExpectations(timeout: 01)
    XCTAssertEqual(viewModel.title, "Cat Facts:")
    XCTAssertEqual(viewModel.numberOfFacts , "Number of Cat Facts: \(numberOfItems)")
    XCTAssertEqual(viewModel.catFacts, "\nModel n1\nModel n2")
    XCTAssertNil(viewModel.alert)
  }
  
  func test_WhenDataProviderResultIsFailure_ViewModelPropertiesAreSetAccordingly() {
    let ext = expectation(description: "Waiting to receive first fetched value")
    ext.expectedFulfillmentCount = 2
    dataProvider.result = .failure(NetworkError.noData)
    viewModel.start()
    viewModel.$alert.sink { _ in
      ext.fulfill()
    }.store(in: &cancellables)
    waitForExpectations(timeout: 01)
    XCTAssertEqual(viewModel.title, "Cat Facts:")
    XCTAssertEqual(viewModel.numberOfFacts, "")
    XCTAssertEqual(viewModel.catFacts, "")
    XCTAssertNotNil(viewModel.alert)
  }
  
  private func catModels(number: Int) -> [CatModel] {
    Range(1...number).map {
      CatModel(text: "Model n\($0)")
    }
  }
}


final private class MokcCatsDataProvider: CatsDataProvider {
  var result: Result<[CatModel], NetworkError> = .failure(NetworkError.noData)
  private(set) var didInvokeGetCatFacts = 0
  
  func getCatFacts(maxItems: Int, completion: @escaping (Result<[CatModel], NetworkError>) -> Void) {
    didInvokeGetCatFacts += 1
    completion(result)
  }
}

