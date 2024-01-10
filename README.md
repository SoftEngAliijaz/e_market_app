```markdown
# E-Market App

E-Market App is a Flutter application designed for managing products and user interactions. It provides features for both users and administrators.

## Features

- **User Authentication:** Secure user login and registration.
- **Admin Dashboard:** Admins can manage products, categories, and user roles.
- **User Dashboard:** Users can explore and interact with products.
- **CRUD Operations:** Admins can perform CRUD operations on products.
- **Responsive Design:** The app is designed to work seamlessly on various devices.

## Screenshots
Will Add Screenshots ASAP! 😊

## Tech Stack

- Flutter
- Firebase (Authentication, Firestore)
- Cloud Firestore
- Cached Network Image

## Setup

1. Clone the repository.
   ```bash
   git clone https://github.com/your-username/e-market-app.git
   ```

2. Navigate to the project directory.
   ```bash
   cd e-market-app
   ```

3. Install dependencies.
   ```bash
   flutter pub get
   ```

4. Run the app.
   ```bash
   flutter run
   ```

## Configuration

- Update Firebase configuration in `lib/constants/constants.dart` with your Firebase project details.

## Contributing

Contributions are welcome! Please follow the [Contribution Guidelines](CONTRIBUTING.md).

## License

This project is licensed under the [MIT License](LICENSE).

```
#Generating SHA-1 & SHA-256 key

To generate the Android debug key, use the following command:

keytool -list -v -keystore "C:\Users\YourUserName\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android

Note: 
- Make sure to replace "YourUserName" with your actual Windows username.
- The keystore is typically located at "C:\Users\YourUserName\.android\debug.keystore".
- If you are using Android Studio, the keytool executable is usually found at:
                "C:\Program Files\Android\Android Studio\jbr\bin".
