# Calculator App - README

## Overview

This Flutter-based calculator application is designed to perform basic mathematical operations with a clean and user-friendly interface. The app features Material Design 3 principles, a dynamic input/output display, and a scrollable history of calculations.

---

## Features

- **Basic Operations**: Supports addition, subtraction, multiplication, division, exponentiation, and factorials.
- **Dynamic UI**:
  - Input and output adjust font size dynamically based on the content length.
  - Distinct color codes for inputs and outputs.
- **Calculation History**:
  - Stores and displays previous calculations in a scrollable list.
  - Clears history with the "C" button.
- **Responsive Grid Layout**:
  - Buttons are laid out in a grid for easy interaction.
  - Adaptive styling for buttons and operators.
- **Error Handling**: Gracefully handles invalid inputs or edge cases in calculations.
- **Max Input Length**: Prevents inputs exceeding the screen width for better usability.

---

## Dependencies

- **`math_expressions` Package**: Used for evaluating mathematical expressions.

To install the dependency, add the following to your `pubspec.yaml`:
```yaml
dependencies:
  flutter:
    sdk: flutter
  math_expressions: ^2.0.1
```

## File Structure
```
  .
  ├── lib
  │   └── main.dart       # Contains the main logic and UI of the calculator app
  └── pubspec.yaml        # Contains project metadata and dependencies
```

## Running the App

1. Clone or download the project.
2. Navigate to the project folder.
3. Run the following commands:
```
     flutter pub get
     flutter run
```

## Conclusion

This Flutter calculator app provides a simple and clean interface for performing basic mathematical operations with an optional history view. It supports Material Design 3 theming for a modern and visually appealing UI. You can easily modify the layout and theme to match your preferences.



