//
//  VotingPageViewController.swift
//  Poll-System-Application-iOS
//
//  Created by Hristijan Slavkoski on 12/28/22.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import CoreLocation

class VotingPageViewController: UIViewController, CLLocationManagerDelegate {
    
    var poll: Poll?
    var pollId: String?
    var firebaseAuth: Auth!
    var firebaseUser: FirebaseAuth.User!
    var firebaseDatabase: Database!
    var databaseReference: DatabaseReference!
    @IBOutlet var questions: UITableView!
    @IBOutlet var pollTitle: UILabel!
    var answers: [String] = []
    var userLocation = CLLocationCoordinate2D()
    
    let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firebaseAuth = Auth.auth()
        firebaseUser = firebaseAuth.currentUser
        firebaseDatabase = Database.database()
        databaseReference = firebaseDatabase.reference()
        let nib = UINib(nibName: "votingPollCell", bundle: nil)
        questions.register(nib, forCellReuseIdentifier: "votingPollCell")
        questions.delegate = self
        questions.dataSource = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        pollTitle.text = poll?.title
        let count = poll?.questions.count
        answers = Array(repeating: "EMPTY", count: count!)
    }
    
    @objc func answerButtonTapped(_ sender: CustomRadioButton) {
        if let stackView = sender.superview as? UIStackView {
            for button in stackView.arrangedSubviews as! [UIButton] {
                button.isSelected = false
            }
        }
        sender.isSelected = true
        answers[sender.index!] = sender.answer!
    }
    
    
    @IBAction func submitVoteClicked(_ sender: Any) {
        if answers.contains("EMPTY") {
            let message = "Please answer all the questions"
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
        else {
            let currentDate = Date()
            let currentDateAsCustomDate = CustomDate(time: currentDate.timeIntervalSince1970)
            let customLocation = CustomLocation(longitude: userLocation.longitude, latitude: userLocation.latitude)
            let vote = Vote(answers: answers, time: currentDateAsCustomDate, location: customLocation)
            
            databaseReference.child("vote").child(pollId!).child(firebaseUser.uid).setValue(vote.toDictionary()) { (error, ref) in
                if error != nil {
                    let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default)
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                } else {
                    let message = "Successfully voted to this poll"
                    let alert = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
                    self.present(alert, animated: true, completion: nil)
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                        alert.dismiss(animated: true, completion: nil)
                        self.performSegue(withIdentifier: "successfullySubmitedVote", sender: nil)
                    }
                }
            }
        }
    }
    
    func getCurrentLocation(completion: @escaping (_ latitude: Double, _ longitude: Double) -> ()) {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        locationCompletion = completion
    }
    
    var locationCompletion: ((Double, Double) -> ())?
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coord = manager.location?.coordinate {
            let center = CLLocationCoordinate2D(latitude: coord.latitude, longitude: coord.longitude)
            userLocation = center
        }
    }
}

extension VotingPageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("you tapped me!")
    }
}

extension VotingPageViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (poll?.questions.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "votingPollCell", for: indexPath) as! votingPollCell
        
        let question = poll?.questions[indexPath.item]
        cell.questionLabel.text = question?.question
        //cell.options = question!.options
        cell.answersButonStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for (index, answer) in question!.options.enumerated() {
            let button = CustomRadioButton(type: .system)
            //let button = UIButton(type: .system)
            button.setTitle("O", for: .normal)
            button.addTarget(self, action: #selector(answerButtonTapped), for: .touchUpInside)
            button.answer = answer
            button.index = indexPath.item
            cell.answersButonStackView.addArrangedSubview(button)
        }
        cell.answersTextStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for (index, answer) in question!.options.enumerated() {
            let label = UILabel()
            label.text = answer
            label.tag = indexPath.item
            cell.answersTextStackView.addArrangedSubview(label)
        }
        return cell
    }
}

extension Vote {
    func toDictionary() -> [String: Any] {
        return [
            "answers": answers,
            "time": time.toDictionary(),
            "location": location.toDictionary()
        ]
    }
}

extension CustomLocation {
    func toDictionary() -> [String: Any] {
        return [
            "longitude": longitude,
            "latitude": latitude
        ]
    }
}
