## Ticketmaster
Technical test for Ticketmaster

This app is built with XCode 15 and targets iOS17. The reason for this was to experiment with the new @Observable macro for viewmodels, and also to try SwiftData for persistence.

To build the app use Xcode 15, check out the code, and press the run button…

This is my first time using SwiftData (it's a new iOS17 framework) - I have one unresolved issue, which is that in my unit tests I was not able to use the entity relationship for the EventImages. I suspect there is something I need to declare in the schema or model container, but the documentation for SwiftData is...sparse...at the moment.

Only 1 external dependency is used: SwiftUI Async Image - for cacheing images (in URLCache) as the standard AsyncImage type does not perform any cacheing. 

Networking is done via the `TicketmasterClient` type (in it’s own package) which in turn uses a generic `APIClient` package which is designed to be re-usable (although it only implements `GET` requests at this stage).

Tests for the `APIClient` itself are not implemented, but this could be done using `URLProtocol` to intercept requests and return mocked data.