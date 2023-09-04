//
//  HeadlinesTableViewCell.swift
//  AssignmentQuantumIt
//
//  Created by Sandeep kumar on 03/09/23.
//

import UIKit

class HeadlinesTableViewCell: UITableViewCell {

    @IBOutlet weak var Uiview: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var publishedDate: UILabel!
    
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var DisplayImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
       
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
