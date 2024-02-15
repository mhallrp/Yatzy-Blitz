import SwiftUI

struct MainButtonView: ButtonStyle {
    
    let text: String
    var isPressed:Bool
    
    func makeBody(configuration: Configuration) -> some View {
        ZStack(alignment:.topLeading) {
            RoundedRectangle(cornerRadius: 8)
                .padding([.top, .leading], 7.0)
                .frame(width: 301, height: 55)
                .foregroundColor(isPressed ? .white : .black)
            RoundedRectangle(cornerRadius: 8)
                .padding([.top, .leading], isPressed ? 7.0 : 0.0)
                .frame(width: isPressed ? 301 : 294, height: isPressed ? 55 : 48)
                .foregroundColor(.white)
                .overlay(
                    Text(text)
                        .font(Font.custom("Inter-Bold", size: 20))
                        .foregroundColor(.black)
                )
        }
    }
}
