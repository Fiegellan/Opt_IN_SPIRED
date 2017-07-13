//
//  SecondViewController.swift
//  Optinote
//
//  Created by Christopher Fiegel on 5/28/17.
//  Copyright © 2017 Optimi. All rights reserved.
//

import UIKit
import SQLite 
import MessageUI

class SecondViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate {

    let settings = ["Set Reminder Time","Support - Message OPTIMI","Optimi - HQ","Help - Whats this app do","Data and Storage - On my device"]
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return(settings.count)
    }
 
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settings", for: indexPath) as! SetTableViewCell
        
        cell.layer.backgroundColor = UIColor.clear.cgColor
        
        cell.Output.text = settings[indexPath.row]
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let row = indexPath.row
        let url = URL(string: "http://getoptimi.com")!
        let alert = UIAlertController(title: "Remove all stored Data", message: "Are you sure you want to delete all your data from your device?", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Remove All Data", style: .default) { action in
            self.removeStorage()
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .default) { action in
        })
        
        print("Row: \(row)")
        
        if(row == 3){
        performSegue(withIdentifier: "segue", sender: self)
        }

        else if(row == 2){
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                //If you want handle the completion block than
                UIApplication.shared.open(url, options: [:], completionHandler: { (success) in
                    print("Open url : \(success)")
                })
            }
        }
        else if( row == 4){
            self.present(alert, animated: true)
            //removeStorage()
        }
        else if(row == 1){
            if !MFMailComposeViewController.canSendMail() {
                print("Mail services are not available")
                return
            }
            sendEmail()
        }
        else if(row == 0){
            //print("fuck you!")
            performSegue(withIdentifier: "showTheTime", sender: self)
            
        }
        else{
            print("no segue")
        }

        
    }
    
    func sendEmail() {
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        // Configure the fields of the interface.
        composeVC.setToRecipients(["admin@getoptimi.com"])
        composeVC.setSubject("Issues with Opt-in-Spired")
        composeVC.setMessageBody("Hello - I'm facing the following issues: ", isHTML: false)
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

    
    
    
    func removeStorage(){
        do {
            
            //let databaseFileName = "optiNoteDB.db"
            //let databaseFilePath = "/Users/christopherfiegel/Desktop/ios/Optimi/OptiNote/OptiNote/OptiNote/\(databaseFileName)"
            //let db = try Connection(databaseFilePath)
            
            //let path = Bundle.main.path(forResource: "db", ofType: "sqlite3")!
            let path = NSSearchPathForDirectoriesInDomains(
                .documentDirectory, .userDomainMask, true
                ).first!
            
            //let db = try Connection(path)
            let db = try Connection("\(path)/db.sqlite3")
            
            
            do {
                let sql1 = "delete from history"
                
                try db.run(sql1)
            } catch let err as NSError
            {
                print("error \(err)")
            }
        }
        catch{
            print("Error : \(error)")
        }
    }

    override func viewDidLoad() {
        print("in setting")
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

