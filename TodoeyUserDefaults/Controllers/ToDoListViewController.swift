//
//  ViewController.swift
//  TodoeyUserDefaults
//
//  Created by Kajal on 1/9/18.
//  Copyright © 2018 Kajal. All rights reserved.
//

import UIKit
import CoreData
class ToDoListViewController: UITableViewController{

    //var itemArray = ["kajal","kiran","padhy"]
    var itemArray = [Item]()
    //it is called when selectedCategory has value
    var selectCategory: Category? {
        didSet{
        loadData()
        }
    }
      let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
  //  let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
     let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(dataFilePath)
        
        //loadData()
    }
    //MARK:- TableView DataSource Method
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
       // let cell = UITableViewCell(style: .default, reuseIdentifier: "ToDoItemCell")
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done == true ? .checkmark : .none
        return cell
    }
 //MARK:- TableView Delegate Method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        }else{
//           tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        //tableView.reloadData()
        saveData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
//MARK:- Add new Item in List

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
         var textField = UITextField()
        let alert = UIAlertController(title: "ADD NEW ITEM IN TODOEY", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "ADD NEW ITEM", style: .default) { (action) in
          
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectCategory
            self.itemArray.append(newItem)
          // self.defaults.set(self.itemArray, forKey: "ToDoListArray")
          //  self.tableView.reloadData()
            self.saveData()
        }
      //adding text field to alert dialuge box
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "create a new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK:- Manipulation data
    func saveData()
    {
        do{
            try context.save()
        }
        catch{
            print(error)
        }
       self.tableView.reloadData()
    }
   
    func loadData(with request : NSFetchRequest<Item>  = Item.fetchRequest(), predicate: NSPredicate? = nil)
     {
      //  let request : NSFetchRequest<Item> = Item.fetchRequest()
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectCategory!.name!)

        //let compaundCategory = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate])
       // request.predicate = compaundCategory
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [additionalPredicate, predicate!])
        }else{
           request.predicate = categoryPredicate
        }
            do{
            itemArray =  try context.fetch(request)
            }
            catch {
                print(error)
            }
        
    }
    
   
}
extension ToDoListViewController : UISearchBarDelegate
{
   
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
       let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        //        do{
        //          itemArray = try context.fetch(request)
        //        }
        //        catch{
        //            print("error while fetching data\(error)")
        //        }
        loadData(with : request, predicate: predicate)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0
        {
           loadData()
            DispatchQueue.main.async{
            searchBar.resignFirstResponder()
            }
        }
    }
}

