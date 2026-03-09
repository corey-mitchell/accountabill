# accountabill

An accountability buddy designed for keeping the user on task by forcing consequences onto them for failing to accomplish their own goals.

## Getting Started

**Note:** This application is currently only tested for Android.

To start this project, you will need Flutter and Dart installed.

First, clone the repository:

```
git clone https://github.com/corey-mitchell/accountabill.git
```

Then `cd` into the application:

```
cd ./accountabill
```

Install the application dependencies:

```
flutter pub get
```

Make sure your emulator is running or that your physical device is plugged in. You can run the below command for Android simulator devices to check if your device is listed:

```
adb devices
```

Finally, start up the application with the below command!

```
flutter run
```

## Future goals

- Implement Auth0 for handling user authentication.
- Get a service provider for listing and searching for available charities.
- Get a service provider for handling user notifications (probably AWS SNS).
- Implement stripe payments for handling user payment instruments.

## Known issues

- User authentication is supposed to be through another service that isn't Firebase. As such, there is no validation for user login or any separate flow for sign up.
- The charity search screen currently doesn't have any search functionality due to not being able to get an API key in time. Due to this, I had to literally pull tax information for all tax exempt businesses - which is a lot of businesses - and I didn't want to spin my wheels implementing my own search functionality.
- The dashboard page and the user's accounts are entirely hard-coded.
- Need some improvements on the swipe animations, but I think they'll do for being slapped together.
- Events that overlap don't have elevation offsets.
