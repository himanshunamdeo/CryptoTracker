//
//  HomeView.swift
//  CryptoTracker
//
//  Created by Himanshu Namdeo on 28/10/25.
//

import SwiftUI

struct HomeView: View {
    @State private var showPortfolio: Bool = false
    @EnvironmentObject private var homeViewModel: HomeViewModel
    @State private var showPortfolioView: Bool = false
    
    var body: some View {
        
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
                .sheet(isPresented: $showPortfolioView) {
                    PortfolioView()
                        .environmentObject(homeViewModel)
                }
            
            VStack {
                homeHeader
                HomeStatisticsView(showPortfolio: $showPortfolio)
                SearchBarView(searchText: $homeViewModel.searchText)
                columnTitles
                
                
                if !showPortfolio {
                    allCoinsView
                    .transition(.move(edge: .leading))
                } else {
                    portfolioCoinsView
                        .transition(.move(edge: .trailing))
                }
                
                Spacer()
            }
        }
    }
}

extension HomeView{
    private var homeHeader: some View {
        HStack {
            CircleButtonView(iconName: showPortfolio ? "plus" : "info")
                .animation(.none, value: showPortfolio)
                .onTapGesture {
                    if showPortfolio == true {
                        showPortfolioView.toggle()
                    }
                }
                .background(
                    CircleButtonAnimationView(animate: $showPortfolio)
                )
            
            Spacer()
            
            Text(showPortfolio ? "Portfolio" : "Live Prices")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundStyle(Color.theme.accent)
                .animation(.none, value: showPortfolio)
            
            Spacer()
            
            CircleButtonView(iconName: "chevron.right")
                .rotationEffect(Angle(degrees: showPortfolio ? 180.0 : 0.0))
                .onTapGesture {
                    withAnimation(.spring) {
                        showPortfolio.toggle()
                    }
                }
        }
    }
    
    private var allCoinsView: some View {
        List {
            ForEach(homeViewModel.allCoins) { coin in
                CoinRowView(coin: coin, showHoldingsColumn: false)
            }
        }
        .listStyle(.plain)
    }
    
    private var portfolioCoinsView: some View {
        List {
            ForEach(homeViewModel.portfolioCoins) { coin in
                CoinRowView(coin: coin, showHoldingsColumn: true)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
            }
        }
        .listStyle(.plain)
    }
    
    private var columnTitles: some View {
        HStack {
            Text("Coin")
            Spacer()
            
            if showPortfolio {
                Text("Holdings")
            }
            
            Text("Price")
                .frame(width: UIScreen.main.bounds.width / 3, alignment: .trailing)
        }
        .font(.caption)
        .foregroundStyle(Color.secondaryText)
        .padding(.horizontal)
    }
}

struct HomeView_preview: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView()
                .navigationBarHidden(true)
        }
        .environmentObject(Self.dev.homeViewModel)
    }
}
