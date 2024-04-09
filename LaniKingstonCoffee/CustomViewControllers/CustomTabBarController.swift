//
//  CustomTabBarController.swift
//  LaniKingstonCoffee
//
//  Created by Mackenzie Wacker on 1/6/23.
//

import UIKit

class CustomTabBarController: UITabBarController {
    @IBInspectable var initialIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedIndex = initialIndex
    }
}
