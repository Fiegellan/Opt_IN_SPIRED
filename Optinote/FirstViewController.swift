//
//  FirstViewController.swift
//  Optinote
//
//  Created by Christopher Fiegel on 5/28/17.
//  Copyright © 2017 Optimi. All rights reserved.
//

import UIKit
import SQLite

class FirstViewController: UIViewController {
    @IBOutlet weak var authorField: UILabel!
    
    @IBOutlet weak var quoteField: UITextView!
    
    
   

    


    override func viewDidLoad() {
        super.viewDidLoad()
        print("I'm first controller hello!")
        myCodeSqlite()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func myCodeSqlite(){
        do {
            
            print("in the do")
            //let date = Date()
            //let calendar = Calendar.current
            
            //let year = calendar.component(.year, from: date)
            //let month = calendar.component(.month, from: date)
            //let day = calendar.component(.day, from: date)
            
            let databaseFileName = "optiNoteDB.db"
            let databaseFilePath = "/Users/christopherfiegel/Desktop/ios/Optimi/OptiNote/OptiNote/OptiNote/\(databaseFileName)"
            let db = try Connection(databaseFilePath)
            
            
            for row in try db.prepare("select * from quotes ORDER BY RANDOM() LIMIT 1;") {
                print("Quote: \(String(describing: row[1]))")
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
}

