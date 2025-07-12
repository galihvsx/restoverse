# Restoverse - Restaurant App

A beautiful and modern restaurant discovery app built with Flutter, featuring clean architecture and smooth animations.

## 🚀 Features

- **Restaurant Discovery**: Browse through a curated list of restaurants
- **Detailed Information**: View comprehensive restaurant details including menus and reviews
- **Search Functionality**: Find restaurants by name, category, or menu items
- **Review System**: Add and read customer reviews
- **Dark/Light Theme**: Toggle between beautiful light and dark themes
- **Smooth Animations**: Full animation support for enhanced user experience
- **Responsive Design**: Optimized for different screen sizes

## 🏗️ Architecture

This project follows **Clean Architecture** principles with clear separation of concerns:

```
lib/
├── core/                     # Core utilities and shared components
│   ├── constants/           # App constants and API endpoints
│   ├── errors/              # Error handling and exceptions
│   ├── network/             # HTTP client configuration
│   ├── themes/              # App theming system
│   ├── utils/               # Helper functions and extensions
│   └── widgets/             # Reusable UI components
├── features/                # Feature-based modules
│   ├── splash/              # Splash screen feature
│   ├── restaurant_list/     # Restaurant listing feature
│   ├── restaurant_detail/   # Restaurant detail feature
│   └── theme/               # Theme management feature
└── main.dart               # App entry point
```

### Each feature follows the same structure:
- **data/**: Data sources, models, and repository implementations
- **domain/**: Business logic, entities, and repository interfaces
- **presentation/**: UI components, pages, and state management

## 🛠️ Tech Stack

- **Framework**: Flutter
- **State Management**: Provider
- **HTTP Client**: Dio
- **Architecture**: Clean Architecture
- **Animations**: Flutter built-in + Lottie
- **Image Caching**: cached_network_image
- **Fonts**: Google Fonts

## 📋 Development Plan

The development is organized into phases. Check the detailed plan in:
📄 [Development Todo List](.trae/todo.md)

### Phase Overview:
1. **Phase 1**: Project setup and foundation
2. **Phase 2**: Splash screen and theme system
3. **Phase 3**: Restaurant list feature
4. **Phase 4**: Restaurant detail feature
5. **Phase 5**: Navigation and animations
6. **Phase 6**: Polish and testing

## 🔧 Getting Started

### Prerequisites
- Flutter SDK (>=3.8.1)
- Dart SDK
- Android Studio / VS Code
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd dcresto
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

## 🌐 API Integration

The app integrates with the Dicoding Restaurant API:

**Base URL**: `https://restaurant-api.dicoding.dev`

### Endpoints:
- `GET /list` - Get restaurant list
- `GET /detail/:id` - Get restaurant details
- `GET /search?q=<query>` - Search restaurants
- `POST /review` - Add restaurant review

### Image URLs:
- Small: `https://restaurant-api.dicoding.dev/images/small/<pictureId>`
- Medium: `https://restaurant-api.dicoding.dev/images/medium/<pictureId>`
- Large: `https://restaurant-api.dicoding.dev/images/large/<pictureId>`

## 🎨 Design Principles

- **Clean Architecture**: Separation of concerns with clear dependencies
- **Provider Pattern**: Reactive state management
- **Responsive Design**: Adaptive layouts for different screen sizes
- **Material Design**: Following Material Design 3 guidelines
- **Accessibility**: Support for screen readers and accessibility features
- **Performance**: Optimized for smooth 60fps animations

## 📱 Screenshots

*Screenshots will be added as development progresses*

## 🧪 Testing

The project includes comprehensive testing:
- **Unit Tests**: Business logic and use cases
- **Widget Tests**: UI components
- **Integration Tests**: API integration and user flows

Run tests with:
```bash
flutter test
```

## 📦 Dependencies

Key dependencies used in this project:
- `provider` - State management
- `dio` - HTTP client
- `cached_network_image` - Image caching
- `lottie` - Animations
- `google_fonts` - Typography
- `flutter_rating_bar` - Rating display
- `skeletonizer` - Loading skeleton effects
- `equatable` - Value equality

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new features
5. Ensure all tests pass
6. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 👨‍💻 Development Status

🚧 **Currently in development** - Check the [todo list](.trae/todo.md) for current progress and upcoming features.

---

**Built with ❤️ using Flutter**
