@main
public struct Lindenmayer
{

    class ProductionRule
    {
        let predecessor: Character
        let successor: String

        init(predecessor: Character, successor: String)
        {
            self.predecessor = predecessor
            self.successor = successor
        }
    }

    class LSystem
    {
        let alphabet: [Character]
        let axiom: String
        let productionRules: [ProductionRule]

        init(alphabet: [String], axiom: String, productionRules: [ProductionRule])
        {
            self.alphabet = alphabet.map { $0.first! }
            self.axiom = axiom
            self.productionRules = productionRules
        }

        func nonTerminals() -> Set<Character>
        {
            let terminals = Set(alphabet).subtracting(self.productionRules.map { $0.predecessor })
            return terminals
        }

        func terminals() -> Set<Character>
        {
            let nonTerminals = Set(alphabet).subtracting(self.nonTerminals())
            return nonTerminals
        }

        func produce(generationCount: Int) -> String
        {
            var nextGeneration = axiom
            for _ in 0..<generationCount
            {
                var result = ""
                for symbol in nextGeneration
                {
                    var added = false
                    //let added = false
                    if nonTerminals().contains(symbol)
                    {
                        result += String(symbol)
                        added = true
                    }
                    if !added
                    {
                        for rule in productionRules
                        {
                            if String(rule.predecessor) == String(symbol)
                            {
                                result += String(rule.successor)

                                //added = true
                                //break
                            }
                        }
                    }
                    nextGeneration = result
                }
            }
            return nextGeneration
        }
    }

    public static func main()
    {
        let productionRules = [ProductionRule(predecessor:"1", successor:"11"), ProductionRule(predecessor:"0", successor:"1[0]0")]
        let lSystem = LSystem(alphabet:["0", "1", "[", "]"], axiom:"0", productionRules:productionRules)

        var duplicatePredecessor = false
        if duplicatePredecessor == false
        {
            var bCount = 0
            var sCount = 0
            for ruleB in productionRules
            {
                bCount += 1
                for ruleS in productionRules
                {
                    sCount += 1
                    if sCount != bCount
                    {
                        if ruleS.predecessor == ruleB.predecessor
                        {
                            print("Error, more than one production rule for the same predecessor is forbidden.")
                            duplicatePredecessor = true
                            break
                        }
                    }
                }
                sCount = 0
            }
        }

        var illegalPredecessor = false
        if illegalPredecessor == false
        {
            for ruleAlph in productionRules
            {
                var strike = 0
                for letters in lSystem.alphabet
                {
                    if ruleAlph.predecessor != letters
                    {
                        strike += 1
                    }
                    if strike == lSystem.alphabet.count
                    {
                        print("Error, a rule for which the predecessor is not present in the alphabet is forbidden.")
                        illegalPredecessor = true
                        break
                    }
                }
            }
        }

        if duplicatePredecessor == false && illegalPredecessor == false
        {
            let result = lSystem.produce(generationCount: 3)
            print(result) // Output: "1111[11[1[0]0]1[0]0]11[1[0]0]1[0]0"
        }

        //let result = lSystem.produce(generationCount: 3)
        //print(result) // Output: "1111[11[1[0]0]1[0]0]11[1[0]0]1[0]0"
    }
}

        
