import Combine
import Foundation

class ViewModel: ObservableObject {
  @Published
  private (set) var title: String = "Cat Facts:"
  @Published
  private (set) var numberOfFacts: String = ""
  @Published
  private (set) var catFacts: String = ""
  @Published
  private (set) var alert: String?
  
  private let dataProvider: CatsDataProvider
  
  init(dataProvider: CatsDataProvider) {
    self.dataProvider = dataProvider
  }
  
  func start() {
    dataProvider.getCatFacts(maxItems: 3) { (result) in
      DispatchQueue.main.async { [weak self] in
        switch result {
        case .success(let catModel):
          self?.numberOfFacts = "Number of Cat Facts: \(catModel.count)"
          var cumulativeString = ""
          for catFact in catModel {
            cumulativeString.append("\n\(catFact.text)")
          }
          self?.catFacts = cumulativeString
        case.failure(let networkError):
          self?.alert = networkError.localizedDescription
        }
      }
    }
  }
}
