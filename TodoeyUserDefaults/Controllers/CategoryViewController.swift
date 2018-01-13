//
//  CategoryViewController.swift
//  TodoeyUserDefaults
//
//  Created by Kajal on 1/12/18.
//  Copyright © 2018 Kajal. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
 
    let realm = try! Realm()
    //var categories : Results<Category>!
    var categories : Results<Category>?
  
    override func viewDidLoad() {
        super.viewDidLoad()

       loadCategory()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //return categories.count
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        //cell.textLabel?.text = categories[indexPath.row].name
        cell.textLabel?.text = categories?[indexPath.row].name ?? "NO Category added yet"
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

}
