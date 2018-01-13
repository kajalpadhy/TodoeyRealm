//
//  ViewController.swift
//  TodoeyUserDefaults
//
//  Created by Kajal on 1/9/18.
//  Copyright © 2018 Kajal. All rights reserved.
//

import UIKit
import RealmSwift
class ToDoListViewController: UITableViewController{

    //var toDoItems = ["kajal","kiran","padhy"]
    var toDoItems: Results<Item>?
    let realm = try! Realm()
    //it is called when selectedCategory has value
    var selectCategory: Category? {
        didSet{
        loadData()
        }
    }
    
    
  //  let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
     let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(dataFilePath)
        
       // loadData()
    }
    //MARK:- TableView DataSource Method
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
       // let cell = UITableViewCell(style: .default, reuseIdentifier: "ToDoItemCell")
         if let item = toDoItems?[indexPath.row]
         {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done == true ? .checkmark : .none
         }else{
            cell.textLabel?.text = "NO Item added yet"
        }
        
        return cell
    }
 
    //MARK:- TableView Delegate Method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //update abd delete operation
        if let item = toDoItems?[indexPath.row]{
            do{
            try realm.write {
                 item.done = !item.done
                //realm.delete(item)
            }
            }
            catch{
                print("while updating error shows\(error)")
            }
        }
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    //MARK:- Add new Item in List
    @IBAction func addButtonPresseed(_ sender: UIBarButtonItem) {
    
        var textField = UITextField()
        let alert = UIAlertController(title: "ADD NEW ITEM IN TODOEY", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "ADD NEW ITEM", style: .default) { (action) in
            
            if let currentCategory = self.selectCategory{
                do{
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                       // newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                }
                catch{
                    print("while saving items \(error)")
                }
            }
           self.tableView.reloadData()
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
   
    func loadData()
     {
    toDoItems = selectCategory?.items.sorted(byKeyPath: "title", ascending: true)
    tableView.reloadData()
    }
    
   
}

extension ToDoListViewController : UISearchBarDelegate
{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
      toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
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

