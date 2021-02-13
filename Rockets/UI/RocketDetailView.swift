//
//  RocketDetailView.swift
//  Rockets
//
//  Created by Walter Fettich on 12/02/2021.
//

import SwiftUI

struct RocketDetailView: View {
  
  @ObservedObject var viewModel: RocketDetailViewModel
  var rocket: Rocket {
    viewModel.rocket
  }
    var body: some View {
      
      let badge = viewModel.badgeColor == .green ?  Color.green : viewModel.badgeColor == .orange ? Color.orange : Color.red
      
      NavigationView{
        VStack(content: {
            if let data = viewModel.imageData,
               let uiImage = UIImage(data: data) {
              Image(uiImage: uiImage)
                .resizable()
                .frame(width: 200, height: 200, alignment: .center)
                .background(Color.green)
            } else {
              Text("Waiting for image ...")
            }
          badge.frame(width: 50, height: 50, alignment: .center)
          Spacer()
            .frame(height: 10)
          Group {
            Text("Name: \(rocket.name) ")
            Spacer()
              .frame(height: 10)
            Text("Success rate: \(rocket.successRate)")
            Spacer()
              .frame(height: 10)
            Text("Active: \( rocket.active ? "active" : "inactive")")
            Spacer()
              .frame(height: 10)
            Text("Country: \( rocket.country)")
            Spacer()
              .frame(height: 10)
          }
          Group {
            Text("\( rocket.description)")
              .lineLimit(100)
              .frame(maxHeight: .infinity)
              .padding()
            Text("First flight: \(rocket.firstFlightFormatted() ?? "")" )
            Spacer()
              .frame(height: 10)
            Text("Cost per launch: \( rocket.costPerLaunchFormatted())")
            Spacer().frame(height: 10)
            Button("Wikipedia") {
              viewModel.openWikipedia()
            }
          }
          Spacer().frame(minHeight: 10)
        })
//        .background(Color.green)
      }
      .navigationBarTitle(Text("\(rocket.name)"), displayMode: .inline)
      .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct RocketDetailView_Previews: PreviewProvider {
    static var previews: some View {
      RocketDetailView(viewModel: RocketDetailViewModel(rocket: .dummy, imageService: .shared, openURL:{ _ in }))
    }
}
