import SwiftUI

struct WaitingForRematchView: View {
    
    @Binding var waitingForRematchConfirmation:Bool
    @Binding var customAlertMessage:String
    
    var body: some View {
        ZStack{
            Color.black.opacity(0.2)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Text(customAlertMessage)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                ActivityIndicator()
                    .scaleEffect(1.5)
                Button(action: {
                    waitingForRematchConfirmation = false
                }) {
                    Text("Close")
                        .foregroundColor(.black)
                        .padding(.horizontal, 30)
                        .padding(.vertical, 10)
                        .background(Color.gray.opacity(0.3))
                        .cornerRadius(10)
                }
            }
            .padding(30)
            .background(Color.white)
            .cornerRadius(20)
        }
    }
}
