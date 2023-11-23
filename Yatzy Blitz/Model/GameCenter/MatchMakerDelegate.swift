import GameKit

class MatchmakerDelegate: NSObject, GKMatchmakerViewControllerDelegate {
    var viewModel: MultiplayerModel
    
    init(viewModel: MultiplayerModel) {
        self.viewModel = viewModel
    }
    
    func matchmakerViewControllerWasCancelled(_ viewController: GKMatchmakerViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFailWithError error: Error) {
        print("Error finding match: \(error.localizedDescription)")
        viewController.dismiss(animated: true, completion: nil)
    }

    func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFind match: GKMatch) {
        viewController.dismiss(animated: true, completion: nil)
        viewModel.setup(match: match)
    }
    
}
