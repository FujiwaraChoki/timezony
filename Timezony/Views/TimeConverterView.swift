import SwiftUI

struct TimeConverterView: View {
    @Binding var isActive: Bool
    @Binding var selectedDate: Date
    @Binding var selectedTimezoneId: String

    let availableTimezones: [SavedTimezone]

    @State private var isExpanded = false

    private var selectedTimezone: TimeZone? {
        TimeZone(identifier: selectedTimezoneId)
    }

    private var selectedTimezoneName: String {
        selectedTimezone?.cityName ?? "Select timezone"
    }

    var body: some View {
        VStack(spacing: 0) {
            // Toggle header
            Button(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                    if isActive {
                        isActive = false
                        isExpanded = false
                    } else {
                        isExpanded.toggle()
                        if isExpanded {
                            isActive = true
                        }
                    }
                }
            }) {
                HStack(spacing: 8) {
                    Image(systemName: isActive ? "clock.badge.checkmark.fill" : "clock.arrow.2.circlepath")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(isActive ? Color.coralAccent : .secondary)
                        .frame(width: 20)

                    Text(isActive ? "Custom Time Active" : "Convert Time")
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(isActive ? Color.coralAccent : .primary)

                    Spacer()

                    if isActive {
                        Button(action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                isActive = false
                                isExpanded = false
                            }
                        }) {
                            Text("Reset")
                                .font(.caption.weight(.medium))
                                .foregroundStyle(.secondary)
                        }
                        .buttonStyle(.plain)
                    }

                    Image(systemName: "chevron.right")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.tertiary)
                        .rotationEffect(.degrees(isExpanded ? 90 : 0))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            // Expandable content
            if isExpanded {
                VStack(spacing: 12) {
                    // Time picker
                    HStack {
                        Text("When it's")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        Spacer()

                        DatePicker("", selection: $selectedDate, displayedComponents: [.hourAndMinute])
                            .labelsHidden()
                            .datePickerStyle(.compact)
                            .onChange(of: selectedDate) { _, _ in
                                if !isActive {
                                    withAnimation { isActive = true }
                                }
                            }
                    }

                    // Timezone selector
                    HStack {
                        Text("in")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        Spacer()

                        Menu {
                            // Local timezone option
                            Button(action: {
                                selectedTimezoneId = TimeZone.current.identifier
                                if !isActive {
                                    withAnimation { isActive = true }
                                }
                            }) {
                                HStack {
                                    Text(TimeZone.current.cityName)
                                    if selectedTimezoneId == TimeZone.current.identifier {
                                        Image(systemName: "checkmark")
                                    }
                                }
                            }

                            Divider()

                            // Saved timezones
                            ForEach(availableTimezones) { tz in
                                Button(action: {
                                    selectedTimezoneId = tz.identifier
                                    if !isActive {
                                        withAnimation { isActive = true }
                                    }
                                }) {
                                    HStack {
                                        Text(tz.displayName)
                                        if selectedTimezoneId == tz.identifier {
                                            Image(systemName: "checkmark")
                                        }
                                    }
                                }
                            }
                        } label: {
                            HStack(spacing: 4) {
                                Text(selectedTimezoneName)
                                    .font(.subheadline.weight(.medium))
                                Image(systemName: "chevron.up.chevron.down")
                                    .font(.caption2)
                            }
                            .foregroundStyle(.primary)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(Color.primary.opacity(0.08))
                            .clipShape(RoundedRectangle(cornerRadius: 6))
                        }
                        .menuStyle(.borderlessButton)
                    }

                    // Quick time buttons
                    HStack(spacing: 8) {
                        ForEach(quickTimeOptions, id: \.label) { option in
                            Button(action: {
                                selectedDate = option.date
                                if !isActive {
                                    withAnimation { isActive = true }
                                }
                            }) {
                                Text(option.label)
                                    .font(.caption.weight(.medium))
                                    .foregroundStyle(.secondary)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.primary.opacity(0.05))
                                    .clipShape(RoundedRectangle(cornerRadius: 4))
                            }
                            .buttonStyle(.plain)
                        }
                        Spacer()
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 12)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(isActive ? Color.coralAccent.opacity(0.08) : Color.primary.opacity(0.03))
        )
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
    }

    private var quickTimeOptions: [(label: String, date: Date)] {
        let calendar = Calendar.current
        let now = Date()

        return [
            ("Now", now),
            ("9 AM", calendar.date(bySettingHour: 9, minute: 0, second: 0, of: now) ?? now),
            ("12 PM", calendar.date(bySettingHour: 12, minute: 0, second: 0, of: now) ?? now),
            ("5 PM", calendar.date(bySettingHour: 17, minute: 0, second: 0, of: now) ?? now),
        ]
    }
}

#Preview {
    TimeConverterView(
        isActive: .constant(false),
        selectedDate: .constant(Date()),
        selectedTimezoneId: .constant(TimeZone.current.identifier),
        availableTimezones: TimezoneManager.defaultTimezones
    )
    .frame(width: 340)
    .padding()
}
