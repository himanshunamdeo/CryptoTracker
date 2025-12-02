//
//  DetailView.swift
//  CryptoTracker
//
//  Created by Himanshu Namdeo on 06/11/25.
//

import SwiftUI

struct DetailLoadingView: View {
    @Binding var coin: CoinModel?
    
    
    init(coin: Binding<CoinModel?>) {
        self._coin = coin
    }
    var body: some View {
        ZStack {
            if let coin = self.coin {
                DetailView(coin: coin)
            }
        }
        
    }
}


struct DetailView: View {
    
    let coin: CoinModel
    @StateObject private var detailViewModel: DetailViewModel

    private var columns: [GridItem] = [GridItem(.flexible()), GridItem(.flexible())]
    
    init(coin: CoinModel) {
        self.coin = coin
        _detailViewModel = StateObject(wrappedValue: DetailViewModel(coin: coin))
    }
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                Text("HI")
                    .frame(height: 150)
                
                overviewTitle
                Divider()
                overViewStatsGrid
                
                additionalDetailsTitle
                Divider()
                additionalStatsGrid
                
            }
            .padding()
        }
        .navigationTitle(detailViewModel.coin.name ?? "")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                HStack {
                    Text(detailViewModel.coin.symbol?.uppercased() ?? "")
                        .font(.headline)
                        .foregroundStyle(Color.theme.secondaryText)
                    CoinImageView(coin: detailViewModel.coin)
                        .frame(width: 25, height: 25)
                }
            }
        }
    }
}

extension DetailView {
    
    private var overviewTitle: some View {
        Text("Overview")
            .font(.title)
            .fontWeight(.bold)
            .foregroundStyle(Color.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var overViewStatsGrid: some View {
        LazyVGrid(columns: columns, alignment: .leading, spacing: 30) {
            ForEach(detailViewModel.overviewStatistics) { stat in
                StatisticsView(stats: stat)
            }
        }
    }
    
    private var additionalDetailsTitle: some View {
        Text("Additional Details")
            .font(.title)
            .fontWeight(.bold)
            .foregroundStyle(Color.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var additionalStatsGrid: some View {
        LazyVGrid(columns: columns, alignment: .leading, spacing: 30) {
            ForEach(detailViewModel.additionalStatistics) { stat in
                StatisticsView(stats: stat)
            }
        }
    }
}
struct DetailView_preview: PreviewProvider {
    static var previews: some View {
        return DetailView(coin: dev.coin)
    }
}
