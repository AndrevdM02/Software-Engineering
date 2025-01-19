This project implements a Two-Factor Authentication (2FA) system to enhance the security of user logins.

## Table of Contents

- [Features](#features)
- [Prerequisites](#prerequisites)
- [Getting Started](#getting-started)
- [Usage](#usage)
- [Project Structure](#project-structure)
- [Database Structure](#database-structure)
- [Backend Functions](#backend-functions)
- [Contributing](#contributing)
- [Coverage report](#coverage-report)
- [Mutation report](#mutation-report)

| Branch |                                                                                                   Pipeline                                                                                                  |                                                                                                Code coverage                                                                                                | Pages                                                                                             |                                                             Coverage Report                                                             |                                                                Mutation Report                                                                |
|:------:|:-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------:|:-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------:|---------------------------------------------------------------------------------------------------|:---------------------------------------------------------------------------------------------------------------------------------------:|:---------------------------------------------------------------------------------------------------------------------------------------------:|
| master | [ ![pipeline status ]( https://git.cs.sun.ac.za/Computer-Science/rw344/2023/Adrastea-cs344/badges/main/pipeline.svg ) ](https://git.cs.sun.ac.za/Computer-Science/rw344/2023/Adrastea-cs344/-/commits/main) | [ ![coverage report ]( https://git.cs.sun.ac.za/Computer-Science/rw344/2023/Adrastea-cs344/badges/main/coverage.svg ) ](https://git.cs.sun.ac.za/Computer-Science/rw344/2023/Adrastea-cs344/-/commits/main) | [    link    ](    https://git.cs.sun.ac.za/Computer-Science/rw344/2023/Adrastea-cs344/pages    ) | [    link    ](    https://computer-science.pages.cs.sun.ac.za/rw344/2023/Adrastea-cs344/coverage-website/coverage/html/index.html    ) | [     link     ](     https://computer-science.pages.cs.sun.ac.za/rw344/2023/Adrastea-cs344/mutation-website/mutation-test-report.html     )  |

## Features
### Website
- User registration.
- User login
- Option to enable 2FA.
- Login using 2FA.
- Display generated OTP
- Communication with backend

### App
- Device registration.
- OTP validation.
- Authentication of website login.
- Push Notifications.
- Boimetrics.
- Communication with backend.

### Backend
#### Database
- Users table with fields: email, name, surname, phonenumber, hashedPassword.
- PublicKey table with field Key containing the public key for encryption.
- PrivateKey table with field Key containing the private key for decryption.
- OTPandEmail table with fields: email, otp.
- RegisteredDevices table with fields: deviceID, email, registeredAt

#### Functions
- initializeBackend (start firebase instance)
- generateOTP (creates an entry for OTPandEmail and deletes it after 60 seconds)
- SendEmailtoBackend (get the current logged in user's email)
- registerDevice (compare generated OTP and inputted OTP and creates a RegisteredDevices entry)
- generateKeyPair (generates private/public key pairs for encryption)

## Prerequisites

Before getting started, ensure you have the following:

- Node.js and npm installed.
- Flutter is installed.
- Android studio is installed.

## Getting Started

1. Clone this repository.

2. cd App/frictionless-authentication 

3. Install app dependencies: flutter pub get

4. cd website/ 

5. Install website dependencies: flutter pub get

6. Run website: flutter run -d chrome

## Coverage report
To access the coverage report for the website, go to the pages page on gitlab and click on the link. Add the following to the back of the URL: coverage-website/coverage/html/index.html

Link to the coverage report: https://computer-science.pages.cs.sun.ac.za/rw344/2023/Adrastea-cs344/coverage-website/coverage/html/index.html

In flutter, when you test a new app, there is a few files that will never be tested. One of these cases is the main, as a flutter test runs its own main function and will never reach the main of the actual app. Thus we needed to exclude the main file in our coverage report. There was a few more cases like these, for example the responsive.dart files that was excluded, as it basically just checks what device the app is being run on and since the project was tested on a laptop, it never reached the mobile and tablet lines, which influenced our coverage a lot, as that file is used in every single test. In our actual code that runs the project, we have to use a mocked Firebase and a mocked URL link to generate and run our tests, so all the code that uses a Firebase or a URL link, will never be reached, as we need to use our mocked functions to run our tests, and this does impact our coverage quite a lot.

## Mutation report

In our mutation with flutter, there is unfortunatly also a few cases similar to the coverage report. There is a few files that generates muattion, but will never stop, because of how flutter works. For example in our responsive.dart file, it basically changes all of our aspect ratio tests to negative numbers, but it will never terminate, because in flutter, a negative aspect ratio is obtainable and thus, the project will never terminate. There was also a lot of cases, where we had to use a hyphen in a String for a html URL link and the mutation changes the hyphen to a "+" and since we need to mock a html link to test our project, the project will never terminate. In our programs that actually executes the code and builds the app, most of the mutations terminate.

To access the mutation report for the website, go to the pages page on gitlab and click on the link. Add the following to the back of the URL: mutation-website/mutation-test-report.html

Link to the mutation report: https://computer-science.pages.cs.sun.ac.za/rw344/2023/Adrastea-cs344/mutation-website/mutation-test-report.html