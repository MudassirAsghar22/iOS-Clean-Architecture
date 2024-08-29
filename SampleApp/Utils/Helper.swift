//
//  Helper.swift
//  Sample App
//
//  Created by Mudassir Asghar on 14/05/2024.
//

import UIKit

class Helper {

    static let shared = Helper()

    // MARK: - isValidEmailAddress
    func isValidEmailAddress(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)

    }

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    // saveFile
    func saveFile(from sourceURL: URL, withName name: String) -> URL? {
        let documentsDirectory = getDocumentsDirectory()
        let destinationURL = documentsDirectory.appendingPathComponent(name)

        do {
            let fileData = try Data(contentsOf: sourceURL)
            try fileData.write(to: destinationURL)
            print("File saved to \(destinationURL.path)")
            return destinationURL
        } catch {
            print("Error saving file: \(error)")
            return nil
        }
    }

    // deleteFile
    func deleteFile(at url: URL) {
        let fileManager = FileManager.default

        do {
            // Check if the file exists
            if fileManager.fileExists(atPath: url.path) {
                // Attempt to delete the file
                try fileManager.removeItem(at: url)
                print("File deleted successfully.")
            } else {
                print("File does not exist.")
            }
        } catch {
            print("Failed to delete file: \(error.localizedDescription)")
        }
    }

    // MARK: - openURLInSafari
    func openURLInSafari(url: URL) {
           if UIApplication.shared.canOpenURL(url) {
               UIApplication.shared.open(url, options: [:], completionHandler: { (success) in
                   if success {
                       print("Opened \(url) successfully.")
                   } else {
                       print("Failed to open \(url).")
                   }
               })
           } else {
               print("Invalid URL or cannot open URL.")
           }
       }

    func removeExistingBanner() {
        guard let window = appDelegate?.window else { return }
        let banners = window.subviews.filter { NSStringFromClass($0.classForCoder).contains("NotificationBannerSwift") }
        for value in banners {
            value.removeFromSuperview()
        }
    }
}
