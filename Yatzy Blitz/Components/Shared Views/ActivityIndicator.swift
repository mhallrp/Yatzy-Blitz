import SwiftUI

struct ActivityIndicator: UIViewRepresentable {
    var style = UIActivityIndicatorView.Style.medium
    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(style: style)
        indicator.startAnimating()
        indicator.tintColor = .black
        indicator.color = .black
        return indicator
    }
    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {}
}
