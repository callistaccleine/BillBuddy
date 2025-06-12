import SwiftUI
import MessageUI

struct InviteView: View {
    enum InviteMethod: String, CaseIterable, Identifiable {
        case share = "Share Link"
        case manual = "Send to Contact"
        var id: String { self.rawValue }
    }
    @State private var method: InviteMethod = .share
    @State private var contactInfo: String = ""
    @State private var showMailSheet = false
    @State private var showMessageSheet = false
    @State private var showAlert = false
    private let inviteURL = URL(string: "https://yourapp.com/download")!

    // MARK: - Validation
    private var trimmedContact: String {
        contactInfo.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var isValidEmail: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex)
            .evaluate(with: trimmedContact)
    }

    private var isValidAustralianPhone: Bool {
        let digits = trimmedContact.replacingOccurrences(of: "[^0-9+]", with: "", options: .regularExpression)
        let phoneRegex = "^(?:\\+?61|0)4\\d{8}$"
        return NSPredicate(format: "SELF MATCHES %@", phoneRegex)
            .evaluate(with: digits)
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Picker("Invite via", selection: $method) {
                    ForEach(InviteMethod.allCases) { method in
                        Text(method.rawValue).tag(method)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                Group {
                    if method == .share {
                        shareView
                    } else {
                        manualView
                    }
                }
                .animation(.default, value: method)
            }
            .padding(.vertical)
            .navigationTitle("Invite a Friend")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                }
            }
        }
        .sheet(isPresented: $showMailSheet) {
            MailComposeView(
                recipients: [trimmedContact],
                subject: "Join me on BillBuddy!",
                body: "Hi! Download BillBuddy here: \(inviteURL)"
            )
        }
        .sheet(isPresented: $showMessageSheet) {
            MessageComposeView(
                recipients: [trimmedContact],
                body: "Join me on BillBuddy! Download: \(inviteURL)"
            )
        }
    }

    // MARK: - Subviews
    private var shareView: some View {
        VStack(spacing: 20) {
            Spacer()
            Image(systemName: "person.crop.circle.badge.plus")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(.accentColor)
            Text("Invite your friends")
                .font(.title2).bold()
            Text("Learn together with friends")
                .font(.subheadline).foregroundColor(.secondary)
            Spacer()
            shareLinkButton
        }
    }

    @ViewBuilder
    private var shareLinkButton: some View {
        if #available(iOS 16.0, *) {
            ShareLink(
                item: inviteURL,
                subject: Text("Join me on BillBuddy!"),
                message: Text("Let's split bills easily with BillBuddy: \(inviteURL)")
            ) {
                Label("Share Link", systemImage: "square.and.arrow.up")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .padding(.horizontal)
        } else {
            Button(action: { showAlert = true }) {
                Label("Share Link", systemImage: "square.and.arrow.up")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .padding(.horizontal)
            .alert("Feature Unavailable", isPresented: $showAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("Upgrade to iOS 16 to use the native share sheet.")
            }
        }
    }

    private var manualView: some View {
        VStack(spacing: 20) {
            Spacer()
            TextField(
                "Enter email or phone number",
                text: $contactInfo
            )
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .keyboardType(method == .manual && isValidAustralianPhone ? .phonePad : .emailAddress)
            .autocapitalization(.none)
            .padding(.horizontal)

            HStack(spacing: 20) {
                Button(action: { showMailSheet = true }) {
                    Label("Email", systemImage: "envelope.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(isValidEmail ? .blue : .gray)
                .disabled(!isValidEmail || !MFMailComposeViewController.canSendMail())

                Button(action: { showMessageSheet = true }) {
                    Label("SMS", systemImage: "message.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(isValidAustralianPhone ? .blue : .gray)
                .disabled(!isValidAustralianPhone || !MFMessageComposeViewController.canSendText())
            }
            .padding(.horizontal)
            Spacer()
        }
    }
}

// MARK: - Mail Composer
struct MailComposeView: UIViewControllerRepresentable {
    var recipients: [String]
    var subject: String
    var body: String

    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let vc = MFMailComposeViewController()
        vc.setToRecipients(recipients)
        vc.setSubject(subject)
        vc.setMessageBody(body, isHTML: false)
        vc.mailComposeDelegate = context.coordinator
        return vc
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        let parent: MailComposeView
        init(parent: MailComposeView) { self.parent = parent }
        func mailComposeController(
            _ controller: MFMailComposeViewController,
            didFinishWith result: MFMailComposeResult,
            error: Error?
        ) {
            controller.dismiss(animated: true)
        }
    }
}

// MARK: - Message Composer
struct MessageComposeView: UIViewControllerRepresentable {
    var recipients: [String]
    var body: String

    func makeUIViewController(context: Context) -> MFMessageComposeViewController {
        let vc = MFMessageComposeViewController()
        vc.recipients = recipients
        vc.body = body
        vc.messageComposeDelegate = context.coordinator
        return vc
    }

    func updateUIViewController(_ uiViewController: MFMessageComposeViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    class Coordinator: NSObject, MFMessageComposeViewControllerDelegate {
        let parent: MessageComposeView
        init(parent: MessageComposeView) { self.parent = parent }
        func messageComposeViewController(
            _ controller: MFMessageComposeViewController,
            didFinishWith result: MessageComposeResult
        ) {
            controller.dismiss(animated: true)
        }
    }
}


#Preview {
    InviteView()
}

