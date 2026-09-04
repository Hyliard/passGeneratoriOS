import SwiftUI

struct HomeView: View {
    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()

            VStack(spacing: 28) {
                Spacer(minLength: 24)

                Image(systemName: "lock.shield.fill")
                    .font(.system(size: 88, weight: .semibold))
                    .foregroundStyle(AppColors.accent)
                    .accessibilityHidden(true)

                VStack(spacing: 10) {
                    Text("Hyliard Password Generator")
                        .font(.largeTitle.bold())
                        .multilineTextAlignment(.center)

                    Text("Genera contraseñas seguras y personalizadas sin salir del dispositivo.")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal)

                NavigationLink {
                    PasswordGeneratorView()
                } label: {
                    Label("Ir al generador", systemImage: "key.fill")
                        .font(.headline)
                        .frame(maxWidth: .infinity, minHeight: 52)
                }
                .buttonStyle(.borderedProminent)
                .tint(AppColors.accent)
                .padding(.horizontal)
                .accessibilityHint("Abre las opciones para generar una contraseña.")

                Spacer(minLength: 24)
            }
        }
        .foregroundStyle(AppColors.primaryText)
    }
}

#Preview {
    HomeView()
}
