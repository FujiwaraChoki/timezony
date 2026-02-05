import SwiftUI

@MainActor
@Observable
final class TimezoneManager {
    private static let storageKey = "savedTimezones"

    var timezones: [SavedTimezone] {
        didSet {
            saveToStorage()
        }
    }

    static let defaultTimezones: [SavedTimezone] = [
        SavedTimezone(identifier: "America/New_York"),
        SavedTimezone(identifier: "Europe/London"),
        SavedTimezone(identifier: "Asia/Tokyo")
    ]

    init() {
        if let data = UserDefaults.standard.string(forKey: Self.storageKey),
           let decoded = [SavedTimezone](rawValue: data) {
            self.timezones = decoded
        } else {
            self.timezones = Self.defaultTimezones
        }
    }

    private func saveToStorage() {
        UserDefaults.standard.set(timezones.rawValue, forKey: Self.storageKey)
    }

    func addTimezone(_ identifier: String) {
        guard !timezones.contains(where: { $0.identifier == identifier }) else { return }
        let newTimezone = SavedTimezone(identifier: identifier)
        timezones.append(newTimezone)
    }

    func removeTimezone(_ timezone: SavedTimezone) {
        timezones.removeAll { $0.id == timezone.id }
    }

    func removeTimezones(at offsets: IndexSet) {
        timezones.remove(atOffsets: offsets)
    }

    func moveTimezones(from source: IndexSet, to destination: Int) {
        timezones.move(fromOffsets: source, toOffset: destination)
    }

    static var allAvailableTimezones: [(identifier: String, displayName: String)] {
        TimeZone.knownTimeZoneIdentifiers
            .compactMap { identifier -> (String, String)? in
                guard let tz = TimeZone(identifier: identifier) else { return nil }
                return (identifier, tz.cityName)
            }
            .sorted { $0.1 < $1.1 }
    }
}
