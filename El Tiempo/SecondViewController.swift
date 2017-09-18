//
//  SecondViewController.swift
//  El Tiempo
//
//  Created by Miguel Ibáñez Paricio on 2/9/15.
//  Copyright (c) 2015 Miguel Ibáñez Paricio. All rights reserved.
//

import UIKit
var ciudad: String!

var arrayfechas = [String]()
var arraytemperaturas = [String]()
var arrayiconos = [String]()

class SecondViewController: UIViewController,UITableViewDelegate {

    @IBOutlet weak var listaPrevision: UITableView!
   
    @IBOutlet weak var labelCiudad: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        listaPrevision.sizeToFit()
    }

    
    override func viewWillAppear(animated: Bool) {
        ciudad =  NSUserDefaults.standardUserDefaults().objectForKey("ciudad") as? String
        labelCiudad.text = ciudad
        obtenerPrediccionMeteo()
    }
    
    
    
    func obtenerPrediccionMeteo()
    {
        let url = NSURL(string:"http://api.openweathermap.org/data/2.5/forecast/daily?q=\(ciudad)&units=metric&cnt=6")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
            print("tarea finalizada")
            if error != nil
            {
                print("error")
                print(error!.localizedDescription)
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), {
                    self.extraerDatos(data!)
                })
            }
        })
        
        
        task.resume()
    }

    func extraerDatos(datos:NSData)
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        arrayiconos.removeAll(keepCapacity: false)
        arraytemperaturas.removeAll(keepCapacity: false)
        arrayfechas.removeAll(keepCapacity: false)
        var strMax:String = ""
        var strMin:String = ""
        var errorJSON:NSError?
        let jsonArray = (try! NSJSONSerialization.JSONObjectWithData(datos, options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
        if let arraypredicciones = jsonArray["list"] as? NSArray
        {
            print(arraypredicciones)
            for prediccion in arraypredicciones
            {
                if let temperaturas = prediccion["temp"] as? NSDictionary
                {
                    if let max = temperaturas["max"] as? Double
                    {
                        strMax = String(format: "%.0fºC", max)
                    }
                    
                    if let min = temperaturas["min"] as? Double
                    {
                        strMin = String(format: "%.0fºC", min)
                    }
                    
                    arraytemperaturas.append(strMin+"/"+strMax)
                }
                
                if let weather = prediccion["weather"] as? NSArray
                {
                    if let icon = weather[0]["icon"] as? String
                    {
                        arrayiconos.append(icon)
                    }
                }
                
                if let timestamp = prediccion["dt"] as? Double
                {
                    let date = NSDate(timeIntervalSince1970:timestamp)
                    arrayfechas.append(dateFormatter.stringFromDate(date))
                }
                
                
            }
            
        }
        listaPrevision.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 6
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let celda:Celda = tableView.dequeueReusableCellWithIdentifier("Celda") as! Celda
 
       celda.labelFecha.text = "Hola"
        if !arraytemperaturas.isEmpty
        {
            celda.labelTemp.text = arraytemperaturas[indexPath.row]
            celda.imgIcon.downloadImage("http://openweathermap.org/img/w/\(arrayiconos[indexPath.row]).png")
            celda.labelFecha.text = arrayfechas[indexPath.row]
            
        }
        
        
        return celda
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

}

