//
//  CarouselViewController.swift
//  Viapresse
//
//  Created by Axel Imberdis on 14/09/2020.
//  Copyright © 2020 Axel Imberdis. All rights reserved.
//

import iCarousel
import UIKit

class CarouselViewController: UIViewController, iCarouselDataSource
{
    var issues = [IssueCategory]()
    var imageView = [UIImageView]()
    var dataImage = [Data]()
    var category: Category?
    var indexIssues = Int()
    
    let myCarousel: iCarousel = {
        let view = iCarousel()
        view.type = .coverFlow
        
        return view
    }()
    
    @IBOutlet weak var categoryName: UILabel!
    
    override func viewDidLoad()
    {
        issues = downloadIssueJson()
        var issueId = 0
        while (issueId < Int(issues.count))
        {
            dataImage.append(downloadCoverJson(issues[issueId]))
            issueId += 1
        }
        categoryName.text = category?.name
        view.addSubview(myCarousel)
        myCarousel.dataSource = self
        myCarousel.frame = CGRect(x: 0, y: 200, width: view.frame.size.width, height: 200)
        super.viewDidLoad()
    }
    
    func loadData()
    {
        view.layoutIfNeeded()
    }
    
    func numberOfItems(in carousel: iCarousel) -> Int
    {
        return issues.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        if (imageView.count < issues.count)
        {
            imageView.append(UIImageView(frame: view.bounds))
            view.addSubview(imageView[imageView.count - 1])
            imageView[imageView.count - 1].contentMode = .scaleAspectFit
            imageView[imageView.count - 1].image = UIImage(data: dataImage[imageView.count - 1])
        }
        else
        {
            view.addSubview(imageView[index])
            imageView[index].contentMode = .scaleAspectFit
            imageView[index].image = UIImage(data: dataImage[index])
        }
        return view
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    private func downloadIssueJson() -> [IssueCategory]
    {
        guard let url = URL(string: "https://press-api.wobook.com/v1/catalog/categories/\(category!.id)/issues/itw/0")
            else
        {
            return []
        }
        
        var toReturn = [IssueCategory]()
        var request = URLRequest(url: url)
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
                let decoding = try JSONDecoder().decode([IssueCategory].self, from: data)
                toReturn = decoding
            }
            catch
            {
                print("something went wrong after downloading")
            }
            sem.signal()
        }
        task.resume()
        sem.wait()
        return toReturn
    }
    
    private func downloadCoverJson(_ index: IssueCategory) -> Data
    {
        let url = URL(string: "https://press-api.wobook.com/v1/issue/\(index.id)/cover/large")
        
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
            catch
            {
                print("something went wrong after downloading")
            }
            sem.signal()
        }
        task.resume()
        sem.wait()
        return toReturn
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? "")
        {
        case "Show":
            guard let detailInformation = segue.destination as? DetailsViewController
                else
            {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            if (issues.count == 0)
            {
                return
            }
            let selectedIssue = issues[myCarousel.currentItemIndex].id
            detailInformation.issueId = selectedIssue
        default:
            fatalError("Unexpected segue identifier; \(segue.identifier)")
        }
    }
}
