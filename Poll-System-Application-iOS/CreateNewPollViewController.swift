//
//  CreateNewPollViewController.swift
//  Poll-System-Application-iOS
//
//  Created by Hristijan Slavkoski on 12/26/22.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import Firebase

class CreateNewPollViewController: UIViewController {
    
    @IBOutlet var pollTitlefield: UITextField!
    @IBOutlet var questions: UITableView!
    @IBOutlet weak var startDate: UIDatePicker!
    @IBOutlet weak var endDate: UIDatePicker!
    var firebaseAuth: Auth!
    var firebaseUser: FirebaseAuth.User!
    var firebaseDatabase: Database!
    var databaseReference: DatabaseReference!
    var numOfQuestions: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firebaseAuth = Auth.auth()
        firebaseUser = firebaseAuth.currentUser
        firebaseDatabase = Database.database()
        databaseReference = firebaseDatabase.reference()
        numOfQuestions = 1
        let nib = UINib(nibName: "createNewPollCell", bundle: nil)
        questions.register(nib, forCellReuseIdentifier: "createNewPollCell")
        questions.delegate = self
        questions.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func addNewQuestion(_ sender: Any) {
        numOfQuestions+=1
        questions.reloadData()
    }
    
    
    @IBAction func submitButtonClicked(_ sender: Any) {
        if let poll = createPoll() {
            databaseReference.child("poll").childByAutoId().setValue(poll.toDictionary()) { (error, ref) in
                if error != nil {
                    let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default)
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                } else {
                    // Set up the topic name
//                    let topic = "all_users"
//
//                    // Set up the notification data
//                    let notification = ["title": "New Poll", "body": "A new poll is available"]
//
//                    // Set up the request data
//                    let requestData = ["to": "/topics/\(topic)", "notification": notification] as [String : Any]
//
//                    // Send the request
//                    Messaging.send(requestData) { (error) in
//                        if let error = error {
//                            print("Error sending notification: \(error)")
//                        } else {
//                            print("Notification sent successfully")
//                        }
//                    }
                    let message = "Successfully added new poll"
                    let alert = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
                    self.present(alert, animated: true, completion: nil)
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                        alert.dismiss(animated: true, completion: nil)
                        self.performSegue(withIdentifier: "successfulCreateNewPoll", sender: nil)
                    }
                }
            }
        }
    }
    
    func createPoll() -> Poll? {
        guard let pollTitle = pollTitlefield.text, !pollTitle.isEmpty else {
            let message = "You must insert title"
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            return nil
        }
        let start = CustomDate(time: startDate.date.timeIntervalSince1970)
        let end = CustomDate(time: endDate.date.timeIntervalSince1970)
        
        let startDateAsSwiftDate = Date(timeIntervalSince1970: start.time / 1000.0)
        let endDateAsSwiftDate = Date(timeIntervalSince1970: end.time / 1000.0)
        if startDateAsSwiftDate >= endDateAsSwiftDate {
            let message = "Start date cannot be before end date"
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            return nil
        }
        // Create an empty array of questions to store the questions in the poll
        var pollQuestions: [Question] = []
        
        // Iterate through the rows in the questions table view
        for i in 0..<questions.numberOfRows(inSection: 0) {
            // Get the createNewPollCell at the current index
            let indexPath = IndexPath(row: i, section: 0)
            let cell = questions.cellForRow(at: indexPath) as! createNewPollCell
            
            // Get the question text from the cell's question text field
            guard let questionText = cell.question.text, !questionText.isEmpty else {
                let message = "You must fill all questions that you added"
                let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                return nil
            }
            
            // Create an empty array of answers to store the answers for the current question
            var questionAnswers: [String] = []
            
            // Iterate through the rows in the answers table view
            for j in 0..<cell.answers.numberOfRows(inSection: 0) {
                // Get the createNewQuestionCell at the current index
                let answerIndexPath = IndexPath(row: j, section: 0)
                let answerCell = cell.answers.cellForRow(at: answerIndexPath) as! createNewQuestionCell
                
                // Get the answer text from the cell's answer text field
                guard let answerText = answerCell.answer.text, !answerText.isEmpty else {
                    let message = "You must fill all answers that you added to each question"
                    let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default)
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                    return nil
                }
                
                // Add the answer text to the array of answers
                questionAnswers.append(answerText)
            }
            
            // Create a new question object with the question text and answers
            if questionAnswers.isEmpty {
                let message = "Each question may have at least one answer"
                let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                return nil
            }
            let question = Question(question: questionText, options: questionAnswers)
            
            // Add the question object to the array of questions
            pollQuestions.append(question)
        }
        
        if pollQuestions.isEmpty {
            let message = "You must enter at least one question"
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            return nil
        }
        // Create a new poll object with the poll title, creator, questions, start date, and end date
        let poll = Poll(title: pollTitle, creator: firebaseUser.uid, questions: pollQuestions, start: start, end: end)
        
        return poll
    }
    
}

extension CreateNewPollViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("you tapped me!")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension CreateNewPollViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numOfQuestions
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "createNewPollCell", for: indexPath) as! createNewPollCell
        cell.tapAddAnswer = {
            cell.numOfAnswers+=1
            cell.answers.reloadData()
        }
        return cell
    }
}

extension Poll {
    func toDictionary() -> [String: Any] {
        return [
            "title": title,
            "creator": creator,
            "questions": questions.map { $0.toDictionary() },
            "start": start.toDictionary(),
            "end": end.toDictionary()
        ]
    }
}

extension Question {
    func toDictionary() -> [String: Any] {
        return [
            "question": question,
            "options": options
        ]
    }
}

extension CustomDate {
    func toDictionary() -> [String: Any] {
        return [
            "time": time
        ]
    }
}
