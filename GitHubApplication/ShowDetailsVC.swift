//
//  ShowDetailsVC.swift
//  GitHubApplication
//
//  Created by Consultant on 1/11/20.
//  Copyright © 2020 Consultant. All rights reserved.
//

import UIKit

class ShowDetailsVC: UIViewController, UISearchBarDelegate {
    
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
                    self.joinDateLabel.text = "JoinDate: " + joinDate
                }
                if let bio = self.userinfo?.bio {
                    self.bioLabel.text = "Bio: " + bio
                }
            }
        }
       
    }
    
    //MARK: SearchBar Delegate Function
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        search(query: self.repoSearchBar.text!)
        self.repotableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
       
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        search(query: "")
        self.repotableView.reloadData()
    }
    
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(url: URL){
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() {
                self.avatarImgView.image = UIImage(data: data)
            }
        }
    }

    func download(_ completion: @escaping (UserInfo) -> Void) {
        let url = URL(string: userinfoUrl )!
        networker.get(type: UserInfo.self, url: url){
            (result) in
            self.userinfo = result!
            completion(self.userinfo!)
            
        }
    }
    
    func downloadRepo (_ completion: @escaping ([Repository]) -> Void) {
//        if repository.isEmpty == false{
//            completion(repository)
//            return
//        }
        let url = URL(string: repoUrlString)!
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
    
    func setupName(for cell: RepoDisplayCell, at row: Int){
        if let reponame = _repository[row].repoName{
             cell.repositoryName.text = "Repo:" + reponame
        }
        if let forkNum = _repository[row].numberofForks{
             cell.numberOfStar.text = "Fork: " + "\(forkNum)"
        }
        if let starNum = _repository[row].numberofStar {
            cell.numberOfForks.text = "Star: " + "\(starNum)"
        }
        
    }
    
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




