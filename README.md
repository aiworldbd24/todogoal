# TodoGoal Flutter Starter

A cross-platform Flutter 3+ project scaffold for a futuristic, glassmorphism-inspired to-do and project manager. The app targets Web, Android, and iOS while integrating with Hostinger (PHP + MySQL) or Firebase backends and Firebase Cloud Messaging for push notifications.

## Features

- **Authentication flow** with login, signup, and email verification screens.
- **Welcome messaging** after login and signup actions.
- **Dashboard** with list, calendar, and card views, including first-login project prompt.
- **Project & task management** with add/edit forms and detail pages.
- **Riverpod state management** wired to mocked services and ready for API integration.
- **Glassmorphism UI kit** including reusable containers, buttons, and gradient backgrounds.
- **Notification service** prepared for FCM deadline reminders.
- **Backend samples** for Hostinger PHP API and Firebase Cloud Functions.

## Getting Started

1. Ensure you have Flutter 3+ installed with the required platforms (web, Android, iOS).
2. From the project root run:

   ```bash
   flutter pub get
   flutter run -d chrome # or android/ios device
   ```

3. Replace the dummy implementations inside `lib/services` with your actual API logic:
   - Update `auth_service.dart` to connect to Firebase Auth or your PHP endpoints.
   - Point `db_service.dart` to your Hostinger API base URL or Firebase Functions.
   - Configure `notification_service.dart` with Firebase initialization & local notifications if needed.

4. For backend setup examples, refer to:
   - `backend/hostinger/api_example.php`
   - `backend/firebase/cloud_function_example.js`

## Customization Tips

- Adjust color palettes and animations inside `lib/theme/app_theme.dart` and `lib/widgets`.
- Extend the Riverpod providers in `lib/providers` to support filters, search, and sorting via the database.
- Add platform-specific Firebase setup files (GoogleService-Info.plist, google-services.json) when wiring to Firebase.

## Project Structure (excerpt)

```
lib/
  main.dart
  models/
  providers/
  routes/
  screens/
  services/
  theme/
  utils/
  widgets/
backend/
  hostinger/
  firebase/
```

Happy building!
