## <p align="center"> <a href="https://github.com/DenverCoder1/readme-typing-svg"><img src="https://readme-typing-svg.herokuapp.com?font=Time+New+Roman&color=%233c2d16&size=25&center=true&vCenter=true&width=600&height=100&lines=Login+🐻+project;A+Flutter+Rive+Showcase;by+Emmanuel+Diaz"></a>

<a href="https://www.youtube.com/watch?v=dQw4w9WgXcQ"><img src="https://user-images.githubusercontent.com/73097560/115834477-dbab4500-a447-11eb-908a-139a6edaec5c.gif"></a>

The project works by creating a login screen with an animation of a bear 🐻, where it reacts to success or failure triggers, and also reacts when writing the email, following what you write and the password by covering its eyes.

## 🤔 What is RIVE?
Rive 🤖 is a real-time interactive design tool that allows you to build beautiful, lightweight animations. Unlike static GIFs or videos, Rive animations (.riv files) can be controlled by code, allowing them to react instantly to user input

## 🤔 What is statemachine?
The State Machine 🧠 is the "brain" behind a Rive animation. It's a visual logic editor within Rive where you define different states (e.g., "idle", "typing", "success") and the transitions between them. From our Flutter code, we send inputs (like "isTyping" or "isError") to the State Machine, which then automatically figures out which animation to play.

<a href="https://www.youtube.com/watch?v=dQw4w9WgXcQ"><img src="https://user-images.githubusercontent.com/73097560/115834477-dbab4500-a447-11eb-908a-139a6edaec5c.gif"></a>

## 🛠️ Tech Stack

* **Flutter:** The UI framework.
    ```yaml
    dependencies:
      flutter:
        sdk: flutter
    ```
* **Rive:** The package used to load and control the Rive animation.
    ```yaml
    rive: ^0.13.20
    ```
* **Dart:** The programming language.
<p align="center">
  <a href="https://skillicons.dev">
    <img src="https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white"/>
    <img src="https://img.shields.io/badge/Rive-E855A3?style=for-the-badge&logo=rive&logoColor=white"/>
    <img src="https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white"/>
  </a>
</p>

<a href="https://www.youtube.com/watch?v=dQw4w9WgXcQ"><img src="https://user-images.githubusercontent.com/73097560/115834477-dbab4500-a447-11eb-908a-139a6edaec5c.gif"></a>

## 🚀 Getting Started
Installation
1.  **Clone the repository**
    ```bash
    git clone <project_url>
    ```

2.  **Navigate to the project directory**
    ```bash
    cd practica_1
    ```

3.  **Install dependencies**
    ```bash
    flutter pub get
    ```

4.  **Run the application**
    ```bash
    flutter run
    ```

<a href="https://www.youtube.com/watch?v=dQw4w9WgXcQ"><img src="https://user-images.githubusercontent.com/73097560/115834477-dbab4500-a447-11eb-908a-139a6edaec5c.gif"></a>

## 📂 Project Structure
```bash
Login_bear_project/
├── android/        # Android-specific platform code
├── assets/         # Contains all static assets
│   └── animated_login_character.riv  # <-- The Rive animation
├── ios/            # iOS-specific platform code
├── lib/            # All Dart source code for the app
│   ├── screens/
│   │   └── login_screen.dart   # <-- Main UI and Rive logic
│   └── main.dart         # <-- App entry point
├── test/           # Widget and unit tests
├── .gitignore
├── pubspec.yaml    # <-- Project dependencies (like flutter & rive)
└── README.md
```

<a href="https://www.youtube.com/watch?v=dQw4w9WgXcQ"><img src="https://user-images.githubusercontent.com/73097560/115834477-dbab4500-a447-11eb-908a-139a6edaec5c.gif"></a>

## 🎮 How to Use

Once the application is running on your simulator or device, here’s how you can test the interactive features:

* **Test Email Focus:** Tap on the **Email** field. You will see the Rive character look towards the field and follow along as you type (`isChecking` / `numLook`).
* **Test Password Focus:** Tap on the **Password** field. The character will immediately cover its eyes (`isHandsUp`).
* **See Live Validation:** As you type in the password field, watch the password criteria checklist update in real-time.
* **Trigger Failure:** Enter an invalid email or a password that doesn't meet the criteria, then press the **Login** button. The character will play its "fail" animation (`trigFail`).
* **Trigger Success:** Enter a valid email and a password that meets all requirements, then press **Login**. The character will celebrate with its "success" animation (`trigSuccess`).
  
<a href="https://www.youtube.com/watch?v=dQw4w9WgXcQ"><img src="https://user-images.githubusercontent.com/73097560/115834477-dbab4500-a447-11eb-908a-139a6edaec5c.gif"></a>

## 🎬 Demo

![App Demo GIF](./demo/Demo.gif)

<a href="https://www.youtube.com/watch?v=dQw4w9WgXcQ"><img src="https://user-images.githubusercontent.com/73097560/115834477-dbab4500-a447-11eb-908a-139a6edaec5c.gif"></a>

## 🖌️ class and 🧑🏻‍🏫 professor

<p align="center">
  <a href="https://github.com/CodeWhiteWeb/CodeWhiteWeb"><img src="https://readme-typing-svg.herokuapp.com?color=%23000000&center=true&vCenter=true&lines=Graficacion🧑🏻‍💻;🧑🏻‍🏫Rodrigo+Fidel+Gaxiola+Sosa"></a>
</p>

<a href="https://www.youtube.com/watch?v=dQw4w9WgXcQ"><img src="https://user-images.githubusercontent.com/73097560/115834477-dbab4500-a447-11eb-908a-139a6edaec5c.gif"></a>

## 🙏 Credits 

A huge thank you to the talented creators behind the Rive animation used in this project.

* **Animation:** `Remix of Login Machine`
* **Creator:** [**dexterc**](https://rive.app/community/5608-11531-dexterc/)
* **Source:** [https://rive.app/marketplace/3645-7621-remix-of-login-machine/](https://rive.app/marketplace/3645-7621-remix-of-login-machine/)
* **Based on:** `Animated Login Character` by [**JcToon**](https://rive.app/community/190-366-jctoon/)


