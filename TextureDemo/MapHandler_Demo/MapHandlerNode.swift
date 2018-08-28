//
//  MapHandlerNode.swift
//  textTureDemo
//
//  Created by clt on 2018/8/20.
//  Copyright © 2018年 clt. All rights reserved.
//

import UIKit

class MapHandlerNode: ASDisplayNode {

    let latEditableNode = ASEditableTextNode()
    let lonEditableNode = ASEditableTextNode()
    let deltaLatEditableNode = ASEditableTextNode()
    let deltaLonEditableNode = ASEditableTextNode()
    let updateRegionButton = ASButtonNode()
    let liveMapToggleButton = ASButtonNode()
    lazy var mapNode:ASMapNode = ASMapNode()
    
    var liveMapStr: String {
            return self.mapNode.isLiveMap ? "Live Map is ON" : "Live Map is OFF"
    }
    
    override init() {
        super.init()
        automaticallyManagesSubnodes = true
        mapNode.mapDelegate = self
        let backgroundImage = UIImage.as_resizableRoundedImage(withCornerRadius: 5, cornerColor: UIColor.white, fill: UIColor.lightGray)
        let backgroundHiglightedImage = UIImage.as_resizableRoundedImage(withCornerRadius: 5, cornerColor: UIColor.white, fill: UIColor.lightGray.withAlphaComponent(0.4), borderColor: UIColor.lightGray, borderWidth: 2.0)
        updateRegionButton.setBackgroundImage(backgroundImage, for: .normal)
        updateRegionButton.setBackgroundImage(backgroundHiglightedImage, for: .highlighted)
        liveMapToggleButton.setBackgroundImage(backgroundImage, for: .normal)
        liveMapToggleButton.setBackgroundImage(backgroundHiglightedImage, for: .highlighted)
        updateRegionButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        updateRegionButton.setTitle("Update Region", with: nil, with: UIColor.blue, for: .normal)
        updateRegionButton.addTarget(self, action: #selector(updateRegion), forControlEvents: .touchUpInside)
        liveMapToggleButton.setTitle(self.liveMapStr, with: nil, with: UIColor.blue, for: .normal)
        liveMapToggleButton.addTarget(self, action: #selector(toggleLiveMap), forControlEvents: .touchUpInside)
        
        
        
    }
    
    override func didLoad() {
        super.didLoad()
        configureEditableNodes(node: latEditableNode)
        configureEditableNodes(node: lonEditableNode)
        configureEditableNodes(node: deltaLatEditableNode)
        configureEditableNodes(node: deltaLonEditableNode)
        updateLocationTextWithMKCoordinateRegion(region: mapNode.region)
        
        self.mapNode.imageForStaticMapAnnotationBlock = {[weak self](annotation, centerOffset) -> UIImage? in
            guard let _ = self else {return nil}
            guard let annotation = annotation as? CustomMapAnnotation else {
                return nil
            }
            
            return annotation.image
        }
        // 添加大头针
        addAnnotations()
        
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        latEditableNode.style.width = ASDimensionMake("50%")
        lonEditableNode.style.width      = ASDimensionMake("50%")
        deltaLatEditableNode.style.width = ASDimensionMake("50%")
        deltaLonEditableNode.style.width = ASDimensionMake("50%")
        liveMapToggleButton.style.maxHeight = ASDimensionMake(30)
        mapNode.style.flexGrow = 1.0
        let lonlatSpec = ASStackLayoutSpec(direction: .horizontal, spacing: 5, justifyContent: .start, alignItems: .center, children: [latEditableNode,lonEditableNode])
        let deltaLonlatSpec =  ASStackLayoutSpec(direction: .horizontal, spacing: 5, justifyContent: .spaceBetween, alignItems: .center, children: [deltaLatEditableNode,deltaLonEditableNode])
        let lonlatConfigSpec = ASStackLayoutSpec(direction: .vertical, spacing: 5, justifyContent: .start, alignItems: .stretch, children: [lonlatSpec,deltaLonlatSpec])
        lonlatConfigSpec.style.flexGrow = 1.0
        let dashboardSpec = ASStackLayoutSpec(direction: .horizontal, spacing: 5, justifyContent: .start, alignItems: .stretch, children: [lonlatConfigSpec,updateRegionButton])
        let headerVerticalStack = ASStackLayoutSpec(direction: .vertical, spacing: 5, justifyContent: .start, alignItems: .stretch, children: [dashboardSpec,liveMapToggleButton])
        headerVerticalStack.style.flexGrow = 1.0
        let insetSpec = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 40, left: 10, bottom: 10, right: 10), child: headerVerticalStack)
        let layoutSpec = ASStackLayoutSpec(direction: .vertical, spacing: 5, justifyContent: .start, alignItems: .stretch, children: [insetSpec,mapNode])
        
        return layoutSpec
    }
    
    
    
    
    
    fileprivate func addAnnotations(){
        
        let brno = MKPointAnnotation()
        brno.coordinate = CLLocationCoordinate2D(latitude: 49.2002211, longitude: 16.6078411)
        brno.title = "Brno City"
        
        let atlantic = CustomMapAnnotation()
        atlantic.coordinate = CLLocationCoordinate2D(latitude: 38.6442228, longitude: -29.9956942)
        atlantic.title = "Atlantic Ocean"
        atlantic.image = UIImage(named: "Water")
        
        let kilimanjaro = CustomMapAnnotation()
        atlantic.coordinate = CLLocationCoordinate2D(latitude: -3.075833, longitude: 37.353333)
        atlantic.title = "Kilimanjaro"
        atlantic.image = UIImage(named: "Hill")
        
        let mtblanc = CustomMapAnnotation()
        atlantic.coordinate = CLLocationCoordinate2D(latitude: 45.8325, longitude: 6.864444)
        atlantic.title = "Mont Blanc"
        atlantic.image = UIImage(named: "Hill")
        self.mapNode.annotations = [brno, atlantic, kilimanjaro, mtblanc]
    }
    
    
    fileprivate func configureEditableNodes(node:ASEditableTextNode){
        node.returnKeyType = node == deltaLonEditableNode ? UIReturnKeyType.done : UIReturnKeyType.next
        node.delegate = self
    }
    
    fileprivate func updateLocationTextWithMKCoordinateRegion(region:MKCoordinateRegion){
        latEditableNode.attributedText = attributedStringFromFloat(value: CGFloat(region.center.latitude))
        lonEditableNode.attributedText = attributedStringFromFloat(value: CGFloat(region.center.longitude))
        deltaLatEditableNode.attributedText = attributedStringFromFloat(value: CGFloat(region.span.latitudeDelta))
        deltaLonEditableNode.attributedText = attributedStringFromFloat(value: CGFloat(region.span.longitudeDelta))
    }
    
    fileprivate func attributedStringFromFloat(value:CGFloat) -> NSAttributedString {
        
        return NSAttributedString(string: String(format: "%0.3f", value))
    }
    
    
    // 更新地区
    @objc func updateRegion(){
        let f = NumberFormatter()
        f.numberStyle = .decimal
        
        let lat = f.number(from: latEditableNode.attributedText?.string ?? "0")?.doubleValue ?? 0
        let lon = f.number(from: lonEditableNode.attributedText?.string ?? "0")?.doubleValue ?? 0
        let deltaLat = f.number(from: deltaLatEditableNode.attributedText?.string ?? "0")?.doubleValue ?? 0
        let deltaLon = f.number(from: deltaLonEditableNode.attributedText?.string ?? "0")?.doubleValue ?? 0
        let region = MKCoordinateRegionMake(CLLocationCoordinate2D(latitude: lat, longitude: lon), MKCoordinateSpan(latitudeDelta: deltaLat, longitudeDelta: deltaLon))
        mapNode.region = region
    }
    
    // 切换地图
    @objc func toggleLiveMap(){
        
        mapNode.isLiveMap = !mapNode.isLiveMap
        liveMapToggleButton.setTitle(self.liveMapStr, with: nil, with: UIColor.blue, for: .normal)
        liveMapToggleButton.setTitle(self.liveMapStr, with: UIFont.systemFont(ofSize: 14), with: UIColor.blue, for: .highlighted)
    }
    
}



extension MapHandlerNode:ASEditableTextNodeDelegate{
    
    func editableTextNode(_ editableTextNode: ASEditableTextNode, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
            switch editableTextNode {
            case latEditableNode:
                lonEditableNode.becomeFirstResponder()
                break
                
            case lonEditableNode:
                deltaLatEditableNode.becomeFirstResponder()
                break
                
            case deltaLatEditableNode:
                deltaLonEditableNode.becomeFirstResponder()
                break
            case deltaLonEditableNode:
                deltaLatEditableNode.becomeFirstResponder()
                updateRegion()
                break
      
            default:
                break
            }
            return false
        }
        
        let s = NSMutableCharacterSet(charactersIn: ".-")
        s.formUnion(with: NSCharacterSet.decimalDigits) // 小数
        s.invert()
        
        if let r = text.rangeOfCharacter(from: s as CharacterSet){
            if r.isEmpty {
                return false
            }
        }
        
        if ((editableTextNode.attributedText?.string.range(of: ".")) != nil) && (text.range(of: ".") != nil){
            return false
        }
        
        if ((editableTextNode.attributedText?.string.range(of: "-")) != nil) && (text.range(of: "-") != nil){
            return false
        }
        
        return true
    }
    
    func annotationViewForAnnotation(annotation:MKAnnotation) -> MKAnnotationView {
        
        if let annotation = annotation as? CustomMapAnnotation {
            let av = MKAnnotationView()
            av.centerOffset = CGPoint(x: 21, y: 21)
            av.image = annotation.image
            av.isOpaque = false
            return av
        }else{
            let av = MKAnnotationView(annotation: nil, reuseIdentifier: "")
            av.isOpaque = false
            return av
        }
        
    }
    
}



extension MapHandlerNode:MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        updateLocationTextWithMKCoordinateRegion(region: mapView.region)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        return annotationViewForAnnotation(annotation: annotation)
    }
    
}

