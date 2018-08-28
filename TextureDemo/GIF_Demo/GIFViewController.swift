//
//  GIFViewController.swift
//  textTureDemo
//
//  Created by clt on 2018/8/7.
//  Copyright © 2018年 clt. All rights reserved.
//

import UIKit

class GIFViewController: UIViewController {

    lazy var netImageNode = { () -> ASNetworkImageNode in
       
//        let img = ASNetworkImageNode(cache: ImageManager.sharedManager, downloader: ImageManager.sharedManager)
        let img = ASNetworkImageNode()
        img.url = URL(string: "http://wx2.sinaimg.cn/mw690/006ZrXHXgy1fsoqeuk8szg30cf05m7vm.gif")
        img.contentMode = .scaleAspectFit
        img.frame = view.bounds
        img.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        
        return img
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black
        view.addSubnode(netImageNode)
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
