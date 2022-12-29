//
//  votingPollCell.swift
//  Poll-System-Application-iOS
//
//  Created by Hristijan Slavkoski on 12/28/22.
//

import UIKit

class votingPollCell: UITableViewCell {
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answersTextStackView: UIStackView!
    @IBOutlet weak var answersButonStackView: UIStackView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
