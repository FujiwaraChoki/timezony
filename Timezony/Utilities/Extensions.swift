import SwiftUI

// MARK: - Codable AppStorage Extension

extension Array: @retroactive RawRepresentable where Element: Codable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode([Element].self, from: data)
        else { return nil }
        self = result
    }

    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8)
        else { return "[]" }
        return result
    }
}

// MARK: - TimeZone Helpers

extension TimeZone {
    var cityName: String {
        let id = identifier
        if let lastSlash = id.lastIndex(of: "/") {
            return String(id[id.index(after: lastSlash)...]).replacingOccurrences(of: "_", with: " ")
        }
        return id
    }

    var formattedOffset: String {
        let hours = secondsFromGMT() / 3600
        let minutes = abs(secondsFromGMT() / 60 % 60)
        if minutes == 0 {
            return String(format: "GMT%+d", hours)
        }
        return String(format: "GMT%+d:%02d", hours, minutes)
    }

    func currentTime(format: String = "HH:mm") -> String {
        let formatter = DateFormatter()
        formatter.timeZone = self
        formatter.dateFormat = format
        return formatter.string(from: Date())
    }

    func currentHour() -> Double {
        let formatter = DateFormatter()
        formatter.timeZone = self
        formatter.dateFormat = "HH"
        let hour = Double(formatter.string(from: Date())) ?? 0

        formatter.dateFormat = "mm"
        let minutes = Double(formatter.string(from: Date())) ?? 0

        return hour + minutes / 60.0
    }

    /// Returns the time in this timezone for a given reference date/time in another timezone
    func convertedTime(from referenceDate: Date, sourceTimezone: TimeZone, format: String = "HH:mm") -> String {
        let formatter = DateFormatter()
        formatter.timeZone = self
        formatter.dateFormat = format
        return formatter.string(from: referenceDate)
    }

    /// Returns the hour (as decimal) in this timezone for a given reference date/time
    func convertedHour(from referenceDate: Date) -> Double {
        let formatter = DateFormatter()
        formatter.timeZone = self
        formatter.dateFormat = "HH"
        let hour = Double(formatter.string(from: referenceDate)) ?? 0

        formatter.dateFormat = "mm"
        let minutes = Double(formatter.string(from: referenceDate)) ?? 0

        return hour + minutes / 60.0
    }

    /// Creates a Date object representing a specific time in this timezone
    func dateForTime(hour: Int, minute: Int, from baseDate: Date = Date()) -> Date {
        var calendar = Calendar.current
        calendar.timeZone = self
        let components = calendar.dateComponents([.year, .month, .day], from: baseDate)
        var newComponents = DateComponents()
        newComponents.year = components.year
        newComponents.month = components.month
        newComponents.day = components.day
        newComponents.hour = hour
        newComponents.minute = minute
        newComponents.second = 0
        newComponents.timeZone = self
        return calendar.date(from: newComponents) ?? baseDate
    }
}

// MARK: - Color Palette

extension Color {
    static let midnight = Color(hex: "1a1a2e")
    static let dawn = Color(hex: "ff7e5f")
    static let daylight = Color(hex: "feb47b")
    static let dusk = Color(hex: "764ba2")
    static let coralAccent = Color(hex: "FF6B6B")

    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - View Extensions

extension View {
    func hoverEffect(_ isHovered: Binding<Bool>) -> some View {
        self.onHover { hovering in
            withAnimation(.easeInOut(duration: 0.15)) {
                isHovered.wrappedValue = hovering
            }
        }
    }
}
