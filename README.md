# Sporter

`Sporter!` connect Sport Players and Gymmers

## 📦 Package Dependencies

Please double check and add those into the project. `Reset package caches` and `Update package caches` when there's any problem with packages before building the app.

- [Lottie](https://github.com/airbnb/lottie-ios)
- [Firebase iOS SDK](https://github.com/firebase/firebase-ios-sdk): Tick everything to be sure (although it will increase the project size quite a bit)

## 🧱 Project Structure

- `./Components` store all the reusable / customized components in the project
- `./Extensions` adapt customization on development types (Color, String, Double,...)
- `./Managers` OS configuration (Eg: Audio, Haptic)
- `./MVVM`
  - `/Models`: store all the entities
  - `/ViewModels`: store the ViewModels for the according views
  - `/Views`: store all the views displayed to the user
- `./Repositories` store all the direct interactive functions to (cloud) database (Firestore)
- `./Utils` support converting operation and accessing/updating UserDefaults

## Example of MVVM Architecture Flow

Please take a look on this reference: [Getting Started with Cloud Firestore and SwiftUI](https://www.raywenderlich.com/11609977-getting-started-with-cloud-firestore-and-swiftui#toc-anchor-004)
