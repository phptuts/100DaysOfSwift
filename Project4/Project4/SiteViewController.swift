//
//  ViewController.swift
//  Project4
//
//  Created by Noah Glaser on 12/4/21.
//

import UIKit
import WebKit

class SiteViewController: UIViewController, WKNavigationDelegate {
    
    var webView: WKWebView!
    
    var progressView: UIProgressView!
    
    var websites = ["apple.com", "hackingwithswift.com"]
    
    var firstUrl: String!
    
    
    override func loadView() {
        webView = WKWebView()
        webView.showsLargeContentViewer = true
        webView.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresher = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        let back = UIBarButtonItem(barButtonSystemItem: .undo, target: webView, action: #selector(webView.goBack))
        let forward = UIBarButtonItem(barButtonSystemItem: .redo, target: webView, action: #selector(webView.goForward))

        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        
        let progressButton = UIBarButtonItem(customView: progressView)
        
        self.toolbarItems = [progressButton, spacer, refresher, back, forward]
        self.navigationController?.isToolbarHidden = false
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
        let url = URL(string: "https://" + firstUrl)!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
    
    @objc func openTapped() {
        let ac = UIAlertController(title: "Open page...", message: nil, preferredStyle: .actionSheet)
        
        for website in websites {
            ac.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
        }
        ac.addAction(UIAlertAction(title: "google.com", style: .default, handler: openPage))

        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        // important for iPad
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }

    
    func openPage(action: UIAlertAction) {
        let url = URL(string: "https://" + action.title!)!
        webView.load(URLRequest(url: url))
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.title = webView.title
    }

    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        if let host = url?.host {
            for website in websites {
                if host.contains(website) {
                    decisionHandler(.allow)
                    return
                }
            }
            let ac = UIAlertController(title: "URL not allowed", message: "\(host) is not allow", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Continue", style: .cancel))
            present(ac, animated: true)
        }
        
        decisionHandler(.cancel)
    }
}

