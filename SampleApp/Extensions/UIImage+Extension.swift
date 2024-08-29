//
//  UIImage+Extension.swift
//  Sample App
//
//  Created by Mudassir Asghar on 04/06/2024.
//

import UIKit

extension UIImage {

    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()

    }

    func resizedTo9MB() -> UIImage? {
        guard let imageData = self.pngData() else { return nil }
        var resizingImage = self
        var imageSizeKB = Double(imageData.count) / 1000.0
        while imageSizeKB > 9000 {
            guard let resizedImage = resizingImage.resized(withPercentage: 0.5),
                  let imageData = resizedImage.pngData()
            else { return nil }
            resizingImage = resizedImage
            imageSizeKB = Double(imageData.count) / 1000.0 
        }
        return resizingImage
    }

    func getSize() -> Double? {
        guard let imageData = self.pngData() else { return nil }
        var resizingImage = self
        var imageSizeKB = Double(imageData.count) / 1000.0
        return imageSizeKB
    }
    
    // Save an image to the Documents directory
    func saveImage(withName name: String) -> URL? {
        let documentsDirectory = Helper.shared.getDocumentsDirectory()
        let destinationURL = documentsDirectory.appendingPathComponent(name)

        if let data = self.jpegData(compressionQuality: 0.5) {
            do {
                try data.write(to: destinationURL)
                print("Image saved to \(destinationURL.path)")
                return destinationURL
            } catch {
                print("Error saving image: \(error)")
                return nil
            }
        }
        return nil
    }

    // Load an image from the Documents directory
    func loadImage(withName name: String) -> UIImage? {
        let documentsDirectory = Helper.shared.getDocumentsDirectory()
        let fileURL = documentsDirectory.appendingPathComponent(name)

        if FileManager.default.fileExists(atPath: fileURL.path) {
            return UIImage(contentsOfFile: fileURL.path)
        } else {
            print("Image file does not exist at path: \(fileURL.path)")
            return nil
        }
    }
}
