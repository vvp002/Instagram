//
//  Post.swift
//  Instagram
//
//  Created by Vivian Pham on 3/11/17.
//  Copyright © 2017 Vivian Pham. All rights reserved.
//

import Foundation
import UIKit
import Parse

class Post: NSObject {
    var photo: UIImage?
    var caption: String?
    
    init(photo: UIImage, caption: String) {
        self.photo = photo
        self.caption = caption
    }
    
    class func postPhoto(photo: UIImage, caption: String?, success: PFBooleanResultBlock?) {
        
        let post = PFObject(className: "Post")
        
        post["caption"] = caption
        post["author"] = PFUser.current()
        
        post["media"] = getPhotoFile(photo: photo)
        
        post.saveInBackground(block: success)
    }
    
    class func getPhotoFile(photo: UIImage?) -> PFFile? {
        if let photo = photo {
            if let photo_data = UIImagePNGRepresentation(photo) {
                return PFFile(name: "photo.png", data: photo_data)
            }
        } else {
            return nil
        }
        return nil
    }
}
