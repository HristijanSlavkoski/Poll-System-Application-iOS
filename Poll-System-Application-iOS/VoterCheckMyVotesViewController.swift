//
//  VoterCheckMyVotesViewController.swift
//  Poll-System-Application-iOS
//
//  Created by Hristijan Slavkoski on 12/28/22.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class VoterCheckMyVotesViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    var firebaseAuth: Auth!
    var firebaseUser: FirebaseAuth.User!
    var firebaseDatabase: Database!
    var databaseReference: DatabaseReference!
    var polls = [Poll]()
    var pollIds = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firebaseAuth = Auth.auth()
        firebaseUser = firebaseAuth.currentUser
        firebaseDatabase = Database.database()
        databaseReference = firebaseDatabase.reference()
        
        databaseReference.child("poll").observeSingleEvent(of: .value, with: { (snapshot) in
            for dataSnapshot in snapshot.children.allObjects as! [DataSnapshot] {
                let pollId = dataSnapshot.key as? String
                let valueData = dataSnapshot.value as? NSDictionary
                let title = valueData?["title"] as? String
                let creator = valueData?["creator"] as? String
                let questionArray = valueData?["questions"] as! [NSDictionary]
                var questions: [Question] = []
                for data in questionArray {
                    let question = data["question"] as! String
                    let options = data["options"] as! [String]
                    let questionObject = Question(question: question, options: options)
                    questions.append(questionObject)
                }
                let startAsDictionary = valueData?["start"] as? NSDictionary
                let startDate = startAsDictionary?["time"] as? Double
                let endAsDictionary = valueData?["end"] as? NSDictionary
                let endDate = endAsDictionary?["time"] as? Double
                let iosStartDate = CustomDate(time: startDate!)
                let iosEndDate = CustomDate(time: endDate!)
                
                self.databaseReference.child("vote").child(dataSnapshot.key).child(self.firebaseUser.uid).observeSingleEvent(of: .value) { snapshotVote in
                    if snapshotVote.exists() {
                        //Ako userot ima glasano na toa prashanje
                        //dodaj go
                        let poll = Poll(title: title!, creator: creator!, questions: questions, start: iosStartDate, end: iosEndDate)
                        self.polls.append(poll)
                        self.pollIds.append(pollId!)
                        self.tableView.reloadData()
                    }
                    
                }
            }
        })
        
        let nib = UINib(nibName: "pollCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "pollCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToResults" {
            let destinationVC = segue.destination as! ResultsForVoterViewController
            let polltoBeSend = sender as! PollToBeSent
            destinationVC.poll = polltoBeSend.poll
            destinationVC.pollId = polltoBeSend.pollId
        }
    }
}

extension VoterCheckMyVotesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("you tapped me!")
    }
}

extension VoterCheckMyVotesViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return polls.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pollCell", for: indexPath) as! pollCell
        cell.pollTitle?.text = polls[indexPath.item].title
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let startTempDate = Date(timeIntervalSince1970: polls[indexPath.item].start.time)
        let endTempDate = Date(timeIntervalSince1970: polls[indexPath.item].end.time)
        let fromText = formatter.string(from: startTempDate)
        let toText = formatter.string(from: endTempDate)
        
        cell.from?.text = "From:" + fromText
        cell.to?.text = "To: " + toText
        let currentDate = Date()
        let startDateAsSwiftDate = Date(timeIntervalSince1970: polls[indexPath.item].start.time)
        let endDateAsSwifDate = Date(timeIntervalSince1970: polls[indexPath.item].end.time)
        if currentDate > endDateAsSwifDate {
            //Results
            cell.voteResultButton.setTitle("Results", for: .normal)
        }
        else {
            //Not finished yet
            cell.voteResultButton.setTitle("Not finished yet", for: .normal)
            cell.voteResultButton.isEnabled = false
            cell.voteResultButton.backgroundColor = UIColor.gray
        }
        cell.voteResultClick = {
            let pollToBeSent = PollToBeSent(poll: self.polls[indexPath.item], pollId: self.pollIds[indexPath.item])
            self.performSegue(withIdentifier: "goToResults", sender: pollToBeSent)
        }
        return cell
    }
}

