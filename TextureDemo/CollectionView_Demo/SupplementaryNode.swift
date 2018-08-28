//
//  SupplementaryNode.swift
//  textTureDemo
//
//  Created by clt on 2018/8/7.
//  Copyright © 2018年 clt. All rights reserved.
//

import UIKit

class SupplementaryNode: ASCellNode {

    let kInsets = CGFloat(15.0)
    lazy var textNode = ASTextNode()
    
    convenience  init(text:String) {
        self.init()
        self.textNode.attributedText = NSAttributedString(string: text, attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 18),             NSAttributedStringKey.foregroundColor:UIColor.white])
        self.addSubnode(self.textNode)
        
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let center = ASCenterLayoutSpec(centeringOptions:ASCenterLayoutSpecCenteringOptions.XY, sizingOptions:[], child: self.textNode)
        let insets = UIEdgeInsets(top: kInsets, left: kInsets, bottom: kInsets, right: kInsets)
        
        return ASInsetLayoutSpec(insets: insets, child: center)
    }
    
}
