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
    
    public var userType = String()
    private var accountState: AccountState = .newUser
    private var authentication = AuthenticationSession()
    private var isSelected: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        configureButtons()
    }
    
    private func configureButtons() {
        volunteerButton.layer.cornerRadius = 10
        postButton.layer.cornerRadius = 10
    }
    
    @IBAction func volunteerButtonPressed(_ sender: UIButton) {
//        ToggleButton.shared.buttonPressed()
//        volunteerButton.layer.borderColor = UIColor.black.cgColor
//        volunteerButton.layer.borderWidth = 1.5
//        let newUserType = userType.first
        userType = "Volunteer"
    }
    
    @IBAction func postButtonPressed(_ sender: UIButton) {
//        ToggleButton.shared.buttonPressed()
//        postButton.layer.borderColor = UIColor.black.cgColor
//        postButton.layer.borderWidth = 1.5
//        let newUserType = userType.last
        userType = "Organization"
    }
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        guard let username = usernameTextField.text, !username.isEmpty, let password = passwordTextField.text, !password.isEmpty else {
            errorLabel.text = "Both textfields must be filled"
            errorLabel.textColor = .systemRed
            return
        }
        continueSignUpFlow(username: username, password: password)
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
                        self?.createDatabaseUser(authDataResult: authDataResult, userType: self?.userType ?? "Volunteer")
                    }
                }
            }
        }
    }
    
    private func navigateToAppView() {
        if userType == "Volunteer" {
            UIViewController.showViewController(storyBoardName: "Volunteer", viewControllerId: "VolunteerTabBarController")
        } else if userType == "Organization" {
            UIViewController.showViewController(storyBoardName: "Organization", viewControllerId: "OrganizationTabBarController")
        }
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
                    self?.navigateToAppView()
                }
            }
        }
    }
    
}
