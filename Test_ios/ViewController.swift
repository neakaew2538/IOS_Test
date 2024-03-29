//
//  ViewController.swift
//  Test_ios
//
//  Created by udom on 20/6/2562 BE.
//  Copyright © 2562 udom Neakaew. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class ViewController: UIViewController {

    @IBOutlet var emailTextFiled: UITextField!
    @IBOutlet var checkBox: UIButton!
    
    var selectDataTnc: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func register(email: String, uuid: String, data: String, tnc: Bool) {
        if let  Url = URL(string: "https://staging.hellogold.com/api/v3/users/register.json") {
            Alamofire.request(Url,
                              method: .post,
                              parameters: [
                                "email": email,
                                "uuid": uuid,
                                "data": data,
                                "tnc": tnc
                ]).responseJSON { (response) in
                    switch response.result {
                    case .success(let value): // Success is clearText and Show Alert
                        print(value)
                        self.clearText()
                        self.checkBox.isSelected = false
                        self.alertData(title: "E-mail correct", message: "Thank You!")
                    case .failure(let error):
                        print(error)
                    }
            }
        }
    }
    
    @IBAction func clickCheckBox(_ sender: UIButton) {
        if sender.isSelected {
            selectDataTnc = false
            sender.isSelected = false
        } else {
            selectDataTnc = true
            sender.isSelected = true
        }
    }
    
    @IBAction func confirmButton(_ sender: Any) {
        if emailTextFiled.text?.count == 0 {
            clearText()
            return alertData(title: "Empty", message: "Please enter e-mail.")
        }
        
        if selectDataTnc == false {
            return alertData(title: "CheckBox", message: "Please enter checkBox.")
        }
        
        if isValidEmail(testStr: emailTextFiled.text ?? "") == true {
            print("succress")
        } else {
            clearText()
            alertData(title: "E-mail incorrect", message: "Check format e-mail.")
        }
        
        let selectData = randomData(length: 15)
        let selectUUID = NSUUID().uuidString
        register(email: emailTextFiled.text ?? "", uuid: selectUUID, data: selectData, tnc: selectDataTnc)

    }
    
    func alertData(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func clearText() {
        emailTextFiled.text = ""
    }
    
    func isValidEmail(testStr: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func randomData(length: Int) -> String {
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString: String = ""
        
        for _ in 0..<length {
            let randomValue = arc4random_uniform(UInt32(base.count))
            randomString += "\(base[base.index(base.startIndex, offsetBy: Int(randomValue))])"
        }
        return randomString
    }
}


