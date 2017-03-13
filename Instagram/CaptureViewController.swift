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
        let caption = captionTextField.text
        
        let photoPost = resize(photo: self.photoImageView.image!, newSize: CGSize(width: 600, height: 600))
        Post.postPhoto(photo: photoPost, caption: caption) { (success: Bool, error: Error?) in
            if success {
                self.tabBarController?.selectedIndex = 0
            } else {
                print(error?.localizedDescription ?? "")
            }
        }
        
        self.captionTextField.text = "Please add a caption"
        self.captionTextField.textColor = UIColor.darkGray
        photoImageView.isHidden = false
        photoImageView.image = nil
        defaultLabel.isHidden = false
        
    }

    @IBAction func selectImageFromLibrary(_ sender: UITapGestureRecognizer) {
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    func resize(photo: UIImage, newSize: CGSize) -> UIImage {
        let resizedImage = UIImageView(frame: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        resizedImage.contentMode = UIViewContentMode.scaleAspectFill
        resizedImage.image = photo
        
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
        
        photoImageView.image = originalImage
        defaultLabel.isHidden = true
        self.captionTextField.text = ""
        self.captionTextField.textColor = UIColor.darkGray
        
        // Dismiss UIImagePickerController to go back to your original view controller
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
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
