import TaskManagerLib

let taskManager = createTaskManager()

// Show here an example of sequence that leads to the described problem.
// For instance:

let create = taskManager.transitions.filter{$0.name == "create"}[0]
let spawn = taskManager.transitions.filter{$0.name == "spawn"}[0]
let exec = taskManager.transitions.filter{$0.name == "exec"}[0]
let fail = taskManager.transitions.filter{$0.name == "fail"}[0]
let success = taskManager.transitions.filter{$0.name == "success"}[0]
let taskPool = taskManager.places.filter{$0.name == "taskPool"}[0]
let processPool = taskManager.places.filter{$0.name == "processPool"}[0]
let inProgress = taskManager.places.filter{$0.name == "inProgress"}[0]

print("avec le réseau de pétri de base")
let m1 = create.fire(from: [taskPool: 0, processPool: 0, inProgress: 0])
print(m1!)
let m2 = spawn.fire(from: m1!)
print(m2!)
let m3 = spawn.fire(from: m2!)
print(m3!, "on a ici un 2 processus pour une seule tâche")
let m4 = exec.fire(from: m3!)
print(m4!)
let m5 = exec.fire(from: m4!)
print(m5!)
let m6 = success.fire(from: m5!)
print(m6!, "le jeton est bloqué dans inProgress")



let correctTaskManager = createCorrectTaskManager()

// Show here that you corrected the problem.
// For instance:
let create2 = correctTaskManager.transitions.filter{$0.name == "create"}[0]
let spawn2 = correctTaskManager.transitions.filter{$0.name == "spawn"}[0]
let exec2 = correctTaskManager.transitions.filter{$0.name == "exec"}[0]
let fail2 = correctTaskManager.transitions.filter{$0.name == "fail"}[0]
let success2 = correctTaskManager.transitions.filter{$0.name == "success"}[0]
let taskPool2 = correctTaskManager.places.filter{$0.name == "taskPool"}[0]
let processPool2 = correctTaskManager.places.filter{$0.name == "processPool"}[0]
let inProgress2 = correctTaskManager.places.filter{$0.name == "inProgress"}[0]
let regulateur2 = correctTaskManager.places.filter{$0.name == "regulateur"}[0]

print(" ")
print("avec la correction")
let n1 = create2.fire(from: [taskPool2: 0, processPool2: 0, inProgress2: 0, regulateur2: 0])
print(n1!)
let n2 = spawn2.fire(from: n1!)
print(n2!)
let n3 = spawn2.fire(from: n2!)
print(n3!)
let n4 = exec2.fire(from: n3!)
print(n4!)
let n5 = exec2.fire(from: n4!)
print(n5!)
let n6 = success2.fire(from: n5!)
print(n6!, "après le sucess le processus qui est dans inProgress doit s'exécuter avec la tâche qui est dans le regulateur")
let n7 = fail2.fire(from: n6!)
print(n7!, "c'est ici que le processus s'execute et doit forcément fail car la tâche à déjà été accomplie")




