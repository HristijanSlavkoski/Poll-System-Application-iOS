//
//  createNewQuestionCell.swift
//  Poll-System-Application-iOS
//
//  Created by Hristijan Slavkoski on 12/26/22.
//

import UIKit

class createNewQuestionCell: UITableViewCell {

    @IBOutlet var answer: UITextField!
    @IBOutlet var deleteAnswer: UIButton!
    var deleteAnswerBlock: (() -> Void)? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func deleteAnswerClicked(_ sender: Any) {
        deleteAnswerBlock?()
        guard let tableView = self.superview as? UITableView else {
               return
           }
           
           // Get the index path of this cell in the table view
           guard let indexPath = tableView.indexPath(for: self) else {
               return
           }
           
           // Get the view controller that is the table view's data source
           guard let viewController = tableView.dataSource as? createNewPollCell else {
               return
           }
           
           // Decrement the number of questions in the view controller
        viewController.numOfAnswers -= 1
           
           // Delete the row at the given index path from the table view
           tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
