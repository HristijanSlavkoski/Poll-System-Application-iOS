//
//  pollCell.swift
//  Poll-System-Application-iOS
//
//  Created by Hristijan Slavkoski on 12/25/22.
//

import UIKit

class pollCell: UITableViewCell {

    @IBOutlet var pollTitle: UILabel!
    @IBOutlet var from: UILabel!
    @IBOutlet var to: UILabel!
    @IBOutlet var voteResultButton: UIButton!
    var voteResultClick: (() -> Void)? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func voteResultButtonClicked(_ sender: Any) {
        voteResultClick?()
    }
}
