import SwiftUI

@MainActor
struct AddTimezoneView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var manager: TimezoneManager

    @State private var searchText = ""

    private var filteredTimezones: [(identifier: String, displayName: String)] {
        let all = TimezoneManager.allAvailableTimezones
        if searchText.isEmpty {
            return all
        }
        return all.filter { $0.displayName.localizedCaseInsensitiveContains(searchText) }
    }

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("Add Timezone")
                    .font(.headline)
                Spacer()
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                        .imageScale(.large)
                }
                .buttonStyle(.plain)
            }
            .padding()

            // Search field
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)
                TextField("Search cities...", text: $searchText)
                    .textFieldStyle(.plain)
                if !searchText.isEmpty {
                    Button(action: { searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.secondary)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(10)
            .background(Color.primary.opacity(0.05))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .padding(.horizontal)

            Divider()
                .padding(.top, 12)

            // Timezone list
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(filteredTimezones, id: \.identifier) { tz in
                        TimezoneListItem(
                            displayName: tz.displayName,
                            identifier: tz.identifier,
                            isAdded: manager.timezones.contains { $0.identifier == tz.identifier }
                        ) {
                            manager.addTimezone(tz.identifier)
                            dismiss()
                        }
                    }
                }
            }
            .frame(maxHeight: 300)
        }
        .frame(width: 300)
        .background(.ultraThinMaterial)
    }
}

@MainActor
struct TimezoneListItem: View {
    let displayName: String
    let identifier: String
    let isAdded: Bool
    let onAdd: () -> Void

    @State private var isHovered = false

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(displayName)
                    .font(.body)
                    .foregroundStyle(isAdded ? .secondary : .primary)

                if let tz = TimeZone(identifier: identifier) {
                    Text(tz.formattedOffset)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()

            if isAdded {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.green)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(isHovered && !isAdded ? Color.primary.opacity(0.05) : Color.clear)
        .contentShape(Rectangle())
        .hoverEffect($isHovered)
        .onTapGesture {
            if !isAdded {
                onAdd()
            }
        }
    }
}

#Preview {
    AddTimezoneView(manager: TimezoneManager())
}
