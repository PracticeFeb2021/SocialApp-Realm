//
//  UserObj.swift
//  SocialApp
//
//  Created by Oleksandr Bretsko on 1/2/2021.
//

import RealmSwift


class UserObj: Object {
    
    @objc dynamic var id: Int = 0

    @objc dynamic var name: String = ""
    
    @objc dynamic var username: String = ""
    
    @objc dynamic var email: String = ""
    
    @objc dynamic var address: AddressObj?
    
    @objc dynamic var phone: String = ""

    @objc dynamic var website: String = ""

    @objc dynamic var company: CompanyObj?

    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(id: Int, name: String, username: String, email: String, address: AddressObj?, phone: String, website: String, company: CompanyObj?) {
        self.init()
        self.id = id
        self.name = name
        self.username = username
        self.email = email
        self.address = address
        self.phone = phone
        self.website = website
        self.company = company
     }
}
