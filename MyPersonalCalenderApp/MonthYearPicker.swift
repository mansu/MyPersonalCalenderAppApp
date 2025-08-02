//
//  MonthYearPicker.swift
//  MyPersonalCalenderApp
//
//  Created by suman_karumuri on 8/1/25.
//


import SwiftUI

struct MonthYearPicker: View {
    @State private var tempYear: Int
    @State private var tempMonth: Int

    let onDone: (Int, Int) -> Void
    let onCancel: () -> Void

    private let yearRange = (1900...2100)

    private let months: [String] = {
        let df = DateFormatter()
        return df.monthSymbols
            ?? df.standaloneMonthSymbols
            ?? ["January","February","March","April","May","June",
                "July","August","September","October","November","December"]
    }()

    init(initialYear: Int, initialMonth: Int, onDone: @escaping (Int, Int) -> Void, onCancel: @escaping () -> Void) {
        _tempYear = State(initialValue: initialYear)
        _tempMonth = State(initialValue: initialMonth)
        self.onDone = onDone
        self.onCancel = onCancel
    }

    var body: some View {
        VStack(spacing: 16) {
            Text("Pick Month & Year")
                .font(.headline)

            HStack {
                Picker("Month", selection: $tempMonth) {
                    ForEach(1...12, id: \.self) { m in
                        Text(months[m - 1]).tag(m)
                    }
                }
                .pickerStyle(.menu)

                Picker("Year", selection: $tempYear) {
                    ForEach(yearRange, id: \.self) { y in
                        Text("\(y)").tag(y)
                    }
                }
                .pickerStyle(.menu)
            }

            HStack {
                Spacer()
                Button("Cancel") { onCancel() }
                Button("Done") { onDone(tempYear, tempMonth) }
                    .keyboardShortcut(.defaultAction)
            }
        }
        .padding()
    }
}
