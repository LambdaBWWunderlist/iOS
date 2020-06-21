//
//  Todo+Convenience.swift
//  Wunderlist
//
//  Created by Kenny on 6/21/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import CoreData

extension Todo {
    convenience init?(
        identifier: String,
        context: NSManagedObjectContext = CoreDataStack.shared.mainContext
    ) {
        self.init(context: context)
        if identifier.isEmpty { //also required to be >1 in the CoreData model
            return nil
        } else {
            self.identifier = identifier
        }
    }

}
