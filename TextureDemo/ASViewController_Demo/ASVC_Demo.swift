//
//  ASVC_Demo.swift
//  textTureDemo
//
//  Created by clt on 2018/8/15.
//  Copyright © 2018年 clt. All rights reserved.
//

import UIKit

class ASVC_Demo: ASViewController<ASTableNode> {

    
    let imageCategories = ["abstract","animals","business","cats","city","food","nightlife","fashion","people","nature","sports","technics","transport"]
    
    
    init() {
        super.init(node: ASTableNode())
    }
    
    deinit {
        self.node.delegate = nil
        self.node.dataSource = nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let selectedRow = self.node.indexPathForSelectedRow else {return}
        self.node.deselectRow(at: selectedRow, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Image Categories"
        self.node.delegate = self
        self.node.dataSource = self
        
        // Do any additional setup after loading the view.
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


extension  ASVC_Demo:ASTableDataSource,ASTableDelegate {
  
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return self.imageCategories.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        
        return {
            let textCellNode = ASTextCellNode()
            textCellNode.text = self.imageCategories[indexPath.row].capitalized
            return textCellNode
        }
    }
    
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        
        let imageCategories = self.imageCategories[indexPath.row]
        let detailRootNode = DetailRootNode(imageCategory: imageCategories)
        let detailVC = ASDetailVC(node: detailRootNode)
        detailVC.title = imageCategories.capitalized
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    
    
}


