import SwiftUI
import UIKit

struct PasswordGeneratorView: View {
    @State private var length = 12
    @State private var options = PasswordOptions()
    @State private var password = ""
    @State private var copyConfirmation = ""

    private let generator = PasswordGenerator()

    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 22) {
                    Image("logohyliard")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 150)
                        .padding(.top, 12)
                        .accessibilityLabel("Logo de Hyliard")

                    VStack(spacing: 8) {
                        Text("Generador de Contraseñas")
                            .font(.title.bold())
                            .multilineTextAlignment(.center)

                        Text("Configura la longitud y los tipos de caracteres.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }

                    passwordPanel
                    optionsPanel
                    actionButtons
                }
                .padding(.horizontal)
                .padding(.bottom, 24)
            }
        }
        .foregroundStyle(AppColors.primaryText)
        .navigationTitle("Generador")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var passwordPanel: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Contraseña")
                    .font(.headline)

                Spacer()

                if !password.isEmpty {
                    Text(PasswordStrength(length: length, options: options).rawValue)
                        .font(.caption.bold())
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(AppColors.accent.opacity(0.18), in: Capsule())
                        .foregroundStyle(AppColors.accent)
                        .accessibilityLabel("Fortaleza \(PasswordStrength(length: length, options: options).rawValue)")
                }
            }

            Text(password.isEmpty ? "Aún no generada" : password)
                .font(.system(.title3, design: .monospaced).weight(.semibold))
                .textSelection(.enabled)
                .lineLimit(nil)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(16)
                .background(AppColors.surface, in: RoundedRectangle(cornerRadius: 8))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(AppColors.border)
                )
                .foregroundStyle(password.isEmpty ? .secondary : AppColors.primaryText)
                .accessibilityLabel(password.isEmpty ? "Contraseña aún no generada" : "Contraseña generada")
                .accessibilityValue(password.isEmpty ? "" : password)

            if !copyConfirmation.isEmpty {
                Label(copyConfirmation, systemImage: "checkmark.circle.fill")
                    .font(.footnote)
                    .foregroundStyle(AppColors.success)
                    .accessibilityAddTraits(.isStaticText)
            }
        }
        .padding(16)
        .background(AppColors.elevatedSurface, in: RoundedRectangle(cornerRadius: 8))
    }

    private var optionsPanel: some View {
        VStack(alignment: .leading, spacing: 18) {
            Stepper(value: $length, in: PasswordGenerator.allowedLengthRange) {
                Text("Longitud: \(length)")
                    .font(.headline)
            }
            .accessibilityValue("\(length) caracteres")

            Divider()

            categoryToggle("Minúsculas", systemImage: "textformat", isOn: binding(for: \.includeLowercase))
            categoryToggle("Mayúsculas", systemImage: "textformat.size", isOn: binding(for: \.includeUppercase))
            categoryToggle("Números", systemImage: "number", isOn: binding(for: \.includeNumbers))
            categoryToggle("Símbolos", systemImage: "curlybraces", isOn: binding(for: \.includeSymbols))
        }
        .padding(16)
        .background(AppColors.elevatedSurface, in: RoundedRectangle(cornerRadius: 8))
    }

    private var actionButtons: some View {
        VStack(spacing: 12) {
            Button {
                generatePassword()
            } label: {
                Label("Generar contraseña", systemImage: "arrow.clockwise")
                    .font(.headline)
                    .frame(maxWidth: .infinity, minHeight: 52)
            }
            .buttonStyle(.borderedProminent)
            .tint(AppColors.accent)

            Button {
                copyPassword()
            } label: {
                Label("Copiar contraseña", systemImage: "doc.on.doc")
                    .font(.headline)
                    .frame(maxWidth: .infinity, minHeight: 52)
            }
            .buttonStyle(.bordered)
            .disabled(password.isEmpty)
            .accessibilityHint(password.isEmpty ? "Genera una contraseña antes de copiar." : "Copia la contraseña al portapapeles.")
        }
    }

    private func categoryToggle(_ title: String, systemImage: String, isOn: Binding<Bool>) -> some View {
        Toggle(isOn: isOn) {
            Label(title, systemImage: systemImage)
                .labelStyle(.titleAndIcon)
        }
        .toggleStyle(.switch)
        .tint(AppColors.accent)
    }

    private func binding(for keyPath: WritableKeyPath<PasswordOptions, Bool>) -> Binding<Bool> {
        Binding(
            get: { options[keyPath: keyPath] },
            set: { newValue in
                var updatedOptions = options
                updatedOptions[keyPath: keyPath] = newValue

                guard updatedOptions.isValid else {
                    return
                }

                options = updatedOptions
                password = ""
                copyConfirmation = ""
            }
        )
    }

    private func generatePassword() {
        do {
            password = try generator.generate(length: length, options: options)
            copyConfirmation = ""
        } catch {
            password = ""
        }
    }

    private func copyPassword() {
        guard !password.isEmpty else {
            return
        }

        UIPasteboard.general.string = password
        copyConfirmation = "Contraseña copiada"
        UIAccessibility.post(notification: .announcement, argument: copyConfirmation)
    }
}

enum AppColors {
    static let background = Color(.systemGroupedBackground)
    static let elevatedSurface = Color(.secondarySystemGroupedBackground)
    static let surface = Color(.tertiarySystemGroupedBackground)
    static let primaryText = Color.primary
    static let border = Color.primary.opacity(0.12)
    static let accent = Color(red: 0.18, green: 0.58, blue: 0.42)
    static let success = Color(red: 0.16, green: 0.55, blue: 0.32)
}

#Preview {
    PasswordGeneratorView()
}
