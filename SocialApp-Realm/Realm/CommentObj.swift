//
//  CommentObj.swift
//  SocialApp
//
//  Created by Oleksandr Bretsko on 1/2/2021.
//

import RealmSwift


class CommentObj: Object {
    
    @objc dynamic var id: Int = 0
    
    @objc dynamic var postId: Int = 0
    
    @objc dynamic var name: String = ""
    
    @objc dynamic var body: String = ""
    
    @objc dynamic var email: String = ""
    
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(id: Int,
         postId: Int,
         name: String,
         body: String,
         email: String) {
        self.init()
        self.id = id
        self.postId = postId
        self.name = name
        self.body = body
        self.email = email
    }
    
    convenience init(_ comment: Comment) {
        self.init(id: comment.id,
                  postId: comment.postId,
                  name: comment.name,
                  body: comment.body,
                  email: comment.email)
    }
}

