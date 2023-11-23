import Foundation

class ComputerPlayer {
    
    var filledCategories: Set<String>
    
    private var rollCount = 0
    
    init(currentScores: [Int?]) {
        self.filledCategories = Set(currentScores.enumerated()
            .compactMap { (index, element) in
                guard element != nil else { return nil }
                return ["1", "2", "3", "4", "5", "6", "Times3", "Times4", "FullHouse", "Small", "Large", "Yahtzee", "Chance"][index]
            })
    }
    
    func startTurn() {
        rollCount = 0
    }
    
    func evaluateRoll(roll: [Int], filledCategories: Set<String>) -> (category: String, score: Int) {
        let potentialScores = [
            ("1", sumOfNumber(number: 1, roll: roll)),
            ("2", sumOfNumber(number: 2, roll: roll)),
            ("3", sumOfNumber(number: 3, roll: roll)),
            ("4", sumOfNumber(number: 4, roll: roll)),
            ("5", sumOfNumber(number: 5, roll: roll)),
            ("6", sumOfNumber(number: 6, roll: roll)),
            ("Times3", threeOfAKindScore(roll: roll)),
            ("Times4", fourOfAKindScore(roll: roll)),
            ("FullHouse", fullHouseScore(roll: roll)),
            ("Small", smallStraightScore(roll: roll)),
            ("Large", largeStraightScore(roll: roll)),
            ("Yahtzee", yahtzeeScore(roll: roll)),
            ("Chance", roll.reduce(0, +)),
        ]
        if yahtzeeScore(roll: roll) > 0 && filledCategories.contains("Yahtzee") {
            let possibleBonusCategories = filledCategories.subtracting(["Yahtzee"])
            if let categoryToBonus = possibleBonusCategories.min(by: { a, b in
                potentialScores.first(where: { $0.0 == a })!.1 < potentialScores.first(where: { $0.0 == b })!.1
            }) {
                return (categoryToBonus, potentialScores.first(where: { $0.0 == categoryToBonus })!.1 + 100)
            }
        }
        let availableScores = potentialScores.filter { !filledCategories.contains($0.0) }
        for category in ["Yahtzee", "Large", "FullHouse", "Times4", "Times3", "Small"] {
            if let highScore = availableScores.first(where: { $0.0 == category })?.1, highScore > 0 {
                return (category, highScore)
            }
        }
        let numbers = ["1", "2", "3", "4", "5", "6"]
        let availableNumbers = availableScores.filter { numbers.contains($0.0) && $0.1 > 0 }
        if !availableNumbers.isEmpty {
            let mostCommonNumber = availableNumbers.max(by: { a, b in
                roll.filter { $0 == Int(a.0)! }.count < roll.filter { $0 == Int(b.0)! }.count
            })
            if let common = mostCommonNumber {
                return (common.0, common.1)
            }
        }
        if let chanceScore = availableScores.first(where: { $0.0 == "Chance" })?.1, chanceScore > 0 {
            return ("Chance", chanceScore)
        }
        return availableScores.first ?? ("", 0)
    }
    
    func sumOfNumber(number: Int, roll: [Int]) -> Int {
        return roll.filter { $0 == number }.reduce(0, +)
    }
    
    func threeOfAKindScore(roll: [Int]) -> Int {
        for num in 1...6 {
            if roll.filter({ $0 == num }).count >= 3 {
                return roll.reduce(0, +) + 5
            }
        }
        return 0
    }
    
    func fourOfAKindScore(roll: [Int]) -> Int {
        for num in 1...6 {
            if roll.filter({ $0 == num }).count >= 4 {
                return roll.reduce(0, +) + 10
            }
        }
        return 0
    }
    
    func fullHouseScore(roll: [Int]) -> Int {
        var counts = Array(repeating: 0, count: 6)
        for die in roll {
            counts[die - 1] += 1
        }
        if counts.contains(3) && counts.contains(2) {
            return 25
        }
        return 0
    }
    
    func smallStraightScore(roll: [Int]) -> Int {
        let uniqueSortedRoll = Array(Set(roll)).sorted()
        if uniqueSortedRoll.count >= 4 {
            for i in 0..<uniqueSortedRoll.count - 3 {
                if uniqueSortedRoll[i] + 1 == uniqueSortedRoll[i + 1] && uniqueSortedRoll[i] + 2 == uniqueSortedRoll[i + 2] && uniqueSortedRoll[i] + 3 == uniqueSortedRoll[i + 3] {
                    return 30
                }
            }
        }
        return 0
    }
    
    func largeStraightScore(roll: [Int]) -> Int {
        let uniqueSortedRoll = Array(Set(roll)).sorted()
        if uniqueSortedRoll == [1, 2, 3, 4, 5] || uniqueSortedRoll == [2, 3, 4, 5, 6] {
            return 40
        }
        return 0
    }
    
    func yahtzeeScore(roll: [Int]) -> Int {
        if Set(roll).count == 1 {
            return 50
        }
        return 0
    }
    
    func decidePlayOrRoll(roll: [Int], rollCount: Int) -> Decision {
        let evaluation = evaluateRoll(roll: roll, filledCategories: filledCategories)
        if rollCount == 0 {
            return .play(category: evaluation.category)
        }
        if yahtzeeScore(roll: roll) > 0 && !filledCategories.contains("Yahtzee") {
            return .play(category: "Yahtzee")
        }
        if yahtzeeScore(roll: roll) > 0 && filledCategories.contains("Yahtzee") {
            let evaluation = evaluateRoll(roll: roll, filledCategories: filledCategories)
            return .play(category: evaluation.category)
        }
        if fullHouseScore(roll: roll) > 0 && !filledCategories.contains("FullHouse") {
            return .play(category: "FullHouse")
        }
        let potentialYahtzeeReward = potentialReward(for: roll)
        if rollCount == 1 && potentialYahtzeeReward >= 50 {
            let diceToHold = diceToHoldForReroll(roll: roll)
            if !diceToHold.contains(false) {
                return .play(category: evaluation.category)
            }
            return .reRoll(diceToHold)
        }
        let diceToHold = diceToHoldForReroll(roll: roll)
        if diceToHold.allSatisfy({ $0 }) {
            return .play(category: evaluation.category)
        }
        return .reRoll(diceToHold)
    }
    
    func simulateRerolls(for holdFlags: [Bool], currentRoll: [Int], simulations: Int) -> Double {
        var totalScore = 0.0
        for _ in 0..<simulations {
            var simulatedRoll = currentRoll
            for (index, flag) in holdFlags.enumerated() {
                if !flag {
                    simulatedRoll[index] = Int.random(in: 1...6)
                }
            }
            let evaluation = evaluateRoll(roll: simulatedRoll, filledCategories: filledCategories)
            totalScore += Double(evaluation.score)
        }
        return totalScore / Double(simulations)
    }
    
    func diceToHoldForReroll(roll: [Int]) -> [Bool] {
        var holdFlags = [false, false, false, false, false]
        var counts = Array(repeating: 0, count: 6)
        for die in roll {
            counts[die - 1] += 1
        }
        if let index = counts.firstIndex(of: 3), !filledCategories.contains("Yahtzee") {
            for (i, die) in roll.enumerated() {
                if die == index + 1 {
                    holdFlags[i] = true
                }
            }
            return holdFlags
        }
        if counts.contains(4) {
            let num = counts.firstIndex(of: 4)! + 1
            for (i, die) in roll.enumerated() {
                if die == num {
                    holdFlags[i] = true
                }
            }
            return holdFlags
        }
        if !filledCategories.contains("FullHouse"){
            if counts.contains(2) {
                for (i, die) in roll.enumerated() {
                    if counts[die - 1] == 2 {
                        holdFlags[i] = true
                    }
                }
            }
            return holdFlags
        }
        if !filledCategories.contains("Times4"){
            if counts.contains(3) {
                let num = counts.firstIndex(of: 3)! + 1
                for (i, die) in roll.enumerated() {
                    if die == num {
                        holdFlags[i] = true
                    }
                }
                return holdFlags
            }
        }
        if !filledCategories.contains("Times3"){
            if let index = counts.firstIndex(of: 3) {
                for (i, die) in roll.enumerated() {
                    if die == index + 1 {
                        holdFlags[i] = true
                    }
                }
                return holdFlags
            }
        }
        let sortedRoll = Array(Set(roll)).sorted()
        if !filledCategories.contains("Large"){
            if sortedRoll.count >= 3 {
                for i in 0..<sortedRoll.count - 3 {
                    if sortedRoll[i] + 1 == sortedRoll[i + 1] && sortedRoll[i] + 2 == sortedRoll[i + 2] && sortedRoll[i] + 3 == sortedRoll[i + 3] {
                        for j in i...(i + 3) {
                            holdFlags[roll.firstIndex(of: sortedRoll[j])!] = true
                        }
                        return holdFlags
                    }
                }
            }
        }
        if !filledCategories.contains("Small"){
            for i in 0..<sortedRoll.count - 2 {
                if sortedRoll[i] + 1 == sortedRoll[i + 1] && sortedRoll[i] + 2 == sortedRoll[i + 2] {
                    for j in i...(i + 2) {
                        holdFlags[roll.firstIndex(of: sortedRoll[j])!] = true
                    }
                    return holdFlags
                }
            }
        }
        return holdFlags
    }
    
    private func shouldPlayBasedOnScore(_ score: Int) -> Bool {
        let threshold = 15
        return score >= threshold
    }
    
    func potentialReward(for roll: [Int]) -> Int {
        let rewards: [String: Int] = [
            "Yahtzee": filledCategories.contains("Yahtzee") ? 100 : 50,
            "Large": 30,
            "Small": 20,
            "FullHouse": 25,
            "Times4": 15,
            "Times3": 10,
            "1": roll.filter { $0 == 1 }.count * 1,
            "2": roll.filter { $0 == 2 }.count * 2,
            "3": roll.filter { $0 == 3 }.count * 3,
            "4": roll.filter { $0 == 4 }.count * 4,
            "5": roll.filter { $0 == 5 }.count * 5,
            "6": roll.filter { $0 == 6 }.count * 6,
            "Chance": roll.reduce(0, +)
        ]
        let evaluation = evaluateRoll(roll: roll, filledCategories: filledCategories)
        return rewards[evaluation.category] ?? 0
    }
}

enum Decision {
    case play(category: String)
    case reRoll([Bool])
}
