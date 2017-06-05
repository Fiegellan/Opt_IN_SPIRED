//
//  fourthViewController.swift
//  Optinote
//
//  Created by Christopher Fiegel on 5/30/17.
//  Copyright © 2017 Optimi. All rights reserved.
//

import Foundation
import UIKit
import SQLite

class FourthViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var testingResults: UITextView!
    var rowNum = 1

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("I'm Fourth controller hello!")
        createTable()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowNum // your number of cell here
    }
    
    func tableView(_ cellForRowAttableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // your cell coding
        
        let cell:UITableViewCell = UITableViewCell(style:UITableViewCellStyle.default, reuseIdentifier:"cell")
        cell.textLabel?.text = "Test"
        
        return cell
        
        
        
        //return UITableViewCell()
    }
    
    private func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
        // cell selected code here
    }
    
    func createTable(){
        do {
            
            print("in the do")
            let databaseFileName = "optiNoteDB.db"
            let databaseFilePath = "/Users/christopherfiegel/Desktop/ios/Optimi/OptiNote/OptiNote/OptiNote/\(databaseFileName)"
            let db = try Connection(databaseFilePath)
            
            let num = try (db.scalar("SELECT count(*) FROM history") as? Int64 )
            rowNum = Int(truncatingBitPattern: num!)
            
            
            //print("Total number is here:")
            //print(num ?? 0)
            
            for row in try db.prepare("select * from history;") {
                print("Quote: \(String(describing: row[1]))")
                //gathering said data out of DB
                let authorStringDB = row[1] as! String
                let quoteStringDB = row[0] as! String
                //print(authorStringDB)
                //print(quoteStringDB)
                testingResults.text = authorStringDB + quoteStringDB
                
            }
            
            
        }
        catch{
            print("Error : \(error)")
        }
        
        
    }

}
