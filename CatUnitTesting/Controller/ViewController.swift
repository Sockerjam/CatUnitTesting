//
//  ViewController.swift
//  CatUnitTesting
//
//  Created by Niclas Jeppsson on 28/04/2021.
//
import Combine
import SwiftUI
import UIKit

class ViewController: UIViewController {
  
  //Text Info Label
  private let textLabel:UILabel = {
    let textLabel = UILabel()
    textLabel.font = UIFont(name: "Helvetica", size: 20)
    textLabel.textAlignment = .center
    textLabel.adjustsFontSizeToFitWidth = true
    textLabel.numberOfLines = 10
    textLabel.textColor = .black
    textLabel.translatesAutoresizingMaskIntoConstraints = false
    return textLabel
  }()
  
  //Text Number Label
  private let numberOfCats:UILabel = {
    let numberOfCats = UILabel()
    numberOfCats.font = UIFont.boldSystemFont(ofSize: 20)
    numberOfCats.textAlignment = .center
    numberOfCats.translatesAutoresizingMaskIntoConstraints = false
    return numberOfCats
  }()
  
  private var cancellables: Set<AnyCancellable> = []
  @ObservedObject
  private var viewModel: ViewModel
  
  //Initialises APIServiceImpl
  init(viewModel: ViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    viewModel.start()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    viewModel.$alert.sink { [weak self] text in
      guard let text = text else { return }
      let alert = UIAlertController(title: "Error", message: text, preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default))
      self?.present(alert, animated: true, completion: nil)
    }.store(in: &cancellables)
  }
  
  //View Setup
  private func setup(){
    
    view.backgroundColor = .white
    
    view.addSubview(textLabel)
    view.addSubview(numberOfCats)
    
    NSLayoutConstraint.activate([textLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor), textLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor), textLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor), textLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor), numberOfCats.bottomAnchor.constraint(equalTo: textLabel.topAnchor), numberOfCats.centerXAnchor.constraint(equalTo: view.centerXAnchor)])
    
    viewModel.$title.sink { [weak self] in
      self?.title = $0
    }.store(in: &cancellables)
    
    viewModel.$numberOfFacts.sink { [weak self] in
      self?.numberOfCats.text = $0
    }.store(in: &cancellables)
    
    viewModel.$catFacts.sink { [weak self] in
      self?.textLabel.text = $0
    }.store(in: &cancellables)
  }
}
