//
//  DataStore.swift
//  Rockets
//
//  Created by Walter Fettich on 12/02/2021.
//

import UIKit
import CoreData

protocol DataStore: class {
  
  func saveOrUpdate(rockets:[Rocket])
  func addObserver(_ observer:@escaping DataChangedObserver)
  func load() -> [Rocket] 
}

class CoreDataStore  {
  
  // MARK: - Core Data stack
  
  private var observers:[DataChangedObserver] = []
  
  private var fetchedResultsController: NSFetchedResultsController<RocketCD>!

  private lazy var persistentContainer: NSPersistentContainer = {
      /*
       The persistent container for the application. This implementation
       creates and returns a container, having loaded the store for the
       application to it. This property is optional since there are legitimate
       error conditions that could cause the creation of the store to fail.
      */
      let container = NSPersistentContainer(name: "Rockets")
      container.loadPersistentStores(completionHandler: { (storeDescription, error) in
          if let error = error as NSError? {
              // Replace this implementation with code to handle the error appropriately.
              // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
               
              /*
               Typical reasons for an error here include:
               * The parent directory does not exist, cannot be created, or disallows writing.
               * The persistent store is not accessible, due to permissions or data protection when the device is locked.
               * The device is out of space.
               * The store could not be migrated to the current model version.
               Check the error message to determine what the actual problem was.
               */
              fatalError("Unresolved error \(error), \(error.userInfo)")
          }
      })
      return container
  }()

  // MARK: - Core Data Saving support

  private func save(context:NSManagedObjectContext? = nil) {
      let context = context ?? persistentContainer.viewContext
      if context.hasChanges {
          do {
              try context.save()
          } catch {
              // Replace this implementation with code to handle the error appropriately.
              // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
              let nserror = error as NSError
              fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
          }
      }
  }

  init() {
    NotificationCenter.default.addObserver(self, selector: #selector(handleEnterBackground), name: UIScene.didEnterBackgroundNotification, object: nil)
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  @objc func handleEnterBackground() {
    save(context:nil)
  }
      
  private func fetchRockets() -> [Rocket]? {
    try! fetchedResultsController.performFetch()
    let results = fetchedResultsController.fetchedObjects?.map{ Rocket(fromCoreData: $0) }
    return results
  }
  
  private func createFetchedResultsController(coreDataContainer:NSPersistentContainer) -> NSFetchedResultsController<RocketCD> {
    //fetch values from CoreData
    let ctxt = coreDataContainer.viewContext
    let dateSort = NSSortDescriptor(key: "firstFlight", ascending: true)
    let request:NSFetchRequest<RocketCD> = RocketCD.fetchRequest()
    request.sortDescriptors = [dateSort]
    let ctl = NSFetchedResultsController(fetchRequest: request, managedObjectContext: ctxt, sectionNameKeyPath: nil, cacheName: nil)
    return ctl
  }
}

extension CoreDataStore : DataStore {
  
  func saveOrUpdate(rockets:[Rocket]) {
    
    //save to CoreData
    let ctxt = self.persistentContainer.viewContext

    for rocket in rockets {
                            
      let req:NSFetchRequest<RocketCD> = RocketCD.fetchRequest()
      req.predicate = NSPredicate(format: "name == %@", rocket.name)
      req.returnsObjectsAsFaults = false
      let results = try? ctxt.fetch(req) as [RocketCD]
      
      if let foundRocket = results?.first {
        foundRocket.populateWith(rocket: rocket)
      } else {
        let rocketCD = NSManagedObject(entity: RocketCD.entity(),
                                     insertInto: ctxt) as! RocketCD
        rocketCD.populateWith(rocket:rocket)
      }
    }
    
    save(context:ctxt)
    
    for handler in observers {
      handler()
    }
  }
  
  func load() -> [Rocket] {
    if fetchedResultsController == nil {
      fetchedResultsController = createFetchedResultsController(coreDataContainer: self.persistentContainer)
    }
    return fetchRockets() ?? []
  }
  
  func addObserver(_ observer: @escaping DataChangedObserver) {
    observers.append(observer)
  }
}
