import SwiftUI

struct PointsView: View {
    
    @Binding var landscape:Bool
    @ObservedObject var gameData: GameData
    @ObservedObject var viewModel: MultiplayerModel
    
    var dynamicFontSize: CGFloat {
        return UIDevice.current.userInterfaceIdiom == .pad ? 28 : 20
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .customHeightForPointsView(landscape: landscape)
            .padding(.top, 16)
            .padding(.leading, 7)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .customHeightForPointsView(landscape: landscape)
                    .padding(.trailing, 7)
                    .foregroundColor(.white)
                    .overlay(
                        HStack(spacing: 0) {
                            let p1Total = gameData.player1Score.compactMap { $0 }.reduce(0, +) + gameData.player1BonusScore
                            let p2Total = gameData.player2Score.compactMap { $0 }.reduce(0, +) + gameData.player2BonusScore
                            HStack {
                                Text(playerName(1))
                                    .font(Font.custom("Inter-Black", size: dynamicFontSize))
                                    .foregroundColor(.black)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.5)
                                    .opacity(gameData.winner == nil ? gameData.p1Active ? 1.0 : 0.5 : 1.0)
                                Spacer()
                                Text(String(p1Total))
                                    .font(Font.custom("Inter-Black", size: dynamicFontSize))
                                    .foregroundColor(.black)
                                    .opacity(gameData.winner == nil ? gameData.p1Active ? 1.0 : 0.5 : 1.0)
                                    .padding(.trailing,16.0)
                            }
                            .frame(maxWidth: .infinity)
                            Spacer()
                            HStack {
                                Text(playerName(2))
                                    .font(Font.custom("Inter-Black", size: dynamicFontSize))
                                    .foregroundColor(.black)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.5)
                                    .opacity(gameData.winner == nil ? !gameData.p1Active ? 1.0 : 0.5 : 1.0)
                                Spacer()
                                Text(String(p2Total))
                                    .font(Font.custom("Inter-Black", size: dynamicFontSize))
                                    .foregroundColor(.black)
                                    .opacity(gameData.winner == nil ? !gameData.p1Active ? 1.0 : 0.5 : 1.0)
                                    .padding(.trailing,16.0)
                            }
                            .frame(maxWidth: .infinity)
                        }
                            .padding(.horizontal, 7.0)
                            .padding(8.0)
                    ))
            .padding(.trailing, -7)
            .padding(.bottom, landscape ? 0 : 8)
            .padding(.top,landscape ? 16 : 0)
    }
    
    func playerName(_ number: Int) -> String {
        let names = viewModel.getPlayerNames()
        if number == 1 {
            if viewModel.firstPLayer {
                return names.local ?? "Player 1"
            } else {
                return names.opponent ?? "Player 1"
            }
        } else {
            if viewModel.firstPLayer {
                return names.opponent ?? "Player 2"
            } else {
                return names.local ?? "Player 2"
            }
        }
    }
}


extension View {
    func customHeightForPointsView(landscape:Bool) -> some View {
        self.modifier(CustomHeightModifier(landscape: landscape))
    }
}

struct CustomHeightModifier: ViewModifier {
    @State var landscape:Bool
    func body(content: Content) -> some View {
        Group {
            if UIDevice.current.userInterfaceIdiom == .pad {
                content
                    .frame(height: landscape ? UIScreen.main.bounds.height * 0.075 : UIScreen.main.bounds.height * 0.05)
            } else {
                content
                    .frame(maxHeight: 38)
            }
        }
    }
}
