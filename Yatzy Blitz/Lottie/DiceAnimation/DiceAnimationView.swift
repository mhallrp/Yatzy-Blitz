import SwiftUI
import Lottie

struct DiceAnimationView: UIViewRepresentable {
  
    func makeUIView(context: Context) -> some UIView {
        let view = UIView()
        let animationView = LottieAnimationView(name: "whiteDice.json")
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.animationSpeed = 1
        animationView.play()
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        view.isUserInteractionEnabled = false

        // Modify these constraints to make the view 1/3 of its size
        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/3),
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/3),
            animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        return view
    }

    func updateUIView(_ uiView: UIViewType, context: UIViewRepresentableContext<DiceAnimationView>) {
        
    }
}
