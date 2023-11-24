import SwiftUI
import GameKit

struct ProfileView: View {
    
    @State var pressed = false
    
    var body: some View {
        ZStack{
            BackgroundView()
            ScrollView(showsIndicators: false) {
                VStack{
                    AvatarView()
                        .padding(.vertical, 32)
                    VStack{
                        StatsView(category: "Games", statistic: String(StatsModel.shared.retrieveStat(value: "games")))
                        StatsView(category: "Won", statistic: String(StatsModel.shared.retrieveStat(value: "won")))
                        StatsView(category: "Lost", statistic: String(StatsModel.shared.retrieveStat(value: "lost")))
                        StatsView(category: "Draw", statistic: String(StatsModel.shared.retrieveStat(value: "draw")))
                    }
                    .padding(.bottom,12)
                    Button(action: {
                        withAnimation(.easeIn(duration: 0.2)) {
                            presentGameCenterDashboard()
                        }
                    }) {}
                        .pressAction { pressed = true }
                onRelease: { pressed = false }
                        .buttonStyle(MainButtonView(text: "Game Center Dashboard", isPressed: pressed))
                    Spacer()
                    Text("Ensure iCloud is enabled in Settings if you encounter any issues with your statistics.")
                        .font(.caption)
                        .foregroundColor(.white)
                        .padding([.leading, .trailing], 16)
                        .padding(.vertical, 16)
                }
            }
            .navigationBarTitle("Profile")
        }
    }
    
    func presentGameCenterDashboard() {
        let gameCenterVC = GKGameCenterViewController()
        let delegate = GameCenterDashboardDelegate()
        gameCenterVC.gameCenterDelegate = delegate
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            objc_setAssociatedObject(gameCenterVC, &GameCenterDashboardDelegateAssociationKey, delegate, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            rootVC.present(gameCenterVC, animated: true, completion: nil)
        }
    }
}

private var GameCenterDashboardDelegateAssociationKey: UInt8 = 1

class GameCenterDashboardDelegate: NSObject, GKGameCenterControllerDelegate {
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
}
