import Foundation
import RealmSwift

class Car: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name: String
    @Persisted var maxSpeed: String
    @Persisted var yearOfIssue: String
    @Persisted var weight: String
    
    convenience init(name: String, maxSpeed: String, yearOfIssue: String, weight: String) {
        self.init()
        self.name = name
        self.maxSpeed = maxSpeed
        self.yearOfIssue = yearOfIssue
        self.weight = weight
    }
}
