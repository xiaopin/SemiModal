//
//  ContentViewController.swift
//  Example
//
//  Created by nhope on 2018/1/10.
//  Copyright © 2018年 xiaopin. All rights reserved.
//

import UIKit

class ContentViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func buttonAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

}
