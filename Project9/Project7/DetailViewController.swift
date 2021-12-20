//
//  DetailViewController.swift
//  Project7
//
//  Created by Noah Glaser on 12/15/21.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {

    var webView: WKWebView!
    var detialItem: Petition?
    
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let detialItem = detialItem else {
            return
        }
        
        let html = """
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1">
<style> body { font-size: 150%; }
    h1 { color: red; font-size: 150%; }
    p { font-family: monospace; }
 </style>

</head>
<body>

<h1>\(detialItem.title)</h1>
<p>
\(detialItem.body)
</p>
</body>
</html>
"""
 
        webView.loadHTMLString(html, baseURL: nil)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
