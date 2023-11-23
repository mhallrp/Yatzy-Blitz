import SwiftUI

struct BonusScoreView: View {
    
    var bonusScores1: [Int?]
    var bonusScores2: [Int?]
    var active: Bool
    let helpers = Helpers()
    
    var dynamicFontSize: CGFloat {
        return UIDevice.current.userInterfaceIdiom == .pad ? 36 : 24
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .foregroundColor(.white)
            .frame(minHeight: 45, maxHeight: UIDevice.current.userInterfaceIdiom == .pad ? 100 : .infinity)
    
            .overlay(
                HStack {
    
                    Image("Bonus35")
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                        .padding(.leading, 8)
                        .padding(.vertical, helpers.isSmallScreenHeightDevice() ? 5 : 0 )
                    generateCircleView(scores: bonusScores1, active: active)
                        .padding(.horizontal, 4)
                        .padding(.vertical, helpers.isSmallScreenHeightDevice() ? 5 : 0 )
                    generateCircleView(scores: bonusScores2, active: !active)
                        .padding(.trailing, 8)
                        .padding(.vertical, helpers.isSmallScreenHeightDevice() ? 5 : 0 )
                }
                    .padding(.vertical, UIDevice.current.userInterfaceIdiom == .pad ? 8 : 0)
            )
    }
    
    
    private func generateCircleView(scores: [Int?], active:Bool) -> some View {
        Circle()
            .strokeBorder(active ? .black : .gray, lineWidth: 4)
            .aspectRatio(1, contentMode: .fit)
            .background(Circle().fill( active ? .white : Color(UIColor(red: 0.92, green: 0.92, blue: 0.92, alpha: 1.00))))
            .overlay(
                Text(computeScoreText(scores: scores))
                    .font(.custom("Inter-Black", size: dynamicFontSize))
                    .multilineTextAlignment(.center)
                    .foregroundColor(active ? .black : .gray)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .padding(.horizontal, 2)
            )
    }
    
    private func computeScoreText(scores: [Int?]) -> String {
        let totalScore = scores.compactMap { $0 }.reduce(0, +)
        if totalScore != 0 {
            return totalScore > 62 ? "\(totalScore + 35)" : "\(totalScore)"
        }
        return ""
    }
}



