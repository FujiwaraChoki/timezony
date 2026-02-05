import SwiftUI

struct ContentView: View {
    @Bindable var manager: TimezoneManager
    @State private var showingAddSheet = false

    // Time converter state
    @State private var isConverterActive = false
    @State private var converterDate = Date()
    @State private var converterTimezoneId = TimeZone.current.identifier

    private var referenceDate: Date? {
        isConverterActive ? converterDate : nil
    }

    var body: some View {
        TimelineView(.periodic(from: .now, by: 1.0)) { timeline in
            VStack(spacing: 0) {
                // Header
                header

                Divider()

                // Time Converter
                TimeConverterView(
                    isActive: $isConverterActive,
                    selectedDate: $converterDate,
                    selectedTimezoneId: $converterTimezoneId,
                    availableTimezones: manager.timezones
                )

                // Timezone list
                if manager.timezones.isEmpty {
                    emptyState
                } else {
                    timezoneList(date: timeline.date)
                }

                Divider()

                // Footer
                footer
            }
            .frame(width: 340)
            .background(.ultraThinMaterial)
        }
        .sheet(isPresented: $showingAddSheet) {
            AddTimezoneView(manager: manager)
        }
    }

    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("Timezony")
                    .font(.title2.bold())

                if isConverterActive {
                    Text("Showing converted times")
                        .font(.caption2)
                        .foregroundStyle(Color.coralAccent)
                }
            }

            Spacer()

            Button(action: { showingAddSheet = true }) {
                Image(systemName: "plus.circle.fill")
                    .font(.title2)
                    .foregroundStyle(Color.coralAccent)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "globe")
                .font(.system(size: 40))
                .foregroundStyle(.secondary)
            Text("No timezones added")
                .font(.headline)
                .foregroundStyle(.secondary)
            Text("Click + to add your first timezone")
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }

    @ViewBuilder
    private func timezoneList(date: Date) -> some View {
        List {
            ForEach(manager.timezones) { timezone in
                TimezoneRowView(
                    timezone: timezone,
                    currentHour: timezone.timeZone?.currentHour() ?? 0,
                    onDelete: { manager.removeTimezone(timezone) },
                    referenceDate: referenceDate,
                    isConversionMode: isConverterActive
                )
                .listRowInsets(EdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4))
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
            }
            .onDelete(perform: manager.removeTimezones)
            .onMove(perform: manager.moveTimezones)
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .frame(minHeight: 100, maxHeight: 400)
    }

    private var footer: some View {
        HStack {
            Text("Local: \(TimeZone.current.cityName)")
                .font(.caption)
                .foregroundStyle(.secondary)
            Spacer()
            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
            .buttonStyle(.plain)
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
}

#Preview {
    ContentView(manager: TimezoneManager())
}
