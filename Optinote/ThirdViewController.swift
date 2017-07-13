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
var query2 = ""
class ThirdViewController: UIViewController, UITextViewDelegate   {
    
    @IBAction func backToEnter(_ sender: Any) {
        self.dismiss(animated: true, completion: {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "composeThoughts")
            self.present(vc!, animated: true, completion: nil)
            sadThoughtString = ""
        })
    }
  

    @IBOutlet weak var sadThoughts: UITextView!
    @IBOutlet weak var happyThoughts: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.sadThoughts.delegate = self
        //self.happyThoughts.delegate = self
        print("in the third view")
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
        
    }
    
   
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func next(_ sender: UIButton) {
        //print("in the Button")
        sadThoughtString = sadThoughts.text
        print(sadThoughtString)
        query1 = "INSERT INTO history (Date, Category, Thought) VALUES (DATE('now','localtime'), 'Bad', '\(sadThoughtString)');"
        //insertInto()
    }

    @IBAction func submitValues(_ sender: UIButton) {
        //print("submit full values")
        happyThoughtString = happyThoughts.text
        query2 = "INSERT INTO history (Date, Category, Thought) VALUES (DATE('now','localtime'), 'Good', '\(happyThoughtString)');"
        insertInto()
        
    }

    func insertInto(){
        do {
            let path = NSSearchPathForDirectoriesInDomains(
                .documentDirectory, .userDomainMask, true
                ).first!
            
            let db = try Connection("\(path)/db.sqlite3")

            do{
                let history = Table("history")
                let Date = Expression<Date>("Date")
                let Category = Expression<String>("Category")
                let Thought = Expression<String?>("Thought")
                try db.run(history.create(ifNotExists: true){(t) in t.column(Date); t.column(Category); t.column(Thought); t.primaryKey(Date, Category)})
                
            }
            
        
            do {
                //let sql2 = "CREATE TABLE history(Date DATE, Category Text, Thought Text, constraint new_key primary key (Date, Category));"
                //try db.run(sql2)
                
                
                let sql1 = query1
                let sql2 = query2

                try db.run(sql1)
                try db.run(sql2)
            } catch
            {
                print("insert error \(error)")
            }
        }
        catch{
            print("total error : \(error)")
        }
    }
    
    
}

        
    
    
    

