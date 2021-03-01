//
//  AddressObj.swift
//  SocialApp
//
//  Created by Oleksandr Bretsko on 1/2/2021.
//

import RealmSwift


class AddressObj: Object {
    
    @objc dynamic var id: Int = 0
    
    @objc dynamic var street: String = ""
    
    @objc dynamic var suite: String = ""
    
    @objc dynamic var city: String = ""
    
    @objc dynamic var zipcode: String = ""
    
    // Geo
    @objc dynamic var lat: String = ""
    @objc dynamic var lng: String = ""
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(id: Int,
                     street: String,
                     suite: String,
                     city: String,
                     zipcode: String,
                     lat: String,
                     lng: String) {
        self.init()
        self.id = id
        self.street = street
        self.suite = suite
        self.city = city
        self.zipcode = zipcode
        self.lat = lat
        self.lng = lng
    }
    
    convenience init(id: Int, _ address: Address) {
        self.init(id: id,
                  street: address.street,
                  suite: address.suite,
                  city: address.city,
                  zipcode: address.zipcode,
                  lat: address.geo.lat,
                  lng: address.geo.lng)
    }
}

