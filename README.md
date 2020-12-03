# IOTConduit
iOS application to visualize pollution in Lake Champlain in and around the Burlington Waterfront. IOTConduit is a project for CS 275 at the University of Vermont.


# Burlington Water Quality Dashboard

This is an application that we made (Prasidha Timsina, Owen Anderson, Nicholas Hella, Oliver Reckord Groten) for our CS 275 Mobile App Development class in collaboration with IOTConduit.


## Installation

There may be errors when first trying to comple the project due to cocoapods. Try these two steps:

1) With terminal, CD into the project directory and run these terminal commands:
rm -rf "${HOME}/Library/Caches/CocoaPods"
rm -rf "`pwd`/Pods/"
pod update

1)  With the project still open, go into the project directory and delete hte 'Pods' folder and the 'Podfile.lock' file. Then quit xcode and open terminal into the project directory then 
do pod install. (this will take a few minutes)



This project was made on XCode Version 12.1 (12A7403) using Swift 5
The backend for this project was made with Google Firebase
