//
//  CustomMapAnnotation.swift
//  textTureDemo
//
//  Created by clt on 2018/8/21.
//  Copyright © 2018年 clt. All rights reserved.
//

import UIKit

class CustomMapAnnotation:NSObject,MKAnnotation {
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var image:UIImage?
    var title:String?
    var subtitle:String?
 
}

