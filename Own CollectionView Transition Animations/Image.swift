//
//  File.swift
//  Own CollectionView Transition Animations
//
//  Created by Ilya Cherkasov on 08.04.2021.
//

import UIKit

struct Image {
    
    var image: UIImage
    var containerSize: CGSize?
    private var cgImage: CGImage
    enum CropMode {
        case auto
        
    }
    
    init(image: UIImage) {
        self.image = image
        cgImage = image.cgImage!
    }
    
    init(image: UIImage, containerSize: CGSize) {
        self.image = image
        cgImage = image.cgImage!
        self.containerSize = containerSize
    }

    func cropImage(with mode: CropMode = .auto) -> UIImage? {
        guard let containerSize = containerSize else { return nil }
        let scaleX = CGFloat(cgImage.width) / containerSize.width
        let scaleY = CGFloat(cgImage.height) / containerSize.height
        let scale = min(scaleX, scaleY)
        let rect = CGRect(origin: CGPoint(x: (CGFloat(cgImage.width) - containerSize.width * scale) / 2, y: (CGFloat(cgImage.height) - containerSize.height * scale) / 2),
                          size: CGSize(width: containerSize.width * scale, height: containerSize.height * scale))
        let croppedCGImage = cgImage.cropping(to: CGRect(x: rect.origin.x, y: rect.origin.y, width: rect.size.width, height: rect.size.height))
        return UIImage(cgImage: croppedCGImage!)
    }
}
