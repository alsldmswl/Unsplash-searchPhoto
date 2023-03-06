//
//  ViewController.swift
//  unsplash_test
//
//  Created by eun-ji on 2023/03/05.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    var unsplashModel: UnsplashModel?

    var userInput = ""
  
    
    @IBOutlet weak var searchBar: UISearchBar!


    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        requestAPI()
        // Do any additional setup after loading the view.
    }
    
    func loadImage(_ url: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: url) else {return}
        let request = AF.request(url, method: .get)
        request.responseData{ response in
            switch response.result {
            case .success(let imageData):
                    completion(UIImage(data: imageData)) // imageData를 uiimage타입으로 변경
            case.failure(let error):
                print(error)
            }
        }
    }
    

    func requestAPI() {
        
        let url = "https://api.unsplash.com/search/photos"
        let CLIENT_ID = "M99qd0_99-J5U-ZMYLXPAkPqjUik3DpGmoZXYeAFYo4"
        let query = ["query" : userInput, "client_id": CLIENT_ID]
        
        AF.request(url, method: .get, parameters: query, encoding: URLEncoding.default)
            .validate(statusCode: 200..<300)
            .responseJSON { responds in
                print(responds)
                switch responds.result {
                case .success(let res):
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: res, options: .prettyPrinted)
                        self.unsplashModel = try JSONDecoder().decode(UnsplashModel.self, from: jsonData)
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                        
                    }catch(let error){
                        print(error)
                    }
                case .failure(let res):
                    print(res)
                }
            }
    }
    
    

}
extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let hasText = searchBar.text else {return}
        userInput = hasText
        requestAPI()
       
      
        self.view.endEditing(true)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return unsplashModel?.results.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "uncell", for: indexPath) as! uncell
        cell.unLabel.text = unsplashModel?.results[indexPath.row].alt_description
        
        
        if let hasURL = self.unsplashModel?.results[indexPath.row].urls.full{
            self.loadImage(hasURL) {image in
                DispatchQueue.main.async {
                    cell.imgView.image = image
                }
            }
        }
        return cell
    }
    
    
    
}
