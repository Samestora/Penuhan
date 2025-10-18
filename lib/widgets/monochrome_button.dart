import 'package:flutter/material.dart';

class MonochromeButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double width;

  const MonochromeButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width = 250.0,
  });

  @override
  Widget build(BuildContext context) {
    // Define colors for clarity.
    const Color activeColor = Colors.white;
    final Color disabledColor = Colors.grey.shade700;

    return SizedBox(
      width: width,
      child: OutlinedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          // Use WidgetStateProperty.resolveWith to define appearance
          // based on the button's current state (e.g., pressed, hovered).

          // 1. FOREGROUND COLOR (affects Text and Icons)
          // This is the most important property for text color.
          foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
            // If the button is disabled, use the disabled color.
            if (states.contains(WidgetState.disabled)) {
              return disabledColor;
            }
            // Otherwise, use the active color.
            return activeColor;
          }),

          // 2. BORDER SIDE
          side: WidgetStateProperty.resolveWith<BorderSide>((states) {
            final Color borderColor = states.contains(WidgetState.disabled)
                ? disabledColor
                : activeColor;
            return BorderSide(color: borderColor, width: 2);
          }),

          // 3. OVERLAY COLOR (the visual feedback on interaction)
          overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
            if (states.contains(WidgetState.pressed)) {
              return activeColor.withValues(
                alpha: .2,
              ); // More visible when pressed
            }
            if (states.contains(WidgetState.hovered)) {
              return activeColor.withValues(alpha: .1); // Subtle glow on hover
            }
            // Return null for no overlay in other states.
            return null;
          }),

          // --- Static properties that don't depend on state ---
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(vertical: 16.0),
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        // The child Text widget doesn't need its own color style,
        // as it automatically uses the 'foregroundColor' from above.
        child: Text(
          text,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
