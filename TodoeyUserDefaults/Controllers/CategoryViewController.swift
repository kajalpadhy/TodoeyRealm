//
//  CategoryViewController.swift
//  TodoeyUserDefaults
//
//  Created by Kajal on 1/12/18.
//  Copyright © 2018 Kajal. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

     var categories = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()

       loadCategory()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].name
        return cell
    }

    // MARK: - Table view delegate method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVc = segue.destination as! ToDoListViewController
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVc.selectCategory = categories[indexPath.row]
        }
        
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
         var textField = UITextField()
        let alert = UIAlertController(title: "ADD NEW ITEM IN TODOEY", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "ADD ITEM", style: .default) { (action) in
        let newCategory = Category(context: self.context)
        newCategory.name = textField.text!
        self.categories.append(newCategory)
       self.saveCategory()
        
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    //MARK :- Data manipulation
    func saveCategory()
    {
        do{
        try context.save()
        }
        catch{
            print("error shows while saving data\(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategory()
    {
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        do{
         categories = try context.fetch(request)
        }
        catch{
            print("eroor shows while loading data fro table\(error)")
        }
        tableView.reloadData()
    }

}
