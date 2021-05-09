//
//  CatInfoViewModelTest.swift
//  CatUnitTestingTests
//
//  Created by Niclas Jeppsson on 28/04/2021.
//

import XCTest
@testable import CatUnitTesting

class APIServiceImplTest: XCTestCase {
  
  var sut:APIServiceImpl!
  
  override func setUpWithError() throws {
    try super.setUpWithError()
    sut = APIServiceImpl()
  }
  
  override func tearDownWithError() throws {
    sut = nil
    try super.tearDownWithError()
  }
  
  func testSuccessfulAPIServiceImpl(){
    
    //given
    let url = "https://cat-fact.herokuapp.com/facts"
    let response = "Cats make about 100 different sounds. Dogs make only about 10."
    let expectation = self.expectation(description: "Successful APIServiceImpl Reponse")
    
    //when
    sut.getItems(url: url, resultType: [CatModel].self) { (result) in
      
      let textResult = result.map{$0[0].text}
      
      //then
      
      switch textResult {
      case .success(let text):
        XCTAssertEqual(response, text)
        expectation.fulfill()
      default:
        return
      }
    }
    
    self.wait(for: [expectation], timeout: 5)
  }
  
  func testNoData_ShouldReturnTrueWhenThereIsNoData(){
    
    //given
    let url = "https://"
    let expectation = self.expectation(description: "Bad Url")
    
    //when
    sut.getItems(url: url, resultType: [CatModel].self) { (result) in
      
      //then
      switch result{
      case .failure(let networkError):
        XCTAssertEqual(networkError, NetworkError.noData)
        expectation.fulfill()
      default:
        return
      }
    }
    self.wait(for: [expectation], timeout: 5)
  }
  
  func testnoURL_ShouldReturnTrueWithEmpyURL(){
    
    //given
    let url = ""
    let expectation = self.expectation(description: "No Url")
    
    //when
    sut.getItems(url: url, resultType: [CatModel].self) { (result) in
      
      switch result {
      case .failure(let networkError):
        XCTAssertEqual(networkError, NetworkError.noURL)
        expectation.fulfill()
      default:
        return
      }
    }
    
    self.wait(for: [expectation], timeout: 5)
  }
  
  func testWrongReponseModel_ShouldReturnTrueWithWrongModel(){
    
    //given
    let url = "https://cat-fact.herokuapp.com/facts"
    let expectation = self.expectation(description: "Bad Model")
    
    //when
    sut.getItems(url: url, resultType: [CatModelMock].self) { (result) in
      
      //then
      switch result {
      case .failure(let error):
        XCTAssertEqual(error, NetworkError.badModel)
        expectation.fulfill()
      default:
        return
      }
    }
    self.wait(for: [expectation], timeout: 5)
  }
  
  func testNumberOfCats_ShouldReturnTrue(){
    
    //given
    let number = 5
    let url = "https://cat-fact.herokuapp.com/facts"
    let expectation = self.expectation(description: "Number of Cats")
    
    //when
    sut.getItems(url: url, resultType: [CatModel].self) { (result) in
      
      guard case .success(let items) = result else {
        XCTFail()
        return
      }
      
      XCTAssertEqual(items.count, number)
      expectation.fulfill()
    }
    
    self.wait(for: [expectation], timeout: 5)
    
  }
  
}
