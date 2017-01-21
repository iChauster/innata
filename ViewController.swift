//
//  ViewController.swift
//  Innata
//
//  Created by Ivan Chau on 1/20/17.
//  Copyright © 2017 Innata. All rights reserved.
//

import UIKit
class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //Scroll View:
        
        var VOne : ViewOne = ViewOne(nibName: "ViewOne", bundle: nil)
        var VTwo : ViewTwo = ViewTwo(nibName: "ViewTwo", bundle: nil)
        
        self.addChildViewController(VOne)
        self.addChildViewController(VTwo)
        self.scrollView.addSubview(VOne.view)
        self.scrollView.addSubview(VTwo.view)
        VOne.didMove(toParentViewController: self)
        VTwo.didMove(toParentViewController: self)
        var secondScrollFrame : CGRect = VTwo.view.frame
        secondScrollFrame.origin.x = self.view.frame.width
        VTwo.view.frame = secondScrollFrame
        self.scrollView.contentSize = CGSize(width: self.view.frame.width * 2, height: self.view.frame.size.height)
        
        
        
        
        
        let imagePickerActionSheet = UIAlertController(title: "Snap/Upload Photo",
                                                       message: nil, preferredStyle: .actionSheet)
        // 3
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraButton = UIAlertAction(title: "Take Photo",
                                             style: .default) { (alert) -> Void in
                                                let imagePicker = UIImagePickerController()
                                                imagePicker.delegate = self
                                                imagePicker.sourceType = .camera
                                                self.present(imagePicker,
                                                                           animated: true,
                                                                           completion: nil)
            }
            imagePickerActionSheet.addAction(cameraButton)
        }
        let cancelButton = UIAlertAction(title: "Cancel",
                                         style: .cancel) { (alert) -> Void in
        }
        imagePickerActionSheet.addAction(cancelButton)
        // 6
        present(imagePickerActionSheet, animated: true, completion: nil)        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   

}

