//
//  ViewController.swift
//  ImageTransfer
//
//  Created by ding qi on 2018/09/17.
//  Copyright © 2018 ding qi. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var originalImageView: UIImageView!
    @IBOutlet weak var referenceImageView: UIImageView!
    @IBOutlet weak var resultImageView: UIImageView!
    
    var uiImageViewToSet = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            if(uiImageViewToSet != nil){
                self.uiImageViewToSet.contentMode = .scaleAspectFit
                self.uiImageViewToSet.image = pickedImage
            }
        }
        picker.dismiss(animated: true, completion: {
            guard let uiImage = info[UIImagePickerControllerOriginalImage] as? UIImage
                else { fatalError("no image from image picker") }
        })
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func ImagrTransfer () {
        
    }

    @IBAction func chooseOriginalImage(_ sender: Any) {
        let c = UIImagePickerController()
        c.delegate = self
        uiImageViewToSet = originalImageView
        present(c, animated: true)
    }
    @IBAction func chooseReferenceImage(_ sender: Any) {
        let c = UIImagePickerController()
        c.delegate = self
        uiImageViewToSet = referenceImageView
        present(c, animated: true)
    }
    @IBAction func transferImage(_ sender: Any) {
    }
    
}

