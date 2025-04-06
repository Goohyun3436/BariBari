//
//  ImageManager.swift
//  BariBari
//
//  Created by Goo on 4/6/25.
//

import UIKit

protocol ImageManagerProtocol {
    func convertImageToData(image: UIImage, compressionQuality: CGFloat) -> Data?
}

final class ImageManager: ImageManagerProtocol {
    
    static let shared = ImageManager()
    
    private init() {}
    
    func convertImageToData(
        image: UIImage,
        compressionQuality: CGFloat = 0.8
    ) -> Data? {
        return image.jpegData(compressionQuality: compressionQuality)
    }
    
}
