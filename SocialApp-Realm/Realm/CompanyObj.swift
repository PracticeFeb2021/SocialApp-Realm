//
//  UserObj.swift
//  SocialApp
//
//  Created by Oleksandr Bretsko on 1/2/2021.
//

import RealmSwift


class CompanyObj: Object {
    
    @objc dynamic var id: Int = 0

    @objc dynamic var name: String = ""
    
    @objc dynamic var catchPhrase: String = ""

    @objc dynamic var bs: String = ""
    
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(id: Int,
                     name: String,
                     catchPhrase: String,
                     bs: String) {
        self.init()
        self.id = id
        self.name = name
        self.catchPhrase = catchPhrase
        self.bs = bs
    }
    
    convenience init(id: Int,
                     _ company: Company) {
        self.init(id: id,
                  name: company.name,
                  catchPhrase: company.catchPhrase,
                  bs: company.bs)
    }
}
