//
//  CTFrameParser.swift
//  Memery
//
//  Created by 藏银 on 2017/9/20.
//  Copyright © 2017年 藏银. All rights reserved.
//

import UIKit

class CTFrameParser: NSObject {
    class func parseContent(content: String, config: CTFrameParserConfig) -> CTFrameTextData {
        let attributes: NSDictionary = self.attributesWithConfig(config: config)
        let contentString: NSAttributedString = NSAttributedString(string: content, attributes: attributes as? [String : Any])
        
        let framesetter: CTFramesetter = CTFramesetterCreateWithAttributedString(contentString)
        
        let restrictSize: CGSize = CGSize(width: config.width, height: CGFloat.greatestFiniteMagnitude)
        let coreTextSize: CGSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0,0), nil, restrictSize, nil)
        
        let textHeight: CGFloat = coreTextSize.height
        
        let frame = self.createFrameWithFramesetter(framesetter: framesetter, config: config, height: textHeight, contentString:contentString )
   
        let textData = CTFrameTextData()
        textData.frame = frame
        textData.height = textHeight
        
        return textData
    }
    
//    class func loadTemplateFile(path: String, config: CTFrameParserConfig) -> NSAttributedString {
//        
//        let data: NSData? = NSData(contentsOfFile:path)
//        if let jsonData = data {
//            
////            let jsonArray = try? JSONSerialization.jsonObject(with:data! as Data, options: JSONSerialization.ReadingOptions.MutableContainers) as! Array
////            
////            
////            for item in jsonArray {
////                if
////            }
//        
//        }
//        
//    }
    
    
    class func attributesWithConfig(config: CTFrameParserConfig) -> NSDictionary {
        let fontSize = config.fontSize
        let font: CTFont = CTFontCreateWithName("ArialMT" as CFString, fontSize, nil)
        var lineSpace = config.lineSpace
        
        let setting = [CTParagraphStyleSetting(spec: .lineSpacingAdjustment, valueSize: MemoryLayout<CGFloat>.size, value:&lineSpace),
                       CTParagraphStyleSetting(spec: .maximumLineSpacing, valueSize: MemoryLayout<CGFloat>.size, value: &lineSpace),
                       CTParagraphStyleSetting(spec: .minimumLineSpacing, valueSize: MemoryLayout<CGFloat>.size, value: &lineSpace)]
        
        let paragraph: CTParagraphStyle = CTParagraphStyleCreate(setting, setting.count)
        
        let textColor: UIColor = config.textColor
        
        let dic = [
            kCTForegroundColorAttributeName as String: textColor.cgColor,
            kCTFontAttributeName as String: font,
            kCTParagraphStyleAttributeName  as String:paragraph
        ] as [String : Any]
        
        return dic as NSDictionary
    }
    
    class func createFrameWithFramesetter(framesetter: CTFramesetter, config: CTFrameParserConfig, height: CGFloat, contentString: NSAttributedString) -> CTFrame {
        let path : CGMutablePath = CGMutablePath()
        path.addRect(CGRect(x: 0, y: 0, width: config.width, height: height))
        let frame  = CTFramesetterCreateFrame(framesetter, CFRange(location: 0, length: contentString.length), path, nil);
    
        return frame
    }
}
