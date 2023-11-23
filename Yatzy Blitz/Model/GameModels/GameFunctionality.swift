import Foundation

class GameFunctionality{
    
    func rollDice(currentRoll:[Int], selectedDice:[Bool]) -> [Int]{
        var count = 0
        var updatedRoll = currentRoll
        for _ in currentRoll{
            if !selectedDice[count]{
                updatedRoll[count] = Int.random(in: 1...6)
            }
            count += 1
        }
        return updatedRoll
    }
    
    func selectionCheck(selection: String, currentRoll: [Int], hasYahtzee: Bool) -> String {
        let groupedDice = Dictionary(grouping: currentRoll, by: {$0})
        let diceCounts = groupedDice.mapValues { $0.count }
        
        let returnValue = hasYahtzee && diceCounts.contains(where: { $0.value > 4 }) ? 50 : 0
        switch selection {
        case "1", "2", "3", "4", "5", "6":
            if let diceValue = Int(selection) {
                return "\(returnValue + (diceCounts[diceValue] ?? 0) * diceValue)"
            }
            
        case "Times3":
            if diceCounts.values.contains(where: { $0 > 2 }) {
                return "\(returnValue + currentRoll.reduce(0, +))"
            }
            
        case "Times4":
            if diceCounts.values.contains(where: { $0 > 3 }) {
                return "\(returnValue + currentRoll.reduce(0, +))"
            }
            
        case "FullHouse":
            if diceCounts.values.contains(3) && diceCounts.values.contains(2) {
                return "\(returnValue + 25)"
            }
            
        case "Small":
            let smalls: [Set<Int>] = [[1, 2, 3, 4], [2, 3, 4, 5], [3, 4, 5, 6]]
            if smalls.contains(where: { $0.isSubset(of: Set(currentRoll)) }) {
                return "\(returnValue + 30)"
            }
            
        case "Large":
            let larges: [Set<Int>] = [[1, 2, 3, 4, 5], [2, 3, 4, 5, 6]]
            if larges.contains(where: { $0.isSubset(of: Set(currentRoll)) }) {
                return "\(returnValue + 40)"
            }
            
        case "Yahtzee":
            if diceCounts.values.contains(5) {
                return "50"
            } else {
                return "0"
            }
            
        case "Chance":
            return "\(returnValue + currentRoll.reduce(0, +))"
            
        default:
            return "\(returnValue)"
        }
        
        return "\(returnValue)"
    }

}

