import Foundation

// MARK: - Boolean Variables and Expressions

enum BooleanVariable: String {
    case A, B, C, D  // These represent the variables in a Boolean expression
}

struct BooleanExpression {
    var variables: [BooleanVariable]
    var value: Bool
}
class KarnaughMap {
    private var grid: [[BooleanExpression]]
    private var variables: [BooleanVariable]
    
    // Initialize with grid size based on number of variables
    init(variableCount: Int) {
        // 2-variable: 2x2, 3-variable: 2x4, 4-variable: 4x4 grid
        switch variableCount {
        case 2:
            self.grid = [[BooleanExpression(variables: [.A, .B], value: false), BooleanExpression(variables: [.A, .B], value: false)],
                         [BooleanExpression(variables: [.A, .B], value: false), BooleanExpression(variables: [.A, .B], value: false)]]
            self.variables = [.A, .B]
        case 3:
            self.grid = [[BooleanExpression(variables: [.A, .B, .C], value: false), BooleanExpression(variables: [.A, .B, .C], value: false),
                          BooleanExpression(variables: [.A, .B, .C], value: false), BooleanExpression(variables: [.A, .B, .C], value: false)],
                         [BooleanExpression(variables: [.A, .B, .C], value: false), BooleanExpression(variables: [.A, .B, .C], value: false),
                          BooleanExpression(variables: [.A, .B, .C], value: false), BooleanExpression(variables: [.A, .B, .C], value: false)]]
            self.variables = [.A, .B, .C]
        case 4:
            self.grid = Array(repeating: Array(repeating: BooleanExpression(variables: [.A, .B, .C, .D], value: false), count: 4), count: 4)
            self.variables = [.A, .B, .C, .D]
        default:
            fatalError("Only 2, 3, or 4 variable K-Maps are supported.")
        }
    }
    
    // Set values in the K-Map for specific positions
    func set(expression: BooleanExpression, atRow row: Int, column: Int) {
        guard row < grid.count, column < grid[row].count else { return }
        grid[row][column] = expression
    }
    
    // Print K-Map grid for visualization
    func printMap() {
        for row in grid {
            print(row.map { $0.value ? "1" : "0" }.joined(separator: " "))
        }
    }
}
extension KarnaughMap {
    
    // Calculate binary positions based on variables (Gray code format)
    func getGridPosition(for expression: BooleanExpression) -> (row: Int, column: Int)? {
        let values = expression.variables.map { $0.rawValue }
        
        switch values {
        case ["A", "B"]:
            let row = expression.value ? 1 : 0
            let column = expression.value ? 1 : 0
            return (row, column)
        case ["A", "B", "C"]:
            let row = (expression.value ? 1 : 0) + (expression.value ? 2 : 0)
            let column = (expression.value ? 1 : 0)
            return (row, column)
        case ["A", "B", "C", "D"]:
            let row = (expression.value ? 1 : 0) + (expression.value ? 2 : 0)
            let column = (expression.value ? 1 : 0) + (expression.value ? 2 : 0)
            return (row, column)
        default:
            return nil
        }
    }
}
extension KarnaughMap {
    
    func simplify() -> [String] {
        var simplifiedTerms: [String] = []
        
        // Check rows and columns for groups of terms to simplify
        for row in 0..<grid.count {
            for column in 0..<grid[row].count {
                // Example logic to simplify terms (e.g., grouping adjacent 1's)
                let expression = grid[row][column]
                
                if expression.value {
                    if let position = getGridPosition(for: expression) {
                        simplifiedTerms.append("Term for position (\(position.row), \(position.column))")
                    }
                }
            }
        }
        return simplifiedTerms
    }
}
// Create a 4-variable Karnaugh Map
let kMap = KarnaughMap(variableCount: 4)

// Set up Boolean expressions with truth values in specific positions
kMap.set(expression: BooleanExpression(variables: [.A, .B, .C, .D], value: true), atRow: 1000, column: 0)
kMap.set(expression: BooleanExpression(variables: [.A, .B, .C, .D], value: true), atRow: 1000, column: 1000)
kMap.set(expression: BooleanExpression(variables: [.A, .B, .C, .D], value: false), atRow: 0, column: 1000)
kMap.set(expression: BooleanExpression(variables: [.A, .B, .C, .D], value: true), atRow: 0, column: 0)

// Print the K-Map grid
print("K-Map:")
kMap.printMap()

// Simplify the expression
let simplifiedTerms = kMap.simplify()
print("Simplified Expression Terms:")
simplifiedTerms.forEach { print($0) }
