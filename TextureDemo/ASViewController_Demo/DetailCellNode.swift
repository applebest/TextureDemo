//
//  DetailCellNode.swift
//  textTureDemo
//
//  Created by clt on 2018/8/15.
//  Copyright © 2018年 clt. All rights reserved.
//

import UIKit

class DetailCellNode: ASCellNode {

    var row:Int?
    var imageCategory:String?
    var imageNode:ASNetworkImageNode?
    
    var imageURL:URL? {
        get{
            
//            guard let imageCategory = self.imageCategory, let row = self.row else {
//                return nil
//            }
//
//            let imageSize = self.calculatedSize
//            let imageURLString = String(format: "http://lorempixel.com/%ld/%ld/%@/%ld", NSInteger(imageSize.width),NSInteger(imageSize.height),imageCategory,row)
//            return URL(string: imageURLString)
            return URL(string: "http://img.zcool.cn/community/0117e2571b8b246ac72538120dd8a4.jpg@1280w_1l_2o_100sh.jpg")
        }
    }
    
    
    
    override init() {
        super.init()
        self.automaticallyManagesSubnodes = true
        imageNode = ASNetworkImageNode()
        imageNode?.backgroundColor = ASDisplayNodeDefaultPlaceholderColor()
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        guard let imageNode = self.imageNode else {
            return ASLayoutSpec()
        }
        return ASRatioLayoutSpec(ratio: 1.0, child:imageNode)
    }
    
    override func layoutDidFinish() {
        super.layoutDidFinish()
        
        self.imageNode?.url = self.imageURL
        
    }
    
    
}
