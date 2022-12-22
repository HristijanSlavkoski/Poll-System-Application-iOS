//
//  RegisterViewController.swift
//  Poll-System-Application-iOS
//
//  Created by Hristijan Slavkoski on 12/15/22.
//
import UIKit
import FirebaseAuth
import FirebaseDatabase

class RegisterViewController: UIViewController {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        guard let email = emailTextField.text, !email.isEmpty else {
            let alertController = UIAlertController(title: "Error", message: "Please enter your email.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
            return
        }
        
        guard let password = passwordTextField.text, !password.isEmpty else {
            let alertController = UIAlertController(title: "Error", message: "Please enter your password.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
            return
        }
        
        guard let confirmPassword = confirmPasswordTextField.text, !confirmPassword.isEmpty else {
            let alertController = UIAlertController(title: "Error", message: "Please confirm your password.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
            return
        }
        
        if password != confirmPassword {
            let alertController = UIAlertController(title: "Error", message: "Your password and confirm password do not match.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                let user = result?.user
                if let firebaseUser = Auth.auth().currentUser {
                    let newUser = User(type: "voter", email: email)
                    let userDict: [String: Any] = ["type": newUser.type, "email": newUser.email]
                    let databaseReference = Database.database().reference()
                    databaseReference.child("user").child(firebaseUser.uid).setValue(userDict) { (error, _) in
                        if error != nil {
                            let message = "User failed to create created: \(String(describing: user?.email))"
                            let alert = UIAlertController(title: "Registration failed", message: message, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        } else {
                            let message = "User created: \(String(describing: user?.email))"
                            let alert = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
                                DispatchQueue.main.async {
                                    self.performSegue(withIdentifier: "registerSuccess", sender: nil)
                                }
                            })
                            alert.addAction(okAction)
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "registerSuccess" {
            let destinationVC = segue.destination as! VoterHomePageViewController
            destinationVC.source = "RegisterViewController"
        }
    }
}

