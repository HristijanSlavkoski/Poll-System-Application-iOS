//
//  LoginViewController.swift
//  Poll-System-Application-iOS
//
//  Created by Hristijan Slavkoski on 12/15/22.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

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
                let user = result?.user
                //let message = "User successfuly logged in: \(user?.email)"
                //self.showSuccessMessage(message: message)
                let userUID = Auth.auth().currentUser!.uid
                var ref: DatabaseReference!
                ref = Database.database().reference()
                ref.child("user").child(userUID).observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    if let value = snapshot.value as? [String: Any], let role = value["role"] as? String{
                        if role == "voter"
                        {
                            //Voter
                            DispatchQueue.main.async {
                                self.performSegue(withIdentifier: "loginSuccessVoter", sender: nil)
                            }
                        }
                        else{
                            //Administrator
                            DispatchQueue.main.async {
                                self.performSegue(withIdentifier: "loginSuccessAdmin", sender: nil)
                            }
                        }
                    }
                })
            }
        }
    }
    
    private func showError(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    private func showSuccessMessage(message: String) {
        let alertController = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "registerSuccess" {
            let destinationVC = segue.destination as! VoterHomePageViewController
            destinationVC.source = "LoginViewController"
        }
    }
}
