//
//  UIViewController+Theme.swift
//  freddit
//
//  Created by Francisco Gindre on 12/06/2019.
//  Copyright © 2019 Appscrafter. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController  {
    func setBlackBarTheme() {
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
}
