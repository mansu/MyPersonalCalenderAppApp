//
//  CalendarGridView.swift
//  MyPersonalCalenderApp
//
//  Created by suman_karumuri on 8/1/25.
//


import SwiftUI

struct CalendarGridView: View {
    let year: Int
    let month: Int

    var body: some View {
        let cal = Calendar.current
        let cells = monthCells(year: year, month: month, calendar: cal)

        // 7 columns (Sun/Mon … Sat depending on locale)
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 4), count: 7), spacing: 6) {
            ForEach(0..<cells.count, id: \.self) { i in
                if let date = cells[i] {
                    let day = cal.component(.day, from: date)
                    Text("\(day)")
                        .frame(maxWidth: .infinity, minHeight: 28)
                        .padding(.vertical, 4)
                        .background(backgroundShape(for: date))
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                        .accessibilityLabel(accessibilityLabel(for: date))
                } else {
                    Text("") // blank cell
                        .frame(maxWidth: .infinity, minHeight: 28)
                        .padding(.vertical, 4)
                }
            }
        }
    }

    private func backgroundShape(for date: Date) -> some ShapeStyle {
        let cal = Calendar.current
        let today = Date()
        if cal.isDate(date, inSameDayAs: today) {
            return AnyShapeStyle(.quaternary) // subtle highlight for today
        }
        return AnyShapeStyle(.clear)
    }

    private func accessibilityLabel(for date: Date) -> String {
        let df = DateFormatter()
        df.setLocalizedDateFormatFromTemplate("EEEE, MMM d, yyyy")
        return df.string(from: date)
    }
}

// Build the month grid as a list of optional Dates, including leading/trailing blanks to fill weeks
func monthCells(year: Int, month: Int, calendar cal: Calendar) -> [Date?] {
    var comps = DateComponents()
    comps.year = year
    comps.month = month
    comps.day = 1
    guard let firstOfMonth = cal.date(from: comps),
          let range = cal.range(of: .day, in: .month, for: firstOfMonth) else {
        return []
    }

    // Leading blanks based on locale’s firstWeekday
    let weekdayOfFirst = cal.component(.weekday, from: firstOfMonth) // 1..7
    let leading = (weekdayOfFirst - cal.firstWeekday + 7) % 7

    var cells: [Date?] = Array(repeating: nil, count: leading)

    // Dates in month
    for day in range {
        var dc = DateComponents()
        dc.year = year
        dc.month = month
        dc.day = day
        if let d = cal.date(from: dc) {
            cells.append(d)
        }
    }

    // Trailing blanks to complete the last week row
    let remainder = cells.count % 7
    if remainder != 0 {
        cells.append(contentsOf: Array(repeating: nil, count: 7 - remainder))
    }

    return cells
}
