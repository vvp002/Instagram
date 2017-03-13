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
    var username: String?
    var likesCount: Int = 0
    var commentsCount: Int = 0
    
    //Initiate the post
    init(photo: UIImage, caption: String, username: String) {
        self.photo = photo
        self.caption = caption
        self.username = username
    }
    
    class func postPhoto(photo: UIImage, caption: String?, success: PFBooleanResultBlock?) {
        
        let post = PFObject(className: "Post")
        
        post["caption"] = caption
        post["author"] = PFUser.current()
        post["likesCount"] = 0
        post["commentsCount"] = 0
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
