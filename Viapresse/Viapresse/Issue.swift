//
//  Issue.swift
//  Viapresse
//
//  Created by Axel Imberdis on 14/09/2020.
//  Copyright © 2020 Axel Imberdis. All rights reserved.
//

import Foundation

struct IssueCategory : Decodable
{
    var id: String
    var name: String
    var number: String?
}
