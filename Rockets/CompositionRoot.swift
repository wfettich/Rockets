//
//  CompositionRoot.swift
//  Rockets
//
//  Created by Walter Fettich on 12/02/2021.
//

import UIKit

typealias DataChangedObserver = () -> Void

class CompositionRoot: NSObject {
 
  let service:RocketsService = AlamoRocketsService()
  let store:DataStore = CoreDataStore()
  let rocketListViewController:RocketListViewController
  
  required init(rocketListViewController:RocketListViewController) {
    self.rocketListViewController = rocketListViewController
    super.init()
    
    let listViewModel = createListViewModel()
    rocketListViewController.viewModel = listViewModel
    
    rocketListViewController.gotoNextScreen = {
      rocket in
      self.openDetailFor(rocket: rocket)
    }
  }
  
  func start() {
    service.downloadRockets (completion:{
      (rockets, err) in
      if let rockets = rockets {
        self.store.saveOrUpdate(rockets: rockets)
      }
    }, progress: { [self] fraction in
      self.rocketListViewController.updateProgress(fraction)
    })
  }
  
  private func createListViewModel() -> RocketListViewModel {
    let rocketFetcher: RocketListViewModel.RocketFetcher = {
      return self.store.load()
    }
    let listViewModel =  RocketListViewModel(rocketFetcher: rocketFetcher)
    if let obs = listViewModel.dataObserver {
      store.addObserver(obs)      
    }
    return listViewModel
  }
  
  private func openDetailFor(rocket:Rocket) {
    let openURL:RocketDetailViewModel.OpenURL = {
      url in
      UIApplication.shared.open(url, options: [:])
    }
    let contentView = RocketDetailView(viewModel: RocketDetailViewModel(rocket: rocket, openURL: openURL))
    let detailView = RocketDetailViewController(rootView:contentView)
    rocketListViewController.navigationController?.pushViewController(detailView, animated: true)
  }
}
