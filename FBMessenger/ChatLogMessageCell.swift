//
//  ChatLogMessageCell.swift
//  FBMessenger
//
//  Created by Tihomir Videnov on 11/13/16.
//  Copyright © 2016 Tihomir Videnov. All rights reserved.
//

import UIKit

class ChatLogMessageCell: BaseCell {
    
    let messageTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.text = "Sample Message"
        textView.isEditable = false
        textView.backgroundColor = .clear
        return textView
    }()
    
    let textBubleView: UIView = {
       let view = UIView()
//        view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()
    
    let profileImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let bubbleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = grayBubbleImage
        imageView.tintColor = UIColor(white: 0.95, alpha: 1)
        return imageView
    }()
    
    static let grayBubbleImage = UIImage(named: "bubble_gray")!.resizableImage(withCapInsets: UIEdgeInsets(top: 22, left: 26, bottom: 22, right: 26)).withRenderingMode(.alwaysTemplate)
    static let blueBubbleImage = UIImage(named: "bubble_blue")!.resizableImage(withCapInsets: UIEdgeInsets(top: 22, left: 26, bottom: 22, right: 26)).withRenderingMode(.alwaysTemplate)
    
    override func setupViews() {
        super.setupViews()
        
        
        addSubview(textBubleView)
        addSubview(messageTextView)
        
        addSubview(profileImageView)
        
        addConstraintsWithFormat(format: "H:|-8-[v0(30)]", views: profileImageView)
        addConstraintsWithFormat(format: "V:[v0(30)]|", views: profileImageView)
        
        textBubleView.addSubview(bubbleImageView)
        textBubleView.addConstraintsWithFormat(format: "H:|[v0]|", views: bubbleImageView)
        textBubleView.addConstraintsWithFormat(format: "V:|[v0]|", views: bubbleImageView)
        
        
//        addConstraintsWithFormat(format: "H:|[v0]|", views: messageTextView)
//        addConstraintsWithFormat(format: "V:|[v0]|", views: messageTextView)
    }
}
