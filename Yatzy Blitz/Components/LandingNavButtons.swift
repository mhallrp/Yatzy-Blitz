import SwiftUI

struct LandingNavButtons: View {
    @Binding var navigationPath: [NavigationDestination]

    var body: some View {
        HStack(spacing: 16) {
            Button(action: {
                self.navigationPath = [.settings]
            }) {
                Image(systemName: "gear")
                    .resizable()
                    .foregroundColor(.black)
                    .frame(width: 22, height: 22)
            }
            Button(action: {
                self.navigationPath = [.profile]
            }) {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .foregroundColor(.black)
                    .frame(width: 22, height: 22)
            }
        }
    }
}

