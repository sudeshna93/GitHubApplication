//
//  ViewController.swift
//  GitHubApplication
//
//  Created by Consultant on 1/10/20.
//  Copyright © 2020 Consultant. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK:- Properties
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var controller : UserControllerProtocol! = UserController()
    let networker = DecodableNetwork()
    var userinfo : UserInfo?
    var page = 1
    var searchWorkItem: DispatchWorkItem!
    
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }

}

extension ViewController: UITableViewDataSource, UITableViewDelegate{
    //MARK:TableView Delegate Methods
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           if controller.githubs.count > 0{
            return controller.githubs[0].items.count
           }
           else {
               return 0
           }
       }
       
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       var cell = tableView.dequeueReusableCell(withIdentifier: "UserDisplayCell")
          if cell == nil {
              tableView.register(UINib(nibName: "UserDisplayCell", bundle: nil), forCellReuseIdentifier: "UserDisplayCell")
              cell = (tableView.dequeueReusableCell(withIdentifier: "UserDisplayCell") as? UserDisplayCell)!
          }
          let row = indexPath.row
          setupName(for: cell as! UserDisplayCell , at: row)
          setupImage(for: cell as! UserDisplayCell, at: row)
          setupNumber(for: cell as! UserDisplayCell, at: row)
          return cell!
      }
    //Function called when selecting one cell of tableview
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let showDetailsVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ShowDetailsVC") as? ShowDetailsVC
        
        guard let index = tableView.indexPathForSelectedRow?.row else { return }
        showDetailsVC?.repoUrlString = controller.githubs[0].items[index].repoUrl ?? "repo missing"
        showDetailsVC?.imgUrlString = controller.githubs[0].items[index].imageUrl ?? "image missing"
        showDetailsVC?.nameString = controller.githubs[0].items[index].userName ?? "name missing"
        showDetailsVC?.userinfoUrl = controller.githubs[0].items[index].url ?? "url missing"
        self.navigationController?.pushViewController(showDetailsVC!, animated: true)
    }
    
    //Function for Setup Name in tableview cell to set name of a particuler github user
      func setupName(for cell: UserDisplayCell, at row: Int){
          if let name = controller.githubs[0].items[row].userName ,
              let _ = controller.githubs[0].items[row].repoUrl
             {
              cell.userName.text = name
          }
          else{
              cell.userName.text = "loading names"
          }
          
      }
    
    //Function for Setup number of repository of a particular user in tableview cell
    func setupNumber(for cell: UserDisplayCell, at row: Int){
        if  let urls = controller.githubs[0].items[row].url {
            downloadRepoNumber(url: URL(string: urls)!) {_ in
                
                DispatchQueue.main.async {
                    cell.repoNumberLabel.text = "Repo: " + "\(self.userinfo?.repocount ?? 0)"
                }
            }
        }
    }
     //Function for Setup image in tableview cell to set image from url of a particuler github user
    func setupImage(for cell: UserDisplayCell, at row: Int){
        let github = controller.githubs[0]
        if let _ = cell.prevTag,
            let urlString = github.items[row].imageUrl{
            if let oldURL = URL(string: urlString){
                controller.cancelTask(oldURL)
            }
        }
        
        //set image
        cell.imgView.image = nil
        if let image = github.items[row].imageUrl,
            let url = URL(string: image) {
            //set the tag to keep of a current download task
            cell.prevTag = row
            controller.getPicture(url) { (data) in
                guard let data = data else {
                    return
                }
                
                DispatchQueue.main.async {
                    cell.imgView.image = UIImage(data: data)
                }
            }
        }
    }
       
}

extension ViewController: UISearchBarDelegate{
    
    //MARK: Searchbar delegate Function
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let query = self.searchBar.text!
        if self.searchBar.text?.isEmpty == false {
            searchWorkItem?.cancel()
            searchWorkItem = DispatchWorkItem(block: {
                print("Did Start searching with term: \(query)")
                self.controller.download(searchtext: query) { _ in
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    print(self.controller.githubs)
                }
            })
            DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 0.5, execute: searchWorkItem)
        }

    }

    //Download function to fetch number of repository
    func downloadRepoNumber (url: URL, _ completion: @escaping (UserInfo) -> Void) {
        
        networker.get(type: UserInfo.self, url: url) { (result) in
            print("finished download")
            self.userinfo = result!
            completion(self.userinfo!)
        }
    }
}






