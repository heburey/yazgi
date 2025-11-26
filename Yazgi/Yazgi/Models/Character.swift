import Foundation

struct Character: Identifiable, Codable {
    var id: UUID = UUID()
    var name: String
    var age: Int
    var intelligence: Int
    var beauty: Int
    var luck: Int
    var aura: Int
    var gender: String
    var country: String
    var family: FamilyBackground
}
