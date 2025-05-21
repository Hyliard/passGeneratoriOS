//
//  HomeView.swift
//  passGenerator
//
//  Created by Luis Martinez on 20/05/2025.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack(spacing: 40) {
            
            Spacer()
            
            Image(systemName: "lock.shield")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.white)
            
            Text("Generador de Contraseñas Aleatorias")
                .font(.title2)
                .bold()
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .padding(.horizontal)
            
            NavigationLink(destination: PasswordGeneratorView()) {
                Text("Ir al Generador")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            
            Spacer()
        }
        .background(Color(.darkGray))
        .ignoresSafeArea()
    }
}

#Preview {
    HomeView()
}

