import GameKit

class MultiplayerModel: NSObject, ObservableObject, GKMatchDelegate {
    
    @Published var match: GKMatch?
    @Published var player: GKPlayer?
    @Published var isMyTurn = true
    @Published var firstPLayer = true
    @Published var receivedMessage = ""
    @Published var messageToSend = ""
    @Published var showDisconnectAlert = false
    @Published var disconnectedPlayerName: String = ""
    @Published var receiviedRematchRequest: Bool? = false
    @Published var rematchConfirmation: Bool? = nil
    var playerUUIDKey = UUID().uuidString
    var opponentUUIDKey: String?
    var gameData: GameData?
    var animate: EmojiAnimator?
    
    func setup(match: GKMatch) {
        self.match = match
        self.match?.delegate = self
        sendInitialConnectionData()
    }
    
    func resetMultiplayerModel(){
        isMyTurn = true
        firstPLayer = true
        receivedMessage = ""
        messageToSend = ""
        showDisconnectAlert = false
        disconnectedPlayerName = ""
        receiviedRematchRequest = false
        rematchConfirmation = nil
    }
    
    func getPlayerNames() -> (local: String?, opponent: String?) {
        if GKLocalPlayer.local.isAuthenticated {
            let localPlayerID = GKLocalPlayer.local.teamPlayerID
            let localPlayerName = GKLocalPlayer.local.alias
            guard let matchPlayers = self.match?.players else { return (localPlayerName, nil) }
            if let opponent = matchPlayers.first(where: { $0.teamPlayerID != localPlayerID }) {
                return (localPlayerName, opponent.alias)
            }
            return (localPlayerName, nil)
        } else {
            return (nil, nil)
        }
    }
    
    
    private func determineFirstTurn() {
        if self.playerUUIDKey < (self.opponentUUIDKey ?? "") {
            isMyTurn = false
            firstPLayer = false
        }
    }
    
    func sendCurrentGameState(endTurn: Bool) {
        var gameState = gameData?.getCurrentGameState(isSenderTurn: self.isMyTurn, endTurn: endTurn)
        gameState?.senderUUIDKey = self.playerUUIDKey
        if let gameStateData = try? JSONEncoder().encode(gameState) {
            do {
                try match?.sendData(toAllPlayers: gameStateData, with: .reliable)
                if endTurn {
                    self.isMyTurn.toggle()
                }
            } catch {
                print("Failed to send game state: \(error)")
            }
        }
    }
    
    func sendInitialConnectionData() {
        let initialData = InitialConnectionData(playerUUID: self.playerUUIDKey)
        if let initialDataEncoded = try? JSONEncoder().encode(initialData) {
            do {
                try match?.sendData(toAllPlayers: initialDataEncoded, with: .reliable)
            } catch {
                print("Failed to send initial data: \(error)")
            }
        }
    }
    
    func sendRematchRequest() {
        let rematchRequest = RematchRequest(requestRematch: true)
        if let rematchData = try? JSONEncoder().encode(rematchRequest) {
            do {
                try match?.sendData(toAllPlayers: rematchData, with: .reliable)
            } catch {
                print("Failed to send rematch request: \(error)")
            }
        }
    }
    
    func sendRematchConfirmation(response:Bool) {
        let rematchResponse = RematchConfirmation(confirmRematch: response)
        if let rematchResponseData = try? JSONEncoder().encode(rematchResponse) {
            do {
                try match?.sendData(toAllPlayers: rematchResponseData, with: .reliable)
            } catch {
                print("Failed to send rematch request: \(error)")
            }
        }
    }

    func sendEmoji(emoji:String) {
        let emojiResponse = Emoji(emoji: emoji)
        if let emojiResponseData = try? JSONEncoder().encode(emojiResponse) {
            do {
                try match?.sendData(toAllPlayers: emojiResponseData, with: .reliable)
            } catch {
                print("Failed to send rematch request: \(error)")
            }
        }
    }
    
    func match(_ match: GKMatch, didReceive data: Data, fromRemotePlayer player: GKPlayer) {
        if let initialConnectionData = try? JSONDecoder().decode(InitialConnectionData.self, from: data) {
            self.opponentUUIDKey = initialConnectionData.playerUUID
            determineFirstTurn()
        } else if (try? JSONDecoder().decode(RematchRequest.self, from: data)) != nil {
            self.receiviedRematchRequest = true
        } else if let rematchConfirmation = try? JSONDecoder().decode(RematchConfirmation.self, from: data) {
            if rematchConfirmation.confirmRematch {
                self.rematchConfirmation = true
            } else {
                self.rematchConfirmation = false
            }
        }else if let emojiData = try? JSONDecoder().decode(Emoji.self, from: data) {
            animate?.startEmoticonAnimation(emote:decode(emojiData.emoji)!)
        } else if let receivedGameState = try? JSONDecoder().decode(GameState.self, from: data),
                  receivedGameState.senderUUIDKey != self.playerUUIDKey {
            gameData?.currentRoll = receivedGameState.currentRoll
            gameData?.player1Score = receivedGameState.player1Score
            gameData?.player2Score = receivedGameState.player2Score
            gameData?.player1BonusScore = receivedGameState.player1BonusScore
            gameData?.player2BonusScore = receivedGameState.player2BonusScore
            gameData?.selectedDice = receivedGameState.selectedDice
            gameData?.rollCount = receivedGameState.rollCount
            gameData?.selected = receivedGameState.selected
            gameData?.playIsActive = receivedGameState.playIsActive
            gameData?.p1Active = receivedGameState.p1Active
            gameData?.finalChoice = receivedGameState.finalChoice
            gameData?.scoreChoice = receivedGameState.scoreChoice
            gameData?.roundNumber = receivedGameState.roundNumber
            if receivedGameState.endTurn {
                self.isMyTurn = !self.isMyTurn
            }
            if receivedGameState.winner != nil{
                gameData?.winner = !receivedGameState.winner!
                if receivedGameState.draw != nil{
                    gameData?.draw = true
                }
            }
        }
    }
    
    func match(_ match: GKMatch, player: GKPlayer, didChange state: GKPlayerConnectionState) {
        switch state {
        case .disconnected:
            DispatchQueue.main.async {
                self.showDisconnectionAlert(player: player)
            }
        case .connected:
            print("\(player.alias) has connected")
        case .unknown:
            print("Connection state is unknown for \(player.alias)")
        @unknown default:
            print("Unknown state for \(player.alias)")
        }
    }
    
    func showDisconnectionAlert(player: GKPlayer) {
        self.disconnectedPlayerName = player.alias
        self.showDisconnectAlert = true
    }
    func decode(_ s: String) -> String? {
        let data = s.data(using: .utf8)!
        return String(data: data, encoding: .nonLossyASCII)
    }
}

struct GameState: Codable {
    var senderUUIDKey: String
    var isSenderTurn: Bool
    var endTurn: Bool
    var currentRoll: [Int]
    var player1Score: [Int?]
    var player2Score: [Int?]
    var player1BonusScore: Int
    var player2BonusScore: Int
    var selectedDice: [Bool]
    var rollCount: Int
    var selected: [String]
    var playIsActive: Bool
    var p1Active: Bool
    var finalChoice: [Int]
    var scoreChoice: [String]
    var roundNumber: Int
    var winner: Bool?
    var draw: Bool?
    var emoji:String?
}

struct RematchRequest: Codable {
    var requestRematch: Bool
}

struct RematchConfirmation: Codable {
    var confirmRematch: Bool
}

struct Emoji:Codable {
    var emoji:String
}

struct InitialConnectionData: Codable {
    var playerUUID: String
}

