//
//  SignUpViewController.swift
//  VoloHackathon
//
//  Created by Brendon Cecilio on 4/21/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var volunteerButton: UIButton!
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    public var userType = ["Volunteer","Poster"]
    private var accountState: AccountState = .newUser
    private var authentication = AuthenticationSession()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureButtons()
    }
    
    private func configureButtons() {
        
        volunteerButton.layer.cornerRadius = 10
        postButton.layer.cornerRadius = 10
    }
    
    @IBAction func volunteerButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func postButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        guard let username = usernameTextField.text, !username.isEmpty, let password = passwordTextField.text, !password.isEmpty else {
            errorLabel.text = "Both textfields must be filled"
            errorLabel.textColor = .systemRed
            return
        }
    }
    
    private func continueSignUpFlow(username: String, password: String) {
        if accountState == .newUser {
            authentication.createNewUser(email: username, password: password) { [weak self] (result) in
                switch result {
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.errorLabel.text = "\(error)"
                        self?.errorLabel.textColor = .systemRed
                    }
                case .success(let authDataResult):
                    DispatchQueue.main.async {
                        self?.createDatabaseUser(authDataResult: authDataResult, userType: self?.userType.first ?? "no userType")
//                        self?.naviga
                    }
                }
            }
        }
    }
    
    private func navigateToVolunteerView() {
        UIViewController.showViewController(storyBoardName: "Volunteer", viewControllerId: "VolunteerTabBarController")
    }
    
    private func navigateToPostView() {
        
    }
    
    private func createDatabaseUser(authDataResult: AuthDataResult, userType: String) {
        DatabaseService.shared.createDatabaseUser(authDataResult: authDataResult, userType: userType) { [weak self] (result) in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.errorLabel.text = "\(error)"
                    self?.errorLabel.textColor = .systemRed
                }
            case .success:
                DispatchQueue.main.async {
                    self?.navigateToVolunteerView()
                }
            }
        }
    }
    
}
