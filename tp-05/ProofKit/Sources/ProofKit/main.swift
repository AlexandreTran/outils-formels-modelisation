import ProofKitLib

let a: Formula = "a"
let b: Formula = "b"
let c: Formula = "c"
//let f = !(a && (b || c))
/*
print("formula: \(f)")
print("nnf                       : \(f.nnf)")
print("dnf                       : \(f.dnf)")
print("cnf                       : \(f.cnf)")
print("cnf correction exercice   : \((!a || !b) && (!a || !c))")
print("dnf correction exercice   : \(f.nnf)")
*/


let f  = (a=>b) || !(a && c)
print("formula: \(f)")
print("nnf    : \(f.nnf)")
print("dnf                       : \(f.dnf)")
print("cnf                       : \(f.cnf)")
print("cnf correction exercice   : \((!a || b || !c))")
print("dnf correction exercice   : \((!a || b || !c))")
print("dnf correction exercice   : \(f.nnf)")
// !a || b || !c est la cnf et la dnf

/*
let f = (!a || b && c) && a
print("formula: \(f)")
print("nnf    : \(f.nnf)")
print("dnf    : \(f.dnf)")
print("cnf    : \(f.cnf)")
print("cnf correction exercice   : \(b && c && a)")
print("dnf correction exercice   : \(b && c && a)")   //c'est une dnf et une cnf aussi
*/





let booleanEvaluation = f.eval { (proposition) -> Bool in
    switch proposition {
        case "p": return true
        case "q": return false
        default : return false
    }
}
print(booleanEvaluation)

enum Fruit: BooleanAlgebra {

    case apple, orange

    static prefix func !(operand: Fruit) -> Fruit {
        switch operand {
        case .apple : return .orange
        case .orange: return .apple
        }
    }

    static func ||(lhs: Fruit, rhs: @autoclosure () throws -> Fruit) rethrows -> Fruit {
        switch (lhs, try rhs()) {
        case (.orange, .orange): return .orange
        case (_ , _)           : return .apple
        }
    }

    static func &&(lhs: Fruit, rhs: @autoclosure () throws -> Fruit) rethrows -> Fruit {
        switch (lhs, try rhs()) {
        case (.apple , .apple): return .apple
        case (_, _)           : return .orange
        }
    }

}

let fruityEvaluation = f.eval { (proposition) -> Fruit in
    switch proposition {
        case "p": return .apple
        case "q": return .orange
        default : return .orange
    }
}
print(fruityEvaluation)
