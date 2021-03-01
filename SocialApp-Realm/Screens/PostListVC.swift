//
//  PostListVC.swift
//  SocialApp
//
//  Created by Oleksandr Bretsko on 1/2/2021.
//

import UIKit
import RealmSwift

class PostListVC: UIViewController, StoryboardInitializable {
    
    @IBOutlet weak var tableView: UITableView!
    
    var netService: NetworkingService!
    let realm = try! Realm()
    
    private lazy var posts = realm.objects(PostObj.self).sorted(byKeyPath: "id")
    
    //MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //try! Realm().objects(DemoObject.self).sorted(byKeyPath: "date")
        
        view.backgroundColor = UIColor.white
        navigationItem.title = "Posts"
        
        tableView.register(UINib(nibName: "PostCell", bundle: nil), forCellReuseIdentifier: PostCell.cellReuseId)
        
        tableView.dataSource = self
        tableView.delegate = self
        reloadPosts()
    }
    
    //MARK: - Network

    func reloadPosts() {
        netService.loadPosts { result in
            switch result {
            case .failure(let error):
                //TODO: handle error
                print("ERROR: \(error)")
                
            case .success(let posts):
                print("INFO: \(posts.count) posts received from network")
                DispatchQueue.main.async { [weak self] in
                    guard let strongSelf = self else {
                        return
                    }
                    try! strongSelf.realm.write({
                        posts.forEach { post in
                            strongSelf.realm.add(PostObj(post), update: .all)
                        }
                    })
                    strongSelf.tableView.reloadData()
                }
            }
        }
    }
}

//MARK: - TableView

extension PostListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard !posts.isEmpty else {
            return UITableViewCell()
        }
        let cell =
            self.tableView.dequeueReusableCell(withIdentifier: PostCell.cellReuseId, for: indexPath) as! PostCell
        cell.configure(with: posts[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        
        let vc = PostVC.initFromStoryboard()
        vc.netService = netService
        vc.post = posts[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

