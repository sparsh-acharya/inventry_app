# InventryApp Premium Color Scheme

## Overview
This document outlines the premium color scheme implemented for the InventryApp, designed to provide a luxurious and professional user experience.

## Color Palette

### Primary Colors
- **Deep Ocean Blue**: `#0F4C75` - Main primary color for headers, buttons, and key UI elements
- **Darker Navy**: `#1B2951` - Used for AppBar and primary containers in dark mode
- **Rich Purple**: `#BB86FC` - Secondary color for accents and highlights

### Accent Colors
- **Premium Gold**: `#FFB300` - Tertiary color for special elements and premium features
- **Vibrant Teal**: `#00BCD4` - Additional accent for supporting elements

### Surface Colors
- **Clean White**: `#F8F9FA` - Main surface color for cards and containers
- **Light Purple Tint**: `#E8EAF6` - Surface variant for subtle backgrounds
- **Off White**: `#FAFBFC` - Background color for light theme
- **True Dark**: `#121212` - Background color for dark theme

### Functional Colors
- **Success Green**: `#388E3C` - For positive actions and success states
- **Warning Orange**: `#F57C00` - For cautionary messages and warnings
- **Info Blue**: `#1976D2` - For informational content
- **Error Red**: `#BA1A1A` - For error states and destructive actions

## Theme Features

### Material 3 Design System
- Full Material 3 compliance with dynamic color schemes
- Support for both light and dark themes
- Automatic system theme detection
- Consistent elevation and shadow system

### Premium Styling Elements
1. **Elevated Cards**: Enhanced with subtle shadows and rounded corners
2. **Gradient Backgrounds**: Subtle gradients for visual depth
3. **Custom Button Styles**: Premium button styling with proper elevation
4. **Enhanced Input Fields**: Improved form styling with focus states
5. **Rich Typography**: Carefully crafted text styles for readability

### Component Theming

#### AppBar
- Deep Ocean Blue background (`#0F4C75`)
- White foreground for contrast
- Minimal elevation for modern look

#### Cards
- Clean white surface with subtle shadows
- 16px border radius for modern appearance
- Elevation of 3 for depth

#### Buttons
- Primary buttons use Deep Ocean Blue
- Enhanced shadow effects
- 12px border radius
- Proper padding for touch targets

#### Input Fields
- Light purple tint background
- 12px border radius
- Focus state with primary color border
- Proper content padding

#### FloatingActionButton
- Premium Gold background (`#FFB300`)
- High elevation (8) for prominence
- Circular shape with proper icon sizing

## Usage Guidelines

### Importing the Theme
```dart
import 'package:inventry_app/core/theme/app_theme.dart';
import 'package:inventry_app/core/theme/app_colors.dart';
```

### Applying the Theme
```dart
MaterialApp(
  theme: AppTheme.lightTheme,
  darkTheme: AppTheme.darkTheme,
  themeMode: ThemeMode.system,
  // ... rest of app configuration
)
```

### Using Custom Colors
```dart
// Using theme extension methods
Container(
  color: Theme.of(context).successColor,
  child: Text(
    'Success message',
    style: TextStyle(color: Theme.of(context).colorScheme.onSuccess),
  ),
)

// Using ColorScheme extensions
Container(
  decoration: BoxDecoration(
    gradient: AppGradients.primary(),
  ),
  child: Text('Gradient background'),
)
```

### Semantic Color Usage
- **Primary**: Navigation, key actions, headers
- **Secondary**: Supporting actions, less prominent elements
- **Tertiary (Gold)**: Premium features, special call-to-actions
- **Success**: Confirmations, positive feedback
- **Warning**: Cautions, non-critical alerts
- **Error**: Problems, destructive actions
- **Info**: Neutral information, help text

## Accessibility
- All color combinations meet WCAG 2.1 AA standards
- Sufficient contrast ratios for text readability
- Colors work well for users with color vision deficiencies
- Focus states are clearly visible

## Dark Theme Support
- Comprehensive dark theme with inverted luminance
- Maintains brand identity in dark mode
- Proper contrast ratios for dark backgrounds
- Consistent component styling across themes

## Best Practices
1. Always use theme colors instead of hardcoded values
2. Test both light and dark themes during development
3. Use semantic color names (success, warning, etc.) for better maintainability
4. Follow Material 3 guidelines for elevation and shadows
5. Ensure accessibility standards are met

## Examples

### Premium Card Design
```dart
Card(
  elevation: 8,
  shadowColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16),
  ),
  child: // Card content
)
```

### Gradient Background
```dart
Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [
        Theme.of(context).colorScheme.primary.withOpacity(0.1),
        Theme.of(context).colorScheme.background,
      ],
    ),
  ),
  child: // Content
)
```

### Premium Button
```dart
ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: Theme.of(context).colorScheme.primary,
    elevation: 4,
    shadowColor: Theme.of(context).colorScheme.primary.withOpacity(0.4),
  ),
  onPressed: () {},
  child: Text('Premium Action'),
)
```

This color scheme creates a sophisticated, premium look and feel that enhances the user experience while maintaining excellent usability and accessibility standards.
