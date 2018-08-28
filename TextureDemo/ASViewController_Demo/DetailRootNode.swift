//
//  DetailRootNode.swift
//  textTureDemo
//
//  Created by clt on 2018/8/15.
//  Copyright © 2018年 clt. All rights reserved.
//

import UIKit

class DetailRootNode: ASDisplayNode {

    
    var imageCategory = ""
    
    
    lazy var collectionNode:ASCollectionNode = {
        let layout = UICollectionViewFlowLayout()
        let collectionNode = ASCollectionNode(collectionViewLayout: layout)
        return collectionNode
    }()
    
    convenience init(imageCategory:String) {
        self.init()
        self.imageCategory = imageCategory
        self.automaticallyManagesSubnodes = true
        self.collectionNode.delegate = self
        self.collectionNode.dataSource = self
        self.collectionNode.backgroundColor = UIColor.white
    }
    
    deinit {
        self.collectionNode.dataSource = nil
        self.collectionNode.delegate = nil
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        return ASWrapperLayoutSpec(layoutElement: self.collectionNode)
    }
    
}

extension DetailRootNode : ASCollectionDataSource,ASCollectionDelegate {
    
    
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, constrainedSizeForItemAt indexPath: IndexPath) -> ASSizeRange {
        let imageSize = CGSize(width: collectionNode.view.frame.width, height: 200)
        return ASSizeRange(min: imageSize, max: imageSize)
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        
        return {
            let node = DetailCellNode()
            node.row = indexPath.row
            node.imageCategory = self.imageCategory
            return node
        }
    }
    
    
}
