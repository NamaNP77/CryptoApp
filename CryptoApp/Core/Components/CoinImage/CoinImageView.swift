//
//  CoinImageView.swift
//  CryptoApp
//
//  Created by NamaN  on 06/09/23.
//

import SwiftUI



struct CoinImageView: View {
    
    @StateObject var vm : CoinImageViewModel
    
    init(coin : CoinModel) {
        _vm = StateObject(wrappedValue: CoinImageViewModel(coin: coin))
    }
    
    var body: some View {
        ZStack{
            if let image = vm.image{
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            }else if vm.isLoading == true{
                ProgressView()
            }
            else{
                Image(systemName: "questionmark")
                    .foregroundColor(.theme.secondaryText)
                
            }
        }
    }
}

struct CoinImageView_Previews: PreviewProvider {
    static var previews: some View {
        CoinImageView(coin: dev.coin)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
