//
//  UpdateTimeViewController.swift
//  Optinote
//
//  Created by Christopher Fiegel on 7/9/17.
//  Copyright © 2017 Optimi. All rights reserved.
//

import UIKit
import SQLite
import UserNotifications

class UpdateTimeViewController: UIViewController, UNUserNotificationCenterDelegate {
    
    @IBOutlet weak var myDatePicker: UIDatePicker!
    var strMinute = "00"
    var strHour = "00"
    
    @IBAction func backToSettings(_ sender: Any) {
        registerLocal()
        scheduleLocal()
        self.dismiss(animated: true, completion: {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "tableSettings")
            self.present(vc!, animated: true, completion: nil)
        })
    }
    
    //pull the Hour and Minute time off of the date picker
    @IBAction func datePickerAction(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "mm"
        strMinute = dateFormatter.string(from: myDatePicker.date)
        
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "HH"
        strHour = dateFormatter2.string(from: myDatePicker.date)
        
        print("the times: \(strHour) + \(strMinute)")
    }
    
    @IBAction func globalTimeUpdate(_ sender: Any) {
        hour = Int(strHour)!
        minute = Int(strMinute)!
        
        print("sending the time to global variables- the hours is: \(hour) and the minute is : \(minute)")
        
        updateIntoTime()
        
        self.dismiss(animated: true, completion: {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "tableSettings")
            self.present(vc!, animated: true, completion: nil)
        })
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //update the time in the database
    func updateIntoTime(){
        do {
            //open the database
            let path = NSSearchPathForDirectoriesInDomains(
                .documentDirectory, .userDomainMask, true
                ).first!
            
            let db = try Connection("\(path)/db.sqlite3")
            
            //create the table if exists
            
            
            //insert the time for 9 o'clock reminder
            do {
                
                query1 = "UPDATE  reminder set hour = \(hour), minute =\(minute) where ID = 1"
                let sql1 = query1
                print(query1)
                try db.run(sql1)
            } catch
            {
                print("insert error \(error)")
            }
            
        }
        catch{
            print("total error : \(error)")
        }
    }

    //updating information
    
    func registerLocal() {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("Yay!")
                self.scheduleLocal()
            } else {
                print("D'oh")
            }
        }
    }
    
    func scheduleLocal() {
        registerCategories()
        
        let center = UNUserNotificationCenter.current()
        //reminderIntoTime()
        
        // not required, but useful for testing!
        center.removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        content.title = "Time to Remember what happened today!"
        content.body = "Remember just two things, the best part of your day and what could have been improved!  "
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = UNNotificationSound.default()
        
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // pull out the buried userInfo dictionary
        let userInfo = response.notification.request.content.userInfo
        
        if let customData = userInfo["customData"] as? String {
            print("Custom data received: \(customData)")
            
            switch response.actionIdentifier {
            case UNNotificationDefaultActionIdentifier:
                // the user swiped to unlock; do nothing
                print("Default identifier")
                
            case "show":
                print("Show more information…")
                break
                
            default:
                break
            }
        }
        
        // you need to call the completion handler when you're done
        completionHandler()
    }
    
    func registerCategories() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        let show = UNNotificationAction(identifier: "show", title: "Help me remember...", options: .foreground)
        let category = UNNotificationCategory(identifier: "alarm", actions: [show], intentIdentifiers: [])
        
        center.setNotificationCategories([category])
    }
    

}
