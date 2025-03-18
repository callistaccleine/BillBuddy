
import SwiftUI

final class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isLoggedIn: Bool = false
    @Published var errorMessage: String?

    // 🔹 Sign Up (Register a New User)
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
            } catch {
                errorMessage = "Error: \(error.localizedDescription)"
            }
        }
    }

    // Log In (Authenticate an Existing User)
    func signIn() {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Please enter email and password."
            return
        }

        Task {
            do {
                let user = try await AuthenticationManager.shared.loginUser(email: email, password: password)
                print("✅ Logged in successfully: \(user.email ?? "No Email")")
                isLoggedIn = true
            } catch {
                errorMessage = "Login failed: \(error.localizedDescription)"
            }
        }
    }
}


    

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    
    var body: some View {
        VStack {
            Spacer().frame(height: 20)
            
            // Logo
            Image(systemName: "shield.fill") // Replace with actual logo
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(.blue)
            
            // Welcome Text
            Text("Welcome Back")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top, 10)
            
            Text("Please enter your details.")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Spacer().frame(height: 20)
                        
            // Google Sign-in Button
            Button(action: {
                // Handle Google Sign-in
            }) {
                HStack {
                    Image(systemName: "g.circle.fill") // Google icon
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
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 1)
                )
            }
            .padding(.horizontal, 20)
            
            // Apple Sign-in Button
            Button(action: {
                // Handle Apple Sign-in
            }) {
                HStack {
                    Image(systemName: "applelogo") // Apple logo
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
            
            // OR Separator
            HStack {
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.gray.opacity(0.3))
                Text("or")
                    .font(.caption)
                    .foregroundColor(.gray)
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.gray.opacity(0.3))
            }
            .padding(.horizontal, 30)
            .padding(.vertical, 10)
            
            TextField("Email", text: $viewModel.email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 20)
            
            SecureField("Password", text: $viewModel.password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 20)
                .padding(.top, 5)
            
            
            // Forgot Password Button
            HStack {
                Spacer()
                Button(action: {
                    // Handle forgot password action
                }) {
                    Text("Forgot password")
                        .font(.caption)
                        .foregroundColor(.blue)
                        .underline()
                }
                .padding(.trailing, 20)
            }
            .padding(.vertical, 5)
            
            Spacer()
                .padding(.vertical,5)
            
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
