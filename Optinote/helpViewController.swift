//
//  helpViewController.swift
//  Optinote
//
//  Created by Christopher Fiegel on 7/6/17.
//  Copyright © 2017 Optimi. All rights reserved.
//

import UIKit

class helpViewController: UIViewController {
    @IBAction func hideView(_ sender: Any) {
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
