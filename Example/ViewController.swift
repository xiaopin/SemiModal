//
//  ViewController.swift
//  Example
//
//  Created by nhope on 2018/1/10.
//  Copyright © 2018年 xiaopin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func buttonAction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ContentViewController")
        presentSemiModalViewController(vc, contentHeight: 300.0, shouldDismissPopover: true, completion: nil)
        
//        let contentView = UIView()
//        contentView.backgroundColor = .purple
//        presentSemiModalView(contentView, contentHeight: 300.0, shouldDismissPopover: false) {
//            DispatchQueue.main.asyncAfter(deadline: .now()+3.0, execute: {
//                self.presentedViewController?.dismiss(animated: true, completion: nil)
//            })
//        }
    }
    
}

