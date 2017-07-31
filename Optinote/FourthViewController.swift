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

var theQuote = ""
var theDelete = ""


class FourthViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var testingResults: UITextView!
    var rowNum = 1
    var dataOutput = [String]() //the array of strings for the quote
    var dateOutput = [String]()
    var qualification = [String]()
    
    @IBOutlet weak var historic: UITableView!
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return(dataOutput.count)
    }
    
    //including deleting rules
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            theDelete = "delete from history where Thought = '\(dataOutput[indexPath.row])'"
            print(theDelete)
            confirmDelete()
            //removeRow()
            
        }
    }
    
    func confirmDelete() {
        let alert = UIAlertController(title: "Delete historic post", message: "Are you sure you want to remove this post?", preferredStyle: .actionSheet)
        
        let DeleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: handleDeletePost)
        let CancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: cancelDeletePost)
        
        alert.addAction(DeleteAction)
        alert.addAction(CancelAction)
        
        // Support display in iPad

        
        self.present(alert, animated: true, completion: nil)
    }
    
    func handleDeletePost(alertAction: UIAlertAction!) -> Void {
        removeRow()
        self.historic.reloadData()
    }
    
    func cancelDeletePost(alertAction: UIAlertAction!) {
        print("Cancle clicked")
        self.viewDidLoad()
        self.historic.reloadData()

    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "journal", for: indexPath) as! JournalTableViewCell
        //print("made it into the table creation")
        cell.layer.backgroundColor = UIColor.clear.cgColor
        var description = ""
        
        if (qualification[indexPath.row] == "Bad"){
            description = "Needed Improvment"
        }
        else{
            description = "Went Well"
        }
        
        cell.journalData.text = dataOutput[indexPath.row]
        cell.journalDate.text = dateOutput[indexPath.row] + " - \(description)"
        
        return cell 
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        
        print("Row: \(row) and date:  \(dateOutput[indexPath.row]) and quote: \(dataOutput[indexPath.row])")
        
        theQuote = dataOutput[indexPath.row]
        print(theQuote)
        performSegue(withIdentifier: "details", sender: self)
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        createTable()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //table creation from the DB
    func createTable(){
        do {
            
            print("in the do")

            let path = NSSearchPathForDirectoriesInDomains(
                .documentDirectory, .userDomainMask, true
                ).first!
            
            //let db = try Connection(path)
            let db = try Connection("\(path)/db.sqlite3")
            
            let num = try (db.scalar("SELECT count(*) FROM history") as? Int64 )
            rowNum = Int(truncatingBitPattern: num!)
            print(rowNum)
            
            //print("Total number is here:")
            //print(num ?? 0)
            
            for row in try db.prepare("select * from history;") {
                print("Quote: \(String(describing: row[1]))")
                //gathering said data out of DB
                //let authorStringDB = row[1] as! String
                let quoteStringDB = row[0] as! String
                let userQuoteDB = row[2] as! String
                let qualificationDB = row[1] as! String
                self.dataOutput.append(userQuoteDB)
                self.dateOutput.append(quoteStringDB)
                self.qualification.append(qualificationDB)
                
                
                //print(authorStringDB)
                print(quoteStringDB)
                //testingResults.text = "hello" + authorStringDB + quoteStringDB
                
            }
            
            
        }
        catch{
            print("Error : \(error)")
        }
        
        
    }
    
    func removeRow(){
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
                let sql1 = theDelete
                
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
