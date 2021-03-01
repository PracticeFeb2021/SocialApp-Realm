//
//  PostVC.swift
//  SocialApp
//
//  Created by Oleksandr Bretsko on 1/2/2021.
//

import UIKit
import RealmSwift

class PostVC: UIViewController, StoryboardInitializable {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var postTitleLabel: UILabel!
    @IBOutlet weak var postBodyLabel: UILabel!
    @IBOutlet weak var postAuthorLabel: UILabel!
    
    @IBOutlet weak var commentsTableView: UITableView!
    @IBOutlet weak var commentsTableConstraint: NSLayoutConstraint!
    
    
    var post: PostObj!
    private lazy var comments = realm.objects(CommentObj.self).sorted(byKeyPath: "id")

    var netService: NetworkingService!
    let realm = try! Realm()

    
    //MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postTitleLabel.text = post.title
        postBodyLabel.text = post.body

        commentsTableView.register(UINib(nibName: "CommentCell", bundle: nil), forCellReuseIdentifier: CommentCell.cellReuseId)
        commentsTableView.dataSource = self
        commentsTableView.delegate = self
        
        reloadUser()
        reloadComments()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.updateScrollViewContentSize()
    }
    
    private func updateScrollViewContentSize(){
        
        commentsTableConstraint.constant = commentsTableView.contentSize.height + 20.0
        var heightOfSubViews:CGFloat = 0.0
        contentView.subviews.forEach { subview in
            if let tableView = subview as? UITableView {
                heightOfSubViews += (tableView.contentSize.height + 20.0)
            } else {
                heightOfSubViews += subview.frame.size.height
            }
        }
        
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: heightOfSubViews)
    }
    
    //MARK: - Network
    
    private func reloadUser() {
        
        netService.loadUsers { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            
            switch result {
            case .failure(let error):
                //TODO: handle error
                print("ERROR: \(error)")
                
            case .success(let users):
                print("INFO: \(users.count) users received from network")
                
                DispatchQueue.main.async {
                    
                    try! strongSelf.realm.write({
                        users.forEach { user in
                            
                            let addressId = strongSelf.realm.incrementID(type: AddressObj.self)
                            let addressObj = AddressObj(id: addressId, user.address)
                            
                            let companyId = strongSelf.realm.incrementID(type: CompanyObj.self)
                            let companyObj = CompanyObj(id: companyId, user.company)
                            strongSelf.realm.add(addressObj, update: .all)
                            strongSelf.realm.add(companyObj, update: .all)
                            
                            let userObj = UserObj(id: user.id, name: user.name, username: user.username, email: user.email, address: addressObj, phone: user.phone, website: user.website, company: companyObj)
                            strongSelf.realm.add(userObj, update: .all)
                        }
                    })
                    
                    guard let user = users.first(where: {
                        $0.id == strongSelf.post.userId
                    }) else {
                        return
                    }
                    
                    strongSelf.postAuthorLabel.text = user.name
                }
            }
        }
    }
    
    private func reloadComments() {
        
        netService.loadComments { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            
            let comments: [Comment]
            switch result {
            case .failure(let error):
                //TODO: handle error
                print("ERROR: \(error)")
                return
            case .success(let receivedComments):
                comments = receivedComments
                break
            }
            
            DispatchQueue.main.async {
                let commentsForPost = comments.filter {
                    $0.postId == strongSelf.post.id
                }
                print("INFO: found \(commentsForPost.count) comments for this post")
                
                try! strongSelf.realm.write({
                    commentsForPost.forEach { comment in
                        strongSelf.realm.add(CommentObj(comment))
                    }
                })
                
                strongSelf.commentsTableView.reloadData()
                strongSelf.commentsTableConstraint.constant = strongSelf.commentsTableView.contentSize.height
                strongSelf.view.layoutIfNeeded()
            }
        }
    }
}


extension PostVC: UITableViewDelegate,UITableViewDataSource  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard !comments.isEmpty else {
            return UITableViewCell()
        }
        let cell =
            commentsTableView.dequeueReusableCell(withIdentifier: CommentCell.cellReuseId, for: indexPath) as! CommentCell
        cell.configure(with: comments[indexPath.row])
        return cell
    }
}
