//
//  StatisticsView.swift
//  CryptoTracker
//
//  Created by Himanshu Namdeo on 30/10/25.
//

import SwiftUI

struct StatisticsView: View {
    
    let stats: StatisticsModel
    var body: some View {
        VStack(alignment: .leading,spacing: 4){
            Text(stats.title)
                .font(.caption)
                .foregroundStyle(Color.theme.accent)
            Text(stats.value)
                .font(.headline)
                .foregroundStyle(Color.theme.accent)
            HStack {
                Image(systemName: "triangle.fill")
                    .font(.caption2)
                    .rotationEffect (
                        Angle(degrees: (stats.percentageChange ?? 0) >= 0 ? 0 : 180)
                    )
                Text(stats.percentageChange?.asPercentString() ?? "")
                    .font(.caption)
                    .bold()
            }
            .foregroundStyle((stats.percentageChange ?? 0) >= 0 ? Color.theme.greenColor : Color.theme.redColor)
            .opacity(stats.percentageChange == nil ? 0.0 : 1.0)
        }
    }
}

struct StatisticsView_preview: PreviewProvider {
    static var previews: some View {
        Group {
            StatisticsView(stats: dev.stats1)
            StatisticsView(stats: dev.stats2)
            StatisticsView(stats: dev.stats3)
        }
        
    }
}
