//
//  ViewController.swift
//  Rockets
//
//  Created by Walter Fettich on 11/02/2021.
//

import UIKit

class RocketListViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var viewProgress: UIProgressView!
  
  var viewModel:RocketListViewModel!
  var gotoNextScreen:((Rocket)->Void)?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
   
    tableView.dataSource = self
    tableView.delegate = self
    
    self.title = "SpaceX Rockets"
    
    viewModel.onSelectedRocket = {
      rocket in
      self.gotoNextScreen?(rocket)
    }
  }
    
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    assert(viewModel != nil)
    
    viewModel.updateView = { [weak self] in
      self?.update()
    }
    viewModel.fetch()
  }
  
  func update() {
    self.tableView.reloadData()
  }
  
  func updateProgress(_ progress: Double) {
    viewProgress.setProgress(Float(progress), animated: true)
  }
}

extension RocketListViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    viewModel.rockets?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RocketListTableViewCell.self)) as! RocketListTableViewCell
    
      if let rocket = viewModel.rockets?[indexPath.row] {
        let cellData = viewModel.rocketPresentation(rocket: rocket)
        cell.populateWith(cellData)
      
      if let imageURL = rocket.imageURLs.first,
         let url = URL(string:imageURL) {
        ImageDownloaderService.shared.downloadImageFor(url:url,
            onSuccess:{
          imageData in
              cell.rocketImage.image = UIImage(data: imageData)
        })
      }
    }    
    return cell
  }
}

extension RocketListViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    viewModel.selectRocket(at: indexPath.row)
  }
}

class RocketListTableViewCell : UITableViewCell {
  
  @IBOutlet weak var viewSuccessBadge: UIView!
  @IBOutlet weak var labelName: UILabel!
  @IBOutlet weak var labelFirstFlight: UILabel!
  @IBOutlet weak var rocketImage: UIImageView!
  
  func populateWith(_ cellData:RocketListCellPresentation) {
    labelName.text = cellData.name
    labelFirstFlight.text = cellData.launchDate
    viewSuccessBadge.backgroundColor = cellData.badgeColor == .green ? .green :
      cellData.badgeColor == .orange ? .orange : .red
  }
}
