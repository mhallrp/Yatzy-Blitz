import SwiftUI

struct AlertButton: View {
    
    @Binding var showAlert: Bool
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var gameData: GameData
    
    var body: some View {
        Button(action: {
            gameData.paused = true
            self.showAlert = true
        }, label: {
            Image(systemName: "chevron.left")
                .foregroundColor(.black)
        })
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Warning"),
                  message: Text("If you go back, progress will be lost. Are you sure?"),
                  primaryButton: .default(Text("Cancel"), action: {
                gameData.paused = false
                showAlert = false
            }),
                  secondaryButton: .default(Text("Confirm").foregroundColor(.black), action: {
                gameData.cancelled = true
                gameData.paused = false
                self.gameData.resetToDefault()
                presentationMode.wrappedValue.dismiss()
            }))
        }
    }
}
