//
//  ChartView.swift
//  CryptoTracker
//
//  Created by Himanshu Namdeo on 25/11/25.
//

import SwiftUI

struct ChartView: View {
    
    let data: [Double]
    let minY: Double
    let maxY: Double
    
    init(coin: CoinModel) {
        data = coin.sparklineIn7D?.price ?? []
        minY = data.min() ?? 0
        maxY = data.max() ?? 0
    }
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                for index in data.indices {
                    let xPosition  = geometry.size.width / CGFloat(data.count) * CGFloat(index + 1)
                    let yAxis = maxY - minY
                    let yPosition = (1 - CGFloat((data[index] - minY) / yAxis)) * geometry.size.height
                    if index == 0 {
                        path.move(to: CGPoint(x:xPosition, y:yPosition))
                    }
                    path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                }
            }
            .stroke(Color.blue, style: StrokeStyle(lineWidth: 1, lineCap: .round, lineJoin: .round))
        }
    }
}

struct ChatView_preview: PreviewProvider {
    static var previews: some View {
        return ChartView(coin: dev.coin)
    }
}
