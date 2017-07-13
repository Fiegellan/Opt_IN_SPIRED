//
//  DayDetailsViewController.swift
//  Optinote
//
//  Created by Christopher Fiegel on 7/9/17.
//  Copyright © 2017 Optimi. All rights reserved.
//

import UIKit

class DayDetailsViewController: UIViewController {
    @IBOutlet weak var detailsDisplayText: UITextView!
    @IBAction func backToView(_ sender: Any) {
        self.dismiss(animated: true, completion: {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PersonalHistory")
            self.present(vc!, animated: true, completion: nil)
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        detailsDisplayText.text = theQuote

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
