//
//  ViewController.swift
//  HDEmptyViewDemo
//
//  Created by liuyi on 2018/5/18.
//  Copyright © 2018年 liuyi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var myScrollView: UIScrollView = UIScrollView()
    
    @IBAction func pushToSecVCAction(_ sender: UIButton) {
        let index = sender.tag - 100
        if index == 1 {
            self.performSegue(withIdentifier: "pushToWebVCLine", sender: nil)
        }
        else if index == 2 {
            self.performSegue(withIdentifier: "pushToTableViewController", sender: nil)
            
        }
        else if index == 3 {
            self.performSegue(withIdentifier: "pushToCollectionVC", sender: nil)
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "HDEmptyViewDemo"
        myScrollView.frame = CGRect.init(x: 0, y: 0, width: view.ly_width, height: view.ly_height)
        myScrollView.contentSize = CGSize.init(width: view.ly_width, height: view.ly_height*2)
        myScrollView.backgroundColor = .gray
        
//        view.addSubview(myScrollView)
//        self.myScrollView.ly_startLoading()
//        weakSelf?.myScrollView.ly_showEmptyView()
         
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

