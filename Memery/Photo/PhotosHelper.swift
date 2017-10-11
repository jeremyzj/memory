//
//  PhotosHelper.swift
//  Memery
//
//  Created by 藏银 on 2017/10/9.
//  Copyright © 2017年 藏银. All rights reserved.
//

import UIKit
import Photos

class PhotosHelper: NSObject {
    
    public typealias PhotosHandler = () -> Void
    
    var photoHandler: PhotosHandler?
    
    func requestAuthorization(viewController: UIViewController, completionHandler: @escaping PhotosHandler) {
        self.photoHandler = completionHandler
        
        PHPhotoLibrary.requestAuthorization { authStatus in
            
            var alertController:UIAlertController?
            
            switch authStatus {
                case .authorized:
                    if self.photoHandler != nil {
                        self.photoHandler!()
                        self.photoHandler = nil
                    }
                    
                case .notDetermined:
                    alertController = UIAlertController(
                        title: "Let Memories access Photos?",
                        message: "Memories can only work if it has access to your photos. If you tap 'Allow' iOS will ask your permission.",
                        preferredStyle: .alert)
                    // OK
                    let allowAction = UIAlertAction(
                        title: "allow",
                        style: .default,
                        handler: {
                            (action: UIAlertAction!) -> Void in
                            PHPhotoLibrary.requestAuthorization { status in
                                if (status == .authorized) {
                                    if self.photoHandler != nil {
                                        self.photoHandler!()
                                        self.photoHandler = nil
                                    }
                                }
                            }
                    })
                    alertController?.addAction(allowAction)
                    // deny
                    let denyAction = UIAlertAction(
                        title: "not now",
                        style: .default,
                        handler: {
                            (action: UIAlertAction!) -> Void in
                            
                    })
                    alertController?.addAction(denyAction)
         
                
                case .denied:
                
                    alertController = UIAlertController(
                        title: "No Access to Photos",
                        message: "Denied access to Photos for Memories. In order for Memories to work you must enable this access in Settings. Would you like to do this now?",
                        preferredStyle: .alert)
                    
                    let settings = UIAlertAction(
                        title: NSLocalizedString("Settings", comment: ""),
                        style: .default)  { _ in
                            let url = URL(string: UIApplicationOpenSettingsURLString)
                            UIApplication.shared.openURL(url!);
                            
                    }
                    
                    
                    let nothanks = UIAlertAction(
                        title: NSLocalizedString("No thanks", comment: ""),
                        style: .cancel)  { _ in
                    }
                    alertController?.addAction(nothanks)
                    alertController?.addAction(settings)
                
                
                case .restricted:
                    alertController = UIAlertController(
                        title: NSLocalizedString("No Access to Photos", comment: ""),
                        message: NSLocalizedString("Access to Photos has been restricted on this device. Unfortunately this means Memories will not work until this is changed.", comment: ""),
                        preferredStyle: .alert)
                    let ok = UIAlertAction(
                        title: NSLocalizedString("OK", comment: ""),
                        style: .default)  { _ in
                            
                    }
                    alertController?.addAction(ok)
                
            }
            
            if let alert = alertController {
                viewController.present(alert, animated: true)
            }
        
        }
    }

}
