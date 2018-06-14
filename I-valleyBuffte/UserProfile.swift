//
//  UserProfile.swift
//  I-valleyBuffte
//
//  Created by azzaz on 6/11/18.
//  Copyright © 2018 azzaz. All rights reserved.
//

import UIKit
import CoreData

class UserProfile: UIViewController {
    let fetchRequest: NSFetchRequest<User> = NSFetchRequest(entityName: "User")
    let fetchRequest2: NSFetchRequest<Order> = NSFetchRequest(entityName: "Order")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let id = UserDefaults.standard.object(forKey: "id")
    var arrOfItemDiffrentDates:[String] = []
    var arrOfRowsInSection:[Order] = []
    var arrOfUSer:[User] = []
    var arrOfUserOrderrs:[Order] = []
    
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblTelephone: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var tableOrders: UITableView!
    @IBOutlet weak var lblUserName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let id = UserDefaults.standard.object(forKey: "id")
        let predicate = NSPredicate(format: "userId contains %@", id as! CVarArg)
        fetchRequest.predicate = predicate
        do {
            arrOfUSer = try context.fetch(self.fetchRequest)
            
            print("sucess")
        } catch {
            print("No rows found")
        }
        if arrOfUSer.count == 1
        {
            lblUserName.text = arrOfUSer[0].name
            lblUsername.text = arrOfUSer[0].username
            lblTelephone.text = String(arrOfUSer[0].telephoneNumber)
            let img = UIImage(named:arrOfUSer[0].img ?? "")
            imgProfile.image = img
            
        }
        getUserOrders()
        //arrOfUserOrders = CoreDataHandler.getData(entitty: "Order") as! [Order]
//        for index in 0 ... arrOfUserOrderrs.count - 1
//        {
//            print("the name is \(arrOfUserOrderrs[index].name) and id is \(arrOfUserOrderrs[index].userId)")
//        }
        getItemDates()
        tableOrders.reloadData()
        
        /////////
        // End of viewDidLoaed method
    }
    // get user orders
    func getUserOrders()
    {
        let id = UserDefaults.standard.object(forKey: "id")
//        print(id)
//        let ID = "AF9D0D5A-EFCF-4062-A0D9-96B3F2E4CCCE"
        let predicate = NSPredicate(format: "userId = %@", id as! CVarArg)
        fetchRequest2.predicate = predicate
        do {
            arrOfUserOrderrs = try context.fetch(self.fetchRequest2)
            
            print("sucess")
        } catch {
            print("No rows found")
        }
    }
    /////////////
    func getItemDates()
    {
        if arrOfUserOrderrs.count == 1
        {
            arrOfItemDiffrentDates.append(arrOfUserOrderrs[0].date ?? "")
            
        }
        else if  arrOfUserOrderrs.count > 1
        {
            arrOfItemDiffrentDates.append(arrOfUserOrderrs[0].date ?? "")
            for index in 0 ..< arrOfUserOrderrs.count - 1
            {
                if arrOfUserOrderrs[index].date != arrOfUserOrderrs[index + 1].date
                {
                    arrOfItemDiffrentDates.append(arrOfUserOrderrs[index + 1].date ?? "")
                }
            }
            arrOfItemDiffrentDates.reverse()
            print(arrOfItemDiffrentDates.count)
        }
        // End of method
    }
    // get rows for sectoin
    func getRowsInSection(indexPath:IndexPath)
    {
        for _ in 0 ... arrOfItemDiffrentDates.count - 1
        {
             //"(hotelName IN %@) OR (cityName IN %@)"
            //@"name contains[cd] %@ OR ssid contains[cd] %@",
            let predicate = NSPredicate(format: "(date == %@) AND (userId == %@)", arrOfItemDiffrentDates[indexPath.section] ,id as! CVarArg)
            fetchRequest2.predicate = predicate
            do {
                arrOfRowsInSection = try context.fetch(self.fetchRequest2)
                print("sucess")
            } catch {
                print("No rows found")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func BtnLogOut(_ sender: UIButton) {
        
        
        let alert = UIAlertController(title: "Signing out ", message: "Are you sure to sign out", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            
            let def = UserDefaults.standard
            def.removeObject(forKey:"id")
            let SignInVC = self.storyboard?.instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
            let appDelegate = UIApplication.shared.delegate
            appDelegate?.window??.rootViewController = SignInVC
        }))
        alert.addAction(UIAlertAction(title: "CANCEL", style: .cancel, handler: { [weak alert] (_) in
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
extension UserProfile: UITableViewDataSource,UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrOfItemDiffrentDates.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        for index in 0 ... arrOfItemDiffrentDates.count - 1
        {
//            let predicate = NSPredicate(format: "date == %@", arrOfItemDiffrentDates[section])
            let predicate = NSPredicate(format: "(date == %@) AND (userId == %@)", arrOfItemDiffrentDates[section] ,id as! CVarArg)
            fetchRequest2.predicate = predicate
            fetchRequest2.predicate = predicate
            do {
                arrOfRowsInSection = try context.fetch(self.fetchRequest2)
                return arrOfRowsInSection.count
            } catch {
                print("No rows found")
            }
        }
        return 2
    }
    ///////////////
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if arrOfItemDiffrentDates.count > 0
        {
            for index in 0 ... arrOfItemDiffrentDates.count - 1
            {
                let predicate = NSPredicate(format: "date == %@", arrOfItemDiffrentDates[section])
                fetchRequest2.predicate = predicate
                do {
                    arrOfRowsInSection = try context.fetch(self.fetchRequest2)
                    if arrOfRowsInSection.count > 0
                    {
                        return arrOfRowsInSection[index].date
                    }
                    print("sucess")
                } catch {
                    print("No rows found")
                }
            }
        }
        return ""
    }
    //////////////////////
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell")
            as? ProfileCell else {return UITableViewCell()}
        getRowsInSection(indexPath: indexPath)
        let order = arrOfRowsInSection[indexPath.row]
        print("aaaa\(arrOfRowsInSection.count)")
        cell.lblOrderName.text = order.name
        cell.lblOrderPrice.text = String(order.orderPrice)
        print("fgfg\(order.orderPrice)")
        cell.lblOrderCost.text = String(order.totalCost)
        cell.lblOrderDate.text = order.date
        cell.lblPlaced.text = String(describing: order.status)
        
        return cell
    }
    // to remove row from tableview
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "DELETE") { (rowAction, indexPath) in
            if indexPath.section >= 0
            {
                self.getRowsInSection(indexPath: indexPath)
                let order = self.arrOfRowsInSection[indexPath.row]
                if order.status == "Placed"{
                    CoreDataHandler.remove(indexPath:indexPath,array:self.arrOfRowsInSection)
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                    self.getRowsInSection(indexPath: indexPath)
                    self.tableOrders.reloadData()
                }
                else
                {
                    let alert = UIAlertController(title: "the order isn't palced ! ", message: "you can't to delete ", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                        
                    }))
                    
                    self.present(alert, animated: true, completion: nil)// End of the second alert
                }
            }
        }
        deleteAction.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        return [deleteAction]
    }
    
}

