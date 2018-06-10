
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
    
    let fetchRequest: NSFetchRequest<Item> = NSFetchRequest(entityName: "Item")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    
    @IBOutlet weak var ItemsTable: UITableView!
    @IBOutlet weak var txtName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        arrOfItems = CoreDataHandler.getData(entitty: "Item") as! [Item]
        print("asd \(arrOfItems[arrOfItems.count - 1].itemDate )")
        getItemDates()
        ItemsTable.reloadData()
        print("date is \(arrOfItemDates[0])")
        print("date is \(arrOfItemDates[1])")
        print("date is \(arrOfItemDates[3])")
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
        else
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
            let predicate = NSPredicate(format: "itemDate == %@", arrOfItemDates[section] )
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
        for index in 0 ... arrOfItemDates.count - 1
        {
            let predicate = NSPredicate(format: "itemDate == %@", arrOfItemDates[section])
            fetchRequest.predicate = predicate
            do {
                arrOfRowsInSectionn = try context.fetch(self.fetchRequest)
                return arrOfRowsInSectionn[index].itemDate
                print("sucess")
            } catch {
                print("No rows found")
            }
        }
        return "No title"
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
            if indexPath.section >= 0 && indexPath.row >= 0
            {
                CoreDataHandler.remove(indexPath:indexPath,array:self.arrOfRowsInSection)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                self.getRowsInSection(indexPath: indexPath)
                self.ItemsTable.reloadData()
            }
        }
        deleteAction.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        return [deleteAction]
    }
    
    
}
