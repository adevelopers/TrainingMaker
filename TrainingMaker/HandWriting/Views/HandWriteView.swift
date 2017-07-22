//
//  HandWriteView.swift
//  ChemNote
//
//  Created by Kirill Khudyakov on 04.07.17.
//  Copyright © 2017 ChemNote, LLC. All rights reserved.
//

import UIKit
import SnapKit

class HandWriteView: UIView {
    
        var screenSize: CGSize {
            return UIScreen.main.bounds.size
        }
    
        // Canvas
        let instructionLabel = UILabel()
        let canvasContainer = ProtoView()
        let canvas = UIImageView()
        let snapshotBox = UIView()
        // Input
        let inputTitleLabel = UILabel()
        let networkInputContainer = ProtoView()
        let networkInputCanvas = UIImageView()
        // Output
        let outputTitleLabel = UILabel()
        let networkOutputView = ProtoView()
        let outputLabel = UILabel()
        let confidenceLabel = UILabel()
    
        convenience init() {
            self.init(frame: .zero)
            
            configure()
        }
    
}

extension HandWriteView {
    
    func buildViewHierarchy() {
        let subviews = [instructionLabel, canvasContainer,
                        inputTitleLabel, networkInputContainer,
                        outputTitleLabel, networkOutputView]
        
        subviews.forEach{ subview in
            addSubview(subview)
            subview.translatesAutoresizingMaskIntoConstraints = false
        }
        
        canvasContainer.addSubview(canvas)
        canvasContainer.addSubview(snapshotBox)
        networkInputContainer.addSubview(networkInputCanvas)
        networkOutputView.addSubview(outputLabel)
        networkOutputView.addSubview(confidenceLabel)
    }
    
    func setUpConstraints() {

        
        canvasContainer.snp.makeConstraints{set in
            let heightForCanvas = screenSize.height*0.5
            set.left.equalToSuperview().offset(8)
            set.right.equalToSuperview().offset(-8)
            set.top.equalToSuperview().offset(64+10+30)
            set.height.equalTo(heightForCanvas)
            set.width.equalToSuperview().offset(-16)
        }
        
        instructionLabel.snp.makeConstraints{set in
            set.centerX.equalToSuperview()
            set.bottom.equalTo(canvasContainer.snp.top).offset(-5)
            set.width.equalToSuperview().offset(-16)
            set.height.equalTo(30)
        }
        
        canvas.snp.makeConstraints{set in
            set.edges.equalToSuperview()
        }
        
        inputTitleLabel.snp.makeConstraints{set in
            set.centerX.equalTo(networkInputContainer.snp.centerX)
            set.bottom.equalTo(networkInputContainer.snp.top).offset(-5)
        }
        
        networkInputContainer.snp.makeConstraints{set in
            set.left.equalToSuperview().offset(8)
            set.right.equalTo(snp.centerX).offset(-4)
            set.top.equalTo(canvasContainer.snp.bottom).offset(30)
            set.bottom.equalToSuperview().offset(-30)
        }
        
        networkInputCanvas.snp.makeConstraints{set in
            set.edges.equalToSuperview()
        }
        
        outputTitleLabel.snp.makeConstraints{set in
            set.centerX.equalTo(networkOutputView.snp.centerX)
            set.bottom.equalTo(networkOutputView.snp.top).offset(-5)
        }
        
        networkOutputView.snp.makeConstraints{set in
            set.left.equalTo(networkInputContainer.snp.right).offset(4)
            set.right.equalToSuperview().offset(-8)
            set.top.equalTo(networkInputContainer.snp.top)
            set.bottom.equalTo(networkInputContainer.snp.bottom)
        }
        
        outputLabel.snp.makeConstraints{set in
            set.centerX.equalTo(networkOutputView.snp.centerX)
            set.centerY.equalTo(networkOutputView.snp.centerY).offset(-5)
        }
        
        confidenceLabel.snp.makeConstraints{set in
            set.centerX.equalTo(networkOutputView.snp.centerX)
            set.bottom.equalTo(networkOutputView.snp.bottom).offset(-5)
        }

    }
    
    func configureViews() {
         backgroundColor = .from("EEEEEE")
        
        instructionLabel.apply{set in
            set.text = "Sketch a chem symbol"
            set.textColor = UIColor.darkGray
            set.font = UIFont.systemFont(ofSize: 15)
            set.textAlignment = .center
        }
        
        canvasContainer.apply{set in
            set.backgroundColor = .from("FFFFFF")
        }
        
        snapshotBox.apply{set in
            set.backgroundColor = .clear
            set.layer.borderColor = UIColor.from("417505").cgColor
            set.layer.borderWidth = 2
            set.layer.cornerRadius = 3
        }
        
        inputTitleLabel.apply{set in
            set.text = "Network input"
            set.textColor = UIColor.darkGray
            set.font = UIFont.systemFont(ofSize: 15)
            set.textAlignment = .center
        }

        outputTitleLabel.apply{set in
            set.text = "Network output"
            set.textColor = UIColor.darkGray
            set.font = UIFont.systemFont(ofSize: 15)
            set.textAlignment = .center
        }

        outputLabel.apply{set in
            set.font = UIFont.systemFont(ofSize: 100, weight: UIFontWeightLight)
            set.textAlignment = .center
        }

        confidenceLabel.apply{set in
            set.font = UIFont.systemFont(ofSize: 15)
            set.textAlignment = .center
        }
        
    }

    func configure() {
        buildViewHierarchy()
        setUpConstraints()
        configureViews()
    }

}
