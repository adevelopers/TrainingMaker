//
//  Settable.swift
//  TesterUserInterface
//
//  Created by adeveloper on 08.06.17.
//  Copyright © 2017 adeveloper. All rights reserved.
//

import UIKit

protocol Settable {}

extension Settable {
    func apply(_ set: (Self)-> Void) {
        set(self)
    }
}

extension UIView: Settable {}

