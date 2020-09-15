//
//  PresseTableViewController.swift
//  Viapresse
//
//  Created by Axel Imberdis on 14/09/2020.
//  Copyright © 2020 Axel Imberdis. All rights reserved.
//

import UIKit

class PresseTableViewController: UITableViewController
{
    final let url = URL(string: "https://press-api.wobook.com/v1/catalog/categories")
    private var categories = [Category]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        downloadJson()
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return categories.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cellIdentifier = "PresseTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? PresseTableViewCell
        else
        {
            fatalError("The dequeued cell is not an instance of FilmTableViewCell")
        }
        
        //Fetches the appropriate film for the data source layout
        cell.nameLabel.text = categories[indexPath.row].name
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    private func downloadJson()
    {
        guard url != nil
            else
        {
            return
        }
        
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField:"Content-Type")
        request.setValue("bba06baf-f1da-4ca4-838c-1f205dd349d6", forHTTPHeaderField:"API-KEY")
        request.setValue("ITW", forHTTPHeaderField:"Origin")
        URLSession.shared.dataTask(with: request as URLRequest)
        {
            data, urlResponse, error in
            guard let data = data, error == nil, urlResponse != nil
            else
            {
                print("something went wrong before downloading")
                return
            }
            do
            {
                let decoding = try JSONDecoder().decode([Category].self, from: data)
                self.categories = decoding
                DispatchQueue.main.async
                {
                    self.tableView.reloadData()
                }
            }
            catch
            {
                print("something went wrong after downloading")
            }
        }.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? "")
        {
        case "Show":
            guard let detailInformation = segue.destination as? CarouselViewController
                else
            {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedFilmCell = sender as? PresseTableViewCell
                else
            {
                fatalError("Unexpected sender : \(sender)")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedFilmCell)
                else
            {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedCategory = categories[indexPath.row]
            detailInformation.category = selectedCategory
        default:
            fatalError("Unexpected segue identifier; \(segue.identifier)")
        }
    }
}
