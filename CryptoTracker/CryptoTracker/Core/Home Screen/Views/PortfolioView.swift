//
//  PortfolioView.swift
//  CryptoTracker
//
//  Created by Himanshu Namdeo on 02/11/25.
//

import SwiftUI

struct PortfolioView: View {
    
    @EnvironmentObject var homeViewModel: HomeViewModel
    @State private var selectedCoin: CoinModel? = nil
    @State private var quantityText = ""
    @State private var showcheckmark = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    SearchBarView(searchText: $homeViewModel.searchText)
                    coinList
                    
                    if selectedCoin != nil {
                        portfolioInputSection
                    }
                }
            }
            .navigationTitle("Edit Portfolio")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    XMarkButton()
                }
                
                if !quantityText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    ToolbarItem(id: "2", placement: .topBarLeading) {
                        trailingNavBarButton
                    }
                }
            }
            .onChange(of: homeViewModel.searchText) { oldValue, newValue in
                if newValue == "" {
                    removeSelectedCoin()
                }
            }
        }
        
    }
}

extension PortfolioView {
    private var coinList: some View {
        return ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 10) {
                ForEach(homeViewModel.searchText.isEmpty ? homeViewModel.portfolioCoins :  homeViewModel.allCoins) { coin in
                    CoinLogoView(coin: coin)
                        .onTapGesture {
                            withAnimation(.easeIn) {
                                updateSelectedCoin(coin: coin)
                            }
                        }
                        .frame(width: 75)
                        .padding(2)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(selectedCoin?.id == coin.id ? Color.theme.greenColor : .clear, lineWidth: 2)
                        )
                }
                .padding(.vertical, 4)
                .padding(.leading)
            }
        }
    }
    
    private var trailingNavBarButton: some View {
        return HStack(spacing: 10) {
            Image(systemName: "checkmark")
                .opacity(showcheckmark ? 1.0 : 0.0)
            Button {
                saveButtonPressed()
            } label: {
                Text("SAVE")
            }
            .opacity(
                (selectedCoin != nil && selectedCoin?.currentHoldings != Double(quantityText)) ? 1.0 : 0.0
            )
        }
        .font(.headline)
    }
    
    
    private var portfolioInputSection: some View {
        VStack {
            HStack {
                Text("Current price of \(selectedCoin?.symbol?.uppercased() ?? "") : ")
                Spacer()
                Text(selectedCoin?.currentPrice?.asCurrencyWith6Decimals() ?? "")
            }
            
            Divider()
            
            HStack {
                Text("Amount in your portfolio ")
                Spacer()
                TextField("Ex: 1.4", text: $quantityText)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            }
            
            Divider()
            
            HStack {
                Text("Current Value")
                Spacer()
                Text(getCurrentValue().asCurrencyWith2Decimals())
            }
        }
        .padding()
        .font(.headline)
    }
    
    private func updateSelectedCoin(coin: CoinModel) {
        selectedCoin = coin
        
        if let portfolioCoin = homeViewModel.portfolioCoins.first(where: { $0.id == coin.id }),
           let amount = portfolioCoin.currentHoldings {
            quantityText = "\(amount)"
        } else {
            quantityText = ""
        }
    }
    
    private func getCurrentValue() -> Double {
        if let quantity = Double(quantityText) {
            return quantity * (selectedCoin?.currentPrice ?? 0)
        }
        
        return 0
    }
    
    private func saveButtonPressed() {
        
        guard let coin = selectedCoin,
              let amount = Double(quantityText) else { return }
        
        homeViewModel.updatePortfolio(coin: coin, amount: amount)
        
        withAnimation(.easeIn) {
            self.showcheckmark = true
            removeSelectedCoin()
        }
        
        UIApplication.shared.endEditing()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(.easeOut) {
                self.showcheckmark = false
            }
        }
    }
    
    private func removeSelectedCoin() {
        selectedCoin = nil
        homeViewModel.searchText = ""
    }
}

struct PortfolioView_preview: PreviewProvider {
    static var previews: some View {
        PortfolioView()
            .environmentObject(dev.homeViewModel)
    }
}
