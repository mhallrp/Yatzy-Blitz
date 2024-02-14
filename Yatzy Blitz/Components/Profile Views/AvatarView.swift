import SwiftUI
import GameKit

struct AvatarView: View {
    
    @State private var avatarImage: UIImage? = nil

    var body: some View {
        ZStack {
            if let image = avatarImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(Color.white, lineWidth: 8)
                    )
            } else {
                Circle()
                    .foregroundColor(.gray)
                    .frame(width: 200, height: 200)
                    .overlay(
                        Circle()
                            .stroke(Color.white, lineWidth: 8)
                    )
            }
        }
        .onAppear {
            loadGameCenterAvatar()
        }
    }

    func loadGameCenterAvatar() {
        let localPlayer = GKLocalPlayer.local
        if localPlayer.isAuthenticated {
            localPlayer.loadPhoto(for: .normal) { [self] (image, error) in
                if let error = error {
                    print("Error loading Game Center avatar: \(error.localizedDescription)")
                } else if let image = image {
                    self.avatarImage = image
                }
            }
        }
    }
}
