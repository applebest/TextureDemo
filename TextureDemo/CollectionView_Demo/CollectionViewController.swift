//
//  CollectionViewController.swift
//  textTureDemo
//
//  Created by clt on 2018/8/7.
//  Copyright © 2018年 clt. All rights reserved.
//

import UIKit
import Then



class CollectionViewController: UIViewController {

    let kItemSize = CGSize(width: 180, height: 90)
    
    lazy var data:[[String]] = {
        
        var dataSource = [[String]]()
        for i in 0..<100 {
            var items = [String]()
            for j in 0..<10{
               let str = String(format: "[%zd.%zd] says hi", i,j)
                items.append(str)
            }
            dataSource.append(items)
        }
        return dataSource
    }()
    
    
    lazy var collectionNode:ASCollectionNode = {
        let layout = UICollectionViewFlowLayout()
        let sectionSize = CGSize(width: 50.0, height: 50.0)
        layout.headerReferenceSize = sectionSize
        layout.footerReferenceSize = sectionSize
        layout.itemSize = kItemSize
        let node = ASCollectionNode(collectionViewLayout: layout)
        node.backgroundColor = UIColor.white
        node.delegate = self
        node.dataSource = self
        node.frame = view.bounds
        node.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        node.registerSupplementaryNode(ofKind: UICollectionElementKindSectionHeader)
        node.registerSupplementaryNode(ofKind: UICollectionElementKindSectionFooter)
        return node
    }()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        
        // Do any additional setup after loading the view.
    }
    
    
    private func setup(){
        
        // 长按手势
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        view.addGestureRecognizer(longGesture)
        view.addSubnode(collectionNode)
        
    }
    
    @objc private func handleLongPress(sender:UILongPressGestureRecognizer){
        
        let collectionView = self.collectionNode.view
        let point = sender.location(in: collectionView)
        
        switch sender.state {
        case .began:
            let indexPath = collectionView.indexPathForItem(at: point)
            if let indexPath = indexPath{
                collectionView.beginInteractiveMovementForItem(at: indexPath)
            }
            break
            
        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(point)
            break
            
        case .ended:
            collectionView.endInteractiveMovement()
            break
            
        case .failed,.cancelled:
            collectionView.cancelInteractiveMovement()
            
        default:
            break
        }
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

extension CollectionViewController:ASCollectionDelegate,ASCollectionDataSource {
    
    func numberOfSections(in collectionNode: ASCollectionNode) -> Int {
        
        return self.data.count
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        
        return self.data[section].count
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
            return  ({
                return ItemNode(text: self.data[indexPath.section][indexPath.row])
            })
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> ASCellNodeBlock {
        return  ({
            
            let text = kind == UICollectionElementKindSectionHeader ? "Header" : "Footer"
            let node = SupplementaryNode(text: text)
            let isHeaderSection = kind == UICollectionElementKindSectionHeader
            node.backgroundColor = isHeaderSection ? UIColor.blue : UIColor.red
            
            return node
        })

    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, willBeginBatchFetchWith context: ASBatchContext) {
        
        context.completeBatchFetching(true)
    }
    
    
    func collectionNode(_ collectionNode: ASCollectionNode, canMoveItemWith node: ASCellNode) -> Bool {
        
        return true
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        /*
         swift的Array 为值类型 OC为引用类型，使用下列方法有效 ，下方写法错误 ❌
         let sectionArr = self.data[sourceIndexPath.section]
         let text   = sectionArr[sourceIndexPath.item]
         sectionArr.remove(at:sourceIndexPath.item)
         self.data[destinationIndexPath.section].insert(text, at: destinationIndexPath.item)
         */
        
        /*
         swift 值类型取值 ,正确写法
         */
        
        // 删除数据源
        let text = self.data[sourceIndexPath.section].remove(at: sourceIndexPath.item)
        // 插入目标位置
        self.data[destinationIndexPath.section].insert(text, at: destinationIndexPath.item)
        
    }
    

}



