//
//  voterResultCell.swift
//  Poll-System-Application-iOS
//
//  Created by Hristijan Slavkoski on 12/29/22.
//

import UIKit

class voterResultCell: UITableViewCell {

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answersTextStackView: UIStackView!
    @IBOutlet weak var answersResultStackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
