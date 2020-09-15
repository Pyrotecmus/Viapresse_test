//
//  DetailsViewController.swift
//  Viapresse
//
//  Created by Axel Imberdis on 15/09/2020.
//  Copyright © 2020 Axel Imberdis. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController
{
    var issueId: String?
    var cover = Data()
    var details = Details(id: "", name: "", number: "", description: "")
    
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cover = downloadCoverJson()
        downloadDetailsJson()
        coverImage.image = UIImage(data: cover)
        nameLabel.text = details.name
        numberLabel.text = details.number
        descriptionLabel.text = details.description
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    private func downloadCoverJson() -> Data
    {
        let url = URL(string: "https://press-api.wobook.com/v1/issue/\(issueId!)/cover/large")
        
        print(issueId)
        print(url)
        var request = URLRequest(url: url!)
        var toReturn = Data()
        
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField:"Content-Type")
        request.setValue("bba06baf-f1da-4ca4-838c-1f205dd349d6", forHTTPHeaderField:"API-KEY")
        request.setValue("ITW", forHTTPHeaderField:"Origin")
        let sem = DispatchSemaphore(value: 0)
        let task = URLSession.shared.dataTask(with: request as URLRequest)
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
                toReturn = data
            }
            sem.signal()
        }
        task.resume()
        sem.wait()
        return toReturn
    }
    
    private func downloadDetailsJson()
    {
        let url = URL(string: "https://press-api.wobook.com/v1/catalog/issue/itw/\(issueId!)/details")
        
            var request = URLRequest(url: url!)
        
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField:"Content-Type")
            request.setValue("bba06baf-f1da-4ca4-838c-1f205dd349d6", forHTTPHeaderField:"API-KEY")
            request.setValue("ITW", forHTTPHeaderField:"Origin")
            let sem = DispatchSemaphore(value: 0)
            let task = URLSession.shared.dataTask(with: request as URLRequest)
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
                    self.details = try JSONDecoder().decode(Details.self, from: data)
                }
                catch
                {
                    print("something went wrong after downloading")
                }
                sem.signal()
            }
            task.resume()
            sem.wait()
            /*if (issueId == issues.count)
            {
                sem.signal()
            }*/
    }
}
