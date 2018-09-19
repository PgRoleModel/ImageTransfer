//
//  ViewController.swift
//  ImageTransfer
//
//  Created by ding qi on 2018/09/17.
//  Copyright © 2018 ding qi. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // 写真を表示するするView（todo:あとで作る）
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // 画像の選択
    @IBAction func ImageSelect () {
        // フォトライブラリーに対するアクセス権限があれば処理する
        if(UIImagePickerController.isSourceTypeAvailable(.photoLibrary)){
            let pickerView = UIImagePickerController()
            pickerView.sourceType = .photoLibrary
            pickerView.delegate = self
            self.present(pickerView, animated:true)
        }
    }
    
    // 写真が選択されたら呼ばれる
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.imageView.image = image
        self.dismiss(animated: true)
    }
    
    func ImagrTransfer () {
        
    }

}

