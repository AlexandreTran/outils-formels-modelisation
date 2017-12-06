infix operator =>: LogicalDisjunctionPrecedence

public protocol BooleanAlgebra {

    static prefix func ! (operand: Self) -> Self
    static        func ||(lhs: Self, rhs: @autoclosure () throws -> Self) rethrows -> Self
    static        func &&(lhs: Self, rhs: @autoclosure () throws -> Self) rethrows -> Self

}

extension Bool: BooleanAlgebra {}

public enum Formula {

    /// p
    case proposition(String)

    /// ¬a
    indirect case negation(Formula)

    public static prefix func !(formula: Formula) -> Formula {
        return .negation(formula)
    }

    /// a ∨ b
    indirect case disjunction(Formula, Formula)

    public static func ||(lhs: Formula, rhs: Formula) -> Formula {
        return .disjunction(lhs, rhs)
    }

    /// a ∧ b
    indirect case conjunction(Formula, Formula)

    public static func &&(lhs: Formula, rhs: Formula) -> Formula {
        return .conjunction(lhs, rhs)
    }

    /// a → b
    indirect case implication(Formula, Formula)

    public static func =>(lhs: Formula, rhs: Formula) -> Formula {
        return .implication(lhs, rhs)
    }

    /// The negation normal form of the formula.
    public var nnf: Formula {
        switch self {
        case .proposition(_):
            return self
        case .negation(let a):
            switch a {
            case .proposition(_):
                return self
            case .negation(let b):
                return b.nnf
            case .disjunction(let b, let c):
                return (!b).nnf && (!c).nnf
            case .conjunction(let b, let c):
                return (!b).nnf || (!c).nnf
            case .implication(_):
                return (!a.nnf).nnf
            }
        case .disjunction(let b, let c):
            return b.nnf || c.nnf
        case .conjunction(let b, let c):
            return b.nnf && c.nnf
        case .implication(let b, let c):
            return (!b).nnf || c.nnf
        }
    }

    /// The disjunctive normal form of the formula.
    public var dnf: Formula {
        // Write your code here ...
        switch self.nnf {     // on part de la formule NNF pour pouvoir calculer sa DNF
        case .proposition(_):
            return self.nnf   // si c'est une proposition il n'y a rien a faire
        case .negation(_):
            return self.nnf     // si c'est une négation il n'y a rien a faire non plus
        case .disjunction(let a, let b): // si c'est une disjonction on sépare la formule en deux parties ce qu'il y a a droite et a gauche
            return a.dnf || b.dnf // on retourne la dnf des deux parties
        case .conjunction(let a, let b): // si on a une conjonction on sépare la formule en deux aussi
            switch a.dnf { //pour la partie gauche
            case .disjunction(let c, let d):  // dans le cas de la disjonction dans la partie gauche on distribue
                return (b && d).dnf || (b && c).dnf
            default: break
            }
            switch b.dnf {  // pour la partie droite
            case .disjunction(let c, let d): // la meme chose
                return (c && a).dnf || (d && a).dnf
            default: break
            }

            return self.cnf //sinon il n'y a rien a faire donc on retourne sa cnf qui est du coup égale à sa dnf

        case .implication(_,_): //ce cas ne sera jamais utilisé car l'implication est supprimé par la nnf
            return self.nnf
        }

    }

    /// The conjunctive normal form of the formula.
    public var cnf: Formula {
        // Write your code here ...
        switch self.nnf {     // la même chose qu'avec la dnf saud qu'on utilise d'autre loi de distribution
        case .proposition(_):
            return self.nnf
        case .negation(_):
            return self.nnf
        case .conjunction(let a, let b):
            return a.cnf && b.cnf
        case .disjunction(let a, let b):
            switch a.cnf {
            case .conjunction(let c, let d):
                return (b || c).cnf && (b || d).cnf
            default: break
            }
            switch b.cnf {
            case .conjunction(let c, let d):
                return (a || c).cnf && (a||d).cnf
            default: break
            }
            return self.dnf
        case .implication(_,_):
            return self.nnf

        }
}

    /// The propositions the formula is based on.
    ///
    ///     let f: Formula = (.proposition("p") || .proposition("q"))
    ///     let props = f.propositions
    ///     // 'props' == Set<Formula>([.proposition("p"), .proposition("q")])
    public var propositions: Set<Formula> {
        switch self {
        case .proposition(_):
            return [self]
        case .negation(let a):
            return a.propositions
        case .disjunction(let a, let b):
            return a.propositions.union(b.propositions)
        case .conjunction(let a, let b):
            return a.propositions.union(b.propositions)
        case .implication(let a, let b):
            return a.propositions.union(b.propositions)
        }
    }

    /// Evaluates the formula, with a given valuation of its propositions.
    ///
    ///     let f: Formula = (.proposition("p") || .proposition("q"))
    ///     let value = f.eval { (proposition) -> Bool in
    ///         switch proposition {
    ///         case "p": return true
    ///         case "q": return false
    ///         default : return false
    ///         }
    ///     })
    ///     // 'value' == true
    ///
    /// - Warning: The provided valuation should be defined for each proposition name the formula
    ///   contains. A call to `eval` might fail with an unrecoverable error otherwise.
    public func eval<T>(with valuation: (String) -> T) -> T where T: BooleanAlgebra {
        switch self {
        case .proposition(let p):
            return valuation(p)
        case .negation(let a):
            return !a.eval(with: valuation)
        case .disjunction(let a, let b):
            return a.eval(with: valuation) || b.eval(with: valuation)
        case .conjunction(let a, let b):
            return a.eval(with: valuation) && b.eval(with: valuation)
        case .implication(let a, let b):
            return !a.eval(with: valuation) || b.eval(with: valuation)
        }
    }

}

extension Formula: ExpressibleByStringLiteral {

    public init(stringLiteral value: String) {
        self = .proposition(value)
    }

}

extension Formula: Hashable {

    public var hashValue: Int {
        return String(describing: self).hashValue
    }

    public static func ==(lhs: Formula, rhs: Formula) -> Bool {
        switch (lhs, rhs) {
        case (.proposition(let p), .proposition(let q)):
            return p == q
        case (.negation(let a), .negation(let b)):
            return a == b
        case (.disjunction(let a, let b), .disjunction(let c, let d)):
            return (a == c) && (b == d)
        case (.conjunction(let a, let b), .conjunction(let c, let d)):
            return (a == c) && (b == d)
        case (.implication(let a, let b), .implication(let c, let d)):
            return (a == c) && (b == d)
        default:
            return false
        }
    }

}

extension Formula: CustomStringConvertible {

    public var description: String {
        switch self {
        case .proposition(let p):
            return p
        case .negation(let a):
            return "¬\(a)"
        case .disjunction(let a, let b):
            return "(\(a) ∨ \(b))"
        case .conjunction(let a, let b):
            return "(\(a) ∧ \(b))"
        case .implication(let a, let b):
            return "(\(a) → \(b))"
        }
    }

}
