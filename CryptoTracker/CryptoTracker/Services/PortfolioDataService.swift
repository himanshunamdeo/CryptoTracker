//
//  PortfolioDataService.swift
//  CryptoTracker
//
//  Created by Himanshu Namdeo on 03/11/25.
//

import CoreData
import Combine

class PortfolioDataService {
        
    let context = PersistenceController.shared.container.viewContext
    
    @Published var savedEntities: [PortfolioEntity] = []
    
    init () {
        getPortfolio()
    }
    
    func updatePortfolio(coin: CoinModel, amount: Double) {
        if let entity = savedEntities.first(where: {$0.coinID == coin.id }) {
            if amount > 0 {
                update(entity: entity, amount: amount)
            } else {
                delete(entity: entity)
            }
        } else {
            add(coin: coin, amount: amount)
        }
    }
    
    private func getPortfolio() {
        let request = NSFetchRequest<PortfolioEntity>(entityName: "PortfolioEntity")
        do {
            savedEntities = try context.fetch(request)
        } catch (let error) {
            print(error.localizedDescription)
        }
    }
    
    private func add(coin: CoinModel, amount: Double) {
        let entity = PortfolioEntity(context: context)
        entity.coinID = coin.id
        entity.amount = amount
        applyChanges()
    }
    
    private func update(entity: PortfolioEntity, amount: Double) {
        entity.amount = amount
        applyChanges()
    }
    
    private func delete(entity: PortfolioEntity) {
        context.delete(entity)
        applyChanges()
    }
    
    private func save() {
        do {
            try context.save()
        } catch (let error) {
            print("Error saving data: \(error)")
        }
    }
    
    private func applyChanges() {
        save()
        getPortfolio()
    }
}
