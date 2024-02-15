import SwiftUI

struct EmoteButtonStyling: ButtonStyle {

    var isPressed: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
        ZStack(alignment: .topLeading){
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(isPressed ? .clear : .black)
                .frame(width:45,height: 45)
                .padding(.top,7)
                .padding(.leading,7)
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(.white)
                .frame(width: 45, height: 45)
                .overlay(Image("emoji"))
                .frame(width:45,height: 45)
                .padding(.top, isPressed ? 7 : 0)
                .padding(.leading, isPressed ? 7 : 0)
        }
    }
}
