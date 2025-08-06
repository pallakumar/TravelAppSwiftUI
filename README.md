#  SwiftUI Travel App with Live Map Routing

This is a travel-oriented iOS app built using **SwiftUI** and **MapKit** that allows users to search for locations, get directions with route lines, view estimated distance and time, and launch directions in Apple Maps.

##  Features

-  **Live Location Search**: Auto-updating input fields for source and destination
-  **MapKit Integration**: Real-time route drawing and user location tracking
-  **Multiple Travel Modes**: Supports driving, walking, and transit navigation
-  **ETA & Distance Display**: Clean info cards for route distance and estimated time
-  **Live Updates**: Map refreshes automatically when inputs or travel mode change
-  **Deep Linking**: Opens selected routes directly in Apple Maps
-  **Modern SwiftUI UI**: Responsive, minimal design using SwiftUI components

##  Screenshots

![Maps_Inline_RoutesSwiftUI](https://github.com/user-attachments/assets/c1b2ca71-bfe7-4384-a83f-5f52653446c0)

## Getting Started
Clone the repository:
 git clone https://github.com/yourusername/swiftui-travel-mapkit.git

Run on a real device or simulator with location enabled
**Requirements**
Open in Xcode 15+
iOS 15+
Swift 5.8+
Xcode 15+

**Technologies**
SwiftUI
MapKit
CoreLocation

UIViewRepresentable (to bridge UIKit MapKit with SwiftUI)
**DeepLink**
let url = URL(string: "http://maps.apple.com/?daddr=Chennai&saddr=Bangalore&dirflg=d")!
UIApplication.shared.open(url)

**License**
This project is licensed under the MIT License. See the LICENSE file for details.

**Author**
Palla Lakshmi Kumar
📫 KUMAR.PALLA6@GMAIL.COM
📱 https://www.linkedin.com/in/palla-kumar-a1a47848/


