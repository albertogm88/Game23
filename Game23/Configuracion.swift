//
//  Configuracion.swift
//  Game23
//
//  Created by Alberto Garcia Mendez on 1/4/16.
//  Copyright © 2016 Alberto Garcia Mendez. All rights reserved.
//

import UIKit
import CoreData

class Configuracion: UIViewController {
    var empieza = 0
    @IBOutlet var objetivo: UITextField!
    @IBOutlet var primerTurno: UISegmentedControl!
    @IBAction func elegirTurno(sender: AnyObject) {
        empieza = primerTurno.selectedSegmentIndex
    }
    
    @IBAction func comenzar(sender: AnyObject) {
        
        var empiezaJug = false
        let numObjetivo = objetivo.text
        
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let entity =  NSEntityDescription.entityForName("Parametros", inManagedObjectContext:managedContext)
        
        let param = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        let numObjetivoInt = Int(numObjetivo!)
        param.setValue(numObjetivoInt, forKey: "numObjetivo")
        if(empieza == 0){
            empiezaJug=true
        }
        param.setValue(empiezaJug, forKey: "empiezaJug")
        
        do {
            try managedContext.save()
        } catch let error as NSError  {
            print("No se ha podido salvar \(error), \(error.userInfo)")
        }

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        deleteData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func deleteData() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext

        let fetchRequest = NSFetchRequest(entityName: "Parametros")
        fetchRequest.includesPropertyValues = false
        
        do{
            let fetchResults = try context.executeFetchRequest(fetchRequest) as? [NSManagedObject]
            if (fetchResults != nil) {
            
                for result in fetchResults! {
                    context.deleteObject(result)
                }
            
            }
        } catch let error as NSError  {
            print("Error borrando \(error), \(error.userInfo)")
        }
    }


}
