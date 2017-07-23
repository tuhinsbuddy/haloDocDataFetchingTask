//
//  ShowDetailsOnWebPageViewController.swift
//  haloDocDataFetching
//
//  Created by Tuhin Samui on 23/07/17.
//  Copyright © 2017 Tuhin Samui. All rights reserved.
//

import UIKit
import WebKit

class ShowDetailsOnWebPageViewController: UIViewController {
    
    @IBOutlet weak var customNavigationBarOutlet: UINavigationBar!
    @IBOutlet weak var showWebpageToLoadDetailsActivityLoader: UIActivityIndicatorView!
    @IBOutlet weak var showDetailsOnWebPageSuperView: UIView!
    fileprivate var webViewOutletForPageDetails: WKWebView? = nil
    
    var urlToLoad: String = ""
    var pageTitle: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customNavigationBarOutlet.topItem?.title = pageTitle
        self.navigationController?.isNavigationBarHidden = true
        showWebpageToLoadDetailsActivityLoader.hidesWhenStopped = true
        webViewOutletForPageDetails = WKWebView (frame: showDetailsOnWebPageSuperView.frame, configuration: WKWebViewConfiguration())
        
        webViewOutletForPageDetails?.scrollView.delegate = self
        webViewOutletForPageDetails?.scrollView.bounces = false
        webViewOutletForPageDetails?.navigationDelegate = self
        webViewOutletForPageDetails?.uiDelegate = self
        webViewOutletForPageDetails?.translatesAutoresizingMaskIntoConstraints = false
        showDetailsOnWebPageSuperView.addSubview(webViewOutletForPageDetails!)
        let height = NSLayoutConstraint(item: webViewOutletForPageDetails!, attribute: .height, relatedBy: .equal, toItem: showDetailsOnWebPageSuperView, attribute: .height, multiplier: 1, constant: 0)
        let width = NSLayoutConstraint(item: webViewOutletForPageDetails!, attribute: .width, relatedBy: .equal, toItem: showDetailsOnWebPageSuperView, attribute: .width, multiplier: 1, constant: 0)
        webViewOutletForPageDetails?.centerXAnchor.constraint(equalTo: showDetailsOnWebPageSuperView.centerXAnchor).isActive = true
        webViewOutletForPageDetails?.centerYAnchor.constraint(equalTo: showDetailsOnWebPageSuperView.centerYAnchor).isActive = true
        showDetailsOnWebPageSuperView.addConstraints([height, width])
        showDetailsOnWebPageSuperView.bringSubview(toFront: showWebpageToLoadDetailsActivityLoader)
        showWebpageToLoadDetailsActivityLoader.hidesWhenStopped = true
        
        let urlToLoadOnWebView = URL(string: urlToLoad)
        if let urlToLoadOnWebViewCheck = urlToLoadOnWebView,
            let webViewOutletForPageDetailsCheck = webViewOutletForPageDetails{
            let requestObjForWebView = URLRequest(url: urlToLoadOnWebViewCheck)
            webViewOutletForPageDetailsCheck.load(requestObjForWebView)
        } else {
            debugPrint("Url encoding failed! perform some error task here")
        }
        
        showWebpageToLoadDetailsActivityLoader.startAnimating()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        webViewOutletForPageDetails?.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        webViewOutletForPageDetails?.removeObserver(self, forKeyPath: "estimatedProgress")
        
    }
    
    @IBAction func backToPreviousPage(_ sender: UIBarButtonItem) {
        
        DispatchQueue.main.async (execute: { [unowned self] in
            if let navigationControllerCheck = self.navigationController{
                navigationControllerCheck.popViewController(animated: true)
            }else{
                self.dismiss(animated: true, completion: nil)
            }
        })
        
    }
    
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == "estimatedProgress"),
            
            let webviewProgressCheck: Double = webViewOutletForPageDetails?.estimatedProgress,
            webviewProgressCheck == 1.0{
            showWebpageToLoadDetailsActivityLoader.stopAnimating()
        }
    }
    
    
    
}


//MARK: - WKWebView Delegate Methods
extension ShowDetailsOnWebPageViewController: WKUIDelegate, WKScriptMessageHandler, WKNavigationDelegate {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if let messageBody = message.body as? String {
            print(messageBody)
            debugPrint("Can perform some native method call here. This request can come from server side. Cross platform communication it is!")
        }
    }
    
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        return nil
    }
}

//MARK: - UIScrollView Delegate Methods
extension ShowDetailsOnWebPageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return nil
    }
}
