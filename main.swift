
import Foundation

let playcards = PlayCards()
if CommandLine.argc < 2 {
    playcards.interactiveMode()
} else {
    playcards.testMode()
}
