import SwiftUI

@MainActor
final class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isLoggedIn: Bool = false
    @Published var errorMessage: String?

    func signUp() {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Please enter email and password."
            return
        }

        Task {
            do {
                let newUser = try await AuthenticationManager.shared.signUpUser(email: email, password: password)
                print("🎉 Account created successfully: \(newUser.email ?? "No Email")")
                isLoggedIn = true
                errorMessage = nil
            } catch {
                errorMessage = "Error: \(error.localizedDescription)"
            }
        }
    }

    func signIn() {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Please enter email and password."
            return
        }

        Task {
            do {
                let user = try await AuthenticationManager.shared.loginUser(email: email, password: password)
                print(" Logged in successfully: \(user.email ?? "No Email")")
                DispatchQueue.main.async { [self] in
                            isLoggedIn = true
                            errorMessage = nil
                        }
            } catch {
                print(" Login failed: \(error.localizedDescription)")
                DispatchQueue.main.async { [self] in
                            errorMessage = "Email/Password may be incorrect."
                        }
            }
        }
    }
}

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @State private var isPasswordVisible: Bool = false

    var body: some View {
        VStack {
            Spacer().frame(height: 20)

            Image(systemName: "shield.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(.blue)

            Text("Welcome Back")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top, 10)

            Text("Please enter your details.")
                .font(.subheadline)
                .foregroundColor(.gray)

            Spacer().frame(height: 20)

            // Google Button
            Button(action: {}) {
                HStack {
                    Image(systemName: "g.circle.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                    Text("Log in with Google")
                        .fontWeight(.medium)
                }
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.white)
                .cornerRadius(8)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
            }
            .padding(.horizontal, 20)

            // Apple Button
            Button(action: {}) {
                HStack {
                    Image(systemName: "applelogo")
                        .resizable()
                        .frame(width: 20, height: 20)
                    Text("Sign in with Apple")
                        .fontWeight(.medium)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.black)
                .cornerRadius(8)
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)

            // Separator
            HStack {
                Rectangle().frame(height: 1).foregroundColor(.gray.opacity(0.3))
                Text("or").font(.caption).foregroundColor(.gray)
                Rectangle().frame(height: 1).foregroundColor(.gray.opacity(0.3))
            }
            .padding(.horizontal, 30)
            .padding(.vertical, 10)

            // Email
            TextField("Email", text: $viewModel.email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 20)
                .autocapitalization(.none)
                .disableAutocorrection(true)

            // Password with eye icon
            ZStack(alignment: .trailing) {
                Group {
                    if isPasswordVisible {
                        TextField("Password", text: $viewModel.password)
                    } else {
                        SecureField("Password", text: $viewModel.password)
                    }
                }
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 20)
                .autocapitalization(.none)
                .disableAutocorrection(true)

                Button(action: {
                    isPasswordVisible.toggle()
                }) {
                    Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                        .foregroundColor(.gray)
                        .padding(.trailing, 30)
                }
            }
            .padding(.top, 5)

            // Error Message
            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(.caption)
                    .padding(.top, 5)
            }

            // Forgot Password
            HStack {
                Spacer()
                Button(action: {}) {
                    Text("Forgot password")
                        .font(.caption)
                        .foregroundColor(.blue)
                        .underline()
                }
                .padding(.trailing, 20)
            }
            .padding(.vertical, 5)

            Spacer().padding(.vertical, 5)

            // Login Button
            Button(action: {
                viewModel.signIn()
            }) {
                Text("Login")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)

            NavigationLink(destination: HomeView(),
                           isActive: $viewModel.isLoggedIn,
                           label: { EmptyView() })

            // Sign-up link
            HStack {
                Text("Don’t have an account?")
                    .font(.footnote)
                    .foregroundColor(.gray)

                Button(action: {
                    viewModel.signUp()
                }) {
                    Text("Sign up")
                        .font(.footnote)
                        .foregroundColor(.blue)
                        .fontWeight(.bold)
                }
            }
            .padding(.top, 10)

            Spacer()
        }
    }
}

struct LoginPageView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
