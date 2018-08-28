//
//  VideoModel.swift
//  textTureDemo
//
//  Created by clt on 2018/8/9.
//  Copyright © 2018年 clt. All rights reserved.
//

import UIKit

class VideoModel: NSObject {

    var title = "Demo title"
    var url = URL(string: "https://www.w3schools.com/html/mov_bbb.mp4")
    var userName = "Random User"
    var avatarUrl = URL(string: String(format: "https://api.adorable.io/avatars/50/%@", ProcessInfo.processInfo.globallyUniqueString))
}
