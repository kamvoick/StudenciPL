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
    
    var studenci: [Studenci] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Studenci"
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = delegate.managedObjectContext
        
        let request = NSFetchRequest(entityName: "Studenci") //musi być taka sama nazwa jak entity
        
        do{
            try studenci = context.executeFetchRequest(request) as! [Studenci]
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
    
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.Delete{
              let student = studenci[indexPath.row]
            studenci.removeAtIndex(indexPath.row)
            let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let context = delegate.managedObjectContext
            context.deleteObject(student)
            
            try! context.save()
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("data", sender: nil)
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studenci.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        cell.textLabel?.text = studenci[indexPath.row].imie
        
        return cell
    }
    
    func zapiszStudenta(imie: String){
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = delegate.managedObjectContext
        
        let student = NSEntityDescription.insertNewObjectForEntityForName("Studenci", inManagedObjectContext: context) as! Studenci
        student.imie = imie //pobieramy z parametru funkcji i zapisujemy
        
        do{    
            try context.save()
        }catch{
            print("jakiś problem z zapisywaniem danych")
        }
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "data"{
            let path = tableView.indexPathForSelectedRow
            let destination = segue.destinationViewController as! edytujVC
            
            let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let context = delegate.managedObjectContext
            
            destination.context = context
            destination.index = path?.row //wszystko przesyłamy do edytujVC
    }
    
}
}

