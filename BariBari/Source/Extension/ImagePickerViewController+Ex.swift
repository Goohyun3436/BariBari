//
//  ImagePickerViewController+Ex.swift
//  BariBari
//
//  Created by Goo on 4/6/25.
//

import UIKit

extension UIImagePickerController {
    
    func convertImageToBase64(image: UIImage) -> String? {
        guard let imageData = image.pngData() else { return nil }
        return imageData.base64EncodedString(options: .lineLength64Characters)
    }
    
    func convertBase64ToImage(base64String: String) -> UIImage? {
        guard let imageData = Data(base64Encoded: base64String) else { return nil }
        return UIImage(data: imageData)
    }
    
}
