
import RealmSwift



extension Realm {
    
    func incrementID(type: Object.Type, key: String = "id") -> Int {
        guard let id = objects(type).max(ofProperty: key) as Int? else {
            return 1
        }
        return id + 1
    }
}

