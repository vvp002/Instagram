//
//  CaptureViewController.swift
//  Instagram
//
//  Created by Vivian Pham on 3/11/17.
//  Copyright © 2017 Vivian Pham. All rights reserved.
//

import UIKit
import Parse

class CaptureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var defaultLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var captionTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSubmit(_ sender: Any) {
        //Update caption field
        let caption = captionTextField.text
        
        //Resize the photo in the view and post it
        let photoPost = resize(photo: self.photoImageView.image!, newSize: CGSize(width: 600, height: 600))
        Post.postPhoto(photo: photoPost, caption: caption) { (success: Bool, error: Error?) in
            if success {
                self.tabBarController?.selectedIndex = 0
            } else {
                print(error?.localizedDescription ?? "")
            }
        }
        
        //Reset the view and its objects back to default
        self.captionTextField.text = "Please add a caption"
        self.captionTextField.textColor = UIColor.darkGray
        photoImageView.isHidden = false
        photoImageView.image = nil
        defaultLabel.isHidden = false
        
        self.tabBarController?.selectedIndex = 0
        
    }

    @IBAction func selectImageFromLibrary(_ sender: UITapGestureRecognizer) {
        
        //Instantiate a UIImagePickerController
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        //Present it to user
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    func resize(photo: UIImage, newSize: CGSize) -> UIImage {
        
        //Resize the image to match the siize that is passed in
        let resizedImage = UIImageView(frame: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        resizedImage.contentMode = UIViewContentMode.scaleAspectFill
        resizedImage.image = photo
        
        //update the image on the view controller to the new size
        UIGraphicsBeginImageContext(resizedImage.frame.size)
        resizedImage.layer.render(in: UIGraphicsGetCurrentContext()!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        // Get the image captured by the UIImagePickerController
        guard let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        else {
            print("Error when picking an image")
            fatalError("Error when picking an image")
        }
        
        //reset the view controller to original settings
        photoImageView.image = originalImage
        defaultLabel.isHidden = true
        self.captionTextField.text = ""
        self.captionTextField.textColor = UIColor.darkGray
        
        // Dismiss UIImagePickerController to go back to your original view controller
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //Cancel post and reset settings for default view
        defaultLabel.isHidden = false
        dismiss(animated: true, completion: nil)
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
