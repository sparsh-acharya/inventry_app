
# 📦 Zaiko - Enterprise-Grade Inventory Management System

[![Flutter](https://img.shields.io/badge/Flutter-3.7.2+-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)](https://firebase.google.com)
[![TypeScript](https://img.shields.io/badge/TypeScript-007ACC?style=for-the-badge&logo=typescript&logoColor=white)](https://www.typescriptlang.org)
[![Clean Architecture](https://img.shields.io/badge/Architecture-Clean-brightgreen?style=for-the-badge)]()
[![BLoC Pattern](https://img.shields.io/badge/State_Management-BLoC-blue?style=for-the-badge)]()

[![Get APK](https://img.shields.io/badge/📱_Get_APK-Download-success?style=for-the-badge&logo=android&logoColor=white)](https://appdistribution.firebase.dev/i/a6e573688c9153f4)

Zaiko is a sophisticated, **real-time collaborative inventory management system** architected with enterprise-grade patterns and cutting-edge technologies. Built using **Feature-First Clean Architecture**, **Domain-Driven Design**, and **SOLID principles**, it demonstrates advanced software engineering practices suitable for production-scale applications.

## 🏗️ Advanced Architecture & Technical Excellence

### 🎯 Architectural Paradigms

This project showcases **multiple advanced architectural patterns** working in harmony:

- **🧱 Feature-First Clean Architecture**: Complete isolation of business logic from framework dependencies
- **🔄 CQRS-inspired Pattern**: Separation of read/write operations with optimized data flows
- **🎭 Repository Pattern**: Abstracted data access with multiple implementations
- **💉 Dependency Injection**: IoC container using `get_it` for loose coupling
- **📱 BLoC Pattern**: Reactive state management with unidirectional data flow
- **🏭 Factory Pattern**: Model creation and transformation layers
- **🔐 Provider Pattern**: Authentication and authorization abstractions

### 🗂️ Sophisticated Project Structure

```
lib/
│
├── core/                           # 🛠️ Shared Infrastructure & Cross-Cutting Concerns
│   ├── errors/                     # Unified error handling & custom exceptions
│   ├── firebase/                   # Firebase SDK abstractions & utilities
│   ├── utils/                      # Generic utilities, extensions & helpers
│   ├── theme/                      # Design system & theming architecture
│   └── widgets/                    # Reusable UI components library
│
├── features/                       # 🎯 Domain-Driven Feature Modules
│   ├── auth/                       # 🔐 Authentication & Authorization
│   │   ├── data/
│   │   │   ├── datasource/         # Firebase Auth SDK integration
│   │   │   ├── models/             # Data transfer objects & serialization
│   │   │   └── repo/               # Repository implementations
│   │   ├── domain/
│   │   │   ├── entities/           # Core business objects
│   │   │   ├── repo/               # Repository contracts/interfaces
│   │   │   └── usecases/           # Business logic encapsulation
│   │   └── presentation/
│   │       ├── bloc/               # State management (BLoC pattern)
│   │       ├── pages/              # UI screens & navigation
│   │       └── widgets/            # Feature-specific components
│   │
│   ├── group/                      # 👥 Collaborative Group Management
│   ├── list/                       # 📦 Inventory Item Management
│   └── user/                       # 👤 User Profile & Preferences
│
├── injector/                       # 🏭 Dependency Injection Container
│   ├── modules/                    # Feature-specific DI modules
│   └── service_locator.dart        # Global dependency registration
│
├── functions/                      # ☁️ Cloud Functions (TypeScript)
│   └── src/
│       └── index.ts                # Automated inventory & notifications
│
├── firebase_options.dart           # Auto-generated Firebase configuration
└── main.dart                       # Application entry point & bootstrap
```

---

## 🔬 Technical Deep Dive

### 🧠 Clean Architecture Implementation

Each feature implements **Robert C. Martin's Clean Architecture** with strict dependency inversion:

```dart
Presentation Layer (UI/BLoC)
      ↓ (depends on)
Domain Layer (Business Logic)
      ↓ (depends on)
Data Layer (External Interfaces)
```

**Key Benefits Achieved:**
- ✅ **Framework Independence**: Business logic isolated from Flutter/Firebase
- ✅ **Testability**: Each layer independently unit testable
- ✅ **Flexibility**: Easy to swap implementations (e.g., Firebase → REST API)
- ✅ **Maintainability**: Clear separation of concerns and responsibilities

### 🔄 Advanced State Management with BLoC

**Reactive Programming** with event-driven architecture:

```dart
// Example: Advanced BLoC with multiple event handlers
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  // Dependency injection of use cases
  final SendOtpUsecase sendOtp;
  final VerifyOptUsecase verifyOtp;
  final GetCurrentuserUsecase getCurrentUser;

  AuthBloc({required this.sendOtp, ...}) : super(AuthInitialState()) {
    // Event-to-handler mapping with async processing
    on<SendOTPEvent>(_onSendOtp);
    on<VerifyOTPEvent>(_onVerifyOtp);
    on<GetCurrentUserEvent>(_onGetCurrentUser);
  }
}
```

**Advanced Features:**
- 🔄 **Event Transformation**: Complex async event chains
- 📦 **State Persistence**: Automatic state restoration
- 🎯 **Selective Rebuilds**: Optimized UI updates with BlocBuilder/BlocListener
- 🔍 **Debugging**: Comprehensive logging and state inspection

### 🏭 Sophisticated Dependency Injection

**Service Locator Pattern** with modular registration:

```dart
// Modular DI architecture
Future<void> init() async {
  await initAuthModule();      // Authentication services
  await initUserModule();      // User management services
  await initGroupModule();     // Group collaboration services
  await initListModule();      // Inventory management services
}

// Feature-specific dependency modules
Future<void> initAuthModule() async {
  // Data layer registration
  sl.registerLazySingleton<AuthDatasource>(() => FirebaseAuthDatasource());
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));

  // Domain layer registration
  sl.registerLazySingleton(() => SendOtpUsecase(repository: sl()));
  sl.registerLazySingleton(() => VerifyOptUsecase(repository: sl()));

  // Presentation layer registration
  sl.registerFactory(() => AuthBloc(sendOtp: sl(), verifyOtp: sl()));
}
```

### 📊 Real-Time Data Architecture

**Firebase Firestore** integration with **reactive streams**:

```dart
// Real-time inventory updates with stream transformations
Stream<List<ListEntity>> getItems(String groupId) {
  return _firestore
    .collection('groups')
    .doc(groupId)
    .collection('items')
    .orderBy('updatedAt', descending: true)
    .snapshots()
    .map((snapshot) => snapshot.docs
        .map((doc) => ListModel.fromMap(doc.data()))
        .toList());
}
```

**Advanced Real-Time Features:**
- 🔄 **Optimistic Updates**: Immediate UI feedback with rollback capability
- 🔄 **Conflict Resolution**: Last-write-wins with timestamp-based merging
- 📊 **Real-Time Analytics**: Live inventory tracking across multiple users

---

## ☁️ Cloud Infrastructure & Microservices

### 🚀 Firebase Cloud Functions (TypeScript)

**Serverless automation** with enterprise-grade scheduling:
- used to send notification for low stock alert

```typescript
// Automated inventory management with intelligent thresholding
export const dailyItemAutomation = onSchedule({
    schedule: "0 5 * * *",           // Daily at 5 AM IST
    timeZone: "Asia/Kolkata",
}, async (event) => {
    // Collection group queries for cross-group analytics
    const itemsQuery = db
        .collectionGroup("items")
        .where("automationEnabled", "==", true);

    // Parallel processing with Promise.all optimization
    const updatePromises = itemsSnapshot.docs.map(async (doc) => {
        const item = doc.data();
        const newCount = item.itemCount - (item.consumptionRate || 0);

        // Intelligent threshold-based notifications
        if (newCount <= item.notificationThreshold) {
            await sendMulticastNotification(groupMembers, item);
        }
    });

    await Promise.all(updatePromises);
});
```

**Cloud Function Capabilities:**
- ⏰ **Cron-based Scheduling**: Automated daily inventory updates
- 📱 **FCM Integration**: Intelligent push notifications with targeting
- 📊 **Analytics Processing**: Cross-group inventory intelligence
- 🔄 **Atomic Transactions**: Data consistency across multiple documents

### 🔐 Advanced Security & Authentication

**Multi-layered security architecture**:

```dart
// Firebase Security Rules integration
abstract class AuthRepository {
  FutureVoid sendOtp(String phone, Function(String) onCodeSent);
  FutureEither<AuthUserEntity> verifyOtp(String verificationId, String otp);
  FutureEither<AuthUserEntity?> getCurrentUser();
}

// Secure phone number verification flow
class FirebaseAuthDatasource implements AuthDatasource {
  Future<void> sendOTP({required String phone, ...}) async {
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (credential) => /* Auto-verification */,
      verificationFailed: (exception) => /* Error handling */,
      codeSent: (verificationId, resendToken) => /* OTP sent */,
    );
  }
}
```

**Security Features:**
- 📱 **Phone Authentication**: SMS-based OTP verification
- 🔐 **JWT Tokens**: Secure session management
- 🛡️ **Firebase App Check**: App attestation and abuse prevention
- 👥 **Role-Based Access**: Admin/member permission system
- 🔒 **Firestore Security Rules**: Database-level access control

---

## 🚀 Advanced Features & Capabilities

### 📱 Real-Time Push Notifications

**Firebase Cloud Messaging** with intelligent targeting:

```dart
class NotificationServices {
  Future<void> initNotifications(BuildContext context) async {
    // Runtime permission handling
    final settings = await messaging.requestPermission(
      alert: true, badge: true, sound: true, provisional: true
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // Automatic FCM token management
      context.read<UserBloc>().add(RequestFCMTokenEvent());
    }
  }
}
```

### 🎨 Modern UI/UX with Glassmorphism

**Premium design system** with advanced animations:

```dart
// Glassmorphic design components
Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [Colors.white.withOpacity(0.25), Colors.white.withOpacity(0.15)],
    ),
    borderRadius: BorderRadius.circular(24),
    border: Border.all(color: Colors.white.withOpacity(0.2)),
    boxShadow: [/* Advanced shadow system */],
  ),
  child: BackdropFilter(/* Blur effects */),
)
```

### 🌍 International Phone Support

**Country code selection** with comprehensive international support:

```dart
// Advanced country code picker integration
CountryCodePicker(
  onChanged: (countryCode) => setState(() {
    selectedCountryCode = countryCode.dialCode ?? "+91";
  }),
  initialSelection: 'IN',
  favorite: const ['+91', 'IN', '+1', 'US'],
  searchDecoration: InputDecoration(/* Styled search */),
)
```

---

## 🔧 Technical Stack & Dependencies

### 📚 Core Technologies

| **Category** | **Technology** | **Purpose** | **Advanced Features** |
|--------------|----------------|-------------|----------------------|
| **Framework** | Flutter 3.7.2+ | Cross-platform UI | Hot reload, AOT compilation |
| **Language** | Dart 3.0+ | Client-side logic | Sound null safety, async/await |
| **Backend** | TypeScript | Cloud functions | Strong typing, advanced tooling |
| **State Management** | flutter_bloc ^9.1.1 | Reactive architecture | Event sourcing, state persistence |
| **Architecture** | Clean + DDD | Software design | SOLID principles, testability |
| **Database** | Cloud Firestore | NoSQL real-time DB | Offline support, real-time sync |
| **Authentication** | Firebase Auth | Phone verification | Multi-factor auth, JWT tokens |
| **Notifications** | FCM + Local | Push messaging | Background processing, targeting |
| **Dependency Injection** | get_it ^8.0.3 | IoC container | Lazy loading, scope management |
| **Functional Programming** | dartz ^0.10.1 | Error handling | Either monad, immutable data |

### 🏗️ Advanced Dependencies

```yaml
dependencies:
  # Core Framework
  flutter: sdk

  # State Management & Architecture
  flutter_bloc: ^9.1.1              # Advanced state management
  equatable: ^2.0.5                 # Value equality for immutable objects
  dartz: ^0.10.1                    # Functional programming utilities
  get_it: ^8.0.3                    # Dependency injection container

  # Firebase Ecosystem
  firebase_core: ^3.15.1            # Firebase SDK initialization
  firebase_auth: ^5.6.2             # Authentication services
  cloud_firestore: ^5.6.11          # NoSQL real-time database
  firebase_messaging: ^15.2.10      # Push notifications
  firebase_storage: ^12.4.9         # File storage services
  firebase_app_check: ^0.3.2+10     # App attestation & abuse prevention

  # UI & User Experience
  flutter_svg: ^2.2.0               # Vector graphics support
  flutter_local_notifications: ^19.3.1  # Local notification system
  country_code_picker: ^3.0.0       # International phone support
  image_picker: ^1.1.2              # Camera & gallery integration
  app_settings: ^6.1.1              # System settings integration

  # Development & Tooling
  flutter_launcher_icons: ^0.14.4   # App icon generation
```

---

## 🧪 Advanced Error Handling & Resilience

### 🛡️ Robust Error Management

**Centralized error handling** with custom exception hierarchy:

```dart
// Custom failure hierarchy
abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);
}

class FirebaseError extends Failure {
  const FirebaseError({required String message}) : super(message);
}

class NetworkError extends Failure {
  const NetworkError({required String message}) : super(message);
}

// Either monad for elegant error handling
FutureEither<List<GroupEntity>> getGroups(String userId) async {
  try {
    final groups = await datasource.getGroups(userId);
    return Right(groups);
  } catch (e) {
    return Left(FirebaseError(message: e.toString()));
  }
}
```

### 🔄 Atomic Operations & Transactions

**Firestore transactions** for data consistency:

```dart
// Complex multi-document transactions
await FirebaseFirestore.instance.runTransaction((transaction) async {
  // Read phase - get current state
  final groupSnapshot = await transaction.get(groupDocRef);

  // Validation phase - business logic checks
  if (!groupSnapshot.exists) {
    throw Exception("Group does not exist.");
  }

  // Write phase - atomic updates
  transaction.update(groupDocRef, {
    'members': FieldValue.arrayUnion([userId]),
    'updatedAt': FieldValue.serverTimestamp(),
  });
});
```

---

## 📊 Performance Optimization & Scalability

### ⚡ Advanced Performance Techniques

**Optimized data loading** and **memory management**:

```dart
// Stream optimization with selective updates
Stream<List<ListEntity>> getItems(String groupId) {
  return _firestore
    .collection('groups')
    .doc(groupId)
    .collection('items')
    .orderBy('updatedAt', descending: true)
    .limit(50)  // Pagination for large datasets
    .snapshots()
    .distinct()  // Prevent duplicate emissions
    .map((snapshot) => snapshot.docChanges
        .map((change) => ListModel.fromMap(change.doc.data()))
        .toList());
}

// Memory-efficient image handling
Future<void> _pickImage() async {
  final image = await ImagePicker().pickImage(
    source: ImageSource.gallery,
    maxWidth: 1024,      // Reduce memory footprint
    maxHeight: 1024,
    imageQuality: 85,    // Optimize file size
  );
}
```

### 🎯 Intelligent Caching Strategy

**Multi-level caching** for optimal performance:

```dart
class UserBloc extends Bloc<UserEvent, UserState> {
  UserEntity? _userCache;  // In-memory caching

  Future<void> _onLoadUser(LoadUserEvent event, Emitter<UserState> emit) async {
    // Return cached data immediately
    if (_userCache != null) {
      emit(UserLoaded(_userCache!));
    }

    // Background refresh from server
    final result = await getCurrentUser(NoParams());
    result.fold(
      (failure) => emit(UserError(failure.message)),
      (user) {
        _userCache = user;  // Update cache
        emit(UserLoaded(user!));
      },
    );
  }
}
```

---

## 🎯 Why This Project Stands Out

### 💼 Enterprise-Ready Architecture

This project demonstrates **production-grade software engineering** with:

- **🏗️ Scalable Architecture**: Clean architecture principles ensure maintainability at scale
- **🔒 Security-First Design**: Multi-layered security with industry best practices
- **⚡ Performance Optimization**: Advanced caching, lazy loading, and efficient data structures
- **🧪 Quality Assurance**: Comprehensive testing strategy with high code coverage

### 🚀 Technical Innovation

**Cutting-edge technology integration**:

- **Real-time Collaboration**: WebSocket-based live updates across multiple users
- **Serverless Computing**: Cloud Functions for scalable background processing
- **Reactive Programming**: Event-driven architecture with streams and reactive patterns
- **Microservices Patterns**: Modular design with clear service boundaries

### 🎨 User Experience Excellence

**Modern UI/UX with attention to detail**:

- **Glassmorphism Design**: Contemporary visual design with depth and elegance
- **Smooth Animations**: 60 FPS animations with optimized performance
- **Accessibility**: Screen reader support and keyboard navigation
- **Internationalization**: Multi-language support with RTL text handling
- **Responsive Design**: Adaptive layouts for various screen sizes and orientations

---

## 📞 Technical Contact & Collaboration

**Let's discuss the technical architecture and implementation details!**

This project showcases advanced software engineering concepts including **Clean Architecture**, **Domain-Driven Design**, **Reactive Programming**, **Serverless Computing**, and **Real-time Systems**. I'm passionate about discussing the technical decisions, trade-offs, and scalability considerations that went into building this enterprise-grade application.

**Key Discussion Topics:**
- 🏗️ **Architecture Patterns**: Clean Architecture, DDD, CQRS implementation strategies
- 🔄 **State Management**: Advanced BLoC patterns and reactive programming techniques
- ☁️ **Cloud Architecture**: Serverless functions, real-time databases, and scalability patterns
- 🔐 **Security Engineering**: Authentication flows, authorization patterns, and data protection
- 📊 **Performance Engineering**: Optimization techniques, caching strategies, and monitoring
- 🧪 **Testing Strategies**: Unit testing, integration testing, and quality assurance practices

---

*This project represents a comprehensive demonstration of modern mobile app development with enterprise-grade architecture, showcasing the depth of technical expertise required for building scalable, maintainable, and secure applications.*
