import PetriKit

public class MarkingGraph {

    public let marking   : PTMarking
    public var successors: [PTTransition: MarkingGraph]

    public init(marking: PTMarking, successors: [PTTransition: MarkingGraph] = [:]) {
        self.marking    = marking
        self.successors = successors
    }

}

public extension PTNet {

    public func markingGraph(from marking: PTMarking) -> MarkingGraph? {
        // Write here the implementation of the marking graph generation.
        // Parcours en largeur qui va visiter toutes les places

        let initMark = MarkingGraph(marking: marking)
        var toVisit = [MarkingGraph]()
        var visited = [MarkingGraph]()

        toVisit.append(initMark)

        while toVisit.count != 0 {
            let currentNode = toVisit.removeFirst()
            visited.append(currentNode)
            transitions.forEach { trans in
              if let nvoMark = trans.fire(from: currentNode.marking) {
                        if let visitedd = visited.first(where: { $0.marking == nvoMark }) {
                            currentNode.successors[trans] = visitedd
                        } else {
                            let discovered = MarkingGraph(marking: nvoMark)
                            currentNode.successors[trans] = discovered
                            if (!toVisit.contains(where: { $0.marking == discovered.marking})) {
                                toVisit.append(discovered)
                            }
                    }
                }
            }
        }


        return initMark
    }




    public func count (mark: MarkingGraph) -> Int{
      //parcour en profondeur

      var seen = [MarkingGraph]()
      var toSee = [MarkingGraph]()

      toSee.append(mark)
      while let currNode = toSee.popLast() {
        seen.append(currNode)
        for(_, successor) in currNode.successors{
          if !seen.contains(where: {$0 === successor}) && !toSee.contains(where: {$0 === successor}){
              toSee.append(successor)
            }
          }
      }

      return seen.count
    }





    public func moreThanTwo (mark: MarkingGraph) -> Bool {


      var seen = [MarkingGraph]()
      var toSee = [MarkingGraph]()

      toSee.append(mark)
      while let curNode = toSee.popLast() {
        seen.append(curNode)
        var nbSmoke = 0;
        for (key, value) in curNode.marking {
            if (key.name == "s1" || key.name == "s2" || key.name == "s3"){
               nbSmoke += Int(value)
            }
        }
        if (nbSmoke > 1) {
          return true
        }
        for(_, successor) in curNode.successors{
          if !seen.contains(where: {$0 === successor}) && !toSee.contains(where: {$0 === successor}){
              toSee.append(successor)
            }
          }
      }
      return false
    }




    public func twoTimesSame (mark: MarkingGraph) -> Bool {
      var seen = [MarkingGraph]()
      var toSee = [MarkingGraph]()

      toSee.append(mark)
      while let currNode = toSee.popLast() {
        seen.append(currNode)
        for (key, value) in currNode.marking {
            if (key.name == "p" || key.name == "t" || key.name == "m"){
               if(value > 1){
                 return true
               }
            }
        }
        for(_, successor) in currNode.successors{
          if !seen.contains(where: {$0 === successor}) && !toSee.contains(where: {$0 === successor}){
              toSee.append(successor)
            }
          }
      }
      return false
    }

}
