//
//  Creditos.swift
//  Game23
//
//  Created by Alberto Garcia Mendez on 6/4/16.
//  Copyright © 2016 Alberto Garcia Mendez. All rights reserved.
//

import UIKit
import Social

class Creditos: UIViewController {
   
    @IBAction func lblBlog(sender: AnyObject) {
        if let urlBlog = NSURL(string: "http://www.albertogm88.com") {
            UIApplication.sharedApplication().openURL(urlBlog)
        }
    }
    
    @IBAction func btnTwitter(sender: AnyObject) {
        if let urlTwitter = NSURL(string: "https://www.twitter.com/albertogm88") {
            UIApplication.sharedApplication().openURL(urlTwitter)
        }
    }
   
    @IBAction func lblLinkedin(sender: AnyObject) {
        if let urlLinkedIn = NSURL(string: "https://es.linkedin.com/in/albertogarciamendez") {
            UIApplication.sharedApplication().openURL(urlLinkedIn)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


