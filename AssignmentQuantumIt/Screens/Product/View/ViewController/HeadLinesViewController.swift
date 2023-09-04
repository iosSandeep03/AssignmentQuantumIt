//
//  HeadLinesViewController.swift
//  AssignmentQuantumIt
//
//  Created by Sandeep kumar on 02/09/23.
//

import UIKit
import Alamofire
import Kingfisher

class HeadLinesViewController: UIViewController {
    
    @IBOutlet weak var headLineTableView: UITableView!
    var totalArticle: [Article] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headLineTableView.delegate = self
        headLineTableView.dataSource = self
        fetchRequest()
    }
    
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
                    
                    self.headLineTableView.reloadData() // Reload table view after data is fetched
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }
    }
}

extension HeadLinesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return totalArticle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HeadlinesTableViewCell", for: indexPath) as! HeadlinesTableViewCell
        
        let article = totalArticle[indexPath.row]
        
        cell.titleLbl.text = article.title
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" // Customize the format as per your requirement
        let formattedDate = dateFormatter.string(from: article.publishedAt)
        cell.publishedDate.text = formattedDate // No need for optional binding here
        
        cell.author.text = article.author ?? "N/A"
        cell.DisplayImg.setImage(with: article.urlToImage ?? "https://images.wsj.net/im-843253/social")
        cell.Uiview.layer.cornerRadius = 10.0
        cell.DisplayImg.layer.cornerRadius = 25.0
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedArticle = totalArticle[indexPath.row]
        
        // Initialize DetailsNewsViewController from the storyboard
        if let detailVC = storyboard?.instantiateViewController(withIdentifier: "DetailsNewsViewController") as? DetailsNewsViewController {
            
            // Safely unwrap optionals and provide default values
            detailVC.titlelbl = selectedArticle.title ?? "Title Not Available"
            detailVC.discription = selectedArticle.description ?? "Description Not Available"
            detailVC.authortext = selectedArticle.author ?? "Author Not Available"
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            if let formattedDate = dateFormatter.string(for: selectedArticle.publishedAt) {
                detailVC.updatedatetext = formattedDate
            } else {
                detailVC.updatedatetext = "Date Not Available"
            }
            
            let imageView = UIImageView()
            if let imageURLString = selectedArticle.urlToImage,
               let imageURL = URL(string: imageURLString) {
                imageView.setImage(with: imageURL.absoluteString) // Assuming you have a method to load an image from a URL
                detailVC.DetailsImg = imageView.image
            }
            
            navigationController?.pushViewController(detailVC, animated: true)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}
