//
//  HomeStatisticsView.swift
//  CryptoTracker
//
//  Created by Himanshu Namdeo on 30/10/25.
//

import SwiftUI

struct HomeStatisticsView: View {
    
    @Binding var showPortfolio: Bool
    @EnvironmentObject var homeViewModel: HomeViewModel
    
    var body: some View {
        
        HStack {
            ForEach(homeViewModel.statistics) { statistic in
                StatisticsView(stats: statistic)
                    .frame(width: UIScreen.main.bounds.width/3)
            }
        }
        .frame(width: UIScreen.main.bounds.width, alignment: showPortfolio ? .trailing : .leading)
    }
}

struct HomeStatisticsView_preview: PreviewProvider {
    static var previews: some View {
        HomeStatisticsView(showPortfolio: .constant(false))
            .environmentObject(dev.homeViewModel)
    }
}
