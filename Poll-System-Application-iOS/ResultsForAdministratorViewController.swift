//
//  ResultsForAdministratorViewController.swift
//  Poll-System-Application-iOS
//
//  Created by Hristijan Slavkoski on 12/29/22.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ResultsForAdministratorViewController: UIViewController {
    var poll: Poll?
    var pollId: String?
    var firebaseAuth: Auth!
    var firebaseUser: FirebaseAuth.User!
    var firebaseDatabase: Database!
    var databaseReference: DatabaseReference!
    @IBOutlet var questions: UITableView!
    @IBOutlet var pollTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firebaseAuth = Auth.auth()
        firebaseUser = firebaseAuth.currentUser
        firebaseDatabase = Database.database()
        databaseReference = firebaseDatabase.reference()
        let nib = UINib(nibName: "voterResultCell", bundle: nil)
        questions.register(nib, forCellReuseIdentifier: "voterResultCell")
        questions.delegate = self
        questions.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        pollTitle.text = poll?.title
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToMap" {
            let destinationVC = segue.destination as! MapViewController
            destinationVC.pollId = self.pollId
        }
    }
}

extension ResultsForAdministratorViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("you tapped me!")
    }
}

extension ResultsForAdministratorViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (poll?.questions.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "voterResultCell", for: indexPath) as! voterResultCell
        
        let question = poll?.questions[indexPath.item]
        cell.questionLabel.text = question?.question
        databaseReference.child("vote").child(pollId!).observeSingleEvent(of: .value, with: { (snapshot) in
            var answersCount = [Int]()
            answersCount = Array(repeating: 0, count: (question?.options.count)!)
            for dataSnapshot in snapshot.children.allObjects as! [DataSnapshot] {
                if let answersDictionary = (dataSnapshot.value as! NSDictionary).value(forKey: "answers") as? [String] {
                    for (index, answer) in question!.options.enumerated() {
                        if answersDictionary.contains(answer) {
                            answersCount[index] += 1
                        }
                    }
                } else {
                    print("No value for 'answers' key")
                }
            }
            cell.answersResultStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
            for (index, answer) in question!.options.enumerated() {
                let label = UILabel()
                label.text = String(answersCount[index])
                label.tag = indexPath.item
                cell.answersResultStackView.addArrangedSubview(label)
            }
            cell.answersTextStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
            for (index, answer) in question!.options.enumerated() {
                let label = UILabel()
                label.text = answer
                label.tag = indexPath.item
                cell.answersTextStackView.addArrangedSubview(label)
            }
            self.questions.reloadData()
        })
        return cell
    }
}
