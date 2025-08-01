//
//  LocalTimeView.swift
//  MidtermReport
//
//  Created by Guest User on 2025/8/1.
//

import SwiftUI

struct LocalTimeView: View {
    @State private var currentTime: String = ""
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        Text(currentTime)
            .font(.headline)
            .onAppear(perform: updateTime)
            .onReceive(timer) { _ in
                updateTime()
            }
    }

    private func updateTime() {
        let formatter = DateFormatter()
        formatter.timeStyle = .short // 顯示時:分
        formatter.dateStyle = .none
        formatter.locale = Locale.current // 依照當地語系
        currentTime = formatter.string(from: Date())
    }
}
