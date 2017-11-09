import PetriKit

public extension PTNet {

    public func coverToPTMarking(with marking : CoverabilityMarking, and p : [PTPlace]) -> PTMarking{
      var k : PTMarking = [:]

      for tempo in p
      {
        let this = corrValue(to : marking[tempo]!)!
        k[tempo] = this
      }
      return k
    }


    public func ptmarkingToCoverability(with marking: PTMarking, and p : [PTPlace]) ->CoverabilityMarking{
      var tempo : CoverabilityMarking = [:]
      for val in p
      {
        tempo[val] = .some(marking[val]!)
        if(500 < tempo[val]!)
        {
          tempo[val] = .omega
        }
      }
      return tempo
    }


    public func corrValue(to t: Token) -> UInt? {
      if case .some(let value) = t {
        return value
      }
      else {
        return 1000
      }
    }


    public func verify(at marking : [CoverabilityMarking], to markingToAdd : CoverabilityMarking) -> Int
    {
      var value = 0
      for i in 0...marking.count-1
      {
        if (marking[i] == markingToAdd)
        {
          value = 1
        }
        if (markingToAdd > marking[i])
        {
          value = i+2}
      }
      return value
    }


    public func Omega(from comp : CoverabilityMarking, with marking : CoverabilityMarking, and p : [PTPlace])  -> CoverabilityMarking?
    {
      var tempo = marking
      for j in p
      {
        if (comp[j]! < tempo[j]!)
        {
          tempo[j] = .omega
        }
      }
      return tempo
    }


    public func coverabilityGraph(from marking0: CoverabilityMarking) -> CoverabilityGraph? {
        // Write here the implementation of the coverability graph generation.

        // Note that CoverabilityMarking implements both `==` and `>` operators, meaning that you
        // may write `M > N` (with M and N instances of CoverabilityMarking) to check whether `M`
        // is a greater marking than `N`.

        // IMPORTANT: Your function MUST return a valid instance of CoverabilityGraph! The optional
        // print debug information you'll write in that function will NOT be taken into account to
        // evaluate your homework.

        let placesC = Array(places)
        var transitionsC = Array (transitions)
        transitionsC.sort{$0.name < $1.name}

        var graphList : [CoverabilityGraph] = []
        var markingList : [CoverabilityMarking] = [marking0]
        var this: CoverabilityMarking
        let returnedGraph = CoverabilityGraph(marking: marking0, successors: [:])
        var i = 0

        while(i < markingList.count)
        {

          for trans in transitionsC{

            let ptMarking = coverToPTMarking(with: markingList[i], and: placesC)
            if let firedTran = trans.fire(from: ptMarking){

              let convMarking = ptmarkingToCoverability(with: firedTran, and: placesC)

              let nouvCouv = CoverabilityGraph(marking: convMarking, successors: [:])

              returnedGraph.successors[trans] = nouvCouv
            }

            if(returnedGraph.successors[trans] != nil){

              this = returnedGraph.successors[trans]!.marking
              // On vérifie si il est contenu dans la liste
              let curr = verify(at: markingList, to: this)
              if (curr != 1)
              {
                if (curr > 1)
                {
                  this = Omega(from : markingList[curr-2], with : this, and : placesC)!
                }
                 // On ajoute le noeud à la liste
                graphList.append(returnedGraph)
                // On ajoute son marquage à la seconde
                markingList.append(this)
              }
            }
          }
          i = i + 1
        }
        return returnedGraph
      }
}
