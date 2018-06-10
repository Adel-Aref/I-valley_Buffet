//
//  AddItem.swift
//  I-valleyBuffte
//
//  Created by azzaz on 6/4/18.
//  Copyright © 2018 azzaz. All rights reserved.
//

import UIKit

class AddItem: UIViewController {

    @IBOutlet weak var txtItemPrice: UITextField!
    @IBOutlet weak var txtItemName: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("current date is \(getCurrentDate())")

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // make a func the return the current date 
    func getCurrentDate()-> String
    {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let result = formatter.string(from: date)
        return result
    }
    
    @IBAction func BtnDonePressed(_ sender: Any) {
        let currentDate = getCurrentDate()
        let itemId = UUID().uuidString
        let paremters = ["name":txtItemName.text ?? "" ,
                         "price":Int32(txtItemPrice.text!) ?? 1  ,
                         "availbe":true,
                         "itemId":itemId,
                         "itemDate":currentDate
            ] as [String : Any]
        let passed =  CoreDataHandler.saveData(paremeters: paremters, entityName: "Item")
        if passed == true
        {
            guard let OferredItems = storyboard?.instantiateViewController(withIdentifier: "OferredItems") as? OferredItems else {return}
            presentDtails(viewControllerToPresent: OferredItems)
        }
    }

}
