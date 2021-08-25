//
//  ViewController.swift
//  Generator Kotów
//
//  Created by Mateusz Dębski on 18/08/2021.
//

import UIKit
import DropDown


class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var tag: UILabel!
    @IBOutlet weak var lista: UIView!
    @IBOutlet weak var filters: UILabel!
    @IBOutlet weak var catView: UIImageView!
    let dropDown1 = DropDown() //lista rozwijana 1
    let dropDown2 = DropDown() // lista rozwiajana 2
    let catBrain = CatBrain()
    var possibleTags = [String]()
    let possibleFilters = ["brak", "blur", "mono", "sepia", "negative", "paint", "pixel"]
    var opis : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // na początek losowy kotek
        var image: UIImage?
        let urlString = "https://cataas.com/cat"
        let url = NSURL(string: urlString)! as URL
        if let imageData: NSData = NSData(contentsOf: url) {
            image = UIImage(data: imageData as Data)
            catView.image = image
        } else {
            showError()
        }
        
        
        // Do any additional setup after loading the view.
        func fetchTags() {
            let tagsURL = "https://cataas.com/api/tags"
            if let tags = Foundation.URL(string : tagsURL) {
                
                let session = Foundation.URLSession(configuration: .default)
                let task = session.dataTask(with: tags, completionHandler: handle(data:response:error:))
                
                task.resume()
            }
        }
        func handle(data:Data?, response:URLResponse?, error: Error?) {
            
            if error != nil {
                print(error!)
                return
            }
            if let safeData = data {
                parse(dataJSON: safeData)
            }
            
        }
        func parse(dataJSON: Data) {
            do {
                let catArray: CatArray = try .init(tag: JSONDecoder().decode([String].self, from: dataJSON))
                print(catArray.tag)
                pickRandomTags(array: catArray.tag, numbers: catArray.tag.count)
            } catch {
                print(error)
            }
            
        }
        func pickRandomTags(array: [String], numbers: Int)  {
            let numberOfTags = 7 //ile tagów ma się pokazać
            var randomNumbers = [Int]()
            possibleTags.removeAll()
            possibleTags.append("Losowy")
            
            for _ in 0...numberOfTags {
                randomNumbers.append(Int.random(in: 0...numbers))
            }
            
            for index in 0...numberOfTags {
                possibleTags.append(array[randomNumbers[index]])
            }
            print(possibleTags)
            updateDropDown()
            
        }
        
        
        fetchTags()
        
        
        tag.layer.borderWidth = 1.0
        filters.layer.borderWidth = 1.0
        
        func updateDropDown() {
            dropDown1.anchorView = tag
            dropDown1.dataSource = possibleTags
            
            dropDown2.anchorView = filters
            dropDown2.dataSource = possibleFilters
        }
        
        dropDown1.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            tag.text = possibleTags[index]
            catBrain.tag = possibleTags[index]
        }
        
        dropDown2.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            filters.text = possibleFilters[index]
            catBrain.filter = possibleFilters[index]
        }
        
        textBox.delegate = self
    }
    // funkcjonalność textboxa i przekazanie wartości do zmiennej
    func textFieldShouldReturn (_ textField: UITextField) -> Bool {
        opis = textBox.text
        textBox.endEditing(true)
        catBrain.opis = opis
        print(opis ?? "default")
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textBox.text != "" {
            if textBox.text!.contains("?") || ((textBox.text!.contains("/")) ) {
                let alertController = UIAlertController(title: "Niewłaściwe znaki w opisie", message:
                                                            "Proszę usuń znak '?' oraz znak '/' z opisu", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Okej", style: .default))
                
                self.present(alertController, animated: true, completion: nil)
                return false
            }
            opis = textBox.text
            catBrain.opis = opis
            print("shouldendediting działa")
            return true }
        else {
            let alertController = UIAlertController(title: "Ojej", message:
                                                        "Chcesz dodać opis, ale nic nie jest wpisane :)", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Już się poprawiam", style: .default))
            
            self.present(alertController, animated: true, completion: nil)
            return false
        }
    }
    
    @IBAction func filtersPressed(_ sender: UIButton) {
        dropDown2.show()
    }
    
    @IBAction func tagPressed(_ sender: UIButton) {
        dropDown1.show()
    }
    
    
    // regulacja Switcha i pojawianie się dodatkowych opcji
    
    @IBOutlet weak var fontSlider: UISlider!
    @IBOutlet weak var fontLabel: UILabel!
    @IBOutlet weak var fontValue: UILabel!
    @IBOutlet weak var textBox: UITextField!
    @IBOutlet weak var colorOptions: UISegmentedControl!
    @IBOutlet weak var textSwitch: UISwitch!
    @IBAction func switchClicked(_ sender: UISwitch) {
        
        if textSwitch.isOn {
            fontSlider.isHidden = false
            fontLabel.isHidden = false
            fontValue.isHidden = false
            textBox.isHidden = false
            colorOptions.isHidden = false
            catBrain.switchIsOn = true
        }
        else {
            fontSlider.isHidden = true
            fontLabel.isHidden = true
            fontValue.isHidden = true
            textBox.isHidden = true
            colorOptions.isHidden = true
            catBrain.switchIsOn = false
        }
    }
    // aktualizowanie wielkości czcionki
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        fontValue.text = String(format: "%.0f" , sender.value)
        catBrain.wielkośćCzcionki = String(format: "%.0f" , sender.value)
        print(catBrain.wielkośćCzcionki!)
    }
    
    //funkcjonalność opcji koloru i przekazywanie informacji do klasy
    @IBAction func colorChanged(_ sender: UISegmentedControl) {
        let color = colorOptions.titleForSegment(at: colorOptions.selectedSegmentIndex)
        
        switch color {
        case "Biały":
            catBrain.color = "white"
        case "Czarny":
            catBrain.color = "black"
        case "Niebieski":
            catBrain.color = "blue"
        case "Pomarańczowy":
            catBrain.color = "orange"
        default:
            catBrain.color = "white"
        }
        print(catBrain.color!)
    }
    
    // proszę działaj
    
    @IBOutlet weak var catButton: UIButton!
    @IBAction func fetchCatPressed(_ sender: UIButton) {
        if textBox.text != nil {
            if textSwitch.isOn {
                if textBox.endEditing(false) {
                    catButton.isEnabled = false
                    catBrain.generateURL()
                    if catBrain.cat != nil {
                        catView.image = catBrain.cat
                    } else {
                        showError()
                    }
                    catButton.isEnabled = true
                }
            } else {
                catButton.isEnabled = false
                catBrain.generateURL()
                if catBrain.cat != nil {
                    catView.image = catBrain.cat
                } else {
                    showError()
                }
                catButton.isEnabled = true
            }
            
        }
    }
    func showError() {
        let alertController = UIAlertController(title: "Ups...", message:
                                                    "Wystąpił błąd. Czy na pewno masz połączenie z koternetem?", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Miau", style: .default))
        DispatchQueue.main.async {
            self.getTopMostViewController()?.present(alertController, animated: true, completion: nil)
        }
    }
    func getTopMostViewController() -> UIViewController? {
        var topMostViewController = UIApplication.shared.keyWindow?.rootViewController
        
        while let presentedViewController = topMostViewController?.presentedViewController {
            topMostViewController = presentedViewController
        }
        
        return topMostViewController
    }
}
