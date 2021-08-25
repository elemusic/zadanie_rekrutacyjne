//
//  CatBrain.swift
//  Generator Kotów
//
//  Created by Mateusz Dębski on 19/08/2021.
//

import Foundation
import UIKit

class CatBrain {
    
    var opis : String?
    var wielkośćCzcionki : String? = "20"
    var color : String?
    var tag : String?
    var filter : String?
    var opisBezSpacji : String?
    var tagBezSpacji : String?
    
    var finalOpis : String = ""
    var fontSize : String = ""
    var finalColor : String = ""
    var finalTag : String = ""
    var fFilter : String = ""
    var questionMark : String = ""
    var switchIsOn : Bool = false
    var cat : UIImage? = nil
    
    let URL = "https://cataas.com/cat"
    
    func generateURL() {
        
        if opis != nil {
            opisBezSpacji = opis!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            finalOpis = String("/says/" + opisBezSpacji!)
        }
        
        if wielkośćCzcionki != "20" {
            fontSize = String("s=" + wielkośćCzcionki! + "&")
        }
        
        if color != nil {
            finalColor = String("c=" + color! + "&")
        }
        
        if tag != nil {
            if tag == "Losowy" {
                finalTag = ""
            } else {
                tagBezSpacji = tag!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                finalTag = String("/" + tagBezSpacji!)
            }
            
        }
        if filter != nil {
            if filter == "brak" {
                fFilter = "" } else {
                    fFilter = String("filter=" + filter! + "&")
                }
        }
        
        // dodać dodatkowy warunek, jeżeli filtr lub tekst jest obecny, to dodaj znak zapytania. Jeżeli nie, bez znaku zapytania
        if fFilter != "" || finalColor != "" || finalColor != "" || fontSize != "" {
            questionMark = "?"
        }
        
        if switchIsOn {
            let finalURL = String(URL+finalTag+finalOpis+questionMark+fFilter+finalColor+fontSize)
            print(finalURL)
            fetchCat(urlString: finalURL)
        } else {
            let finalURL = String(URL+finalTag+questionMark+fFilter)
            print(finalURL)
            fetchCat(urlString: finalURL)
        }
        
    }
    
    
    
    func fetchCat(urlString: String) {
        var image: UIImage?
        cat = nil // reset obrazka, żeby pokazanie błędu działało
        let url = NSURL(string: urlString)! as URL
        if let imageData: NSData = NSData(contentsOf: url) {
            image = UIImage(data: imageData as Data)
            cat = image! }
        else {
            print("Nie ma kota")
        }
        
    }
    
}
