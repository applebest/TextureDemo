//
//  UIImage+Additions.swift
//  textTureDemo
//
//  Created by clt on 2018/8/13.
//  Copyright © 2018年 clt. All rights reserved.
//

import UIKit



extension UIImage {
    
    
    func makeCircularImage(size:CGSize) -> UIImage? {
        let circleRect = CGRect(origin: .zero, size: size)
        //创建一个CGRect与图像的大小
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let circle = UIBezierPath(roundedRect: circleRect, cornerRadius: size.width / 2)
        circle.addClip()
        draw(in: circleRect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    
    
    
    
}
