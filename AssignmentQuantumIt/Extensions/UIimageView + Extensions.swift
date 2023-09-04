//
//  UIimageView + Extensions.swift
//  AssignmentQuantumIt
//
//  Created by Sandeep kumar on 03/09/23.
//

import UIKit
import Kingfisher

extension UIImageView{
    func setImage(with urlstring : String){
        guard let url = URL.init(string:urlstring) else
        {
            return
            
        }
        
        let resource = ImageResource(downloadURL: url, cacheKey: urlstring)
       kf.indicatorType = .activity
        kf.setImage(with: resource)
    }
}
