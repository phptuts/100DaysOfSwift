//
//  ViewController.swift
//  Project28
//
//  Created by Noah Glaser on 2/11/22.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {

    @IBOutlet var secret: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        notificationCenter.addObserver(self, selector: #selector(saveSecretMessage), name: UIApplication.willResignActiveNotification, object: nil)

        title = "Nothing to see here"
    }

    @IBAction func authenticateTapped(_ sender: Any) {
        let context = LAContext()
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify Yourself"
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) {
                [weak self]  success, authenticationError in
                if success {
                    DispatchQueue.main.async {
                        self?.unlockSecretMessage()
                    }
                } else {
                    DispatchQueue.main.async {
                        let ac = UIAlertController(title: "Auth Failed", message: "You could not be verified", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        self?.present(ac, animated: true)
                    }
                }
            }
        } else {
            // no access to device
            let ac = UIAlertController(title: "Biometry Unvailable", message: "Your device is not configured for biometric auth", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)

        }
                        
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else  {
            return
        }
        DispatchQueue.main.async {
            [weak self] in
            guard let strongSelf = self else { return }

        
        let keyboardScreenEnd = keyboardValue.cgRectValue
            let keyboardViewEndFrame = strongSelf.view.convert(keyboardScreenEnd, from: strongSelf.view.window)
        
            if notification.name == UIResponder.keyboardWillHideNotification {
                strongSelf.secret.contentInset = .zero
            } else {
                strongSelf.secret.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - strongSelf.view.safeAreaInsets.bottom , right: 0)
                
            }
            
            strongSelf.secret.scrollIndicatorInsets = strongSelf.secret.contentInset
            let selectedRange = strongSelf.secret.selectedRange
            strongSelf.secret.scrollRangeToVisible(selectedRange)
        }
    }
    
    
    func unlockSecretMessage() {
        DispatchQueue.main.async {
            [weak self] in
            self?.secret.isHidden = false
            self?.title = "Secret Stuff"
            self?.secret.text = KeychainWrapper.standard.string(forKey: "Secret Message") ?? ""
        }
    }
    
    @objc func saveSecretMessage() {
        DispatchQueue.main.async {
            [weak self] in
            guard self?.secret.isHidden == false else { return }
            
            KeychainWrapper.standard.set(self?.secret.text ?? "", forKey: "Secret Message")
            self?.secret.resignFirstResponder()
            self?.secret.isHidden = true
            self?.title = "Nothing to see here"
        }
    }
    
    
    
    
}

