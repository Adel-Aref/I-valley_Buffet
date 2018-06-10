//
//  SignUpVC.swift
//  I-valleyBuffte
//
//  Created by azzaz on 6/4/18.
//  Copyright © 2018 azzaz. All rights reserved.
//

import UIKit

class SignUpVC: UIViewController {
    @IBOutlet weak var txtTelephone: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtName: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    @IBAction func BtnGetStartedWasPressed(_ sender: UIButton) {
        let userId = UUID().uuidString
        let name = txtName.text
        print(userId)
        let paremters = ["name":name ?? "" ,
                         "username":txtUsername.text ?? "" ,
                         "password":txtPassword.text ?? "" ,
                         "telephoneNumber":Int32(txtTelephone.text!) ?? 1 ,
                         "confirmPassword":txtConfirmPassword.text ?? "" ,
                         "userId":userId] as [String : Any]
       let passed =  CoreDataHandler.saveData(paremeters: paremters, entityName: "User")
        if passed == true
        {
            guard let SignInVC = storyboard?.instantiateViewController(withIdentifier: "SignInVC") as? SignInVC else {return}
            presentDtails(viewControllerToPresent: SignInVC)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
