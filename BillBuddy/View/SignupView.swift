import SwiftUI

final class SignUpViewModel: ObservableObject {
    @Published var fullName: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var isSignedUp: Bool = false
    @Published var errorMessage: String?

    // 🔹 Sign Up (Register a New User)
    func signUp() {
        guard !fullName.isEmpty, !email.isEmpty, !password.isEmpty, !confirmPassword.isEmpty else {
            errorMessage = "Please fill in all fields."
            return
        }

        guard password == confirmPassword else {
            errorMessage = "Passwords do not match."
            return
        }

        Task {
            do {
                let newUser = try await AuthenticationManager.shared.signUpUser(email: email, password: password)
                print("🎉 Account created successfully: \(newUser.email ?? "No Email")")
                isSignedUp = true
            } catch {
                errorMessage = "Error: \(error.localizedDescription)"
            }
        }
    }
}

struct SignUpView: View {
    @StateObject private var viewModel = SignUpViewModel()
    @State private var selectedTab: String = "Register"
    @State private var isPasswordVisible: Bool = false
    @State private var isConfirmPasswordVisible: Bool = false

    var body: some View {
        VStack {
            Spacer().frame(height: 30)

            // Title
            Text("Create an account")
                .font(.title2)
                .fontWeight(.bold)

            // Segmented Control
            HStack {
                Button(action: {
                    // Navigate to Login
                }) {
                    Text("Login")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(selectedTab == "Login" ? Color.white : Color.clear)
                        .foregroundColor(.black)
                        .cornerRadius(25)
                }
                
                Button(action: {
                    selectedTab = "Register"
                }) {
                    Text("Register")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(selectedTab == "Register" ? Color.blue : Color.clear)
                        .foregroundColor(selectedTab == "Register" ? .white : .black)
                        .cornerRadius(25)
                }
            }
            .frame(maxWidth: .infinity)
            .background(Color.white.opacity(0.3))
            .cornerRadius(25)
            .padding(.horizontal, 40)
            .padding(.top, 10)

            // Input Fields
            VStack(spacing: 15) {
                CustomTextField(placeholder: "Full Name", text: $viewModel.fullName)
                CustomTextField(placeholder: "Email", text: $viewModel.email, keyboardType: .emailAddress)

                // Password Fields
                PasswordField(placeholder: "Password", text: $viewModel.password, isSecure: !isPasswordVisible)
                    .overlay(
                        HStack {
                            Spacer()
                            Button(action: { isPasswordVisible.toggle() }) {
                                Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                                    .foregroundColor(.gray)
                            }
                            .padding(.trailing, 15)
                        }
                    )

                PasswordField(placeholder: "Confirm Password", text: $viewModel.confirmPassword, isSecure: !isConfirmPasswordVisible)
                    .overlay(
                        HStack {
                            Spacer()
                            Button(action: { isConfirmPasswordVisible.toggle() }) {
                                Image(systemName: isConfirmPasswordVisible ? "eye.slash" : "eye")
                                    .foregroundColor(.gray)
                            }
                            .padding(.trailing, 15)
                        }
                    )
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)

            // Sign Up Button
            Button(action: {
                viewModel.signUp()
            }) {
                Text("Create account")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(25)
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)

            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.footnote)
                    .padding(.top, 5)
            }

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

// MARK: - Custom Text Fields
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
    }
}

// MARK: - Password Field
struct PasswordField: View {
    var placeholder: String
    @Binding var text: String
    var isSecure: Bool

    var body: some View {
        ZStack {
            if isSecure {
                SecureField(placeholder, text: $text)
                    .padding(15)
                    .background(Color.white)
                    .cornerRadius(25)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
            } else {
                TextField(placeholder, text: $text)
                    .padding(15)
                    .background(Color.white)
                    .cornerRadius(25)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
            }
        }
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
