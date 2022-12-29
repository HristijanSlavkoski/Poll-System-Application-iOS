//
//  VoterHomePageViewController.swift
//  Poll-System-Application-iOS
//
//  Created by Hristijan Slavkoski on 12/22/22.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class VoterHomePageViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    var source: String?
    var firebaseAuth: Auth!
    var firebaseUser: FirebaseAuth.User!
    var firebaseDatabase: Database!
    var databaseReference: DatabaseReference!
    var logoutButton: UIButton!
    var checkMyVotes: UIButton!
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
                //let poll = snapshot.value as? [Poll: Any]
                let pollId = dataSnapshot.key as? String
                let valueData = dataSnapshot.value as? NSDictionary

                //let username = value?["username"] as? String ?? ""
                //let user = User(username: username)
                
                
                let title = valueData?["title"] as? String
                let creator = valueData?["creator"] as? String
                //let questions = valueData?["questions"] as? [Question]
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
                //ako sakame da konvertirame od java:
                //let iosStartDate = CustomDate(time: (startDate! / 1000.0))
                //let iosEndDate = CustomDate(time: (endDate! / 1000.0))
                //ako sakame da ne konvertirame od java, tuku od ios:
                let iosStartDate = CustomDate(time: startDate!)
                let iosEndDate = CustomDate(time: endDate!)
                //ZA STORE VO DATA BASE
                //KIKO TODO
                //let javaTimestamp = iosDate.timeIntervalSince1970 * 1000.0
                //let data: [String: Any] = ["timestamp": javaTimestamp]
                //databaseReference.child("date").setValue(data)
                
                
                
                
                print(title!)
                let currentDate = Date()
                let endDateAsSwiftDate = Date(timeIntervalSince1970: iosEndDate.time)
                if endDateAsSwiftDate > currentDate {
                    //Gi dodavame samo aktivnite glasanja
                    //znaci aok zavrsuvaat na datum sto e pogolem
                    self.databaseReference.child("vote").child(dataSnapshot.key).child(self.firebaseUser.uid).observeSingleEvent(of: .value) { snapshotVote in
                            if !snapshotVote.exists() {
                                //Ako userot nema glasano na toa
                                //glasanje, dodaj go toa glasanje
                                //vo listata
                                let poll = Poll(title: title!, creator: creator!, questions: questions, start: iosStartDate, end: iosEndDate)
                                self.polls.append(poll)
                                self.pollIds.append(pollId!)
                                self.tableView.reloadData()
                            }
                        }
                }
            }
        })

        let nib = UINib(nibName: "pollCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "pollCell")
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let message: String
        if source == "RegisterViewController" {
            message = "Register successful"
            let alertController = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
            self.present(alertController, animated: true, completion: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                alertController.dismiss(animated: true, completion: nil)
            }
        } else if source == "LoginViewController" {
            message = "Login successful"
            let alertController = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
            self.present(alertController, animated: true, completion: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                alertController.dismiss(animated: true, completion: nil)
            }
        }
        tableView.reloadData()
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToVotingPage" {
            let destinationVC = segue.destination as! VotingPageViewController
            let polltoBeSend = sender as! PollToBeSent
            destinationVC.poll = polltoBeSend.poll
            destinationVC.pollId = polltoBeSend.pollId
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

extension VoterHomePageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("you tapped me!")
    }
}

extension VoterHomePageViewController: UITableViewDataSource{
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
        if currentDate > startDateAsSwiftDate {
            //Vote
            cell.voteResultButton.setTitle("Vote", for: .normal)
            cell.voteResultButton.backgroundColor = UIColor.green
        }
        else {
            //Coming soon
            cell.voteResultButton.setTitle("Coming soon", for: .normal)
            cell.voteResultButton.isEnabled = false
            cell.voteResultButton.backgroundColor = UIColor.gray
        }
        cell.voteResultClick = {
            let pollToBeSent = PollToBeSent(poll: self.polls[indexPath.item], pollId: self.pollIds[indexPath.item])
            self.performSegue(withIdentifier: "goToVotingPage", sender: pollToBeSent)
        }
        return cell
    }
}
