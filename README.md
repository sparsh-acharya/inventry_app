
# 📦 Zaiko - Inventory Management App

Zaiko is a collaborative, real-time inventory management system built with Flutter using **Feature-First Clean Architecture** and **BLoC** for state management. It leverages Firebase for authentication, cloud storage, and real-time updates.

---

## 🧱 Project Structure

The app uses **Feature-First Clean Architecture**, organized into the following layers:

```
lib/
│
├── core/                 # Shared utilities (theme, firebase functions, failures, widgets, etc.)
├── features/             # Feature-specific logic (auth, groups, items, etc.)
│   └── [feature]/
│       ├── data/         # Data layer (models, data sources, repository implementations)
│       ├── domain/       # Domain layer (entities, use cases, repository interfaces)
│       └── presentation/ # UI layer (blocs, screens, widgets)
├── injector/             # Dependency injection setup
├── firebase_options.dart# Firebase configuration
└── main.dart             # Entry point
```

---

## 🧠 Clean Architecture Overview

Each feature follows **3-layered clean architecture**:

1. **Data Layer**: Implements APIs, Firebase interactions, and persistence.
2. **Domain Layer**: Contains core business logic - entities, use cases, and repository interfaces.
3. **Presentation Layer**: UI logic and BLoC for state management.

🔁 **Dependency Rule**:
`Presentation → Domain → Data`

✅ Ensures:
- Separation of concerns
- Reusability
- Testability
- Scalability

---

## 🚀 Features

Each feature is implemented using its own folder with all layers encapsulated inside.

### ✅ Auth Feature
- Phone number authentication using Firebase
- OTP handling
- Session persistence
- Sign-out

### 👥 Group Management
- Create, join, and view groups
- Group membership with admin privileges
- Add/remove users (admin only)

### 📦 Inventory Items
- Add/edit/delete items within a group
- Quantity tracking
- Collaborative updates
- Low-stock notifications (planned)

---

## 🧩 State Management

**Library Used**: `flutter_bloc`
**Pattern**: BLoC (Business Logic Component)

Each feature has its own Bloc/Cubit and handles:
- State emissions (`Initial`, `Loading`, `Loaded`, `Error`)
- Event-driven UI updates
- Unidirectional data flow

Example:
```
lib/features/auth/presentation/bloc/auth_bloc.dart
lib/features/group/presentation/bloc/group_bloc.dart
```

Benefits:
- Testable and modular logic
- Clear separation of UI and logic
- Ideal for complex apps with async data flow

---

## 🔧 Technical Stack

| Layer           | Technology         |
|----------------|--------------------|
| UI              | Flutter            |
| State Mgmt      | BLoC               |
| Architecture    | Clean + Feature-First |
| Authentication  | Firebase Phone Auth |
| Backend (BaaS)  | Firebase Firestore |
| Notifications   | Firebase Messaging |
| Dependency Inj. | `get_it`, `injector.dart` |


---

## 🛠 Core Utilities

Shared across all features:

- `core/errors/failure.dart` – unified failure handling
- `core/firebase/firebase_functions.dart` – reusable Firebase operations
- `core/utils/usecase.dart` – base use case contract
- `core/theme/` – color schemes and app theme
- `core/widgets/` – reusable UI components

---

## 📂 Dependency Injection

Zaiko uses `get_it` for managing dependencies and services globally via:

```dart
lib/injector/injector.dart
```

Each repository, use case, and BLoC is registered and resolved through a centralized container.

---

## 🔥 Firebase Integration

Zaiko uses Firebase extensively:

- **Authentication**: via Phone Auth
- **Firestore**: for real-time data (groups, items, users)
- **Messaging**: push notifications (low inventory alerts, group invites)
- `firebase_options.dart` is auto-generated for project config

---

## 🔐 Security & Roles

- Each group has an **admin** user
- Admins can **add/remove** members
- **Role-based access** enforced in Firestore logic

---

## 📱 UI Overview

### Auth Flow
- Phone input screen
- OTP verification screen
- Authenticated home screen

### Main App
- Group selection screen
- Inventory list (with add/edit/delete)
- Group settings

---

## 🧪 Testing

✅ Recommended:
- **Unit Tests** for use cases and bloc logic
- **Widget Tests** for UI components

📁 Suggest creating:
```
test/
├── features/
│   ├── auth/
│   ├── group/
│   └── item/
└── core/
```

---

## 📦 Build & Run

### 🔧 Prerequisites

- Flutter SDK (3.x)
- Firebase project (with Phone Auth enabled)
- Firestore and Messaging setup
- Emulator or physical device

### ▶️ Run App

```bash
flutter pub get
flutter run
```

---

## 🛠 Future Improvements

- Add low-inventory push notifications
- Item history logs
- Image uploads (Firebase Storage)
- Testing suite with coverage
- Admin panel UI for managing groups
- Offline support with local cache

---

## 🧑‍💻 Contributing

Want to improve Zaiko?

1. Fork the repo
2. Create a feature branch
3. Make changes with clean architecture
4. Write tests
5. Submit a PR

---

## 📄 License

MIT License – feel free to use and modify.
