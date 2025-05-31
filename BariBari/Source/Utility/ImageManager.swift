//
//  ImageManager.swift
//  BariBari
//
//  Created by Goo on 4/6/25.
//

import UIKit
import PhotosUI
import RxSwift

protocol ImageManagerProtocol {
    func convertImageToData(image: UIImage, compressionQuality: CGFloat) -> Data?
    func convertPHPicker(with results: [PHPickerResult]) -> Single<Result<(UIImage, Data?), ImageError>>
}

enum ImageError: AppError, Error {
    case loadImage
    
    var title: String {
        return C.failure
    }
    
    var message: String {
        return C.cantLoadImageMessage
    }
    
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
    
    func convertPHPicker(with results: [PHPickerResult]) -> Single<Result<(UIImage, Data?), ImageError>> {
        return Single<Result<(UIImage, Data?), ImageError>>.create { observer in
            let disposables = Disposables.create()
            
            guard let firstResult = results.first,
                  firstResult.itemProvider.canLoadObject(ofClass: UIImage.self)
            else {
                observer(.success(.failure(.loadImage)))
                return disposables
            }
            
            firstResult.itemProvider.loadObject(ofClass: UIImage.self) { image_, error in
                if let _ = error {
                    observer(.success(.failure(.loadImage)))
                    return
                }
                
                guard let selectedImage = image_ as? UIImage else {
                    observer(.success(.failure(.loadImage)))
                    return
                }
                
                let imageData = ImageManager.shared.convertImageToData(image: selectedImage)
                
                observer(.success(.success((selectedImage, imageData))))
            }
            
            return disposables
        }
    }
    
    func downsample(
        data: Data?,
        to pointSize: CGSize = CGSize(width: 180, height: 180),
        scale: CGFloat = UIScreen.main.scale
    ) -> Data? {
        guard let data else { return nil }
        
        let maxDimensionInPixels = max(pointSize.width, pointSize.height) * scale
        
        let options: [CFString: Any] = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceThumbnailMaxPixelSize: maxDimensionInPixels
        ]
        
        guard let source = CGImageSourceCreateWithData(data as CFData, nil),
              let cgImage = CGImageSourceCreateThumbnailAtIndex(source, 0, options as CFDictionary) else {
            return nil
        }
        
        let uiImage = UIImage(cgImage: cgImage)
        
        return uiImage.jpegData(compressionQuality: 0.7)
    }
    
}
