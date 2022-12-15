//
//  LoginViewController.swift
//  Poll-System-Application-iOS
//
//  Created by Hristijan Slavkoski on 12/15/22.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

  
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
  override func viewDidLoad() {
    super.viewDidLoad()

  }

    @IBAction func loginButtonPressed(_ sender: UIButton) {
    guard let email = emailTextField.text, !email.isEmpty else {
      showError(message: "Please enter your email.")
      return
    }

    guard let password = passwordTextField.text, !password.isEmpty else {
      showError(message: "Please enter your password.")
      return
    }

    login(email: email, password: password)
  }

  private func login(email: String, password: String) {
    Auth.auth().signIn(withEmail: email, password: password) { [weak self] (result, error) in
      guard let self = self else { return }

      if let error = error {
        self.showError(message: error.localizedDescription)
      } else {
        self.navigateToNextViewController()
      }
    }
  }

  private func showError(message: String) {
    let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    present(alertController, animated: true, completion: nil)
  }

  private func navigateToNextViewController() {
    //TODO: VOTER OR ADMIN VIEW CONTROLLER
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let nextViewController = storyboard.instantiateViewController(withIdentifier: "NextViewController")
    present(nextViewController, animated: true, completion: nil)
  }

}


