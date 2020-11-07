//
//  ContentView.swift
//  FetchDataFromAPIBySwiftUI
//
//  Created by chen Ivan on 2020/11/7.
//

import SwiftUI

struct ContentView: View {
  @State var cityName: String = ""
  @State var keyword: String = ""
  
  var body: some View {
    ZStack {
      VStack {
        VStack {
          Text(self.cityName)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
        }
        Spacer()
        VStack {
          TextField("Enter your city name", text: $keyword)
            .keyboardType(.default)
          Divider()
          Button(action: {
            self.endEditing(true)
            if keyword != "" {
              self.cityName = keyword
              keyword = ""
            }
          }) {
            Text("Search")
              .frame(minWidth: 0, maxWidth: .infinity)
          }
        }      }.padding()
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}

extension View {
  func endEditing(_ force: Bool) {
    UIApplication.shared.windows.forEach { $0.endEditing(force)}
  }
}
