//
//  TransitionNodeViewController.swift
//  textTureDemo
//
//  Created by clt on 2018/8/8.
//  Copyright © 2018年 clt. All rights reserved.
//

import UIKit


class TransitionNode: ASDisplayNode {
    var enabled = false
   lazy var buttonNode = ASButtonNode().then { (make) in
        let btnTitle = "Start Layout Transition"
        let btnFont = UIFont.systemFont(ofSize: 16)
        let btnColor = UIColor.blue
        make.setTitle(btnTitle, with: btnFont, with: btnColor, for: .normal)
        make.setTitle(btnTitle, with: btnFont, with: btnColor.withAlphaComponent(0.5), for: .highlighted)
    }
    
  lazy  var textNodeOne = ASTextNode().then { (make) in
        make.attributedText = NSAttributedString(string: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled")
        make.backgroundColor = UIColor.orange
    }
    
  lazy  var textNodeTwo = ASTextNode().then { (make) in
        make.attributedText = NSAttributedString(string: "t is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English.")
        make.backgroundColor = UIColor.green
    }
    
    
    override init() {
        super.init()
        self.automaticallyManagesSubnodes = true
        self.defaultLayoutTransitionDuration = 1.0
        
    }
    
    
    override func didLoad() {
        super.didLoad()
        self.buttonNode.addTarget(self, action: #selector(buttonPressed(sender:)), forControlEvents: .touchUpInside)
    }
    
    @objc func buttonPressed(sender:ASButtonNode){
        
        self.enabled = !self.enabled
        // 使用动画
        self.transitionLayout(withAnimation: true, shouldMeasureAsync: false, measurementCompletion: nil)
    }
    
    
    // 布局函数
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let newTextNode = self.enabled ? self.textNodeOne : self.textNodeTwo
        newTextNode.style.flexShrink = 1.0  // 缩小系数
        newTextNode.style.flexGrow = 1.0   // 放大系数
        
        let horizontalStackLayout = ASStackLayoutSpec.horizontal()
        horizontalStackLayout.children = [newTextNode]
        self.buttonNode.style.alignSelf = .center
        
        let verticalStackLayout = ASStackLayoutSpec.vertical()
        verticalStackLayout.spacing = 10.0
        verticalStackLayout.children = [horizontalStackLayout,buttonNode]
        
        return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 15.0, left: 15.0, bottom: 15.0, right: 15.0), child: verticalStackLayout)
    }
    
    // 重写动画实现
    override func animateLayoutTransition(_ context: ASContextTransitioning) {
        // 即将删除的子节点
        let fromNode  = context.removedSubnodes()[0]
        // 即将插入的子节点
        let toNode = context.insertedSubnodes()[0]
        
        // 寻找btn节点
        var buttonNode:ASButtonNode?
        for  node in context.subnodes(forKey: ASTransitionContextToLayoutKey) {
            guard node.isKind(of: ASButtonNode.classForCoder()) else { continue}
            buttonNode = node as? ASButtonNode
            break
        }
        // 获取转换完成后的坐标（如果转换后不在层次结构中，则返回CGRectNull）
        var toNodeFrame = context.finalFrame(for: toNode)
        toNodeFrame.origin.x += (enabled ? toNodeFrame.size.width : -toNodeFrame.size.width)
        toNode.alpha = 0
        var fromNodeFrame = fromNode.frame
        
        fromNodeFrame.origin.x += (enabled ? -fromNodeFrame.size.width : fromNodeFrame.size.width)
        
        // 动画更改
        UIView.animate(withDuration: self.defaultLayoutTransitionDuration, animations: {
            toNode.frame = context.finalFrame(for: toNode)
            toNode.alpha = 1.0
            fromNode.frame = fromNodeFrame
            fromNode.alpha = 0
            // 原大小
            let fromSize = context.layout(forKey: ASTransitionContextFromLayoutKey)?.size ?? CGSize.zero
            // 目标大小
            let toSize = context.layout(forKey: ASTransitionContextToLayoutKey)?.size ?? CGSize.zero
            if !fromSize.equalTo(toSize){
                let position = self.frame.origin
                self.frame = CGRect(origin: position,size:toSize)
            }
            if let btnNodel = buttonNode{
                btnNodel.frame = context.finalFrame(for: btnNodel)
            }
        }) { (finished) in
            context.completeTransition(finished)
        }
        
        
    }
    
}




class TransitionNodeViewController: UIViewController {

    lazy var transitionNode = TransitionNode().then { (make) in
        make.backgroundColor = UIColor.gray
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        view.addSubnode(transitionNode)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let size = transitionNode.layoutThatFits(ASSizeRange(min: .zero, max: self.view.frame.size)).size
        self.transitionNode.frame = CGRect(x: 0, y: 100, width: size.width, height: size.height)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
