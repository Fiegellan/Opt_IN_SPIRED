//
//  FirstViewController.swift
//  Optinote
//
//  Created by Christopher Fiegel on 5/28/17.
//  Copyright © 2017 Optimi. All rights reserved.
//

import UIKit
import SQLite
import UserNotifications
import MessageUI


var queryTime = ""
var hour = 00
var minute = 12

class FirstViewController: UIViewController, UNUserNotificationCenterDelegate, MFMailComposeViewControllerDelegate {
    @IBOutlet weak var authorField: UILabel!
    
    @IBOutlet weak var quoteField: UITextView!


    override func viewDidLoad() {
        super.viewDidLoad()
        print("I'm first controller hello!")
        myCodeSqlite()
        registerLocal()
        scheduleLocal()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
        reminderIntoTime()
        
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
    
    
    func myCodeSqlite(){
        do {
            
            print("in the do")
            let path = Bundle.main.path(forResource: "optiNoteDB", ofType: "db")!

            let db = try Connection(path, readonly: false)
            //print(db)
            
            for row in try db.prepare("select * from quotes ORDER BY RANDOM() LIMIT 1;") {
                //print("Quote: \(String(describing: row[1]))")
                //gathering said data out of DB
                let authorStringDB = row[1] as! String
                let quoteStringDB = row[0] as! String

                //displaying on the UI controller
                authorField.text = "-  " + authorStringDB + "  -"
                quoteField.text = quoteStringDB
            }
            
        }
        catch{
            print("Error : \(error)")
        }


    }
    //mail functions:
    @IBAction func FeedBack(_ sender: Any) {
        if !MFMailComposeViewController.canSendMail() {
            print("Mail services are not available")
            return
        }
        sendEmail()
    }
    
    func sendEmail() {
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        // Configure the fields of the interface.
        composeVC.setToRecipients(["admin@getoptimi.com"])
        composeVC.setSubject("Feedback for Opti-IN-SPIRED")
        composeVC.setMessageBody("Hello - I'm digging your app but have the following suggestions: ", isHTML: false)
        // Present the view controller modally.
        self.present(composeVC, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        switch result {
        case .cancelled:
            break
        case .saved:
            break
        case .sent:
            break
        case .failed:
            break
            
        }
        
        controller.dismiss(animated: true, completion: nil)
    }
    //connect to the db for the reminder time, and create the table and insert the time as 8 pm
    
    func reminderIntoTime(){
        do {
            //open the database
            let path = NSSearchPathForDirectoriesInDomains(
                .documentDirectory, .userDomainMask, true
                ).first!
            
            let db = try Connection("\(path)/db.sqlite3")
            
            //create the table if exists
            do{
                let reminder = Table("reminder")
                let ID = Expression<String>("ID")
                let hourDB = Expression<String>("hour")
                let minuteDB = Expression<String?>("minute")
                try db.run(reminder.create(ifNotExists: true){(t) in t.column(ID, primaryKey: true); t.column(hourDB); t.column(minuteDB);})
                
            }
            
            //insert the time for 9 o'clock reminder
            do {
                
                query1 = "INSERT INTO reminder (ID, hour, minute) VALUES (1, '21', '00');"
                let sql1 = query1
                
                try db.run(sql1)
            } catch
            {
                print("insert error \(error)")
            }
            
            //remove the most recent time and reset the hour/minute per the DB
            for row in try db.prepare("Select * from Reminder where ID = 1;") {
                //print("Quote: \(String(describing: row[1]))")
                //gathering said data out of DB
                let hours = row[1] as! String
                let minutes = row[2] as! String
                hour = Int(hours)!
                minute = Int(minutes)!
                
                print("hour is: \(hour) and minute is: \(minute)")

            }
            
        }
        catch{
            print("total error : \(error)")
        }
    }
}

