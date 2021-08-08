# Wrappers

Wrapper is way to display views or content by vertically wrapping them in a horizontal pattern.

# Requirements
* iOS 14 or 
* macOS 11

# Installation
There are two ways to add to your own project
1. Add as a Swift Package Dependency 
2. Import this project into your Xcode project and add under Frameworks and Libraries. 

```http
https://github.com/jonnyholland/Wrapper
````

# Use
The Wrapper framework allows you to access Wrap & Grid.
Simply import Wrapper, then use as seen below. 

````swift
import Wrapper
````
````swift
static let imageNames: [String] = ["plus", 
"minus",
"person",
"trash",
"doc",
"paperplane",
"newspaper"]
````
### Wrap multiple views 
````swift
Wrap {
Image(systemName: "plus")
Image(systemName: "minus")
Image(systemName: "person")
Image(systemName: "trash")
Image(systemName: "doc")
Image(systemName: "paperplane")
Image(systemName: "newspaper")

ForEach(imageNames, id: \.self) { imageName in
Image(systemName: imageName)
}
}
````
<img width="449" alt="Screen Shot 2021-07-15 at 4 49 11 PM" src="https://user-images.githubusercontent.com/26751945/125855872-c590c851-adce-43c7-ae2b-aa2e8a385c40.png">

### Wrap an array with Grid 
```swift
Grid(imageNames) { imageName in
Image(systemName: imageName)
}
````
<img width="444" alt="Screen Shot 2021-07-15 at 4 00 11 PM" src="https://user-images.githubusercontent.com/26751945/125855427-fd3745db-7522-4b25-8746-3ffce55a375f.png">


## Customize
You can actually customize every aspect of the grid so the items are arranged and displayed according to your liking.
````swift
Wrap(minimumWidth: 75, padding: 6, alignment: .center, spacing: 15) {
Image(systemName: "plus")
Image(systemName: "minus")
Image(systemName: "person")
Image(systemName: "trash")
Image(systemName: "doc")
Image(systemName: "paperplane")
Image(systemName: "newspaper")

ForEach(imageNames, id: \.self) { imageName in
Image(systemName: imageName)
}
}
````
<img width="452" alt="Screen Shot 2021-07-15 at 4 54 17 PM" src="https://user-images.githubusercontent.com/26751945/125856248-0332fbd1-cc7c-4b4c-91d5-08817770a80c.png">

````swift
Grid(imageNames, minimumWidth: 100, padding: 10, spacing: 15) { imageName in
Image(systemName: imageName)
}
````
<img width="435" alt="Screen Shot 2021-07-15 at 4 06 01 PM" src="https://user-images.githubusercontent.com/26751945/125855445-f0d4eea3-9cdd-4e6e-a95a-d27047603bc0.png">

