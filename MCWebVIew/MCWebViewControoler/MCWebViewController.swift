//
//  MCWebViewController.swift
//  MCWebVIew
//
//  Created by 马超 on 16/3/3.
//  Copyright © 2016年 @qq:714080794 (交流qq). All rights reserved.
//

import UIKit
import WebKit


class MCWebViewController: UIViewController,WKNavigationDelegate {

    
    
    var url: String?
    var haveNavBar: Bool = true
    
    private var webView: UIWebView?  ///ios8 一下的支持
    private var wwebView: WKWebView! /// ios8 + 的支持
    private var errorLabel: UILabel?
    private var progressView: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.whiteColor()
        //关闭系统自动缩进
        if self.respondsToSelector("setAutomaticallyAdjustsScrollViewInsets:") {
            
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
       
       
        
        if let _ = url {

            if NSProcessInfo().isOperatingSystemAtLeastVersion(NSOperatingSystemVersion(majorVersion: 8, minorVersion: 0, patchVersion: 0)) {
                
                self.initWkWebView()
                
            }else {
                
                self.webView = UIWebView(frame: self.view.bounds)
                self.view.addSubview(self.webView!)
            }
        }else {
            
            self.showError("Please enter a url string")
        }

        
         self.initNavBar()
         self.initProgressView()
    }
    
    
     init(url: String?) {
        
        super.init(nibName: nil, bundle: nil)
        
        self.url = url
        
    }

     required init?(coder aDecoder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }


    //MARK: ----------- 私有方法 ----------
    func showError(message: String?) {
        
        hideError()
        errorLabel = UILabel()
        errorLabel!.font = UIFont.systemFontOfSize(17)
        errorLabel!.textAlignment = NSTextAlignment.Center
        errorLabel!.textColor = UIColor.redColor()
        errorLabel!.text = message
        self.view.addSubview(errorLabel!)
        
        errorLabel!.frame = CGRectMake(0, self.view.bounds.height / 2 - 10, self.view.bounds.width, 20)
    }
    
    func hideError() {
        
        if let _ = errorLabel {
           errorLabel!.removeFromSuperview()
        }
        
    }
    
    func setMyTitle(title: String?) {
        
        self.title = title;
    }
    
    
    //MARK: ---------- 初始话wk -----------
    func initWkWebView() {
        
        self.wwebView = WKWebView(frame: self.view.bounds)

        self.wwebView.navigationDelegate = self
        self.view.addSubview(self.wwebView!)
        
        self.wwebView.allowsBackForwardNavigationGestures = true
        
        if self.haveNavBar {
            self.wwebView.scrollView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0)
        }else {
            self.wwebView.scrollView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0)
        }
        self.wwebView!.loadRequest(NSURLRequest(URL: NSURL(string: self.url!)!))
        
        //监听进度
        self.wwebView.addObserver(self, forKeyPath: "estimatedProgress", options: NSKeyValueObservingOptions.New, context: nil)
        //监听标题
        self.wwebView.addObserver(self, forKeyPath: "title", options: NSKeyValueObservingOptions.New, context: nil)
    }
    
    //MARK: ---------- 初始化progressView ----------
    func initProgressView() {
        
        self.progressView = UIProgressView(progressViewStyle: UIProgressViewStyle.Bar)
        self.progressView.frame = CGRectMake(0, haveNavBar ? 64 : 20 , self.view.bounds.width, 5.0)
        self.view.addSubview(self.progressView)
        
        self.progressView.hidden = true
        self.progressView.trackTintColor = UIColor.clearColor()
        self.progressView.progressTintColor = UIColor.redColor()
    }
    
    //MARK: ---------- 初始化导航 ----------
    //隐藏系统的,替换成自定义的导航，这个日后再扩展，目前先使用系统自带的
    func initNavBar() {
        
        self.navigationItem.leftBarButtonItems = nil
        self.navigationItem.leftBarButtonItem = nil
        
        let backBtn = UIButton()
        backBtn.setImage(UIImage(named: "back_icon"), forState: UIControlState.Normal)
        backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        backBtn.frame = CGRectMake(0, 0, 40, 40)
        backBtn.addTarget(self, action: "backAction", forControlEvents: UIControlEvents.TouchUpInside)
        
        let backItem = UIBarButtonItem(customView: backBtn)
        
        let closeBtn = UIButton()
        closeBtn.setTitle("关闭", forState: UIControlState.Normal)
        closeBtn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        closeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        closeBtn.frame = CGRectMake(0, 0, 40, 40)
        closeBtn.addTarget(self, action: "closeAction", forControlEvents: UIControlEvents.TouchUpInside)
        
        let closeItem = UIBarButtonItem(customView: closeBtn)
        
        if self.wwebView != nil && self.wwebView.canGoBack {
            self.navigationItem.leftBarButtonItems = [backItem,closeItem]
        }else {
            self.navigationItem.leftBarButtonItem = backItem
        }
        
    }
    
    //MARK: ---------- wkdelegate ----------
    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
        self.progressView.hidden = false
        self.progressView.setProgress(0.2, animated: true)
    }
    

    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {

        

    }

    func webView(webView: WKWebView, didFailNavigation navigation: WKNavigation!, withError error: NSError) {
        
        self.progressView.hidden = true
    }
    
    
    //MARK:----------进度的监听方法
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        if keyPath == "estimatedProgress" {
            
            if object as! NSObject == self.wwebView {
                print(self.wwebView.estimatedProgress)
                if self.wwebView.estimatedProgress > 0.2 {
                  
                    self.progressView.setProgress(Float(self.wwebView.estimatedProgress), animated: true)
                    
                    if self.wwebView.estimatedProgress >= 1.0 {
                      
                        self.progressView.setProgress(0.99999, animated: true)
                        UIView.animateWithDuration(0.3, delay: 0.3, options: UIViewAnimationOptions.Autoreverse, animations: { () -> Void in
                                self.progressView.hidden = true
                                self.progressView.setProgress(0.0, animated: false)
                            }) { (finish) -> Void in

                        }
                    }
                    
                }
                
                
            }else {
                
                super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
            }
        }else if keyPath == "title" {
            
             if object as! NSObject == self.wwebView {
                
                self.setMyTitle(self.wwebView.title)
                
                if self.wwebView != nil && self.wwebView.canGoForward {
                    
                    self.initNavBar()
                }
                
             }else{
                
               super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
                
            }
        }else {
            
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }
    
    
    //MARK: --------- private func ----------
    func closeAction() {
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func backAction() {
        
        if self.wwebView.canGoBack {
            
            self.wwebView.goBack()
        }else {
            
            self.closeAction()
        }
        
    }
    
    
    
    
    
    deinit {
        
        if let _ = self.wwebView {
            
            self.wwebView.removeObserver(self, forKeyPath: "estimatedProgress")
            self.wwebView.removeObserver(self, forKeyPath: "title")
        }
    }
}
