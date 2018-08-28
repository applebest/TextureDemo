//
//  ItemNode.swift
//  textTureDemo
//
//  Created by clt on 2018/8/7.
//  Copyright © 2018年 clt. All rights reserved.
//

import UIKit

class ItemNode: ASTextCellNode {

    
    convenience  init(text:String) {
        self.init()
        self.text = text
        self.updateBackgroundColor()
    }
    
    private func updateBackgroundColor(){
        
        if self.isHighlighted {
            self.backgroundColor = UIColor.gray
        }else if self.isSelected{
            self.backgroundColor = UIColor.darkGray
        }else{
            self.backgroundColor = UIColor.lightGray
        }
        
    }
    
    override var isHighlighted: Bool{
        didSet{
            updateBackgroundColor()
        }
    }
    
    
}
