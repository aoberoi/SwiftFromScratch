import Foundation
import Dispatch


// Run a smoke test for Dispatch functionality
let myQueue = DispatchQueue(label: "myQueue")
myQueue.async {
  print("1")
}
myQueue.async {
  print("2")
}
myQueue.async {
  print("3")
}
myQueue.async {
  exit(0)
}
dispatchMain();
