import SwiftUI

struct MultiplayerHeaderView: View {
    
    @Binding var showMultiplayerOptions: Bool
    
    var body: some View {
        HStack {
            Button(action: {
                withAnimation(.easeIn(duration: 0.2))
                {
                    print("IM RUNNING")
                    showMultiplayerOptions = false
                }
            }) { Image(systemName: "chevron.left")
                    .foregroundColor(.white)
            }
            Spacer()
            Text("Play Together")
                .font(Font.custom("Inter-Bold", size: 24))
                .padding()
                .foregroundColor(.white)
            Spacer()
        }
        .frame(width:300)
    }
}
