//
//  AdministratorHomePageViewController.swift
//  Poll-System-Application-iOS
//
//  Created by Hristijan Slavkoski on 12/22/22.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class AdministratorHomePageViewController: UIViewController {

    var firebaseAuth: Auth!
    var firebaseUser: FirebaseAuth.User!
    var firebaseDatabase: Database!
    var databaseReference: DatabaseReference!
    var logoutButton: UIButton!
    var createNewPollButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        firebaseAuth = Auth.auth()
        firebaseUser = firebaseAuth.currentUser
        firebaseDatabase = Database.database()
        databaseReference = firebaseDatabase.reference()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        
    }
    
    
    
    
    @IBAction func logoutClicked(_ sender: Any) {
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        let toastMessage = "Logout successful"
        let alertController = UIAlertController(title: "Success", message: toastMessage, preferredStyle: .alert)
        self.present(alertController, animated: true, completion: nil)

        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            alertController.dismiss(animated: true, completion: nil)
            self.performSegue(withIdentifier: "logoutSuccess", sender: nil)
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
