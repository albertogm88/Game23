//
//  Negocio.swift
//  Game23
//
//  Created by Alberto Garcia Mendez on 31/3/16.
//  Copyright © 2016 Alberto Garcia Mendez. All rights reserved.
//

import UIKit
import CoreData

class Negocio: UIViewController {
    
    var sumaTotal = 0
    var turnos = 0
    var numObjetivo = 0
    var turnoJugador = false
    var empiezaJug = true
    var timer = NSTimer()
    
    @IBOutlet var btnNew: UIButton!
    @IBOutlet var btnReload: UIButton!
    
    //Declaración de los outlet botones y label
    
    @IBOutlet var btn1: UIButton!
    @IBOutlet var btn2: UIButton!
    @IBOutlet var btn3: UIButton!
    @IBOutlet var btn4: UIButton!
    
    @IBOutlet var lblSel1: UILabel!
    @IBOutlet var lblSel2: UILabel!
    @IBOutlet var lblSel3: UILabel!
    @IBOutlet var lblSel4: UILabel!

    @IBOutlet var labelSelec: UILabel!
    @IBOutlet var objetivo: UILabel!
    @IBOutlet var labelTotal: UILabel!
    @IBOutlet var labelResultado: UILabel!
    
    @IBAction func recargar(sender: AnyObject) {
        sumaTotal = 0
        turnos = 0
        repintarSelec()
        despintarJugadaMaquina()
        labelResultado.text = ""
        habilitarTodo()
    }
    
    @IBAction func button1(sender: AnyObject) {
        sumaTotal+=1
        lblSel1.text = "+1"
        negocioBoton()
        animarBoton(btn1.layer, bounce: 0.2, damp: 0.055)
    }
    
    @IBAction func button2(sender: AnyObject) {
        sumaTotal+=2
        lblSel2.text = "+2"
        negocioBoton()
    }
    
    @IBAction func button3(sender: AnyObject) {
        sumaTotal+=3
        lblSel3.text = "+3"
        negocioBoton()
    }
    
    @IBAction func button4(sender: AnyObject) {
        sumaTotal+=4
        lblSel4.text = "+4"
        negocioBoton()
    }
    
    func negocioBoton(){
        labelTotal.text = sumaTotal.description
        deshabilitarTodo()
        timer.invalidate()
        timer = NSTimer.scheduledTimerWithTimeInterval(0.7, target: self, selector: #selector(Negocio.repintarSelec), userInfo: nil, repeats: false)
        var timer2 = NSTimer()
        timer2.invalidate()
        timer2 = NSTimer.scheduledTimerWithTimeInterval(0.7, target: self, selector: #selector(Negocio.sumaMaquina), userInfo: nil, repeats: false)
    }
    
    func sumaMaquina() -> Int{
        var numMaquina = 0
        turnoJugador = true
        if(evaluarSuma()){
            turnos+=1
            var res = numObjetivo-((((numObjetivo/5)+1)-turnos)*5)
            if(sumaTotal>res){
                turnos+=1
                res = numObjetivo-((((numObjetivo/5)+1)-turnos)*5)
                numMaquina = res - sumaTotal
            }else{
                numMaquina = res - sumaTotal
            }
            if(numMaquina == 0 || numMaquina > 4){
                numMaquina += Int(arc4random_uniform(4)+1)
            }
        }
        turnoJugador = false
        labelSelec.text = "+"+numMaquina.description
        sumaTotal+=numMaquina
        var timer1 = NSTimer()
        timer1.invalidate()
        timer1 = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(Negocio.despintarJugadaMaquina), userInfo: nil, repeats: false)
        if(btn1.enabled){
            evaluarSuma()
        }
        return numMaquina
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Parametros")
        
        do{
            let params = try managedContext.executeFetchRequest(fetchRequest)
            let parametro = params[0] as! NSManagedObject
            numObjetivo = (parametro.valueForKey("numObjetivo")!.integerValue)!
            empiezaJug = parametro.valueForKey("empiezaJug")!.boolValue
            if(!empiezaJug){
                sumaMaquina()
            }
            if(numObjetivo==0){
                numObjetivo=23
            }
            objetivo.text = "\(String(numObjetivo))"
            
        } catch {
            let error1 = error as NSError
            print("No se puede cargar\(error1)")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func deshabilitarTodo(){
        btn1.enabled = false
        btn2.enabled = false
        btn3.enabled = false
        btn4.enabled = false
    }
    
    func habilitarTodo(){
        btn1.enabled = true
        btn2.enabled = true
        btn3.enabled = true
        btn4.enabled = true
    }

    
    func evaluarSuma() -> Bool{
        var continua = true
        var textoResultado = ""
        if(sumaTotal==numObjetivo){
            if(turnoJugador){
                textoResultado = "HAS GANADO"
                labelResultado.textColor = UIColor.greenColor()
            }else{
                textoResultado = "HAS PERDIDO"
                labelResultado.textColor = UIColor.redColor()
            }
            labelResultado.text = textoResultado
            deshabilitarTodo()
            continua=false
        }else if(sumaTotal>numObjetivo){
            if(turnoJugador){
                textoResultado = "HAS PERDIDO"
                labelResultado.textColor = UIColor.redColor()
            }else{
                textoResultado = "HAS GANADO"
                labelResultado.textColor = UIColor.greenColor()
            }
            labelResultado.text = textoResultado
            deshabilitarTodo()
            continua=false
        }
        return continua
    }
    
    func repintarSelec(){
        habilitarTodo()
        lblSel1.text = ""
        lblSel2.text = ""
        lblSel3.text = ""
        lblSel4.text = ""
    }

    func despintarJugadaMaquina(){
        labelTotal.text = sumaTotal.description
        labelSelec.text = ""
    }
    
    func animarBoton(aLayer: CALayer, bounce: CGFloat, damp: CGFloat){
        // TESTED WITH BOUNCE = 0.2, DAMP = 0.055
        let animation:CABasicAnimation = CABasicAnimation(keyPath:"transform.scale")
        
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.duration = 1;
            
        let steps = 100;
        let values = NSMutableArray.init(capacity: steps)
        var value:Double = 0;
        let e:Float = 2.71;
        for t in 1..<100 {
            value = pow(Double(e), -Double(damp)*Double(t)) * sin(Double(bounce)*Double(t)) + 1;
            values.addObject(value)
        }
        animation.byValue = values;
        aLayer.addAnimation(animation, forKey: "appear")
    }
    
}