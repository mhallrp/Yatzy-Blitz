import SwiftUI

struct StatsView: View {
    
    var category: String
    var statistic: String
    
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .overlay(
                HStack{
                    Text(category)
                        .font(Font.custom("Inter-Black", size: 20))
                        .foregroundColor(.black)
                        .padding(.leading)
                    Spacer()
                    Text(statistic)
                        .font(Font.custom("Inter-Black", size: 20))
                        .foregroundColor(.black)
                        .padding(.trailing)
                }
            )
            .foregroundColor(.white)
            .frame(width:301, height:48)
            .padding(.vertical,4)
    }
}
