//
//  WebViewController.swift
//  HDEmptyViewDemo
//
//  Created by liuyi on 2018/5/28.
//  Copyright © 2018年 liuyi. All rights reserved.
//

import UIKit
import WebKit

//适配iPhone X
let kNavBarHeight = 44
let kStatusBarHeight = UIApplication.shared.statusBarFrame.size.height
//TabBarHeight
let kTabBarHeight = kStatusBarHeight > 20 ? 83 : 49
//NavBarHeight
let kTopHeight =  Float(kNavBarHeight) + Float(kStatusBarHeight)

class WebViewController: UIViewController,WKNavigationDelegate {
    
    fileprivate var webView: WKWebView!
    fileprivate var progressView: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initWkWebView()
        self.initProgressView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadingURL(urltring: "http://news.baidu.com/")
    }
    
    //MARK: ---------- 初始化 webView ----------
    func initWkWebView() {
        
        self.webView = WKWebView(frame: self.view.bounds)
        self.view.addSubview(self.webView!)
        
        self.webView.navigationDelegate = self
        self.webView.allowsBackForwardNavigationGestures = true
        //监听进度
        self.webView.addObserver(self, forKeyPath: "estimatedProgress", options: NSKeyValueObservingOptions.new, context: nil)
        
        weak var weakSelf = self
        //空数据界面
        let emptyV:HDEmptyView = HDEmptyView.emptyActionViewWithImageStr(imageStr: "net_error_tip", titleStr: "暂无数据", detailStr: "请检查网络连接或稍后再试", btnTitleStr: "重新加载") {
            print("点击刷新")
            weakSelf!.loadingURL(urltring: "http://news.baidu.com/")
        }
        
        emptyV.contentViewY = -100
        emptyV.actionBtnBackGroundColor = .lightGray
        self.webView.scrollView.ly_emptyView = emptyV
        
        self.webView.scrollView.ly_emptyView?.tapContentViewBlock = {
            weakSelf!.loadingURL(urltring: "http://news.baidu.com/")
        }
    }
    
    //MARK: ---------- 初始化progressView ----------
    func initProgressView() {
        
        self.progressView = UIProgressView(progressViewStyle: UIProgressViewStyle.bar)
        self.progressView.frame = CGRect(x: 0, y:CGFloat(kTopHeight) , width: self.view.bounds.width, height: 5.0)
        self.view.addSubview(self.progressView)
        self.progressView.isHidden = true
        self.progressView.trackTintColor = UIColor.clear
        self.progressView.progressTintColor = UIColor.blue
    }
    
    func loadingURL(urltring: String) {
        let urlstr = URL(string: urltring)
        self.webView!.load(URLRequest(url: urlstr!))
    }
    
    //MARK: ----  observeValue ---
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            if object as! NSObject == self.webView {
                print(self.webView.estimatedProgress)
                if self.webView.estimatedProgress > 0.2 {
                    self.progressView.setProgress(Float(self.webView.estimatedProgress), animated: true)
                }
            }
            if self.webView.estimatedProgress >= 1.0 {
                self.progressView.setProgress(0.99999, animated: true)
                UIView.animate(withDuration: 0.3, delay: 0.3, options: UIViewAnimationOptions.autoreverse, animations: {
                    self.progressView.isHidden = true
                    self.progressView.setProgress(0.0, animated: false)
                }, completion: nil)
            }
        }else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    //MARK: ---- WKNavigationDelegate ----
    //开始加载
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
        self.progressView.isHidden = false
        self.progressView.setProgress(0.2, animated: true)
        print("_____开始加载_____")
    }
    
    //完成加载
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("_____完成加载_____")
        self.webView.scrollView.ly_hideEmptyView()

    }
    //加载失败
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("_____加载失败_____")
        self.webView.scrollView.ly_showEmptyView()
        self.progressView.isHidden = true
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
    }
    
    
}
