//
//  ContactHelp.swift
//  Messages
//
//  Created by Robin He on 11/20/18.
//  Copyright © 2018 Robin He. All rights reserved.
//

import UIKit

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView{
    
    
    
    func loadImageUsingCacheFromUrl(urlString:String){
        self.image = nil
        
        if let imageCacheDownload = imageCache.object(forKey: urlString as NSString) {
            
            self.image = imageCacheDownload
            return
        }
        
        let url = NSURL(string: urlString)
        let dataTask =   URLSession.shared.dataTask(with: url as! URL, completionHandler: { (data, response , error) in
            if error != nil {
                fatalError()
                return
            }
            DispatchQueue.main.async(execute: {
                if let downloadedImage = UIImage(data: data!) {
                    
                    imageCache.setObject(downloadedImage, forKey: urlString as NSString)
                    
                    self.image  = downloadedImage
                }
                
                
                
            })
            
            
            
        })
        
        dataTask.resume()
        
        
    }
    
    
    
}
