import Foundation

struct SavedTimezone: Identifiable, Codable, Equatable, Hashable {
    let id: UUID
    let identifier: String

    init(id: UUID = UUID(), identifier: String) {
        self.id = id
        self.identifier = identifier
    }

    var timeZone: TimeZone? {
        TimeZone(identifier: identifier)
    }

    var displayName: String {
        timeZone?.cityName ?? identifier
    }

    var offset: String {
        timeZone?.formattedOffset ?? ""
    }
}
