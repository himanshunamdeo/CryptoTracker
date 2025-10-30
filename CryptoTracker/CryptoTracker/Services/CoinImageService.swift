//
//  CoinImageService.swift
//  CryptoTracker
//
//  Created by Himanshu Namdeo on 30/10/25.
//

import Foundation
import Combine
import SwiftUI

class CoinImageService {
    
    @Published var image: UIImage? = nil
    var imageSubscription: AnyCancellable?
    let fileManager = LocalFileManager.shared
    
    let coin: CoinModel
    let folderName = "coin_image_folder"
    let imageName: String
    
    init(coin: CoinModel) {
        self.coin = coin
        self.imageName = coin.id ?? ""
        getImage()
    }
    
    func getImage() {
        if let savedImage = fileManager.getImage(imageName: imageName, folderName: folderName) {
            image = savedImage
        } else {
            downloadImage()
        }
    }
    
    private func downloadImage() {
        guard let urlString = coin.image,
            let url = URL(string: urlString) else { return }
        
        imageSubscription = NetworkingManager.download(url: url)
            .compactMap { UIImage(data: $0) }
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] image in
                guard let self = self else {return}
                self.image = image
                self.imageSubscription?.cancel()
                self.fileManager.saveImage(image: image, imageName: imageName, folderName: folderName)
            })
        
    }
}
