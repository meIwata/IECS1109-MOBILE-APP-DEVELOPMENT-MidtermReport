//
//  ContentView.swift
//  MidtermReport
//
//  Created by Lulu Liao on 2025/7/30.
//
import SwiftUI

struct ContentView: View {
    @State private var city = "Niseko"
    @State private var weather: WeatherResponse?
    @State private var isLoading = false
    @State private var showFahrenheit = false // 一開始顯示是攝氏
    @State private var shakeOffset: CGFloat = 0 // 新增搖動用的變數
    let service = WeatherService()
    
    var body: some View {
        VStack(spacing: 20) {
            TextField("輸入城市", text: $city)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button("查詢天氣") {
                isLoading = true
                service.fetchWeather(city: city) { result in
                    DispatchQueue.main.async {
                        weather = result
                        isLoading = false
                    }
                }
            }
            .padding()
            
            if isLoading {
                ProgressView()
            }
            
            if let w = weather {
//                HStack {
//                    Image(systemName: "dot.scope")
//                    Text("\(w.location.name), \(w.location.country)")
//                        .font(.title)
//                        .lineLimit(1)                // 僅一行
//                        .minimumScaleFactor(0.45)     // 最小縮放到原本的 45%
//                }
//                .frame(maxWidth: .infinity, alignment: .center)
                
                
                HStack {
                    Image(systemName: "dot.scope")
                    Text("\(w.location.name), \(w.location.country)")
                        .font(.system(size: 32, weight: .bold))    // 預設大一點
                        .lineLimit(1)
                        .minimumScaleFactor(0.1)                   // 最小可縮到原本 10%
                        .layoutPriority(1)                         // 讓它優先佔滿空間
                }
                .frame(maxWidth: .infinity, alignment: .center)
                
                LocalTimeView() // ←這裡插入當地時間顯示
                Text("目前天氣：\(w.current.condition.text)")
                Text("溫度：\(showFahrenheit ? (w.current.temp_c * 9/5 + 32) : w.current.temp_c, specifier: "%.1f")\(showFahrenheit ? "°F" : "°C")")
                    .onTapGesture {
                        showFahrenheit.toggle()
                    } // 點選溫度這串字串可以改辦成華氏
                
                AsyncImage(url: URL(string: "https:\(w.current.condition.icon)")) { image in
                    image
                        .resizable()
                        .frame(width: 85, height: 85)
                        .offset(x: shakeOffset)
                        .onAppear {
                            startShaking()
                        }
                } placeholder: {
                    ProgressView()
                }
                .id(w.current.condition.icon) // 加入id可以讓每次查詢都讓圖片搖動
            }
        }
        .padding()
        .frame(width: 300)
    }
    
    // 加入圖片搖動動畫function
    func startShaking() {
        shakeOffset = 0
        var count = 0
        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
            withAnimation(.easeInOut(duration: 0.05)) {
                shakeOffset = shakeOffset == 0 ? 5 : -shakeOffset
            }
            count += 1
            if count >= 12 { // 10秒
                timer.invalidate()
                withAnimation {
                    shakeOffset = 0
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
