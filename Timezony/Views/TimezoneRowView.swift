import SwiftUI

struct TimezoneRowView: View {
    let timezone: SavedTimezone
    let currentHour: Double
    let onDelete: () -> Void

    // Optional: for custom time conversion mode
    var referenceDate: Date? = nil
    var isConversionMode: Bool = false

    @State private var isHovered = false

    private var displayTime: String {
        guard let tz = timezone.timeZone else { return "--:--" }
        if let refDate = referenceDate {
            return tz.convertedTime(from: refDate, sourceTimezone: tz)
        }
        return tz.currentTime()
    }

    private var displayHour: Double {
        guard let tz = timezone.timeZone else { return 0 }
        if let refDate = referenceDate {
            return tz.convertedHour(from: refDate)
        }
        return currentHour
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(timezone.displayName)
                        .font(.headline)
                        .foregroundStyle(.primary)

                    HStack(spacing: 6) {
                        Text(timezone.offset)
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        if isConversionMode {
                            Text("converted")
                                .font(.caption2)
                                .foregroundStyle(Color.coralAccent.opacity(0.8))
                                .padding(.horizontal, 5)
                                .padding(.vertical, 1)
                                .background(Color.coralAccent.opacity(0.15))
                                .clipShape(RoundedRectangle(cornerRadius: 3))
                        }
                    }
                }

                Spacer()

                Text(displayTime)
                    .font(.system(size: 24, weight: .medium, design: .monospaced))
                    .foregroundStyle(isConversionMode ? Color.coralAccent : .primary)
                    .contentTransition(.numericText())
                    .animation(.spring(response: 0.3), value: displayTime)

                if isHovered {
                    Button(action: onDelete) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.secondary)
                            .imageScale(.medium)
                    }
                    .buttonStyle(.plain)
                    .transition(.opacity.combined(with: .scale))
                }
            }

            if let tz = timezone.timeZone {
                TimeBarView(
                    timeZone: tz,
                    currentHour: displayHour,
                    isConversionMode: isConversionMode
                )
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(isHovered ? Color.primary.opacity(0.05) : Color.clear)
        )
        .hoverEffect($isHovered)
    }
}

#Preview {
    VStack {
        TimezoneRowView(
            timezone: SavedTimezone(identifier: "America/New_York"),
            currentHour: 14.5,
            onDelete: {}
        )

        TimezoneRowView(
            timezone: SavedTimezone(identifier: "Asia/Tokyo"),
            currentHour: 3.5,
            onDelete: {},
            referenceDate: Date(),
            isConversionMode: true
        )
    }
    .frame(width: 320)
    .padding()
}
