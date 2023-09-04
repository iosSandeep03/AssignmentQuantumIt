//
//  DetailsNewsViewController.swift
//  AssignmentQuantumIt
//
//  Created by Sandeep kumar on 03/09/23.
//

import UIKit

class DetailsNewsViewController: UIViewController {
   
    
   
    @IBOutlet weak var updatedDateLbl: UILabel!
    @IBOutlet weak var Authorlbl: UILabel!
    @IBOutlet weak var DiscriptionLbl: UILabel!
    @IBOutlet weak var TitleLbl: UILabel!
    @IBOutlet weak var DetailsImgView: UIImageView!
    
    @IBOutlet weak var backBtn: UIButton!
    var updatedatetext : String?
    var authortext : String?
    var discription : String?
    var titlelbl : String?
    var DetailsImg : UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        TitleLbl.text = titlelbl
        DiscriptionLbl.text = discription
        Authorlbl.text = authortext
        updatedDateLbl.text = updatedatetext
        DetailsImgView.image = DetailsImg
        
        
        // Do any additional setup after loading the view.
    }
   
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
  
}
