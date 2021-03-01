//
//  PostObj.swift
//  SocialApp
//
//  Created by Oleksandr Bretsko on 1/2/2021.
//

import RealmSwift


class PostObj: Object {
    
    @objc dynamic var id: Int = 0
    
    @objc dynamic var userId: Int = 0
    
    @objc dynamic var title: String = ""
    
    @objc dynamic var body: String = ""
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(id: Int, userId: Int, title: String, body: String) {
        self.init()
        self.id = id
        self.userId = userId
        self.title = title
        self.body = body
    }
    
    convenience init(_ post: Post) {
        self.init(id: post.id,
                  userId: post.userId,
                  title: post.title,
                  body: post.body)
    }
}
