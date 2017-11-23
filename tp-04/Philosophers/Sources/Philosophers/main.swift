import PetriKit
import PhilosophersLib

do {
  let philosophers = lockFreePhilosophers(n : 5)
  let philosophersMarking = philosophers.markingGraph(from: philosophers.initialMarking!)
  print("Il y a \(philosophersMarking!.count) marquage possible pour le modèle des philosophes non bloquable à 5 philosophes")
  print("")
}

do {
  let philosophers = lockablePhilosophers(n: 5)
  let philosophersMarking = philosophers.markingGraph(from : philosophers.initialMarking!)
  print("Il y a \(philosophersMarking!.count) marquage possible pour le modèle des philosophes bloquable à 5 philosophes")
  print("")

lock : for node in philosophersMarking! {
  var found = true
  for (_, e) in node.successors {
    if e.count != 0 {
    found = false
    }
  }
    if found {
      print("Avec ce marquage : \(node.marking) le réseaux est bloqué")
      print("")
      break lock
    }
}
}


/*

do {
    enum C: CustomStringConvertible {
        case b, v, o

        var description: String {
            switch self {
            case .b: return "b"
            case .v: return "v"
            case .o: return "o"
            }
        }
    }

    func g(binding: PredicateTransition<C>.Binding) -> C {
        switch binding["x"]! {
        case .b: return .v
        case .v: return .b
        case .o: return .o
        }
    }

    let t1 = PredicateTransition<C>(
        preconditions: [
            PredicateArc(place: "p1", label: [.variable("x")]),
        ],
        postconditions: [
            PredicateArc(place: "p2", label: [.function(g)]),
        ])

    let m0: PredicateNet<C>.MarkingType = ["p1": [.b, .b, .v, .v, .b, .o], "p2": []]
    guard let m1 = t1.fire(from: m0, with: ["x": .b]) else {
        fatalError("Failed to fire.")
    }
    print(m1)
    guard let m2 = t1.fire(from: m1, with: ["x": .v]) else {
        fatalError("Failed to fire.")
    }
    print(m2)
}

print()

do {
    let philosophers = lockFreePhilosophers(n: 3)
    // let philosophers = lockablePhilosophers(n: 3)
    for m in philosophers.simulation(from: philosophers.initialMarking!).prefix(10) {
        print(m)
    }

}*/

/*
do {
	enum Ingredients {
	case p,t,m
	}

	enum Smoker {
	case mia, bob, tom
	}

	enum Referee{
	case rob
	}

	enum Types {
	case ingredients(Ingredients)
	case smokers(Smokers)
	case referee(Referee)
	}

	let s = PredicateTransition<Types>{
	preconditions: [
		PredicateArc(place: "i", label: [.variable("x"), .variable("y")]),
		PredicateArc(place: "s", label: [.variable("s")]),
	],
	postconditions: [
		PredicateArc(place: "r", label: [.function({ _ in .referee(.rob) })]),
		PredicateArc(place: "w", label: [.variable("w"), .variable("s")]),
	],

	conditions : [{ binding in

		guard case let .smokers(s)      = binding ["s"]!,
		      case let .ingredients(x)  = binding ["x"]!,
		      case let .ingredients(y)  = binding ["y"]!

		else{
			return false
		}

		switch (s, x, y) {
		case (.mia, .p, .t): return true
		case (.tom, .p, .m): return true
		case (.bob, .t, .m): return true

		default: return false

		}
  }
}*/
