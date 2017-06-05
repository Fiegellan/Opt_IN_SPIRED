//
//  ThirdViewController.swift
//  Optinote
//
//  Created by Christopher Fiegel on 5/28/17.
//  Copyright © 2017 Optimi. All rights reserved.
//

import UIKit
import SQLite

//query creation required here

var sadThoughtString = ""
var happyThoughtString = ""
var query1 = ""
class ThirdViewController: UIViewController {
    
  

    @IBOutlet weak var sadThoughts: UITextView!
    @IBOutlet weak var happyThoughts: UITextView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("in the third view")
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func next(_ sender: UIButton) {
        //print("in the Button")
        sadThoughtString = sadThoughts.text
        //print(sadThoughtString)
        query1 = "INSERT INTO history (Date, Category, Thought) VALUES (datetime(), 'Bad', '\(sadThoughtString)');"
        insertInto()
    }

    @IBAction func submitValues(_ sender: UIButton) {
        //print("submit full values")
        happyThoughtString = happyThoughts.text
        query1 = "INSERT INTO history (Date, Category, Thought) VALUES (datetime(), 'Good', '\(happyThoughtString)');"
        insertInto()
        
        //print("BLESSED i'm in the final submit")
        //print(query1)
        //print(query2)
        //add the insert into table script here
    }

    func insertInto(){
        do {
            
            print("in the do")
            let databaseFileName = "optiNoteDB.db"
            let databaseFilePath = "/Users/christopherfiegel/Desktop/ios/Optimi/OptiNote/OptiNote/OptiNote/\(databaseFileName)"
            let db = try Connection(databaseFilePath)
            
            
            do {
                let sql1 = query1
                print("IM IN THE DO QUERY NOW!!! the insert is now going to be: " + sql1)
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
    
    
}

        
    
    
    

