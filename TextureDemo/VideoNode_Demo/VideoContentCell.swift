//
//  VideoContentCell.swift
//  textTureDemo
//
//  Created by clt on 2018/8/13.
//  Copyright © 2018年 clt. All rights reserved.
//

import UIKit

class VideoContentCell: ASCellNode {

  fileprivate  var titleNode:ASTextNode?
  fileprivate  var avatarNode:ASNetworkImageNode?
  fileprivate  var videoPlayerNode:ASVideoPlayerNode?
  fileprivate  var likeButtonNode:ASControlNode?
  fileprivate  var muteButtonNode:ASButtonNode?
  fileprivate  var videoModel:VideoModel?
    
    // 自定义初始化函数
    convenience  init(videoObject:VideoModel) {
        self.init()
        self.videoModel = videoObject
        titleNode = ASTextNode()
        titleNode?.attributedText = NSAttributedString(string: videoModel?.title ?? "", attributes: [NSAttributedStringKey.font :UIFont.systemFont(ofSize: 14),              NSAttributedStringKey.foregroundColor:UIColor.black            ])
        titleNode?.style.flexGrow = 1.0
        addSubnode(titleNode!)
        
        avatarNode = ASNetworkImageNode()
        avatarNode?.url = videoObject.avatarUrl
        // 加载图片后进行绘制圆形头像
        avatarNode?.imageModificationBlock = { (currentImage) ->UIImage? in
            return currentImage.makeCircularImage(size: CGSize(width: 30, height: 30))
        }
        addSubnode(avatarNode!)
        
        likeButtonNode = ASControlNode()
        likeButtonNode?.backgroundColor = UIColor.red
        addSubnode(likeButtonNode!)
        
        muteButtonNode = ASButtonNode()
        muteButtonNode?.style.width = ASDimensionMake(16)
        muteButtonNode?.style.height = ASDimensionMake(22)
        muteButtonNode?.addTarget(self, action: #selector(didTapMuteButton), forControlEvents: .touchUpInside)
        
        if let videoURL = videoObject.url {
            videoPlayerNode = ASVideoPlayerNode(url: videoURL)
            videoPlayerNode?.backgroundColor = UIColor.black
            videoPlayerNode?.delegate = self
            addSubnode(videoPlayerNode!)
        }
        
        self.setMuteButtonIcon()
        
    }
    
    // 静音UI配置
    private func setMuteButtonIcon(){
        guard let  videoPlayerNode = videoPlayerNode else {return}
        muteButtonNode?.setImage(UIImage(named: videoPlayerNode.muted ? "ico-mute":"ico-unmute"), for: .normal)
    }
    
    // 静音
    @objc func  didTapMuteButton(){
        guard let  videoPlayerNode = videoPlayerNode else {return}
        videoPlayerNode.muted = !videoPlayerNode.muted
        setMuteButtonIcon()
    }
    
    // MARK:cell布局
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        // 16:9 视频
        let fullWidth = UIScreen.main.bounds.size.width
        // 固定videoPlayerNode 宽高
        videoPlayerNode?.style.width = ASDimensionMake(fullWidth)
        videoPlayerNode?.style.height = ASDimensionMake(fullWidth * 9 / 16)
        // 固定头像宽高
        avatarNode?.style.width = ASDimensionMake(30)
        avatarNode?.style.height = ASDimensionMake(30)
        
        // 固定likeBtn宽高
        likeButtonNode?.style.width = ASDimensionMake(50)
        likeButtonNode?.style.height = ASDimensionMake(26)
        // 横向布局
        let headerStack = ASStackLayoutSpec.horizontal()
        // 每个子node的间隔为10
        headerStack.spacing =  10
        // 对其方式为居中
        headerStack.alignItems = .center
        // 加入管理
        headerStack.child = [avatarNode,titleNode] as? ASLayoutElement
        // 边距
        let headerInsets = UIEdgeInsetsMake(10, 10, 10, 10)
        // 包裹headerStack 组成块
        let headerInset = ASInsetLayoutSpec.init(insets: headerInsets, child: headerStack)
        // 底部布局
        let bottomControlsStack = ASStackLayoutSpec.horizontal()
        // 元素间隔
        bottomControlsStack.spacing = 10
        bottomControlsStack.alignItems = .center
        bottomControlsStack.child = [likeButtonNode] as? ASLayoutElement
        // 底部边距
        let bottomControlsInsets = UIEdgeInsetsMake(10, 10, 10, 10)
        // 包裹bottomStack 组成快
        let bottomControlsInset = ASInsetLayoutSpec(insets: bottomControlsInsets, child: bottomControlsStack)
        
        // 纵向布局元素
        let verticalStack = ASStackLayoutSpec.vertical()
        // 基线对其
        verticalStack.alignItems = .stretch
        verticalStack.child = [headerInset,videoPlayerNode,bottomControlsInset] as? ASLayoutElement
        
        return verticalStack
    }
    
    
    
}

// MARK:ASVideoPlayerNodeDelegate
extension VideoContentCell : ASVideoPlayerNodeDelegate {
    
    
    func didTap(_ videoPlayer: ASVideoPlayerNode) {
        
        if videoPlayer.playerState == .playing {
            videoPlayer.controlsDisabled = !videoPlayer.controlsDisabled
            videoPlayer.pause()
        }else{
            videoPlayer.play()
        }
        
        
    }
    
    // 自定义控件
    func videoPlayerNodeCustomControls(_ videoPlayer: ASVideoPlayerNode) -> [AnyHashable : Any] {
        guard let muteButtonNode = muteButtonNode else { return [:] }
        return ["muteControl":muteButtonNode]
    }
    
    
    
    //videoPlayerNodeLayout布局设置 , controls视频中使用的控件字典，字典键为ASVideoPlayerNodeControlType ,需要返回的布局对象
    func videoPlayerNodeLayoutSpec(_ videoPlayer: ASVideoPlayerNode, forControls controls: [AnyHashable : Any], forMaximumSize maxSize: CGSize) -> ASLayoutSpec {
        let spacer = ASLayoutSpec()
        spacer.style.flexGrow  = 1
        // 设置布局对象
        if let scrubber = controls[ASVideoPlayerNodeControlType.scrubber] as? ASDisplayNode {
            scrubber.style.height = ASDimensionMake(44.0)
            scrubber.style.minWidth = ASDimensionMake(0)
            scrubber.style.maxWidth = ASDimensionMake(maxSize.width)
            scrubber.style.flexGrow = 1.0
        }
        // 检索包含的控件
        let controlBarControls = self.controlsForControlBar(availableControls: controls)
        // 从字典中取出自定义的控件
        var topBarControls = [ASButtonNode]()
        if let btnNode = controls["muteControl"] as? ASButtonNode {
            topBarControls.append(btnNode)
        }

        // 设置顶部布局
        let topBarSpec = ASStackLayoutSpec(direction: .horizontal, spacing: 10.0, justifyContent: .start, alignItems: .center, children: topBarControls)

        let insets = UIEdgeInsetsMake(10, 10, 10, 10)
        let topBarInsetSpec = ASInsetLayoutSpec(insets: insets, child: topBarSpec)

        // 设置controlbar布局
        let controlbarSpec = ASStackLayoutSpec(direction: .horizontal, spacing: 10, justifyContent: .start, alignItems: .center, children: controlBarControls)
        controlbarSpec.style.alignSelf = .stretch


        let controlbarInsetSpec = ASInsetLayoutSpec(insets: insets, child: controlbarSpec)
        controlbarInsetSpec.style.alignSelf = .stretch

        let mainVerticalStack = ASStackLayoutSpec(direction: .vertical, spacing: 0, justifyContent: .start, alignItems: .start, children: [topBarInsetSpec,spacer,controlbarInsetSpec])


        return mainVerticalStack
    }

    
}

extension VideoContentCell {
    
    // 检索包含在内的布局对象
    fileprivate func controlsForControlBar(availableControls:Dictionary<AnyHashable, Any>) -> Array<ASDisplayNode>{
        
        var controls = [ASDisplayNode]()
        if let playbackButton = availableControls[ASVideoPlayerNodeControlType.playbackButton] as? ASDisplayNode {
           controls.append(playbackButton)
        }
        
        if let elapsedText = availableControls[ASVideoPlayerNodeControlType.elapsedText] as? ASDisplayNode {
            controls.append(elapsedText)
        }
        
        if let scrubber = availableControls[ASVideoPlayerNodeControlType.scrubber] as? ASDisplayNode {
            controls.append(scrubber)
        }
        
        if let durationText = availableControls[ASVideoPlayerNodeControlType.durationText] as? ASDisplayNode {
            controls.append(durationText)
        }
        
        return controls
        
    }
    
    
}


