//
//  NotificationsUtil.swift
//  Momentum
//
//  Created by Ahmer Baig on 22/11/2017.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import Whisper

class NotificationsUtil {
    
    static var currentNavController:UINavigationController!
    
    
    class func setSuperView(navController: UINavigationController) {
        self.currentNavController = navController
    }
    
    class func removeFromSuperView() {
        self.currentNavController = nil
    }
    
    class func fireNotification(data: [String:Any]) {
        if let notification_id = data["title"] as? String {
            if data["isNotificationTapped"] as! Bool == true {
                self.performNotificationTypeAction(type: notification_id, jsonMessage: data)
                //do something on notification tappe, app in background state
            } else {
                guard let aps = data["aps"] as? [String:Any] else {return}
                guard let alert = aps["alert"] as? [String:Any] else {return}
                guard let Title = alert["title"] as? String else {return}
                guard let Body = alert["body"] as? String else {return}
                let notificationShout = Announcement(title: Title, subtitle: Body, image: #imageLiteral(resourceName: "logo"), duration: TimeInterval(10), action: {
                    self.performNotificationTypeAction(type: notification_id, jsonMessage: data)
                    print("notification tapped")
                })
                Whisper.hide()
                Whisper.show(shout: notificationShout, to: self.currentNavController)
            }
        }
    }
    
    class func performNotificationTypeAction(type: String, jsonMessage: [String:Any]) {
        if type == "Doctor Message" || type == "Patient Message" {
            self.showMessagesController(data: jsonMessage)
        }
    }
    
    class func showMessagesController(data: [String:Any]) {
        let window = UIApplication.shared.keyWindow!
        let mainController = window.currentViewController()
        if mainController is ViewController {
            let controller = mainController as! ViewController
            controller.notificationData = data
        } else if mainController is MessagesViewController {
            let controller = mainController as! MessagesViewController
            controller.notificationData = data
            controller.performDidApearThings()
        } else {
            let MessagesVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MessagesViewController") as! MessagesViewController
            MessagesVC.notificationData = data
            self.currentNavController.pushViewController(MessagesVC, animated: true)
        }
    }
}
