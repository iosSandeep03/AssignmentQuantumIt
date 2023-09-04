//
//  ArticleViewModel.swift
//  AssignmentQuantumIt
//
//  Created by Sandeep kumar on 03/09/23.
//

import Foundation
import Alamofire
class ArticleViewModel{
    
    var totalArticle: [Article] = []
    
    
    func fetchRequest() {
        AF.request(Constant.API.productURL).responseJSON { [weak self] response in
            guard let self = self else { return }
            switch response.result {
            case .success(let value):
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    let responseData = try JSONSerialization.data(withJSONObject: value)
                    let welcome = try decoder.decode(Welcome.self, from: responseData)
                    self.totalArticle = welcome.articles
                    
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }
    }
}
    
    
    

