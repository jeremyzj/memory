//
//  MagazineViewController.swift
//  Memery
//
//  Created by 藏银 on 2017/9/19.
//  Copyright © 2017年 藏银. All rights reserved.
//

import UIKit

class MagazineViewController: UIViewController {

    var ctView: MagazineDisplayView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.ctView = MagazineDisplayView()
        self.view.addSubview(self.ctView!)
        
        let config:CTFrameParserConfig = CTFrameParserConfig()
        config.width = self.view.bounds.width
        config.textColor = UIColor.black
        var content: String = " 对于上面的例子，我们给 CTFrameParser 增加了一个将 NSString 转 "
        content += " 换为 CoreTextData 的方法。"
        content += " 但这样的实现方式有很多局限性，因为整个内容虽然可以定制字体 "
        content += " 大小，颜色，行高等信息，但是却不能支持定制内容中的某一部分。"
        content += " 例如，如果我们只想让内容的前三个字显示成红色，而其它文字显 "
        content += " 示成黑色，那么就办不到了。"
        content += " \n\n "
        content += " 解决的办法很简单，我们让`CTFrameParser`支持接受 "
        content += " NSAttributeString 作为参数，然后在 NSAttributeString 中设置好 "
        content += " 我们想要的信息。"
        
        
        let data: CTFrameTextData = CTFrameParser.parseContent(content: content, config: config)
    
        self.ctView?.frame = CGRect(x: 0, y: 20, width: self.view.bounds.size.width, height: data.height)
        self.ctView?.textData = data;
        self.ctView?.backgroundColor = UIColor.yellow;
        
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
