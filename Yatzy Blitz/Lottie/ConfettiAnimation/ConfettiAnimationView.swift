
import SwiftUI
import Lottie

struct ConfettiAnimationView: UIViewRepresentable{

    func makeUIView(context: Context) -> some UIView {
        let view = UIView()
        
        let animationView = LottieAnimationView(name: "confetti.json")
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .playOnce
        animationView.animationSpeed = 1
        animationView.play()
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        view.isUserInteractionEnabled = false

        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        return view
    }

    
    func updateUIView(_ uiView: UIViewType, context: UIViewRepresentableContext<ConfettiAnimationView>) {
        
    }
}
