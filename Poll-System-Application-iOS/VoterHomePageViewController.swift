//
//  VoterHomePageViewController.swift
//  Poll-System-Application-iOS
//
//  Created by Hristijan Slavkoski on 12/22/22.
//

import UIKit

class VoterHomePageViewController: UIViewController {

    var source: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let message: String
            if source == "RegisterViewController" {
                message = "Register successful"
            } else {
                message = "Login successful"
            }
        let alert = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
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
