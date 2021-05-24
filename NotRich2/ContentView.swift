//
//  ContentView.swift
//  NotRich2
//
//  Created by Aritro Paul on 24/05/21.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var model: Model
    
    var body: some View {
        HStack {
            List(model.data) { coin in
                CoinView(coin: coin, data: model.series[coin.slug] ?? [0.0])
                
            }
        }
        .frame(width: 400, height: 600.0)
        .navigationTitle("Not Rich 2: The Dip")
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
