import SwiftUI

struct RollPlayButtonStyling: ButtonStyle {
    var active: Bool
    var roll: Bool
    var text: String
    var rollCount: Int
    var isMyTurn: Bool
    var isPressed: Bool
    var dynamicFontSize: CGFloat {
        return UIDevice.current.userInterfaceIdiom == .pad ? 28 : 20
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            ZStack(alignment:.topLeading) {
                RoundedRectangle(cornerRadius: 8)
                    .frame(minHeight: 0, maxHeight: UIDevice.current.userInterfaceIdiom == .pad ? .infinity : 45)
                    .padding(.top, 7)
                    .padding(.leading, 7)
                    .foregroundColor(isMyTurn ? active ? isPressed ? Color.white : Color.black : Color.gray : Color.gray)
                RoundedRectangle(cornerRadius: 8)
                    .frame(minHeight: 0, maxHeight: UIDevice.current.userInterfaceIdiom == .pad ? .infinity : 45)
                    .foregroundColor(.white)
                    .padding(.bottom, UIDevice.current.userInterfaceIdiom == .pad ? 7 : 0)
                    .padding(.trailing, isMyTurn ? active ? isPressed ? 0 : 7 : 7 : 7)
                    .padding(.top, isMyTurn ? active ? isPressed ? 7 : 0 : 0 : 0)
                    .padding(.leading, isMyTurn ? active ? isPressed ? 7 : 0 : 0 : 0)
                    .overlay(
                        HStack {
                            Text(text)
                                .font(.custom("Inter-Bold", size: dynamicFontSize))
                                .opacity(isMyTurn ? active ? 1.0 : 0.5 : 0.5)
                            if roll {
                                RoundedRectangle(cornerRadius: 4)
                                    .frame(minHeight: 0, maxHeight: dynamicFontSize) 
                                    .frame(width: 22)
                                    .overlay(Text(String(rollCount))
                                        .foregroundColor(.white)
                                        .font(.custom("Inter-Bold", size: dynamicFontSize)))
                                    .opacity(isMyTurn ? active ? 1.0 : 0.5 : 0.5)
                            }
                        }
                        .padding(.trailing, isMyTurn ? active ? isPressed ? 0 : 7 : 7 : 7)
                        .padding(.top, isMyTurn ? active ? isPressed ? 7 : 0 : 0 : 0)
                    )
            }
    }
}
