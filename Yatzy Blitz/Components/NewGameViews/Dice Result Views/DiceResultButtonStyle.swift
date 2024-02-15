import SwiftUI

struct DiceResultButtonStyle: ButtonStyle {
    
    var selectedDice: Bool
    var result: Int
    var isMyTurn: Bool
    var isPressed: Bool
    var style: DiceButtonStyle

    func makeBody(configuration: Configuration) -> some View {
        let imageName: String
        
        if isMyTurn {
            if selectedDice {
                imageName = isPressed ? "\(result)Held" : "\(result)Selected"
            } else {
                imageName = result != 0 ? (isPressed ? "\(result)Held" : String(result)) : "BlankDice"
            }
        } else {
            imageName = selectedDice ? "\(result)Selected" : (result != 0 ? String(result) : "BlankDice")
        }
        
        let baseImage = Image(imageName)
            .resizable()
            .animation(nil)
        let isIpad = UIDevice.current.userInterfaceIdiom == .pad
        let maxWidth: CGFloat = isIpad ? 100 : .infinity
        
        switch style {
        case .portraitStyle:
            return AnyView(baseImage
                .aspectRatio(1, contentMode: .fill)
                .frame(maxWidth: maxWidth, minHeight: 0, maxHeight: isIpad ? 100 : 60)
            )
            
        case .landScapeStyle:
            return AnyView(baseImage
                .aspectRatio(1, contentMode: .fill)
                .frame(maxWidth: maxWidth, minHeight: 0, maxHeight: isIpad ? 100 : 60)
            )
        }
    }
}


enum DiceButtonStyle {
    case portraitStyle
    case landScapeStyle
}
