//
//  ViewController.swift
//  Project25
//
//  Created by Noah Glaser on 2/2/22.
//

import UIKit
import MultipeerConnectivity

class ViewController: UICollectionViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, MCSessionDelegate, MCBrowserViewControllerDelegate, MCNearbyServiceAdvertiserDelegate {
    
    
    var images = [UIImage]()
    
    var peerID = MCPeerID(displayName: UIDevice.current.name)
    
    var mcSession: MCSession?
    
    var mcAdAssistant: MCNearbyServiceAdvertiser?


    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Selfie Share"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(importPicture))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showConnectionPrompt))
        
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .none)
        mcSession?.delegate = self
        
    }
    
    
    
    func startHosting(via action: UIAlertAction) {
        guard mcSession != nil else { return }
        mcAdAssistant = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: nil, serviceType: "hws-project25")
        mcAdAssistant?.delegate = self
        mcAdAssistant?.startAdvertisingPeer()
    }
    
    // Allows user's to accept or decline the invite
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        let ac = UIAlertController(title: title, message: "\(peerID.displayName) wants to connect", preferredStyle: .alert)

            ac.addAction(UIAlertAction(title: "Allow", style: .default, handler: { [weak self] _ in
                invitationHandler(true, self?.mcSession)
            }))

            ac.addAction(UIAlertAction(title: "Decline", style: .cancel, handler: { _ in
                invitationHandler(false, nil)
            }))

            present(ac, animated: true)
    }
    
    func joinSession(action: UIAlertAction) {
        guard let mcSession = mcSession else {
            return
        }
        let mcBrowser = MCBrowserViewController(serviceType: "hws-project25", session: mcSession)
        mcBrowser.delegate = self
        present(mcBrowser, animated: true)
    }
    
    @objc func importPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @objc func showConnectionPrompt() {
        let ac = UIAlertController(title: "Connect to others", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Host a session", style: .default, handler: startHosting))
        ac.addAction(UIAlertAction(title: "Join a session", style: .default, handler: joinSession))
        ac.addAction(UIAlertAction(title: "Disconnect", style: .default, handler: {
            [weak self] _ in
                self?.mcSession?.disconnect()
        }))
        ac.addAction(UIAlertAction(title: "Send Message", style: .default, handler: showMessagePrompt))
        ac.addAction(UIAlertAction(title: "Show Peers", style: .default, handler: showPeers))

        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(ac, animated: true)
    }
    
    @objc func showPeers(_ action: UIAlertAction) {
        showAlert(title: "Peer List", message: mcSession?.connectedPeers.map({
            $0.displayName
        }).joined(separator: ","))
    }
    
    @objc func showMessagePrompt(action: UIAlertAction)
    {
        let ac = UIAlertController(title: "Send Message", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Send", style: .default, handler: {
            [weak self, weak ac] action in
            guard let text =  ac?.textFields?.first?.text else { return }
            guard let mcSession = self?.mcSession else { return }
            
            do {
                try mcSession.send(Data(text.utf8), toPeers: mcSession.connectedPeers, with: .reliable)
            } catch {
                self?.showAlert(title: "Failed to send message", message: nil)
            }
        }))
        present(ac, animated: true)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageView", for: indexPath)
        
        if let imageView = cell.viewWithTag(1000) as? UIImageView {
            imageView.image = images[indexPath.row]
        }
        
        return cell
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage else { return }
        dismiss(animated: true)
        
        images.insert(image, at: 0)
        collectionView.reloadData()
    
        guard let mcSession = mcSession else {
            return
        }
        
        if mcSession.connectedPeers.count > 0 {
            
            if let imageData = image.pngData() {
                do {
                    try mcSession.send(imageData, toPeers: mcSession.connectedPeers, with: .reliable)
                } catch {
                    showAlert(title: "Send Error", message: error.localizedDescription)
                }
            }
        }
    }
    
    func showAlert(title: String, message: String?) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)

    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        DispatchQueue.main.async {
            [weak self] in
             let text = String(decoding: data, as: UTF8.self)
            
            if !text.isEmpty {
                self?.showAlert(title: "New Message", message: text)
                return
            }
            
            if let image = UIImage(data: data) {
                self?.images.insert(image, at: 0)
                self?.collectionView.reloadData()
            }
            
            
        }
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            print("Connectted: \(peerID.displayName)")
        case .connecting:
            print("Connectting: \(peerID.displayName)")
        case .notConnected:
            DispatchQueue.main.async {
                [weak self] in
                let ac = UIAlertController(title: "\(peerID.displayName) has disconnected", message: nil, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(ac, animated: true)

            }
            print("Not Connected: \(peerID.displayName)")
        @unknown default:
            print("Unknown state received: \(peerID.displayName)")
        }
    }
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
}

