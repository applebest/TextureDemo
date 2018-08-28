//
//  ViewController.swift
//  textTureDemo
//
//  Created by clt on 2018/8/3.
//  Copyright © 2018年 clt. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    let tableView = ASTableNode()
    
    let dataSource = ["gif",
                      "collectionView",
                      "TransitionNode",
                      "VideoNode",
                      "ASViewController_Demo",
                      "MapHandler_Demo"
                                    ]
    
    
    
    deinit {
        tableView.delegate = nil
        tableView.dataSource = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        tableView.view.separatorStyle = .none
        tableView.delegate  = self
        tableView.dataSource = self
        view.addSubnode(tableView)
        
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableView.frame = view.bounds
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController:ASTableDelegate,ASTableDataSource {
    
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 1
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        
        return dataSource.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
        
        return  CustomCellNode(text: dataSource[indexPath.row])
    }
    
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            
            navigationController?.pushViewController(GIFViewController(), animated: true)
            break
        case 1:
            navigationController?.pushViewController(CollectionViewController(), animated: true)
            break
            
        case 2:
            navigationController?.pushViewController(TransitionNodeViewController(), animated: true)
            break
            
        case 3:
            navigationController?.pushViewController(VideoNodeController(), animated: true)
            break
            
        case 4:
            navigationController?.pushViewController(ASVC_Demo(), animated: true)

            break
            
        case 5:
            navigationController?.pushViewController(MapVC(), animated: true)
            
            break
            
            
        default: break
            
        }
        
        
    }
    
    
}


