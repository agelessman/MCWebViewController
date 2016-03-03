//
//  ViewController.swift
//  MCWebVIew
//
//  Created by 马超 on 16/3/3.
//  Copyright © 2016年 @qq:714080794 (交流qq). All rights reserved.
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

    @IBAction func buttonAction(sender: AnyObject) {
        
        
        
        let tabVC = MCWebViewController(url: "http:www.7keyun.com")
//        let nav = UINavigationController(rootViewController: tabVC)
//        self.presentViewController(nav, animated: true, completion: nil)
        self.navigationController!.pushViewController(tabVC, animated: true)
    }

}

