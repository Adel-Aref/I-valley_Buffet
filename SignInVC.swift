//
//  SignInVC.swift
//  I-valleyBuffte
//
//  Created by azzaz on 6/4/18.
//  Copyright © 2018 azzaz. All rights reserved.
//

import UIKit
import CoreData

class SignInVC: UIViewController {
    let fetchRequest: NSFetchRequest<User> = NSFetchRequest(entityName: "User")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var arrUser:[User] = []
    
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtUSername: UITextField!
    @IBOutlet weak var BtnSignIn: UIButton!
    @IBOutlet weak var lblCreateAccount: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(SignInVC.tapFunction))
        lblCreateAccount.isUserInteractionEnabled = true
        lblCreateAccount.addGestureRecognizer(tap)
    }
    @objc
    func tapFunction(sender:UITapGestureRecognizer) {
        guard let SignUpVC = storyboard?.instantiateViewController(withIdentifier: "SignUpVC") as? SignUpVC else {return}
        presentDtails(viewControllerToPresent: SignUpVC)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func BtnSignInPressed(_ sender: UIButton) {
        
        let username = txtUSername.text ?? "default"
        let password = txtPassword.text ?? "default"
        let predicate = NSPredicate(format: "username = %@ AND password = %@", username, password)
        fetchRequest.predicate = predicate
        do {
            arrUser = try context.fetch(self.fetchRequest)
            if arrUser.count >= 1{
                let id = arrUser[0].userId
                let def = UserDefaults.standard
                def.set(id, forKey: "id")
                guard let UserProfile = storyboard?.instantiateViewController(withIdentifier: "UserProfile") as? UserProfile else {return}
                presentDtails(viewControllerToPresent: UserProfile)
                print("sucess")
            }
        }catch {
            print("No rows found")
        }
        
        
        if (username == "admin") && (password == "admin")
        {
            guard let AddItem = storyboard?.instantiateViewController(withIdentifier: "AddItem") as? AddItem else {return}
            presentDtails(viewControllerToPresent: AddItem)
        }
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
