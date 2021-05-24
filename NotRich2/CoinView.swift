//
//  CoinView.swift
//  NotRich2
//
//  Created by Aritro Paul on 24/05/21.
//

import SwiftUI

struct CoinView: View {
    var coin: Crypto!
    var data: [Double]!
    
    init(coin: Crypto, data: [Double]) {
        self.coin = coin
        self.data = data
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 0) {
                Text(coin.name)
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                Text(coin.symbol)
                    .font(.system(size: 10, weight: .semibold, design: .rounded))
            }
            Spacer()
            GeometryReader{ reader in
                Line(data: data ?? [0.0],
                     frame: .constant(CGRect(x: 0, y: 0, width: reader.frame(in: .local).width, height: reader.frame(in: .local).height)))
                    .offset(x: 0, y: 0)
            }
            .frame(width: 100, height: 80)
            .offset(x: 0, y: -50)
            .padding([.horizontal], 24.0)
            Spacer()
            VStack(alignment: .trailing, spacing: 0) {
                let price = String(format: "$%.2f", coin.metrics.market_data.price_usd)
                let change = String(format: "%.2f", coin.metrics.market_data.percent_change_usd_last_24_hours)
                Text(price)
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                if coin.metrics.market_data.percent_change_usd_last_24_hours > 0 {
                    Text("+\(change)")
                        .font(.system(size: 10, weight: .semibold, design: .rounded))
                        .foregroundColor(.green)
                }
                else {
                    Text("\(change)")
                        .font(.system(size: 10, weight: .semibold, design: .rounded))
                        .foregroundColor(.red)
                }
            }
            
        }
        .padding([.top, .bottom], 24.0)
    }
}
