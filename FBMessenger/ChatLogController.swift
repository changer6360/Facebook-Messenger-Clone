//
//  ChatLogController.swift
//  FBMessenger
//
//  Created by Tihomir Videnov on 11/13/16.
//  Copyright © 2016 Tihomir Videnov. All rights reserved.
//

import UIKit
import CoreData

class ChatLogController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var messages: [Message]?
    
    var bottomContraint: NSLayoutConstraint?
    
    fileprivate let cellId = "cellId"
    
    var friend: Friend? {
        didSet {
            navigationItem.title = friend?.name
//            messages = friend?.messages?.allObjects as? [Message]
//            
//            messages = messages?.sorted(by: {$0.date!.compare($1.date! as Date) == .orderedAscending})
        }
    }
        lazy var fetchedResultsController: NSFetchedResultsController<Message> = {
        let fetchRequest = NSFetchRequest<Message>(entityName:"Message")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "friend.name = %@", self.friend!.name!)
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        return frc
    }()
    
    let  messageInputContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let inputTexField: UITextField = {
       let textField = UITextField()
        textField.placeholder = "Enter a messsage..."
        return textField
    }()
    
    lazy var sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send", for: .normal)
        let titleColor = UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1)
        button.setTitleColor(titleColor, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        return button
    }()
    
    let topBorderView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        return view
    }()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try fetchedResultsController.performFetch()
            
        } catch let err {
            print(err)
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Simulate", style: .plain, target: self, action: #selector(simulate))
        
        tabBarController?.tabBar.isHidden = true
        
        collectionView?.backgroundColor = .white
        collectionView?.alwaysBounceVertical = true
        
        collectionView?.register(ChatLogMessageCell.self, forCellWithReuseIdentifier: cellId)
        
        view.addSubview(messageInputContainerView)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: messageInputContainerView)
        view.addConstraintsWithFormat(format: "V:[v0(48)]", views: messageInputContainerView)
        bottomContraint = NSLayoutConstraint(item: messageInputContainerView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        view.addConstraint(bottomContraint!)
        
        setupInputComponents()
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: .UIKeyboardWillHide, object: nil)
    }
    
    func simulate() {
//        
//        let message = FriendsController.createMessageWithText(text: "Simulated text message", friend: friend!, minutesAgo: 1)
//        do {
//            try context.save()
//            
//            messages?.append(message)
//            
//            messages = messages?.sorted(by: {$0.date!.compare($1.date! as Date) == .orderedAscending})
//            
//            if let item = messages?.index(of: message) {
//                let receivingIndexPath = IndexPath(item: item, section: 0)
//                collectionView?.insertItems(at: [receivingIndexPath])
//            }
//            
//            
//        } catch let err {
//            print(err)
//        }
    }
    
    func handleSend() {
        
       FriendsController.createMessageWithText(text: inputTexField.text!, friend: friend!, minutesAgo: 0, isSender: true)
        
        do {
            try context.save()
            
              inputTexField.text = nil
//            messages?.append(message)
//            
//            let item = messages!.count - 1
//            
//            let insertionIndexPath = IndexPath(item: item, section: 0)
//            
//            collectionView?.insertItems(at: [insertionIndexPath])
//            collectionView?.scrollToItem(at: insertionIndexPath, at: .bottom, animated: true)
            
        } catch let err {
            print(err)
        }
    }
    
    func handleKeyboardNotification(notification: Notification) {
        
        if let userInfo = notification.userInfo {
            let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
            
            let isKeyboardShowing = notification.name == .UIKeyboardWillShow
            
            bottomContraint?.constant = isKeyboardShowing ? -keyboardFrame!.height : 0
            
            
            UIView.animate(withDuration: 0, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: { (completed) in
                
                if isKeyboardShowing {
//                    let indexPath = IndexPath(item: (self.messages?.count)! - 1, section: 0)
//                    self.collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: true)
                    
                }
            })
        }
        
    }
    
    fileprivate func setupInputComponents() {
        
        messageInputContainerView.addSubview(inputTexField)
        messageInputContainerView.addSubview(sendButton)
        messageInputContainerView.addSubview(topBorderView)
        
        messageInputContainerView.addConstraintsWithFormat(format: "H:|-8-[v0][v1(60)]|", views: inputTexField,sendButton)
        
        messageInputContainerView.addConstraintsWithFormat(format: "V:|[v0]|", views: inputTexField)
        messageInputContainerView.addConstraintsWithFormat(format: "V:|[v0]|", views: sendButton)
        
        messageInputContainerView.addConstraintsWithFormat(format: "H:|[v0]|", views: topBorderView)
        messageInputContainerView.addConstraintsWithFormat(format: "V:|[v0(0.5)]", views: topBorderView)
    }
    
    //MARK:- CollectionView functions
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = fetchedResultsController.sections?[0].numberOfObjects {
            return count
        }
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        inputTexField.endEditing(true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatLogMessageCell
        
        let message = fetchedResultsController.object(at: indexPath)
        
        cell.messageTextView.text = message.text
        
        
        if let messageText = message.text, let profileImageName = message.friend?.profileImage {
            
            cell.profileImageView.image = UIImage(named: profileImageName)
            
            let size = CGSize(width: 250, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let estimatedFrame = NSString(string: messageText).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 18)], context: nil)
            
            if !message.isSender {
                cell.messageTextView.frame = CGRect(x: 48 + 8, y: 0, width: Int(estimatedFrame.width) + 16, height: Int(estimatedFrame.height + 20))
                
                cell.textBubleView.frame = CGRect(x: 48 - 10, y: -4, width: Int(estimatedFrame.width) + 16 + 8 + 16, height: Int(estimatedFrame.height + 20 + 6))
                
                cell.profileImageView.isHidden = false
                
                    cell.bubbleImageView.image = ChatLogMessageCell.grayBubbleImage
                  cell.bubbleImageView.tintColor = UIColor(white: 0.95, alpha: 1)
//                cell.textBubleView.backgroundColor = UIColor(white: 0.95, alpha: 1)
                cell.messageTextView.textColor = .black

            } else {
                
                cell.messageTextView.frame = CGRect(x: Int(view.frame.width - estimatedFrame.width) - 16 - 16 - 8, y: 0, width: Int(estimatedFrame.width) + 16, height: Int(estimatedFrame.height + 20))
                
                cell.textBubleView.frame = CGRect(x: Int(view.frame.width - estimatedFrame.width) - 16 - 8 - 16 - 10, y: -4, width: Int(estimatedFrame.width) + 16 + 8 + 10, height: Int(estimatedFrame.height + 20 + 6))
                
                cell.profileImageView.isHidden = true

                cell.bubbleImageView.image = ChatLogMessageCell.blueBubbleImage
                cell.bubbleImageView.tintColor = UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1)
//                cell.textBubleView.backgroundColor = UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1)
                cell.messageTextView.textColor = .white
            }
            
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let message = fetchedResultsController.object(at: indexPath)
        
        if let messageText = message.text {
            let size = CGSize(width: 250, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let estimatedFrame = NSString(string: messageText).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 18)], context: nil)
            
            return CGSize(width: view.frame.width, height: estimatedFrame.height + 20)
        }
        
        return CGSize(width: view.frame.width, height: 100)
    }
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
    }
    
}
