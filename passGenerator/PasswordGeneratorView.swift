//
//  PasswordGeneratorView.swift
//  passGenerator
//
//  Created by Luis Martinez on 20/05/2025.
//

import SwiftUI

struct PasswordGeneratorView: View {
    @State private var length: Double = 12
    @State private var includeLowercase = true
    @State private var includeUppercase = true
    @State private var includeNumbers = true
    @State private var includeSymbols = true
    @State private var password = ""

    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                
                Image("logohyliard")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 160, height: 160)
                    .padding(50)
                
                Text("Generador de Contraseñas")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.white)

                TextField("Contraseña generada", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disabled(true)
                    .padding(.horizontal)

                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("Longitud: \(Int(length))")
                            .foregroundColor(.white)
                        Spacer()
                        Stepper("", value: $length, in: 4...32)
                    }
                    
                    Toggle("Minúsculas", isOn: $includeLowercase)
                        .toggleStyle(SwitchToggleStyle(tint: .green))
                        .foregroundColor(.white)

                    Toggle("Mayúsculas", isOn: $includeUppercase)
                        .toggleStyle(SwitchToggleStyle(tint: .green))
                        .foregroundColor(.white)

                    Toggle("Números", isOn: $includeNumbers)
                        .toggleStyle(SwitchToggleStyle(tint: .green))
                        .foregroundColor(.white)

                    Toggle("Caracteres especiales", isOn: $includeSymbols)
                        .toggleStyle(SwitchToggleStyle(tint: .green))
                        .foregroundColor(.white)
                }
                .padding(.horizontal)

                Button("Generar Contraseña") {
                    password = generatePassword()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.horizontal)

                Button("Copiar Contraseña") {
                    UIPasteboard.general.string = password
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.horizontal)

            }
            .padding(.vertical)
        }
        .background(Color(.darkGray))
        .ignoresSafeArea()
    }

    func generatePassword() -> String {
        let lowercase = "abcdefghijklmnopqrstuvwxyz"
        let uppercase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let numbers = "0123456789"
        let symbols = "!@#$%^&*()_-+=<>?/|"

        var characters = ""

        if includeLowercase { characters += lowercase }
        if includeUppercase { characters += uppercase }
        if includeNumbers { characters += numbers }
        if includeSymbols { characters += symbols }

        guard !characters.isEmpty else { return "⚠️ Selecciona opciones" }

        return String((0..<Int(length)).compactMap { _ in characters.randomElement() })
    }
}

#Preview {
    PasswordGeneratorView()
}

