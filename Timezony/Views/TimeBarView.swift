import SwiftUI

struct TimeBarView: View {
    let timeZone: TimeZone
    let currentHour: Double
    var isConversionMode: Bool = false

    private let barHeight: CGFloat = 32

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background gradient (day/night cycle)
                dayNightGradient
                    .clipShape(RoundedRectangle(cornerRadius: 6))

                // Work hours overlay (9-17)
                workHoursOverlay(width: geometry.size.width)

                // Hour markers
                hourMarkers(width: geometry.size.width)

                // Current time indicator
                currentTimeIndicator(width: geometry.size.width)
            }
        }
        .frame(height: barHeight)
    }

    private var dayNightGradient: LinearGradient {
        LinearGradient(
            stops: [
                .init(color: .midnight, location: 0),      // 00:00
                .init(color: .midnight, location: 0.2),    // 05:00
                .init(color: .dawn, location: 0.25),       // 06:00
                .init(color: .daylight, location: 0.35),   // 08:00
                .init(color: .daylight, location: 0.65),   // 16:00
                .init(color: .dusk, location: 0.75),       // 18:00
                .init(color: .midnight, location: 0.85),   // 20:00
                .init(color: .midnight, location: 1.0)     // 24:00
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
    }

    @ViewBuilder
    private func workHoursOverlay(width: CGFloat) -> some View {
        let startX = width * (9.0 / 24.0)
        let endX = width * (17.0 / 24.0)

        Rectangle()
            .fill(Color.white.opacity(0.1))
            .frame(width: endX - startX)
            .offset(x: startX)
            .clipShape(RoundedRectangle(cornerRadius: 4))
    }

    @ViewBuilder
    private func hourMarkers(width: CGFloat) -> some View {
        ForEach([6, 12, 18], id: \.self) { hour in
            let position = width * (Double(hour) / 24.0)
            Rectangle()
                .fill(Color.white.opacity(0.3))
                .frame(width: 1, height: barHeight * 0.4)
                .offset(x: position)
        }
    }

    @ViewBuilder
    private func currentTimeIndicator(width: CGFloat) -> some View {
        let position = width * (currentHour / 24.0)

        ZStack {
            // Glow effect
            Rectangle()
                .fill(Color.coralAccent)
                .frame(width: 4, height: barHeight)
                .blur(radius: 4)

            // Main indicator line
            Rectangle()
                .fill(Color.coralAccent)
                .frame(width: 2, height: barHeight)

            // Top triangle marker
            Triangle()
                .fill(Color.coralAccent)
                .frame(width: 8, height: 6)
                .offset(y: -barHeight / 2 - 2)
        }
        .offset(x: position)
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.closeSubpath()
        return path
    }
}

#Preview {
    TimeBarView(timeZone: TimeZone(identifier: "America/New_York")!, currentHour: 14.5)
        .frame(width: 300)
        .padding()
        .background(Color.black.opacity(0.8))
}
