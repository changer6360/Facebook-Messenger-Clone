//
//  Extensions.swift
//  FBMessenger
//
//  Created by Tihomir Videnov on 11/12/16.
//  Copyright © 2016 Tihomir Videnov. All rights reserved.
//

import UIKit
import CoreData

extension UIView {
    
    func addConstraintsWithFormat(format: String, views: UIView...) {
        
        var viewsDictionary = [String:UIView]()
        for (index,view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
}


extension FriendsController {

    
    func setupData() {
        
        clearData()
        
        //let mark = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
        let mark = Friend(context: context)
        
        //let mark = Friend()
        mark.name = "Mark Zuckerberg"
        mark.profileImage = "zuckprofile"
        
        //let steve = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
        let steve = Friend(context: context)
        steve.name = "Steve Jobs"
        steve.profileImage = "steve_profile"
        
        let donald = Friend(context: context)
        donald.name = "Donald Trump"
        donald.profileImage = "donald_trump_profile"
        
        let gandhi = Friend(context: context)
        gandhi.name = "Gandhi"
        gandhi.profileImage = "gandhi"
        
        let hillary = Friend(context: context)
        hillary.name = "Hillary Clinton"
        hillary.profileImage = "hillary_profile"
        
        createMessageWithText(text: "Hey, nice to see you here...", friend: mark, minutesAgo: 1)
        
        createMessageWithText(text: "Good morning...", friend: steve, minutesAgo: 3)
        createMessageWithText(text: "Hello, how are you?", friend: steve,minutesAgo: 2)
        createMessageWithText(text: "Great, thanks for asking!", friend: steve, minutesAgo: 1)
        
        createMessageWithText(text: "I am the new president of USA!", friend: donald, minutesAgo: 5)
        createMessageWithText(text: "Love, Pease and Joy", friend: gandhi, minutesAgo: 60 * 24)
        createMessageWithText(text: "Please vote for me!", friend: hillary, minutesAgo: 8 * 60 * 24)
        
       ad.saveContext()
        
        loadData()
    }
    
    func createMessageWithText(text: String, friend: Friend, minutesAgo: Double) {
        let message = Message(context: context)
        message.friend = friend
        message.text = text
        message.date = NSDate().addingTimeInterval(-minutesAgo * 60)
    }
    
    func loadData() {
        
        let fetchRequest:NSFetchRequest<Message> = Message.fetchRequest()
        
        let dateSort = NSSortDescriptor(key: "date", ascending: false)
        
        if let friends = fetchFriends() {
            
            messages = [Message]()
            
            for friend in friends {
            print(friend.name)
                
                fetchRequest.sortDescriptors = [dateSort]
                fetchRequest.predicate = NSPredicate(format: "friend.name = %@", friend.name!)
                fetchRequest.fetchLimit = 1
                
                do  {
                    let fetchedMessages = try context.fetch(fetchRequest)
                    messages?.append(contentsOf: fetchedMessages)
                } catch let err {
                    print(err)
                    
                }
            }
            
            messages = messages?.sorted(by: {$0.date!.compare($1.date! as Date) == .orderedDescending})
        }
    }
    
    
    func clearData() {
        
        let entityNames = ["Friend", "Message"]
        
        for entity in entityNames {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
            
            do  {
               let objects =  try context.fetch(request)
                for object in objects {
                    context.delete(object as! NSManagedObject)
                }
            } catch let err {
                print(err)
            }
        }
        
    }
        
//            let fetchRequest:NSFetchRequest<Message> = Message.fetchRequest()
//            
//            do  {
//                messages =  try context.fetch(fetchRequest)
//                for message in messages! {
//                    context.delete(message)
//                }
//            } catch let err {
//                print(err)
//            }
//        }
    
    
    func fetchFriends() -> [Friend]? {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Friend")
        
        do  {
            let friends = try context.fetch(request) as? [Friend]
            return friends
            } catch let err {
            print(err)
        }

        return nil
        
    }
    
}
























