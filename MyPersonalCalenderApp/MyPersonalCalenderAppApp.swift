//
//  MyPersonalCalenderAppApp.swift
//  MyPersonalCalenderApp
//
//  Created by suman_karumuri on 8/1/25.
//
import SwiftUI

@main
struct MyPersonalCalenderApp: App {
    var body: some Scene {
        MenuBarExtra("MyPersonalCalenderApp", systemImage: "calendar") {
            CalendarMenuView()
                .frame(minWidth: 320)
                .padding()
        }
        .menuBarExtraStyle(.window)
    }
}
