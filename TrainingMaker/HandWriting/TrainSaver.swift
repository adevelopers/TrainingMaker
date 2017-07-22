//
//  TrainSaver.swift
//  ChemNote
//
//  Created by Kirill Khudyakov on 04.07.17.
//  Copyright © 2017 ChemNote, LLC. All rights reserved.
//

import Foundation

// Class for saving training image to file
class TrainSaver {
    
    let fileName: String = "trainPattern"
    let fileExtension: String = "bin"
    enum Errors: String {
        case file = "Error with file"
    }
    
    private func createArrayPath () -> String? {
        if let docsPath: String = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last {
            
            return ((docsPath as NSString).appendingPathComponent(fileName) as NSString).appendingPathExtension(fileExtension)
        }
        return nil
    }

    @discardableResult
    func save(with array:[Float]) -> URL? {
        if let path: String = createArrayPath() {
            let url = URL(fileURLWithPath: path)
            var outputData = Data()
            outputData.append( UnsafeBufferPointer(start: array, count: array.count))
            
            do {
                print("output file: \n\(url.path)")
                try outputData.write(to: url, options: .atomicWrite)
            }
            catch {
                fatalError(Errors.file.rawValue)
            }
            return url
        }
        return nil
    }
    
}
