//
//  File.swift
//  TopiOSApps
//
//  Created by duraiamuthan harikrishnan on 30/03/2020.
//  Copyright © 2020 duraiamuthan harikrishnan. All rights reserved.
//

import Foundation

extension String
{
    func trim() -> String
   {
    return self.trimmingCharacters(in: NSCharacterSet.whitespaces)
   }
}
