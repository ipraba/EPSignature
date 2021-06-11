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
    @objc  func epSignature(view: EPSignatureViewController, didCancel error : NSError)
    @objc  func epSignature(view: EPSignatureViewController, didSign signatureImage : UIImage, boundingRect: CGRect)
    @objc optional    func epSignatureDelete(view: EPSignatureViewController)
}

open class EPSignatureViewController: UIViewController {

    // MARK: - IBOutlets
    
  //  @IBOutlet weak var switchSaveSignature: UISwitch!
    @IBOutlet weak var lblSignatureSubtitle: UILabel!
    @IBOutlet weak var lblDefaultSignature: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var viewMargin: UIView!
    @IBOutlet weak var lblX: UILabel!
    @IBOutlet weak var signatureView: EPSignatureView!
    
    // MARK: - Public Vars
    
    open var showsDate: Bool = true
//    open var showsSaveSignatureOption: Bool = true
    open weak var signatureDelegate: EPSignatureDelegate?
    open var subtitleText = NSLocalizedString("Sign Here", comment:"Sign Here")
    open var tintColor = UIColor.defaultTintColor()

    // MARK: - Life cycle methods
    
    override open func viewDidLoad() {
        super.viewDidLoad()

        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(EPSignatureViewController.onTouchCancelButton))
        cancelButton.tintColor = tintColor
        self.navigationItem.leftBarButtonItem = cancelButton
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(EPSignatureViewController.onTouchDoneButton))
        doneButton.tintColor = tintColor
        let clearButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(EPSignatureViewController.onTouchClearButton))
        clearButton.tintColor = tintColor
        
        if showsDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle  = DateFormatter.Style.short
            dateFormatter.timeStyle  = DateFormatter.Style.none
            lblDate.text = dateFormatter.string(from: Date())
        } else {
            lblDate.isHidden = true
        }
        
            self.navigationItem.rightBarButtonItems = [doneButton, clearButton]

        lblSignatureSubtitle.text = subtitleText
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
        self.signatureDelegate = signatureDelegate
        let bundle = Bundle(for: EPSignatureViewController.self)
        super.init(nibName: "EPSignatureViewController", bundle: bundle)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Button Actions
    
    @objc func onTouchCancelButton() {
        signatureDelegate?.epSignature(view:self, didCancel: NSError(domain: "EPSignatureDomain", code: 1, userInfo: [NSLocalizedDescriptionKey:"User not signed"]))
    }

    @objc func onTouchDoneButton() {
        if let signature = signatureView.getSignatureAsImage() {
            signatureDelegate?.epSignature(view:self, didSign: signature, boundingRect: signatureView.getSignatureBoundsInCanvas())
        } else {
            showAlert(NSLocalizedString("No signature", comment:"No signature"), andTitle:NSLocalizedString("Please sign on the line.", comment:"Please sign on the line.") )
        }

    }
    

    @objc func onTouchClearButton() {
        signatureView.clear()
        signatureDelegate?.epSignatureDelete?(view:self)
    }
    
    override open func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        signatureView.reposition()
    }
}
