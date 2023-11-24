import SwiftUI
import StoreKit

@main

struct YatzyBlitzApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            LandingView()
                .preferredColorScheme(.light)
                .onAppear(perform: authenticateUser)
        }
    }

    func authenticateUser() {
        DispatchQueue.main.async {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let rootViewController = windowScene.windows.first?.rootViewController {
                GameCenterManager.shared.authenticateLocalPlayer(presentingVC: rootViewController)
            }
        }
    }
}
