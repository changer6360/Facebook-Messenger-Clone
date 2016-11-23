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
//        let mark = Friend(context: context)
//        
//        //let mark = Friend()
//        mark.name = "Mark Zuckerberg"
//        mark.profileImage = "zuckprofile"
        
        let jimmy = Friend(context: context)
        jimmy.name = "Jimmy Fallon"
        jimmy.profileImage = "jimmy"
        
        let elon = Friend(context: context)
        elon.name = "Elon Musk"
        elon.profileImage = "elon"
        
        let justin = Friend(context: context)
        justin.name = "Justin Timberlake"
        justin.profileImage = "justin"
        
//        FriendsController.createMessageWithText(text: "Hey, nice to see you here...", friend: mark, minutesAgo: 1)
        
        createSteveMessages()
        
        FriendsController.createMessageWithText(text: "Did you watch the show last night?", friend: jimmy, minutesAgo: 5)
        FriendsController.createMessageWithText(text: "We are preparing for Mars!", friend: elon, minutesAgo: 60 * 24)
        FriendsController.createMessageWithText(text: "Don't cry me a river...", friend: justin, minutesAgo: 8 * 60 * 24)
        
       ad.saveContext()
        
//        loadData()
    }
    
    fileprivate func createSteveMessages() {
        
        let steve = Friend(context: context)
        steve.name = "Steve Jobs"
        steve.profileImage = "steve_profile"
        
        FriendsController.createMessageWithText(text: "Good morning...", friend: steve, minutesAgo: 3)
        FriendsController.createMessageWithText(text: "Hello, how are you?", friend: steve,minutesAgo: 2)
        FriendsController.createMessageWithText(text: "Did you see the new Macbook Pro's with the new touch bar? They are great, aren't they?", friend: steve, minutesAgo: 1)
        
        //response message
        FriendsController.createMessageWithText(text: "Yes, they are great!", friend: steve, minutesAgo: 1, isSender: true)
        
        FriendsController.createMessageWithText(text: "Will you buy one?", friend: steve, minutesAgo: 1)
        
        //response message
        FriendsController.createMessageWithText(text: "Well, it is a bit expenssive but I am considering it", friend: steve, minutesAgo: 1, isSender: true)
        
        FriendsController.createMessageWithText(text: "You know, great quallity comes with a price", friend: steve, minutesAgo: 1)
        
        //response message
        FriendsController.createMessageWithText(text: "True, but...", friend: steve, minutesAgo: 1, isSender: true)
    }
    
    static func createMessageWithText(text: String, friend: Friend, minutesAgo: Double, isSender: Bool = false) -> Message {
        let message = Message(context: context)
        message.friend = friend
        message.text = text
        message.date = NSDate().addingTimeInterval(-minutesAgo * 60)
        message.isSender = isSender
        
        friend.lastMessage = message
        
        return message
    }
    
//    func loadData() {
//        
//        let fetchRequest:NSFetchRequest<Message> = Message.fetchRequest()
//        
//        let dateSort = NSSortDescriptor(key: "date", ascending: false)
//        
//        if let friends = fetchFriends() {
//            
//            messages = [Message]()
//            
//            for friend in friends {
////            print(friend.name)
//                
//                fetchRequest.sortDescriptors = [dateSort]
//                fetchRequest.predicate = NSPredicate(format: "friend.name = %@", friend.name!)
//                fetchRequest.fetchLimit = 1
//                
//                do  {
//                    let fetchedMessages = try context.fetch(fetchRequest)
//                    messages?.append(contentsOf: fetchedMessages)
//                } catch let err {
//                    print(err)
//                    
//                }
//            }
//            
//            messages = messages?.sorted(by: {$0.date!.compare($1.date! as Date) == .orderedDescending})
//        }
//    }
    
    
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
    
    
//    func fetchFriends() -> [Friend]? {
//        
//        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Friend")
//        
//        do  {
//            let friends = try context.fetch(request) as? [Friend]
//            return friends
//            } catch let err {
//            print(err)
//        }
//
//        return nil
//        
//    }
    
}























