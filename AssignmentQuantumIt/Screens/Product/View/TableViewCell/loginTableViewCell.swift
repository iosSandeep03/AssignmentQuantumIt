//
//  loginTableViewCell.swift
//  AssignmentQuantumIt
//
//  Created by Sandeep kumar on 02/09/23.
//

import UIKit

class loginTableViewCell: UITableViewCell {

    @IBOutlet weak var errorLbl: UILabel!
    @IBOutlet weak var textField: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
        func addPadding() {
          
           let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
            textField.leftView = paddingView
            textField.leftViewMode = .always
        }
        // Configure the view for the selected state
    }

}
