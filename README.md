## Ticketmaster
Technical test for Ticketmaster

This app is built with the latest XCode 15 beta and targets iOS17. The reason for this was to experiment with the new @Observable macro for viewmodels, and also to try SwiftData for persistence.

To build the app use Xcode 15, check out the code, and press the run button…

There are 2 branches: 

* `main` - this branch does not utilise persistence.
* `swiftdata` - this is an experimental branch that uses the new iOS 17 SwiftData technology for persistence. _This is my first attempt at using it and I have not quite worked out how to get all the unit tests run correctly on this branch_ 

Only 1 external dependency is used: SwiftUI Async Image - for cacheing images (in URLCache) as the standard AsyncImage type does not perform any cacheing. 

Networking is done via the `TicketmasterClient` type (in it’s own package) which in turn uses a generic `APIClient` type which is designed to be re-usable (although it only implements `GET` requests at this stage).
