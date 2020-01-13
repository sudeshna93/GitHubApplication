//
//  ShowDetailsVC.swift
//  GitHubApplication
//
//  Created by Consultant on 1/11/20.
//  Copyright © 2020 Consultant. All rights reserved.
//

import UIKit

class ShowDetailsVC: UIViewController {
    
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var joinDateLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var avatarImgView: UIImageView!
    @IBOutlet weak var repotableView: UITableView!
    @IBOutlet weak var repoSearchBar: UISearchBar!
    var repoUrlString = String()
    var imgUrlString = String()
    var nameString = String()
    var userinfoUrl = String()
    var gitUrlString = String()
    var userinfo : UserInfo?
    let networker = DecodableNetwork()
    //all the repository
     var allrepository: [Repository] = []
    //filtered/unfiltered repository
    private var _repository: [Repository] = []
      var isSearching : Bool = false
    var searchWorkItem: DispatchWorkItem!
    
    //UiView  LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //SearchBar Configure
        repoSearchBar.delegate = self as UISearchBarDelegate
        repoSearchBar.returnKeyType = UIReturnKeyType.done
        
        self.avatarImgView.image = nil
        let url = URL(string: imgUrlString)!
        downloadImage(url: url)
        self.usernameLabel.text = "Name: " + nameString
        downloadRepo {_ in
                  DispatchQueue.main.async {
                      self.repotableView.reloadData()
                  }
              }
        
        download {_ in
            DispatchQueue.main.async {
                if let email = self.userinfo?.email {
                    self.emailLabel.text = "Email: " + email
                }
                if let location = self.userinfo?.location {
                    self.locationLabel.text = "Location: " + location
                }
                if let followers = self.userinfo?.followers {
                    self.followersLabel.text = "Followers: " + "\(followers)"
                }
                if let following = self.userinfo?.following {
                    self.followingLabel.text = "Following: " + "\(following)"
                }
                
                
                if let joinDate = self.userinfo?.joinDate {
                    let myDateString: String = joinDate // etcetc
                    if let myDate = myDateString.toDate() {
                        let myString = myDate.toString()
                        self.joinDateLabel.text = "JoinDate: " + myString
                    }
                    
                }
                if let bio = self.userinfo?.bio {
                    self.bioLabel.text = "Bio: " + bio
                }
            }
        }
    }
    
    //Function for get Data from a Url
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
   // Function for downloading image of a particular Github user
    func downloadImage(url: URL){
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() {
                self.avatarImgView.image = UIImage(data: data)
            }
        }
    }

    //Function for downloading information about a github user
    func download(_ completion: @escaping (UserInfo) -> Void) {
        let url = URL(string: userinfoUrl )!
        networker.get(type: UserInfo.self, url: url){
            (result) in
            self.userinfo = result!
            completion(self.userinfo!)
            
        }
    }
    //Function for downloading repositories for a particular Github User
    func downloadRepo (_ completion: @escaping ([Repository]) -> Void) {
        let url = URL(string: repoUrlString + "?per_page=100")!
        networker.get(type: [Repository].self, url: url) { (result) in
            print("finished download")
            self.allrepository = result!
            completion(self.allrepository)
            self._repository = self.allrepository
        }
    }
    
}

extension ShowDetailsVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _repository.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = repotableView.dequeueReusableCell(withIdentifier: "RepoDisplayCell")
        
        if cell == nil {
            tableView.register(UINib(nibName: "RepoDisplayCell", bundle: nil), forCellReuseIdentifier: "RepoDisplayCell")
            cell = (tableView.dequeueReusableCell(withIdentifier: "RepoDisplayCell") as? RepoDisplayCell)!
        }

        let row = indexPath.row
        setupName(for: cell as! RepoDisplayCell, at: row)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let urlstring = _repository[indexPath.row].gitUrl {
            self.gitUrlString = urlstring
        }
        if let url = URL(string: gitUrlString), UIApplication.shared.canOpenURL(url) {
           if #available(iOS 10.0, *) {
               UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
               UIApplication.shared.openURL(url)
            }
        }
    }
    
    //Function for Setup Name in tableview cell to set repository name, Number of fork, Number of star for a particuler github repository
    func setupName(for cell: RepoDisplayCell, at row: Int){
        if let reponame = _repository[row].repoName{
             cell.repositoryName.text = "Repo: " + reponame
        }
        if let forkNum = _repository[row].numberofForks{
             cell.numberOfStar.text = "Fork: " + "\(forkNum)"
        }
        if let starNum = _repository[row].numberofStar {
            cell.numberOfForks.text = "Star: " + "\(starNum)"
        }
        
    }
    //Search Function for searching over repository
    func search(query: String) -> [Repository] {
        var repository : [Repository] = []
        if query.isEmpty {
            isSearching = false
            repository = allrepository
        }
        
        else{
            repository = allrepository.filter{ $0.repoName?.lowercased().prefix(query.count) == query.lowercased().prefix(query.count) }
            isSearching = true
        }
         _repository = repository
        return _repository
    }
    
}

extension ShowDetailsVC: UISearchBarDelegate {
    
    //MARK: SearchBar Delegate Function
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
       let query = self.repoSearchBar.text!
       if self.repoSearchBar.text?.isEmpty == false {
           searchWorkItem?.cancel()
           searchWorkItem = DispatchWorkItem(block: {
               print("Did Start searching with term: \(query)")
               
                DispatchQueue.main.async {
                    self.search(query: self.repoSearchBar.text!)
                    self.repotableView.reloadData()
                }

           })
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 1.0, execute: searchWorkItem)
       }
       else{
            search(query: "")
            self.repotableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        search(query: "")
        self.repotableView.reloadData()
    }
}




