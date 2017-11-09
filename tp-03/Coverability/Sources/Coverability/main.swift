import PetriKit
import CoverabilityLib

// This file contains the code that will be executed if you run your program from the terminal. You
// don't have to write anything in this file, but you may use it to debug your code. You can create
// instances of the provided models as the following:
//
//     let model          = createBoundedModel()
//     let unboundedModel = createUnboundedModel()
//
// Or you can create any instance of your own models to test your code.
//
// You **are** encouraged to write tests of your own!
// You may write as many tests as you want here, or even better in `CoverabilityLibTests.swift`.
// Observe how the two existing tests are implemented to write your own.


//premier modèle BoundedModel
do{
  let model = createBoundedModel()
  guard let r = model.places.first(where: { $0.name == "r" }),
        let s1 = model.places.first(where: { $0.name == "s1" }),
        let s2 = model.places.first(where: { $0.name == "s2" }),
        let s3 = model.places.first(where: { $0.name == "s3" }),
        let p = model.places.first(where: { $0.name == "p" }),
        let t  = model.places.first(where: { $0.name == "t"  }),
        let m  = model.places.first(where: { $0.name == "m"  }),
        let w1  = model.places.first(where: { $0.name == "w1"  }),
        let w2  = model.places.first(where: { $0.name == "w2"  }),
        let w3  = model.places.first(where: { $0.name == "w3"  })
      else{
        fatalError("Erreur")
      }

  let initialMarking: CoverabilityMarking =
      [r: 1, p: 1, t: 0, m: 0, w1: 1, s1: 0, w2: 1, s2: 0, w3: 1, s3: 0]  //marquage initial

      if model.coverabilityGraph(from: initialMarking) != nil{
        print("Graphe crée")
      }
  }


//deuxième modèle unboundedModel
do{
  let model = createUnboundedModel()
  guard let s0 = model.places.first(where: { $0.name == "s0" }),
        let s1 = model.places.first(where: { $0.name == "s1" }),
        let s2 = model.places.first(where: { $0.name == "s2" }),
        let s3 = model.places.first(where: { $0.name == "s3" }),
        let s4 = model.places.first(where: { $0.name == "s4" }),
        let b  = model.places.first(where: { $0.name == "b"  })
        else{
          fatalError("Erreur")
        }

  let initialMarking: CoverabilityMarking =
      [s0: 1, s1: 0, s2: 1, s3: 0, s4: 1, b: 1]   //marquage initial


  if model.coverabilityGraph(from: initialMarking) != nil{
    print("Graphe crée")
  }

print("stop")
}
