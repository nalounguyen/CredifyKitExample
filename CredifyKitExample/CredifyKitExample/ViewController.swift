//
//  ViewController.swift
//  ExampleApp
//
//  Created by Nalou Nguyen on 15/03/2021.
//

import UIKit
import CredifyKit
import Alamofire

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var listOffer: [OfferData] = [OfferData]()
    var userInput: PlatformUserModel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.tableView.rowHeight = UITableView.automaticDimension;
        self.tableView.estimatedRowHeight = 200;
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getInputUser()
    }

    @IBAction func onStartOfferFlow(_ sender: Any) {
        guard let user = self.userInput else { return }
        OfferManager.shared.getOffersConsumer(user: user) { [weak self] result in
            switch result {
            case .success(let offers):
                self?.listOffer = offers
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @IBAction func onRandomUser(_ sender: Any) {
        getInputUser()
    }
    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listOffer.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        cell.textLabel?.text = "CredifyID: \(self.listOffer[indexPath.row].credifyId) \n\nConsumer: \(self.listOffer[indexPath.row].campaign.consumer?.name) \n\nRequired Scope: \(self.listOffer[indexPath.row].evaluationResult.requiredScopes)"
        cell.textLabel?.numberOfLines = 0
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let user = userInput else { return }
        OfferManager.shared.startRedemptionFlow(from: self, offer: self.listOffer[indexPath.row], inputUser: user)
        
    }
    
    private func getInputUser() {
        AF.request("https://dev-demo-api.credify.one/sendo/demo-user")
            .responseJSON { (data) in
                print(data)
                switch data.result {
                case .success(let value):
                    guard let v = value as? [String:Any] else { return }
                    if let id = v["id"] as? Int {
                        let firstName = v["firstName"] as? String ?? ""
                        let lastName =  v["lastName"] as? String ?? ""
                        let email = v["email"] as? String ?? ""
                        let credifyId = v["credifyId"] as? String
                        let phoneNumber = v["phoneNumber"] as? String
                        let phoneCountryCode = v["phoneCountryCode"] as? String
                        
                        self.userInput = PlatformUserModel(id: "\(id)",
                                                           firstName: firstName,
                                                           lastName: lastName,
                                                           email: email,
                                                           credifyId: credifyId,
                                                           countryCode: nil,
                                                           phoneNumber: nil)
                        let alert = UIAlertController(title: "Get user from Provider Success", message: "Info: \n id: \(id) \n firstName: \(firstName) \n lastName: \(lastName) \n email: \(email) \n credifyId: \(credifyId)", preferredStyle: .alert)
                        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                        
                        alert.addAction(ok)
                        self.present(alert, animated: true, completion: nil)
                    }
                case .failure(let err):
                    break
                }
            }
    }
    
}

