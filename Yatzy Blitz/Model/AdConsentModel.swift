import Foundation
import SwiftUI
import UserMessagingPlatform

class UMPViewController: UIViewController {
    
    var canLoadAdsCallback: (() -> Void)?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        let parameters = UMPRequestParameters()
        parameters.tagForUnderAgeOfConsent = false
        UMPConsentInformation.sharedInstance.requestConsentInfoUpdate(
            with: parameters,
            completionHandler: { error in
                if error != nil {
                } else {
                    let formStatus = UMPConsentInformation.sharedInstance.formStatus
                    if formStatus == UMPFormStatus.available {
                        self.loadForm()
                    }
                }
            })
    }
    
    func loadForm() {
        UMPConsentForm.load(completionHandler: { form, loadError in
            if loadError != nil {
            } else {
                if UMPConsentInformation.sharedInstance.consentStatus == UMPConsentStatus.required {
                    form?.present(
                        from: self,
                        completionHandler: { dismissError in
                            if UMPConsentInformation.sharedInstance.consentStatus == UMPConsentStatus.obtained {
                                if let callback = self.canLoadAdsCallback {
                                    callback()
                                }
                            }
                            self.loadForm();
                        })
                } else {
                }
            }
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct UMPWrapper: UIViewControllerRepresentable {
    var canLoadAdsCallback: (() -> Void)?
    
    func makeUIViewController(context: Context) -> UMPViewController {
        let umpViewController = UMPViewController()
        umpViewController.canLoadAdsCallback = canLoadAdsCallback
        return umpViewController
    }
    
    func updateUIViewController(_ uiViewController: UMPViewController, context: Context) {
        
    }
}
