//
//  ItemDetailsVC.swift
//  DreamLister
//
//  Created by Simon Zhen on 5/5/17.
//  Copyright © 2017 Simon Zhen. All rights reserved.
//

import UIKit

class ItemDetailsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        }
    }
}
