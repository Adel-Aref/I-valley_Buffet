
//
//  OferredItems.swift
//  I-valleyBuffte
//
//  Created by azzaz on 6/4/18.
//  Copyright © 2018 azzaz. All rights reserved.
//

import UIKit
import CoreData

class OferredItems: UIViewController {
    
    var arrOfItems:[Item] = []
    var arrOfItemDates:[String] = []
    var arrOfRowsInSection:[Item] = []
    var arrOfRowsInSectionn:[Item] = []
    var arrItemsToShow:[Item] = []
    var arrORder:[Order] = []
    var arrStatus:[String] = ["Placed","Processed","Payed"]
    
    let fetchRequest: NSFetchRequest<Item> = NSFetchRequest(entityName: "Item")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    
    @IBOutlet weak var ItemsTable: UITableView!
    @IBOutlet weak var txtName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        arrOfItems = CoreDataHandler.getData(entitty: "Item") as! [Item]
        getItemDates()
        ItemsTable.reloadData()
        //print(arrOfItemDates[0])
        
        
        // Do any additional setup after loading the view.
    }
    
    // get difrrent dates
    func getItemDates()
    {
        if arrOfItems.count == 1
        {
            arrOfItemDates.append(arrOfItems[0].itemDate ?? "")
            
        }
        else if  arrOfItems.count > 1
        {
            arrOfItemDates.append(arrOfItems[0].itemDate ?? "")
            for index in 0 ..< arrOfItems.count - 1
            {
                if arrOfItems[index].itemDate != arrOfItems[index + 1].itemDate
                {
                    arrOfItemDates.append(arrOfItems[index + 1].itemDate ?? "")
                }
            }
            arrOfItemDates.reverse()
        }
        // End of method
    }
    // get rows for sectoin
    func getRowsInSection(indexPath:IndexPath)
    {
        for index in 0 ... arrOfItemDates.count - 1
        {
            let predicate = NSPredicate(format: "itemDate == %@", arrOfItemDates[indexPath.section] )
            fetchRequest.predicate = predicate
            do {
                arrOfRowsInSection = try context.fetch(self.fetchRequest)
                print("sucess")
            } catch {
                print("No rows found")
            }
        }
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func BtnAddItemPressed(_ sender: Any) {
    }
    // End of the class
}
extension OferredItems: UITableViewDataSource,UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrOfItemDates.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        for index in 0 ... arrOfItemDates.count - 1
        {
            let predicate = NSPredicate(format: "itemDate == %@", arrOfItemDates[section])
            fetchRequest.predicate = predicate
            do {
                arrOfRowsInSection = try context.fetch(self.fetchRequest)
                return arrOfRowsInSection.count
                print("sucess")
            } catch {
                print("No rows found")
            }
        }
        return 1
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if arrOfItemDates.count > 0
        {
            for index in 0 ... arrOfItemDates.count - 1
            {
                let predicate = NSPredicate(format: "itemDate == %@", arrOfItemDates[section])
                fetchRequest.predicate = predicate
                do {
                    arrOfRowsInSectionn = try context.fetch(self.fetchRequest)
                    if arrOfRowsInSectionn.count > 0
                    {
                        return arrOfRowsInSectionn[index].itemDate
                    }
                    print("sucess")
                } catch {
                    print("No rows found")
                }
            }
        }
        return ""
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell")
            as? ItemCell else {return UITableViewCell()}
        getRowsInSection(indexPath: indexPath)
        let itemm = arrOfRowsInSection[indexPath.row]
        print("aaaa\(itemm.itemId)")
        cell.lblName.text = itemm.name
        cell.lblPrice.text = String(itemm.price)
        cell.lblAvalbility.text = String(itemm.availbe)
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
                CoreDataHandler.remove(indexPath:indexPath,array:self.arrOfRowsInSection)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                self.getRowsInSection(indexPath: indexPath)
                self.ItemsTable.reloadData()
            }
        }
        deleteAction.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        return [deleteAction]
    }
    // to select cell from table view
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected cell number: \(indexPath.row)!")
        let alert = UIAlertController(title: "Enter the amont ", message: "it must be a number", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Enter Count"
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            
            let def = UserDefaults.standard
            let userId = def.object(forKey: "id")
            self.getRowsInSection(indexPath: indexPath)
            if indexPath.section >= 0 && indexPath.row >= 0
            {
                let orderCount = Int32((alert?.textFields![0].text) ?? "5" ) ?? 5
                let orderPrice = self.arrOfRowsInSection[indexPath.row].price
                let orderName = self.arrOfRowsInSection[indexPath.row].name
                let orderId = self.arrOfRowsInSection[indexPath.row].itemId
                let availble = self.arrOfRowsInSection[indexPath.row].availbe
                let orderDate = self.getCurrentDate()
                let orderTotalCost = orderCount * orderPrice
                
                
                let paremters = ["count":orderCount ,
                                 "orderId":orderId ,
                                 "name":orderName ,
                                 "status":self.arrStatus[0] ,
                                 "totalCost":orderTotalCost,
                                 "userId":userId ,
                                 "orderPrice":orderPrice ,
                                 "date":orderDate
                    ] as [String : Any]
            
            if availble == true
            {
                print("asd \(CoreDataHandler.saveData(paremeters: paremters, entityName: "Order"))")
                guard let UserProfile = self.storyboard?.instantiateViewController(withIdentifier: "UserProfile") as? UserProfile else {return}
                self.presentDtails(viewControllerToPresent: UserProfile)
                
                self.arrORder = CoreDataHandler.getData(entitty: "Order") as! [Order]
                
                print("name is \(self.arrORder[self.arrORder.count - 1].userId) and id item id is \(self.arrORder[self.arrORder.count - 1].orderPrice)    dddddd \(self.arrORder[self.arrORder.count - 1].totalCost)")
            }
                self.getRowsInSection(indexPath: indexPath)
        }
            else
            {
                let alert = UIAlertController(title: "the Item isn't avilable Now ! ", message: "later will be avilable ", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                    
                }))
                
                self.present(alert, animated: true, completion: nil)// End of the second alert
            }
        })) // End of the first alert
        
        self.present(alert, animated: true, completion: nil)
    }
    
}
