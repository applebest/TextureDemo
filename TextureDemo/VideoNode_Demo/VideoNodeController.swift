//
//  VideoNodeController.swift
//  textTureDemo
//
//  Created by clt on 2018/8/9.
//  Copyright © 2018年 clt. All rights reserved.
//

import UIKit

class VideoNodeController: ASViewController<ASDisplayNode> {

    let tableNode:ASTableNode = ASTableNode()
   lazy var videoData:[VideoModel] = {
        var temp:[VideoModel] = []
        for i in 0..<30 {
            temp.append(VideoModel())
        }
        return temp
    }()
  
    init() {
        
        super.init(node: tableNode)
        tableNode.delegate = self
        tableNode.dataSource = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableNode.reloadData()
    }
    

}

extension VideoNodeController:ASTableDelegate,ASTableDataSource {
    
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 1
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return videoData.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
        
        return VideoContentCell(videoObject: videoData[indexPath.row])
    }
    
}
