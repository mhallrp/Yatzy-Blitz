import SwiftUI

struct BackgroundView: View {
    @AppStorage ("backgroundImage") var backgroundImage = "redGradientBackground"
    var body: some View {
        Image(backgroundImage)
            .resizable()
            .ignoresSafeArea()
    }
}

struct BackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundView()
    }
}
