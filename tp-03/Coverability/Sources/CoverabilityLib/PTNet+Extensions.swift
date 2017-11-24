import PetriKit

public extension PTNet {

<<<<<<< HEAD
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
=======
    /// Computes the coverability graph of this P/T-net, starting from the given marking.
    ///
    /// Implementation note:
    /// It is easier to build the coverability graph in a recursive depth-first manner than with
    /// stacks, because we need to keep track of predecessor nodes as we process new ones. That's
    /// why the algorithm is actually implemented in `computeSuccessors(of:_:_:)`.
    public func coverabilityGraph(from marking: CoverabilityMarking) -> CoverabilityGraph {
        // Create the initial node of the coverability graph.
        let initialNode = CoverabilityGraph(marking: marking)
>>>>>>> e23a2818fc1be467983f6bd26529f44418b26fa9

        // An array of `CoverabilityGraph` instances that keeps track of the nodes we've already
        // visited. It initially contains the initial node of the coverability graph.
        var seen = [initialNode]

        // Compute the successors of the initial node. Notice that we pass a reference to the array
        // of visited nodes, and an initially empty array of predecessors.
        self.computeSuccessors(of: initialNode, seen: &seen, predecessors: [])

<<<<<<< HEAD
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
=======
        // Return the initial node once its successors (i.e. the rest of the graph) generated.
        return initialNode
    }

    /// Computes the successors of a coverability node in a recursive depth-first manner.
    ///
    /// This method recursively computes all its successors. It accepts as parameter the node whose
    /// successors shall be computed, an array of nodes that have already been visited and an array
    /// of predecessor nodes.
    ///
    /// The algorithm boils down to a depth-first search that recursively visits, for each node,
    /// the list of successors we can obtain by firing the transitions of the P/T-net from the
    /// marking associated with the currently visited node. To avoid infinte recursions, we check
    /// for each produced marking if there doesn't already exists a previously created node
    /// associated with the same marking. The detection of ω is done by checking the produced
    /// markings against that of predecessor nodes.
    ///
    /// Note that the `seen` parameter (i.e. the list of nodes that have already been visited) is
    /// declared `inout`. That's because `computeSuccessors(of:_:_:)` has to be able to notify its
    /// callers about the nodes it visited, so as to avoid infinite recursions.
    func computeSuccessors(
        of currentNode: CoverabilityGraph,
        seen          : inout [CoverabilityGraph],
        predecessors  : [CoverabilityGraph])
    {
        for transition in self.transitions {
            // Compute, if possible the coverability marking obtained by firing the transition from
            // the marking associated with the currently visited node.
            // Note that because `currentNode.marking` is an instance of `CoverabilityMarking`, we
            // can't use the methods `isFireable(from:)` and `fire(from:)` provided by PetriKit.
            // Instead, we have to use our own methods (see the extension of below).
            guard var nextMarking = transition.fire(from: currentNode.marking) else {
                // The transition was not fireable (i.e. `fire(from:)` return a nil value), so we
                // continue to the next one.
                continue
            }

            // Notice how we add the currently visited node as a predecessor before checking for
            // unboundedness.
            let predecessors = predecessors + [currentNode]

            // Check if the marking we computed is greater than any of the markings associated with
            // the predecessor nodes. In other words, check if the Petri Net is unbounded.
            if predecessors.contains(where: { nextMarking > $0.marking }) {
                // Since the marking we computed is greater than at least one of the markings we've
                // seen so far, we've to create a new marking where we've to put ω for each place
                // whose number of token is strictly superior to that of all previously visited
                // smaller markings.
                for predecessor in predecessors {
                    // Ignore markings that aren't smaller.
                    guard nextMarking > predecessor.marking else { continue }

                    // Set ω wherever it is needed.
                    for (place, tokens) in nextMarking {
                        if predecessor.marking[place]! < tokens {
                            nextMarking[place] = .omega
                        }
                    }
                }
            }

            // Check if the marking we computed has already been seen.
            if let previouslySeen = seen.first(where: { $0.marking == nextMarking }) {
                // We found a node whose associated marking is the same as that we obtained after
                // firing the transition. Hence we can mark it as successor of the current node,
                // and continue to the next transition.
                currentNode.successors[transition] = previouslySeen
                continue
            }

            // Use the marking we computed to create a new coverability node and mark it as
            // successor of the currently visited one.
            let successor = CoverabilityGraph(marking: nextMarking)
            currentNode.successors[transition] = successor

            // Mark this newly created successor as seen.
            seen.append(successor)

            // Compute its successors. Notice that we pass a reference to the array of visited
            // nodes, because the parameter is declared inout.
            self.computeSuccessors(
                of          : successor,
                seen        : &seen,
                predecessors: predecessors)
        }
    }

}

public extension PTTransition {

    public func isFireable(from marking: CoverabilityMarking) -> Bool {
        for arc in self.preconditions {
            // Note that because `marking[arc.place]!` returns an instance of `Token`, we can't
            // directly compare it is `arc.tokens`, which is an instance of `UInt`. However, the
            // `<` operator is defined for two `Token` operands (see `Token.swift`). So all we have
            // to do is to wrap `arc.tokens` into an instance of `Token`.
            if marking[arc.place]! < .some(arc.tokens) {
                return false
            }
        }

        // If not precondition was found violated, the transition is fireable.
        return true
    }

    public func fire(from marking: CoverabilityMarking) -> CoverabilityMarking? {
        // Make sure the transition is fireable.
        guard self.isFireable(from: marking) else {
            return nil
        }

        // Copy the marking (i.e. state) before the transition is fired.
        var result = marking

        // Consume the appropriate number of tokens from each place in precondition.
        for arc in self.preconditions {
            switch marking[arc.place]! {
            case .some(let tokens):
                // In that case, `marking[arc.place]!` represents a concrete number of tokens, so
                // we have to actually substract the number of tokens the transition consumes.
                result[arc.place] = .some(tokens - arc.tokens)
            case .omega:
                // In that case, `marking[arc.place]!` represents ω, so can leave it untouched.
                // Remember that `ω - n = ω`.
                break
            }
        }

        // Produce the appropriate number of tokens to each place in postcondition.
        for arc in self.postconditions {
            switch result[arc.place]! {
            case .some(let tokens):
                // In that case, `marking[arc.place]!` represents a concrete number of tokens, so
                // we have to actually add the number of tokens the transition produces.
                result[arc.place] = .some(tokens + arc.tokens)
            case .omega:
                // In that case, `marking[arc.place]!` represents ω, so can leave it untouched.
                // Remember that `ω + n = ω`.
                break
            }
        }

        return result
    }
>>>>>>> e23a2818fc1be467983f6bd26529f44418b26fa9

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
