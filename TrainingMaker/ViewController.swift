//
//  ViewController.swift
//  TrainingMaker
//
//  Created by Kirill Khudyakov on 21.07.17.
//  Copyright © 2017 adeveloper. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBAction func sendToServer(_ sender: UIButton) {
        sendFileToServer()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        sendFileToServer()
    }
    
}

extension ViewController {
    
    
    func makeFile() {
        
    }
    
    func sendFileToServer() {
        let urlFile = Bundle.main.url(forResource:"data", withExtension: "txt")
        let server = "http://chemnote.dev/api/"
        
        if let file = urlFile {
            Uploader.upload(file: file, to: server, fileName: "data.txt")
        }
    }
    
}

