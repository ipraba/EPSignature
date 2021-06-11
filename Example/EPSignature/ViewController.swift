//
//  ViewController.swift
//  EPSignature
//
//  Created by Prabaharan on 01/13/2016.
//  Modified By C0mrade on 27/09/2016.
//  Copyright (c) 2016 Prabaharan. All rights reserved.
//

import UIKit
import EPSignature

class ViewController: UIViewController, EPSignatureDelegate {
    @IBOutlet weak var imgWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var imgHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imgViewSignature: UIImageView!

    @IBAction func onTouchSignatureButton(sender: AnyObject) {
        let signatureVC = EPSignatureViewController(signatureDelegate: self, showsDate: true, showsSaveSignatureOption: true)
        signatureVC.subtitleText = "I agree to the terms and conditions"
        signatureVC.title = "John Doe"
        let nav = UINavigationController(rootViewController: signatureVC)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }

    func epSignature(view: EPSignatureViewController, didCancel error : NSError) {
        print("User canceled")
        view.dismiss(animated: true, completion: nil)

    }
    
    func epSignature(view: EPSignatureViewController, didSign signatureImage : UIImage, boundingRect: CGRect) {
        print(signatureImage)
        imgViewSignature.image = signatureImage
        imgWidthConstraint.constant = boundingRect.size.width
        imgHeightConstraint.constant = boundingRect.size.height
        view.dismiss(animated: true, completion: nil)
    }
    
    func epSignatureDelete(view: EPSignatureViewController) {
        imgViewSignature.image = nil
    }


}

