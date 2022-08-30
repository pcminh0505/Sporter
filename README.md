# Sporter

`Sporter!` connects Sport Players and Gymmers

## 📦 Package Dependencies

Please double check and add those into the project. `Reset package caches` and `Update package caches` when there's any problem with packages before building the app.

- [Lottie](https://github.com/airbnb/lottie-ios): For animated icons
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

## 🔺 Housekeeping Rules
### 🧬 Branch

Manage branches by `features`, except for those who is in charge of a whole page can create their own branch to work on. Naming convention: `view`-`feature`

Examples: For 2 developers working on a same page
- `home-tablist` 
- `home-exploring` 

### 🧬 Commit

File commits: Try to split pack of commits according to a completion of one functionality.

Naming convention: `[Type]: Content`

Examples: 
- `[Feat] User Authentication Flow`
- `[Bug] Async-await on home screen`


### 🧬 Pull Request (PR)

- Make sure to PR after completing a single function. PR will be reviewed by others but try to make sure there is no unannounced bug. If there is, please include in the PR for other to solve (in case there's an urgent need for that feature)
- Remember to **Squash and Merge** a whole PR to revert easily if bugs found!


## 📝 Example of MVVM Architecture Flow

Please take a look on this reference: [Getting Started with Cloud Firestore and SwiftUI](https://www.raywenderlich.com/11609977-getting-started-with-cloud-firestore-and-swiftui#toc-anchor-004)
![image](https://user-images.githubusercontent.com/54668379/187414747-ab869678-e83c-4f18-88a9-813b48e4b01b.png)
