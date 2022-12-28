//
//  createNewPollCell.swift
//  Poll-System-Application-iOS
//
//  Created by Hristijan Slavkoski on 12/26/22.
//

import UIKit

class createNewPollCell: UITableViewCell {

    @IBOutlet var question: UITextField!
    @IBOutlet var addAnswer: UIButton!
    @IBOutlet var deleteQuestion: UIButton!
    @IBOutlet var answers: UITableView!
    var numOfAnswers: Int!
    var tapAddAnswer: (() -> Void)? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //TODO:
        //NA POCETOK DA E 0? :)
        numOfAnswers = 2
//        answers.rowHeight = 50 // Set the height of each row to 50 points
//        answers.estimatedRowHeight = UITableView.automaticDimension // Enable automatic row height calculation
        let nib = UINib(nibName: "createNewQuestionCell", bundle: nil)
        answers.register(nib, forCellReuseIdentifier: "createNewQuestionCell")
        answers.delegate = self
        answers.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func addAnswerClicked(_ sender: Any) {
        tapAddAnswer?()
    }
    @IBAction func deleteQuestionClicked(_ sender: Any) {
        // Get the table view that contains this cell
           guard let tableView = self.superview as? UITableView else {
               return
           }
           
           // Get the index path of this cell in the table view
           guard let indexPath = tableView.indexPath(for: self) else {
               return
           }
           
           // Get the view controller that is the table view's data source
           guard let viewController = tableView.dataSource as? CreateNewPollViewController else {
               return
           }
           
           // Decrement the number of questions in the view controller
           viewController.numOfQuestions -= 1
           
           // Delete the row at the given index path from the table view
           tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    //    @objc func addAnswerClicked(_ sender: UIButton) {
//        numOfAnswers+=1
//        answers.reloadData()
//    }
//
//    @objc func deleteQuestionClicked(_ sender: UIButton) {
//        //TODO KIKO
//    }
}

extension createNewPollCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("you tapped me!")
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        // Set the height of each row based on the content it contains
//        let rowHeight: CGFloat = 50.0
//        return rowHeight
//    }
}

extension createNewPollCell: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numOfAnswers
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "createNewQuestionCell", for: indexPath) as! createNewQuestionCell
       // cell.deleteAnswerBlock = {
//            // First, get the index of the cell being deleted
//            let index = indexPath.row
//            // Remove the answer from the data source (an array of answers, for example)
//            self.answers.remove(at: index)
//            // Update the table view to reflect the change in the data source
//            tableView.deleteRows(at: [indexPath], with: .automatic)
            // Get the table view that contains this cell
       // }
        return cell
    }
}
