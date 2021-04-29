//
//  ViewController.swift
//  CatUnitTesting
//
//  Created by Niclas Jeppsson on 28/04/2021.
//

import UIKit

class ViewController: UIViewController {
    
    //Text Label
    let textLabel:UILabel = {
        let textLabel = UILabel()
        textLabel.font = UIFont(name: "Helvetica", size: 20)
        textLabel.textAlignment = .center
        textLabel.adjustsFontSizeToFitWidth = true
        textLabel.numberOfLines = 10
        textLabel.textColor = .black
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        return textLabel
    }()
    
    //Dependency Inversion
    var networkRequest:APICall!
    
    //Initialises networkRequest
    init(catInfoViewModel:APICall){
        super.init(nibName: nil, bundle: nil)
        self.networkRequest = catInfoViewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //View Setup
        setup()
        
        //Networking
        networkRequest.getCatFacts(url: "https://cat-fact.herokuapp.com/facts", resultType: [CatModel].self) { (result) in
            
            DispatchQueue.main.async {
                self.textLabel.text = "Cat Facts: "
                switch result {
                case .success(let catModel):
                    for catFact in catModel {
                        self.textLabel.text!.append("\n\(catFact.text)")
                    }
                case.failure(let networkError):
                    print(networkError)
                    self.textLabel.text = networkError.localizedDescription
                }
            }
        }
        
    }
    
    //View Setup
    private func setup(){
        
        view.backgroundColor = .white
        
        view.addSubview(textLabel)
        
        NSLayoutConstraint.activate([textLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor), textLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor), textLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor), textLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor)])
    }
    
    
}
