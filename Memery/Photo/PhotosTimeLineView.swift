//
//  PhotosTimeLineView.swift
//  Memery
//
//  Created by 藏银 on 2017/10/9.
//  Copyright © 2017年 藏银. All rights reserved.
//

import UIKit

class PhotosTimeLineView: UIView {
    
    public var timePoint: CGPoint?
    public var topCell: Bool?
    public var bottomCell: Bool?
    
    private let lineColor: UIColor = UIColor.gray
    private let lineWidth: CGFloat = 1.0
    private var topLineLayer: CAShapeLayer?
    private var bottomLineLayer: CAShapeLayer?
    private var pointLayer: CAShapeLayer?
    
    
    override func draw(_ rect: CGRect) {
        self.layer.sublayers?.forEach({ (layer) in
            if (layer is CAShapeLayer) {
                layer.removeFromSuperlayer()
            }
        })
        
        if (self.topCell!) == false {
            self.drawLine(from: CGPoint(x:3.5, y:0), to: CGPoint(x:3.5,y:(timePoint?.y)!))
        }
        self.drawPoint()
        if (self.bottomCell!) == false {
            self.drawLine(from: CGPoint(x:3.5, y:(timePoint?.y)! + 3.5), to: CGPoint(x:3.5, y:self.frame.size.height))
        }
        
    }
    
    private func drawPoint()  {
        let path = UIBezierPath(ovalIn: CGRect(x: 0, y: (timePoint?.y)! - 3.5, width: 7.0, height: 7.0))
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = lineColor.cgColor
        shapeLayer.fillColor =  UIColor.white.cgColor
        shapeLayer.lineWidth = lineWidth
        
        self.layer.addSublayer(shapeLayer)
    }

    
    private func drawLine(from: CGPoint, to: CGPoint) {
        let path = UIBezierPath()
        path.move(to: from)
        path.addLine(to: to)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = lineColor.cgColor
        shapeLayer.lineWidth = lineWidth
        
        self.layer.addSublayer(shapeLayer)
    }
    

}
