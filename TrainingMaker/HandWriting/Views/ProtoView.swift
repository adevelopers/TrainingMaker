//
//  MetaView.swift
//  ChemNote
//
//  Created by Kirill Khudyakov on 04.07.17.
//  Copyright © 2017 ChemNote, LLC. All rights reserved.
//

import UIKit

class ProtoView: UIImageView {

    convenience init() {
        self.init(frame: .zero)
        
        backgroundColor = .white
        layer.cornerRadius = 3
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.shadowRadius = 2
        
    }

}
