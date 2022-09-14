//
//  CoreDataManager.swift
//  LanarsTestTask
//
//  Created by Yaroslav Shepilov on 28.02.2022.
//

import Foundation
import CoreData

public final class CoreDataManager {
    
    public func entityForName(entityName: String, context: NSManagedObjectContext) -> NSEntityDescription {
         return NSEntityDescription.entity(forEntityName: entityName, in: context)!
     }
    
    public func getOrCreateEntityBy(id: UUID, nameOfClass: String, context: NSManagedObjectContext) -> NSManagedObject {
        return getEntityBy(id: id, name: nameOfClass, context: context) ?? prepareEntityForSaving(nameOfClass, context: context)
    }
    
    public func prepareEntityForSaving(_ nameOfClass: String, context: NSManagedObjectContext) -> NSManagedObject {
        let entityDescription = NSEntityDescription.entity(forEntityName: nameOfClass, in: context)!
        return NSManagedObject(entity: entityDescription, insertInto: context)
    }
         
    public func getEntities(entityName: String, keyForSort: String, context: NSManagedObjectContext) -> [NSManagedObject]? {
         let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
         fetchRequest.returnsObjectsAsFaults = false
         let sortDescriptor = NSSortDescriptor(key: keyForSort, ascending: true)
         fetchRequest.sortDescriptors = [sortDescriptor]
         
         fetchRequest.fetchBatchSize = 25
         
         do {
            let _context = context
             let fetchedEntities = try _context.fetch(fetchRequest) as! [NSManagedObject]
             return fetchedEntities
         } catch {
             return nil
         }
     }
     
    public func getEntities(entityName: String, keyForSort: String, predicate: NSPredicate?, context: NSManagedObjectContext) -> [NSManagedObject]? {
         let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
         fetchRequest.returnsObjectsAsFaults = false
         let sortDescriptor = NSSortDescriptor(key: keyForSort, ascending: true)
         fetchRequest.sortDescriptors = [sortDescriptor]
         fetchRequest.predicate = predicate
         
         fetchRequest.fetchBatchSize = 25
         
         do {
            let _context = context
             let fetchedEntities = try _context.fetch(fetchRequest) as! [NSManagedObject]
             return fetchedEntities
         } catch {
             return nil
         }
     }
     
    public func getEntities(entityName: String, keyForSort: String, predicate: NSPredicate?, ascending: Bool, context: NSManagedObjectContext) -> [NSManagedObject]? {
         let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
         fetchRequest.returnsObjectsAsFaults = false
         let sortDescriptor = NSSortDescriptor(key: keyForSort, ascending: ascending)
         fetchRequest.sortDescriptors = [sortDescriptor]
         fetchRequest.predicate = predicate
         
         fetchRequest.fetchBatchSize = 25
         
         do {
            let _context = context
             let fetchedEntities = try _context.fetch(fetchRequest) as! [NSManagedObject]
             return fetchedEntities
         } catch {
             return nil
         }
     }

    public func getEntityBy(id: UUID, name: String, context: NSManagedObjectContext) -> NSManagedObject? {
        let predicate = NSPredicate(format: "id == '\(id.uuidString)'")
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: name)
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.includesPendingChanges = true
        fetchRequest.predicate = predicate
        
        do {
            let _context = context
            let fetchedEntities = try _context.fetch(fetchRequest) as! [NSManagedObject]
            return fetchedEntities.first
        } catch {
            return nil
        }
    }
     
    public func getEntitity(entityName: String, filterKey: String, filterValue: String, context: NSManagedObjectContext) -> NSManagedObject? {
         
         let predicate = NSPredicate(format: "\(filterKey) == '\(filterValue)'")
         
         let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
         fetchRequest.returnsObjectsAsFaults = false
         fetchRequest.includesPendingChanges = true
         fetchRequest.predicate = predicate
         
         do {
            let _context = context
             let fetchedEntities = try _context.fetch(fetchRequest) as! [NSManagedObject]
             return fetchedEntities.first
         } catch {
             return nil
         }
     }
     
    public func getEntitity(entityName: String, filterKey: String, filterValueInt: Int, context: NSManagedObjectContext) -> NSManagedObject? {
         
         let predicate = NSPredicate(format: "\(filterKey) == \(filterValueInt)")
         
         let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
         fetchRequest.returnsObjectsAsFaults = false
         fetchRequest.includesPendingChanges = true
         fetchRequest.predicate = predicate
         
         do {
            let _context = context
             let fetchedEntities = try _context.fetch(fetchRequest) as! [NSManagedObject]
             return fetchedEntities.first
         } catch {
             return nil
         }
     }
     
    public func getEntitity(entityName: String, predicateString: String, context: NSManagedObjectContext) -> NSManagedObject? {
         
         let predicate = NSPredicate(format: predicateString)
         
         let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
         fetchRequest.returnsObjectsAsFaults = false
         fetchRequest.includesPendingChanges = true
         fetchRequest.predicate = predicate
         
         do {
            let _context = context
             let fetchedEntities = try _context.fetch(fetchRequest) as! [NSManagedObject]
             return fetchedEntities.first
         } catch {
             return nil
         }
     }
     
    public func getGroupedEntities(
        entityName: String,
        predicate: NSPredicate?,
        propertiesToGroupBy: [Any] = [],
        sortDescriptor: NSSortDescriptor,
        context: NSManagedObjectContext
     ) -> [NSManagedObject]? {
         let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        
         
         if propertiesToGroupBy.count > 0 {
             fetchRequest.propertiesToGroupBy = propertiesToGroupBy
             fetchRequest.propertiesToFetch = propertiesToGroupBy
             fetchRequest.resultType = .dictionaryResultType
             
         }
         fetchRequest.returnsObjectsAsFaults = false
         fetchRequest.predicate = predicate
         fetchRequest.sortDescriptors = [sortDescriptor]
         
         fetchRequest.fetchBatchSize = 25
         
         do {
            let _context = context
             let fetchedEntities = try _context.fetch(fetchRequest)
             print(fetchedEntities)
             return fetchedEntities as? [NSManagedObject]
         } catch {
             return nil
         }
     }
    
    public func remove(_ object: NSManagedObject, in context: NSManagedObjectContext) {
        context.delete(object)
    }

    // MARK: - Core Data stack
    
    lazy var modelName: String = {
        return "LanarsTestTask"
    }()

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: modelName)
        container.loadPersistentStores { (storeDescription, error) in
          if let error = error as NSError? {
            fatalError("Unresolved error \(error), \(error.userInfo)")
          }
        }

        return container
    }()

    lazy var applicationDocumentsDirectory: NSURL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1] as NSURL
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        let bundle = Bundle.main
        let modelURL = bundle.url(forResource: modelName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("LanarsTestTask.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "errorDomain", code: 9999, userInfo: dict)
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    func getMainContext() -> NSManagedObjectContext {
           return mainContext
       }

    private lazy var mainContext: NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    func getBackgroundContext() -> NSManagedObjectContext {
        return backgroundContext
    }
    
    private lazy var backgroundContext: NSManagedObjectContext = {
        let backgroundContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        backgroundContext.parent = mainContext
        return backgroundContext
    }()
    
    func createUniqueBackgroundContext() -> NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = backgroundContext
        context.automaticallyMergesChangesFromParent = true
        return context
    }
    
    public func saveUniqueContext(_ context: NSManagedObjectContext) {
        if context.hasChanges {
            do {
                try context.save()
                saveContext()
            } catch let error as NSError {
                fatalError("Error: \(error.localizedDescription)")
            }
        }
    }

    // MARK: - Core Data Saving support
    
    public func saveContext () {
        if backgroundContext.hasChanges {
            do {
                try self.backgroundContext.save()
                self.saveMainContext()
            } catch let error as NSError {
                fatalError("Error: \(error.localizedDescription)")
            }
        }
    }
    
    public func saveMainContext() {
        if mainContext.hasChanges {
            do {
                try self.mainContext.save()
            } catch let error as NSError {
                fatalError("Error: \(error.localizedDescription)")
            }
        }
    }
}
