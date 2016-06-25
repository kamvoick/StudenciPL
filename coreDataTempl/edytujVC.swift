//
//  edytujVC.swift
//  coreDataTempl
//
//  Created by Kamil Wójcik on 22.06.2016.
//  Copyright © 2016 Kamil Wójcik. All rights reserved.
//

import UIKit
import CoreData

class edytujVC: UIViewController {

    @IBOutlet weak var poleTekst: UITextField!
    @IBOutlet weak var edytujBtn: UIButton!
    @IBOutlet weak var anulujBtn: UIButton!
    @IBOutlet weak var okButton: UIButton!
    
    var studenci: [Studenci] = []
    var context: NSManagedObjectContext!
    var index: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        załadujDane()
        poleTekst.enabled = false
        poleTekst.text = studenci[index!].imie
        
    }
    
    func załadujDane(){
        let request = NSFetchRequest(entityName: "Studenci")
        studenci = try! context.executeFetchRequest(request) as! [Studenci]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func edytujBtn(sender: AnyObject) {
        okButton.hidden = false
        anulujBtn.hidden = false
        edytujBtn.hidden = true
        poleTekst.enabled = true
    }

    @IBAction func anulujBtn(sender: AnyObject) {
        poleTekst.enabled = false
        edytujBtn.hidden = false
        anulujBtn.hidden = true
        okButton.hidden = true
    }
    
    @IBAction func okBtn(sender: AnyObject) {
        
        studenci[index!].imie = poleTekst.text
        try! context.save() //zapisywanie 
        
        
        poleTekst.enabled = false
        edytujBtn.hidden = false
        anulujBtn.hidden = true
        okButton.hidden = true
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
