//
//  CustomCellNode.swift
//  textTureDemo
//
//  Created by clt on 2018/8/3.
//  Copyright © 2018年 clt. All rights reserved.
//

import UIKit

class CustomCellNode: ASCellNode {

   lazy var titleLabel : ASTextNode = {
        let labelNode = ASTextNode()
        return labelNode
    }()
    

    convenience init(text : String) {
        self.init()
        self.titleLabel.attributedText = NSAttributedString(string: text, attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 18),             NSAttributedStringKey.foregroundColor:UIColor.red ]
            )
        
//        self.titleLabel.attributedText = NSAttributedString(string: text)
        
        addSubnode(titleLabel)
    }
    
 
    
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let center = ASCenterLayoutSpec(centeringOptions:ASCenterLayoutSpecCenteringOptions.XY, sizingOptions:[], child: self.titleLabel)
        let kInsets = CGFloat(15.0)
        let insets = UIEdgeInsets(top: kInsets, left: kInsets, bottom: kInsets, right: kInsets)
        
        return ASInsetLayoutSpec(insets: insets, child: center)
    }
    
    
}
