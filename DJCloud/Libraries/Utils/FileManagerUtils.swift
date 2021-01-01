//
//  FileManagerUtils.swift
//  iOS Structure MVC
//
//  Created by kien on 2/19/19.
//  Copyright © 2019 kien. All rights reserved.
//

import UIKit

class FileManagerUtils {
    
    // MARK: - Static variables
    static let fileManager: FileManager  = FileManager.default
    static var documentDirectoryUrl: URL {
        return FileManagerUtils.fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    // MARK: - Static functions
    @discardableResult
    static func saveFileWith(data: Data, name: String, atUrl url: URL = FileManagerUtils.documentDirectoryUrl) -> URL? {
        let filePath = url.appendingPathComponent("\(name)")
        do {
            try data.write(to: filePath, options: .atomic)
            return filePath
        } catch { }
        return nil
    }
    
    @discardableResult
    static func removeFileAt(url: URL) -> Bool {
        do {
            try FileManagerUtils.fileManager.removeItem(at: url)
            return true
        } catch { }
        return false
    }
    
    static func copyFileToDocumentsFolder(nameForFile: String, extForFile: String) {

        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let destURL = documentsURL!.appendingPathComponent(nameForFile).appendingPathExtension(extForFile)
        guard let sourceURL = Bundle.main.url(forResource: nameForFile, withExtension: extForFile)
            else {
                print("Source File not found.")
                return
        }
            let fileManager = FileManager.default
            do {
                try fileManager.copyItem(at: sourceURL, to: destURL)
            } catch {
                print("Unable to copy file")
            }
    }
}
