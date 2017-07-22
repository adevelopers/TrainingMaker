//
//  ViewController.swift
//  TrainingMaker
//
//  Created by Kirill Khudyakov on 21.07.17.
//  Copyright © 2017 adeveloper. All rights reserved.
//

import UIKit
import FileKit

class ViewController: UIViewController {
    @IBAction func sendToServer(_ sender: UIButton) {
        sendFileToServer()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
       // sendFileToServer()
        makeFile()
    }
    
}

extension ViewController {
    
    
    func makeFile() {
        let fileTxt = TextFile(path: Path.userDocuments + "proxima.txt")
        let server = "http://chemnote.dev/api/"
        Uploader.upload(file: fileTxt.path.url, to: server, fileName: "data.txt")
        print("path: \(fileTxt.path.url)")
    }
    
    func sendFileToServer() {
        let urlFile = Bundle.main.url(forResource:"data", withExtension: "txt")
        let server = "http://chemnote.dev/api/"
        
        if let file = urlFile {
            Uploader.upload(file: file, to: server, fileName: "data.txt")
        }
    }
    
}

