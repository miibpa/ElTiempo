//
//  FirstViewController.swift
//  El Tiempo
//
//  Created by Miguel Ibáñez Paricio on 2/9/15.
//  Copyright (c) 2015 Miguel Ibáñez Paricio. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    @IBOutlet weak var imageGif: UIImageView!
    
    @IBOutlet weak var labelCiudad: UILabel!
    
    @IBOutlet weak var labelTemperatura: UILabel!
    
    @IBOutlet weak var textCiudad: UITextField!
    
    var count=1
    var timer:NSTimer = NSTimer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        vaciarLabels()
        obtenerPrediccionMeteo("http://api.openweathermap.org/data/2.5/weather?q=Alcoy,es&units=metric")
        imageGif.hidden=true
        
    }
    
    
    
    
    
    func obtenerPrediccionMeteo(urlString: String)
    {
        let url = NSURL(string: urlString)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
            print("tarea finalizada")
            if error != nil
            {
                print("error")
                print(error.localizedDescription)
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), {
                    self.rellenarLabels(data)
                })
            }
        })
        
        
        task.resume()
    }
    
    
    func actualizarIconowindy(){
        if count==30        {
            count=1
        }
        else
        {
            count++
        }
        imageGif.image = UIImage(named: "windy\(count).tiff")
    }
    
    func actualizarIconosunny(){
        if count==13
        {
            count=1
        }
        else
        {
            count++
        }
        imageGif.image = UIImage(named: "sunny\(count).tiff")
    }
    
    func actualizarIconorainy(){
        if count==10
        {
            count=1
        }
        else
        {
            count++
        }
        imageGif.image = UIImage(named: "rainy\(count).tiff")
    }
    
    func actualizarIconosnowy(){
        if count==10
        {
            count=1
        }
        else
        {
            count++
        }
        imageGif.image = UIImage(named: "snowy\(count).tiff")
    }



    
    func rellenarLabels(datos: NSData)
    {
        timer.invalidate()
        var errorJSON:NSError?
        
        let json = (try! NSJSONSerialization.JSONObjectWithData(datos, options: [])) as! NSDictionary
        
        
        if let nombreCiudad = json["name"] as? String
        {
            labelCiudad.text = nombreCiudad
            NSUserDefaults.standardUserDefaults().setObject(labelCiudad.text, forKey: "ciudad")
        }
        
        
        if let main = json["main"] as? NSDictionary
        {
            if let temperatura = main["temp"] as? Double
            {
                labelTemperatura.text = String(format: "%.1fºC", temperatura)
            }
        }
        if let weather = json["weather"] as? NSArray
        {
            if let icon = weather[0]["icon"] as? String
            {
                var gifselector: String
                var selector:Selector = Selector()
                switch icon
                {
                    case "01d", "02d", "01n", "02n":
                        self.view.backgroundColor = UIColorFromHex(0x36568F, alpha: 1)
                        selector = "actualizarIconosunny"
                    
                    case "04d", "09d", "10d", "11d", "04n", "09n", "10n", "11n":
                        self.view.backgroundColor = UIColorFromHex(0x4E5358, alpha: 1)
                        selector = "actualizarIconorainy"
                    
                    case "03d", "50d", "03n", "50n":
                        self.view.backgroundColor = UIColorFromHex(0x97A2AA, alpha: 1)
                        selector = "actualizarIconowindy"
                    case "50d", "50n":
                        self.view.backgroundColor = UIColorFromHex(0x355591, alpha: 1)
                        selector = "actualizarIconosnowy"
                    default:
                        self.view.backgroundColor = UIColorFromHex(0x355591, alpha: 1)
                        selector = "actualizarIconosnowy"

                    
                }
            
                
                timer = NSTimer.scheduledTimerWithTimeInterval(0.033, target: self, selector: selector, userInfo: nil, repeats: true)
                imageGif.hidden=false
                
            }
        }
        
    }

    
    //GESTION TECLADO
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textCiudad.resignFirstResponder()
        var nombreciudad = textCiudad.text.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())!
        print(nombreciudad)
        obtenerPrediccionMeteo("http://api.openweathermap.org/data/2.5/weather?q=\(nombreciudad),es&units=metric")
        
        
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }

    func vaciarLabels(){
        labelCiudad.text = "--"
        labelTemperatura.text = "--,-ºC"
    }
    
    
    
    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    


}

