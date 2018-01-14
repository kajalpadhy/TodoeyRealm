//
//  CategoryViewController.swift
//  TodoeyUserDefaults
//
//  Created by Kajal on 1/12/18.
//  Copyright © 2018 Kajal. All rights reserved.
//

import UIKit
import RealmSwift
//import SwipeCellKit
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
 
    let realm = try! Realm()
    //var categories : Results<Category>!
    var categories : Results<Category>?
  
    override func viewDidLoad() {
        super.viewDidLoad()

       loadCategory()
        tableView.separatorStyle = .none
       
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //return categories.count
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let category = categories?[indexPath.row]{
            cell.textLabel?.text = category.name
            guard let categorycolour = UIColor(hexString: category.colour) else{fatalError()}
             cell.backgroundColor = categorycolour
            cell.textLabel?.textColor = ContrastColorOf(categorycolour, returnFlat: true)
        }
        
        
        return cell
    }

   
    
    // MARK: - Table view delegate method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVc = segue.destination as! ToDoListViewController
        if let indexPath = tableView.indexPathForSelectedRow{
            //destinationVc.selectCategory = categories[indexPath.row]
            destinationVc.selectCategory = categories?[indexPath.row]
        }
        
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
       
         var textField = UITextField()
        let alert = UIAlertController(title: "ADD NEW ITEM IN TODOEY", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "ADD ITEM", style: .default) { (action) in
        let newCategory = Category()
        newCategory.name = textField.text!
        newCategory.colour = UIColor.randomFlat.hexValue()
       self.save(category: newCategory)
        
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK :- Data manipulation
    func save(category: Category)
    {
        do{
            try realm.write {
                realm.add(category)
            }
        }
        catch{
            print("error shows while saving data\(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategory()
    {
        categories = realm.objects(Category.self)
       tableView.reloadData()
    }
 //MARK :- deletedata from swipe
    override func updateModel(at indexPath: IndexPath) {
        if let categorydeletion = self.categories?[indexPath.row]{
                            do{
                                try self.realm.write {
                                    self.realm.delete(categorydeletion)
                                }
                            }
                            catch{
                                print("error while delete\(error)")
                            }
                            // tableView.reloadData()
                        }
    }
}

