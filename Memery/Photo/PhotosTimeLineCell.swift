//
//  PhotosTimeLineCell.swift
//  Memery
//
//  Created by 藏银 on 2017/10/9.
//  Copyright © 2017年 藏银. All rights reserved.
//

import UIKit

class PhotosTimeLineCell: UITableViewCell {

    @IBOutlet weak var thumbnailImage: UIImageView?
    @IBOutlet weak var timeLineView: PhotosTimeLineView?
    @IBOutlet weak var title: UILabel?
    
    
    func loadData(title: String, image: UIImage, isTop: Bool, isBottom: Bool) {
        self.title?.text = title
        self.thumbnailImage?.image = image
        self.timeLineView?.bottomCell = isBottom
        self.timeLineView?.topCell = isTop
        self.timeLineView?.timePoint = self.title?.center
    }

}
