//
//  ViewController.swift
//  coreDataTempl
//
//  Created by Kamil Wójcik on 22.06.2016.
//  Copyright © 2016 Kamil Wójcik. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var studenci: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Studenci"
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = delegate.managedObjectContext
        
        let request = NSFetchRequest(entityName: "Studenci") //musi być taka sama nazwa jak entity
        
        do{
            studenci = try context.executeFetchRequest(request) as! [NSManagedObject]
        }catch{
            print("jakiś problem z załadowaniem danych")
        }
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func dodajBtn(sender: AnyObject) {
        let alert = UIAlertController(title: "Dodaj studenta", message: "Dodaj nowego studenta", preferredStyle: .Alert)
        
        let zapisz = UIAlertAction(title: "Zapisz", style: .Default) { (UIAlertAction) in
            let poleTekstowe = alert.textFields![0] as UITextField
            self.zapiszStudenta(poleTekstowe.text!)
            self.tableView.reloadData()
        }
        
        let anuluj = UIAlertAction(title: "Anuluj", style: .Default) { (UIAlertAction) in

        }
        
        alert.addTextFieldWithConfigurationHandler { (UITextField) in
        }
        
        alert.addAction(zapisz)
        alert.addAction(anuluj)
        
        presentViewController(alert, animated: true, completion: nil)
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studenci.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        let student = studenci[indexPath.row]
        cell.textLabel?.text = student.valueForKey("imie") as! String
        
        return cell
    }
    
    func zapiszStudenta(imie: String){
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = delegate.managedObjectContext
        
        let student = NSEntityDescription.insertNewObjectForEntityForName("Studenci", inManagedObjectContext: context)
        student.setValue(imie, forKey: "imie") //pobieramy z parametru funkcji i zapisujemy
        
        do{
            try context.save()
        }catch{
            print("jakiś problem z zapisywaniem danych")
        }
        
    }
    
}

