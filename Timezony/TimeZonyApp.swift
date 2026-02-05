import SwiftUI

@main
@MainActor
struct TimeZonyApp: App {
    @State private var manager = TimezoneManager()

    var body: some Scene {
        MenuBarExtra {
            ContentView(manager: manager)
        } label: {
            Label("Timezony", systemImage: "clock.fill")
        }
        .menuBarExtraStyle(.window)
    }
}
