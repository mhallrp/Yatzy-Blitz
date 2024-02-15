import SwiftUI
import Foundation

struct OrientationLockingView: UIViewControllerRepresentable {
    var orientation: UIInterfaceOrientationMask
    
    func makeUIViewController(context: Context) -> CustomOrientationViewController {
        CustomOrientationViewController(orientation: orientation)
    }
    
    func updateUIViewController(_ uiViewController: CustomOrientationViewController, context: Context) {
        uiViewController.updateOrientation(to: orientation)
    }
}


class CustomOrientationViewController: UIViewController {
    private var customOrientation: UIInterfaceOrientationMask = .all
    
    init(orientation: UIInterfaceOrientationMask) {
        self.customOrientation = orientation
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return customOrientation
    }
    
    func updateOrientation(to orientation: UIInterfaceOrientationMask) {
        customOrientation = orientation
        setNeedsUpdateOfSupportedInterfaceOrientations()
    }
}
