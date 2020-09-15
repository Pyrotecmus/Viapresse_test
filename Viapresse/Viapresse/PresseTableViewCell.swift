//
//  PresseTableViewCell.swift
//  Viapresse
//
//  Created by Axel Imberdis on 14/09/2020.
//  Copyright © 2020 Axel Imberdis. All rights reserved.
//

import UIKit

class PresseTableViewCell: UITableViewCell
{
    /*func numberOfItems(in carousel: iCarousel) -> Int {
        return 10
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 60))
        view.backgroundColor = UIColor.red
        
        return view
    }
    
    let myCarousel: iCarousel = {
        let view = iCarousel()
        view.type = .coverFlow
        
        return view
    }()*/
    
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
        /*cell.addSubview(cell.myCarousel)
        cell.myCarousel.dataSource = cell
        cell.myCarousel.frame = CGRect(x: 0, y: 0, width: 200, height: 200)*/
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func categorySelected(_ sender: UIButton)
    {
        
    }
}
