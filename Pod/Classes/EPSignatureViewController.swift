//
//  EPSignatureViewController.swift
//  Pods
//
//  Created by Prabaharan Elangovan on 13/01/16.
//
//

import UIKit

    // MARK: - EPSignatureDelegate
@objc public protocol EPSignatureDelegate {
    @objc optional    func epSignature(_: EPSignatureViewController, didCancel error : NSError)
    @objc optional    func epSignature(_: EPSignatureViewController, didSign signatureImage : UIImage, boundingRect: CGRect)
}

open class EPSignatureViewController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var switchSaveSignature: UISwitch!
    @IBOutlet weak var lblSignatureSubtitle: UILabel!
    @IBOutlet weak var lblDefaultSignature: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var viewMargin: UIView!
    @IBOutlet weak var lblX: UILabel!
    @IBOutlet weak var signatureView: EPSignatureView!
    
    // MARK: - Public Vars
    
    open var showsDate: Bool = true
    open var showsSaveSignatureOption: Bool = true
    open weak var signatureDelegate: EPSignatureDelegate?
    open var subtitleText = "Sign Here"
    open var tintColor = UIColor.defaultTintColor()

    // MARK: - Life cycle methods
    
    override open func viewDidLoad() {
        super.viewDidLoad()

        let cancelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: #selector(EPSignatureViewController.onTouchCancelButton))
        cancelButton.tintColor = tintColor
        self.navigationItem.leftBarButtonItem = cancelButton
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(EPSignatureViewController.onTouchDoneButton))
        doneButton.tintColor = tintColor
        let clearButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.trash, target: self, action: #selector(EPSignatureViewController.onTouchClearButton))
        clearButton.tintColor = tintColor
        
        if showsDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle  = DateFormatter.Style.short
            dateFormatter.timeStyle  = DateFormatter.Style.none
            lblDate.text = dateFormatter.string(from: Date())
        } else {
            lblDate.isHidden = true
        }
        
        if showsSaveSignatureOption {
            let actionButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.action, target:   self, action: #selector(EPSignatureViewController.onTouchActionButton(_:)))
            actionButton.tintColor = tintColor
            self.navigationItem.rightBarButtonItems = [doneButton, clearButton, actionButton]
            switchSaveSignature.onTintColor = tintColor
        } else {
            self.navigationItem.rightBarButtonItems = [doneButton, clearButton]
            lblDefaultSignature.isHidden = true
            switchSaveSignature.isHidden = true
        }
        
        lblSignatureSubtitle.text = subtitleText
        switchSaveSignature.setOn(false, animated: true)
    }
    
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Initializers
    
    public convenience init(signatureDelegate: EPSignatureDelegate) {
        self.init(signatureDelegate: signatureDelegate, showsDate: true, showsSaveSignatureOption: true)
    }
    
    public convenience init(signatureDelegate: EPSignatureDelegate, showsDate: Bool) {
        self.init(signatureDelegate: signatureDelegate, showsDate: showsDate, showsSaveSignatureOption: true)
    }
    
    public init(signatureDelegate: EPSignatureDelegate, showsDate: Bool, showsSaveSignatureOption: Bool ) {
        self.showsDate = showsDate
        self.showsSaveSignatureOption = showsSaveSignatureOption
        self.signatureDelegate = signatureDelegate
        let bundle = Bundle(for: EPSignatureViewController.self)
        super.init(nibName: "EPSignatureViewController", bundle: bundle)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Button Actions
    
    @objc func onTouchCancelButton() {
        signatureDelegate?.epSignature!(self, didCancel: NSError(domain: "EPSignatureDomain", code: 1, userInfo: [NSLocalizedDescriptionKey:"User not signed"]))
        dismiss(animated: true, completion: nil)
    }

    @objc func onTouchDoneButton() {
        if let signature = signatureView.getSignatureAsImage() {
            if switchSaveSignature.isOn {
                let docPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
                let filePath = (docPath! as NSString).appendingPathComponent("sig.data")
                signatureView.saveSignature(filePath)
            }
            signatureDelegate?.epSignature!(self, didSign: signature, boundingRect: signatureView.getSignatureBoundsInCanvas())
            dismiss(animated: true, completion: nil)
        } else {
            showAlert("You did not sign", andTitle: "Please draw your signature")
        }
    }
    
    @objc func onTouchActionButton(_ barButton: UIBarButtonItem) {
        let action = UIAlertController(title: "Action", message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
        action.view.tintColor = tintColor
        
        action.addAction(UIAlertAction(title: "Load default signature", style: UIAlertActionStyle.default, handler: { action in
            let docPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
            let filePath = (docPath! as NSString).appendingPathComponent("sig.data")
            self.signatureView.loadSignature(filePath)
        }))
        
        action.addAction(UIAlertAction(title: "Delete default signature", style: UIAlertActionStyle.destructive, handler: { action in
            self.signatureView.removeSignature()
        }))
        
        action.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        if let popOver = action.popoverPresentationController {
            popOver.barButtonItem = barButton
        }
        present(action, animated: true, completion: nil)
    }

    @objc func onTouchClearButton() {
        signatureView.clear()
    }
    
    override open func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        signatureView.reposition()
    }
}
