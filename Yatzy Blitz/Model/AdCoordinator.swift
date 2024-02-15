import GoogleMobileAds
import SwiftUI

class AdCoordinator: NSObject, ObservableObject, GADFullScreenContentDelegate {
    
    private var ad: GADInterstitialAd?
    @Published var adShown: Bool = false
    @Published var adReady: Bool = false
    @Published var adFailed: Bool = false

    func loadAd() {
        GADInterstitialAd.load(
            withAdUnitID: "ca-app-pub-1067528508711342/7241009509", request: GADRequest()
        ) { ad, error in
            if let error = error {
                self.adFailed = true
                return print("Failed to load ad with error: \(error.localizedDescription)")
                
            }
            self.ad = ad
            self.ad?.fullScreenContentDelegate = self
            self.adReady = true
        }
    }
    
    func adDidRecordImpression(_ ad: GADFullScreenPresentingAd) {
        print("\(#function) called")
    }
    
    func adDidRecordClick(_ ad: GADFullScreenPresentingAd) {
        print("\(#function) called")
    }
    
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        self.adFailed = true
        print("\(#function) called")
    }
    
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("\(#function) called")
    }
    
    func adWillDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        DispatchQueue.main.async {
            self.adShown = true
        }
        print("\(#function) called")
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("\(#function) called")
    }
    
    func presentAd(from viewController: UIViewController) {
        guard let fullScreenAd = ad else {
            return print("Ad wasn't ready")
        }
        fullScreenAd.present(fromRootViewController: viewController)
    }
}

struct AdViewControllerRepresentable: UIViewControllerRepresentable {
    let viewController = UIViewController()
    func makeUIViewController(context: Context) -> some UIViewController {
        return viewController
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}
