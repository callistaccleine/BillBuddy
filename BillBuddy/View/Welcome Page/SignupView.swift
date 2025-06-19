import SwiftUI
import FirebaseFirestore

final class SignUpViewModel: ObservableObject {
    @Published var fullName: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var errorMessage: String?
    @Published var isRegistered: Bool = false

    func register() {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Please fill in all fields."
            return
        }

        guard password == confirmPassword else {
            errorMessage = "Passwords do not match."
            return
        }

        Task {
                do {
                    let user = try await AuthenticationManager.shared.signUpUser(email: email, password: password)

                    // Store full name to Firestore and UserDefaults
                    let uid = user.uid
                    let db = Firestore.firestore()
                    try await db.collection("users").document(uid).setData([
                        "fullName": fullName,
                        "email": email
                    ])

                    UserDefaults.standard.set(fullName, forKey: "currentUserName")

                    DispatchQueue.main.async {
                        self.isRegistered = true
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.errorMessage = "Error: \(error.localizedDescription)"
                    }
                }
            }
        }
    }

struct SignUpView: View {
    @StateObject private var viewModel = SignUpViewModel()
    @State private var showPassword: Bool = false
    @State private var showConfirmPassword: Bool = false

    var body: some View {
        NavigationView {
            VStack {
                Spacer().frame(height: 30)

                // Title
                Text("Create an account")
                    .font(.title2)
                    .fontWeight(.bold)

                // Segmented Control
                HStack {
                    NavigationLink(destination: LoginView()) {
                        Text("Login")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .foregroundColor(.black)
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(Color.black.opacity(0.2), lineWidth: 1)
                            )
                    }

                    Text("Register")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(25)
                }
                .padding(.horizontal, 40)
                .padding(.top, 10)

                // Input Fields
                VStack(spacing: 15) {
                    CustomTextField(placeholder: "Full Name", text: $viewModel.fullName)
                    CustomTextField(placeholder: "Email", text: $viewModel.email, keyboardType: .emailAddress)
                        .autocapitalization(.none)

                    PasswordField(placeholder: "Password", text: $viewModel.password, isVisible: $showPassword)

                    PasswordField(placeholder: "Confirm Password", text: $viewModel.confirmPassword, isVisible: $showConfirmPassword)
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)

                // Error Message
                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.footnote)
                        .padding(.top, 5)
                }

                // Create Account Button
                Button(action: {
                    viewModel.register()
                }) {
                    Text("Create Account")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(25)
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)

                // Navigation to LoginView on success
                NavigationLink(destination: LoginView(),
                               isActive: $viewModel.isRegistered,
                               label: { EmptyView() }
                )

                // OR Separator
                HStack {
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.gray.opacity(0.3))
                    Text("or continue with")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.gray.opacity(0.3))
                }
                .padding(.horizontal, 30)
                .padding(.vertical, 10)

                // Google & Apple Buttons
                HStack(spacing: 20) {
                    SocialLoginButton(imageName: "g.circle.fill", text: "Google", backgroundColor: .white, foregroundColor: .black)
                    SocialLoginButton(imageName: "applelogo", text: "Apple", backgroundColor: .black, foregroundColor: .white)
                }
                .padding(.horizontal, 20)

                Spacer()
            }
            .padding()
        }
    }
}

// MARK: - Custom Text Field
struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default

    var body: some View {
        TextField(placeholder, text: $text)
            .padding(15)
            .background(Color.white)
            .cornerRadius(25)
            .overlay(
                RoundedRectangle(cornerRadius: 25)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
            .keyboardType(keyboardType)
            .autocapitalization(.none)
            .disableAutocorrection(true)
    }
}

// MARK: - Password Field
struct PasswordField: View {
    var placeholder: String
    @Binding var text: String
    @Binding var isVisible: Bool

    var body: some View {
        HStack {
            Group {
                if isVisible {
                    TextField(placeholder, text: $text)
                } else {
                    SecureField(placeholder, text: $text)
                }
            }
            Button(action: { isVisible.toggle() }) {
                Image(systemName: isVisible ? "eye.slash" : "eye")
                    .foregroundColor(.gray)
            }
        }
        .padding(15)
        .background(Color.white)
        .cornerRadius(25)
        .overlay(
            RoundedRectangle(cornerRadius: 25)
                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
        )
        .autocapitalization(.none)
        .disableAutocorrection(true)
    }
}

// MARK: - Social Login Button
struct SocialLoginButton: View {
    var imageName: String
    var text: String
    var backgroundColor: Color
    var foregroundColor: Color

    var body: some View {
        Button(action: {
            // Handle social login
        }) {
            HStack {
                Image(systemName: imageName)
                    .resizable()
                    .frame(width: 20, height: 20)
                Text(text)
                    .fontWeight(.medium)
            }
            .foregroundColor(foregroundColor)
            .frame(maxWidth: .infinity)
            .padding()
            .background(backgroundColor)
            .cornerRadius(25)
            .overlay(
                RoundedRectangle(cornerRadius: 25)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
