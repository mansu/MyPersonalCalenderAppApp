//
//  CalendarMenuView.swift
//  MyPersonalCalenderApp
//
//  Created by suman_karumuri on 8/1/25.
//

import SwiftUI

struct CalendarMenuView: View {
    // Persist last-viewed month/year across launches and menu openings
    @AppStorage("selectedYear") private var selectedYear: Int = Calendar.current.component(.year, from: Date())
    @AppStorage("selectedMonth") private var selectedMonth: Int = Calendar.current.component(.month, from: Date())

    @State private var showingPicker = false

    private var displayedDate: Date {
        var comps = DateComponents()
        comps.year = selectedYear
        comps.month = selectedMonth
        comps.day = 1
        return Calendar.current.date(from: comps) ?? Date()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            // Header with Month Year + actions
            HStack {
                Text(monthYearTitle(for: displayedDate))
                    .font(.headline)
                    .accessibilityAddTraits(.isHeader)
                Spacer()
                Button("Today") {
                    let now = Date()
                    let cal = Calendar.current
                    selectedYear = cal.component(.year, from: now)
                    selectedMonth = cal.component(.month, from: now)
                }
                Button("Pick Month & Year") {
                    showingPicker = true
                }
                .keyboardShortcut(",", modifiers: []) // quick open picker
            }

            // Weekday headers
            WeekdayHeader()

            // Calendar grid
            CalendarGridView(year: selectedYear, month: selectedMonth)
                .accessibilityLabel("Calendar for \(monthYearTitle(for: displayedDate))")
        }
        .sheet(isPresented: $showingPicker) {
            MonthYearPicker(
                initialYear: selectedYear,
                initialMonth: selectedMonth,
                onDone: { y, m in
                    selectedYear = y
                    selectedMonth = m
                    showingPicker = false
                },
                onCancel: { showingPicker = false }
            )
            .frame(width: 320)
        }
    }

    private func monthYearTitle(for date: Date) -> String {
        let df = DateFormatter()
        df.setLocalizedDateFormatFromTemplate("MMMM yyyy")
        return df.string(from: date)
    }
}

// Weekday header that respects the user's locale firstWeekday
struct WeekdayHeader: View {
    var body: some View {
        let cal = Calendar.current
        let symbols = rotated(array: DateFormatter().shortWeekdaySymbols, startIndex: cal.firstWeekday - 1)

        HStack {
            ForEach(symbols, id: \.self) { s in
                Text(s.uppercased())
                    .font(.caption)
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

private func rotated<T>(array: [T], startIndex: Int) -> [T] {
    guard !array.isEmpty else { return array }
    let idx = (startIndex % array.count + array.count) % array.count
    return Array(array[idx...] + array[..<idx])
}
