//
//  MagazineDisplayView.swift
//  Memery
//
//  Created by 藏银 on 2017/9/19.
//  Copyright © 2017年 藏银. All rights reserved.
//

import UIKit

class MagazineDisplayView: UIView {

    var textData : CTFrameTextData?
    

    override func draw(_ rect: CGRect) {
        
        super.draw(rect)
        if let textData = self.textData {
            let context: CGContext = UIGraphicsGetCurrentContext()!
            context.textMatrix = CGAffineTransform.identity
            context.translateBy(x: 0, y: self.bounds.size.height)
            context.scaleBy(x: 1.0, y: -1.0)
            
            CTFrameDraw(textData.frame!, context)
            
        }
        
    }
 

}
