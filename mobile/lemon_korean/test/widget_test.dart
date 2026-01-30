import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Widget Tests', () {
    group('Basic Widget Rendering', () {
      testWidgets('Text widget renders correctly', (WidgetTester tester) async {
        // Build a simple text widget
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text('Lemon Korean'),
              ),
            ),
          ),
        );

        // Verify the text is displayed
        expect(find.text('Lemon Korean'), findsOneWidget);
      });

      testWidgets('CircularProgressIndicator renders correctly', (WidgetTester tester) async {
        // Build a loading indicator widget
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        );

        // Verify the progress indicator is displayed
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

      testWidgets('Column with multiple children renders correctly', (WidgetTester tester) async {
        // Build a column with multiple children
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Title'),
                  SizedBox(height: 10),
                  Text('Subtitle'),
                ],
              ),
            ),
          ),
        );

        // Verify both texts are displayed
        expect(find.text('Title'), findsOneWidget);
        expect(find.text('Subtitle'), findsOneWidget);
      });
    });

    group('Button Interactions', () {
      testWidgets('ElevatedButton responds to tap', (WidgetTester tester) async {
        bool buttonPressed = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ElevatedButton(
                onPressed: () {
                  buttonPressed = true;
                },
                child: const Text('Press Me'),
              ),
            ),
          ),
        );

        // Tap the button
        await tester.tap(find.text('Press Me'));
        await tester.pump();

        // Verify the button was pressed
        expect(buttonPressed, true);
      });

      testWidgets('IconButton responds to tap', (WidgetTester tester) async {
        int tapCount = 0;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  tapCount++;
                },
              ),
            ),
          ),
        );

        // Tap the icon button twice
        await tester.tap(find.byIcon(Icons.add));
        await tester.pump();
        await tester.tap(find.byIcon(Icons.add));
        await tester.pump();

        // Verify the button was pressed twice
        expect(tapCount, 2);
      });
    });

    group('Form Input', () {
      testWidgets('TextField accepts input', (WidgetTester tester) async {
        final controller = TextEditingController();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TextField(
                controller: controller,
              ),
            ),
          ),
        );

        // Enter text
        await tester.enterText(find.byType(TextField), 'test@example.com');

        // Verify the text was entered
        expect(controller.text, 'test@example.com');
      });

      testWidgets('TextField with obscureText hides text', (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: TextField(
                obscureText: true,
              ),
            ),
          ),
        );

        // Find the TextField
        final textField = tester.widget<TextField>(find.byType(TextField));

        // Verify obscureText is true
        expect(textField.obscureText, true);
      });
    });

    group('Navigation', () {
      testWidgets('Navigator.push adds new screen', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) => Scaffold(
                body: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const Scaffold(
                          body: Text('Second Screen'),
                        ),
                      ),
                    );
                  },
                  child: const Text('Navigate'),
                ),
              ),
            ),
          ),
        );

        // Tap the navigation button
        await tester.tap(find.text('Navigate'));
        await tester.pumpAndSettle();

        // Verify the second screen is displayed
        expect(find.text('Second Screen'), findsOneWidget);
      });
    });

    group('Layout', () {
      testWidgets('Container with decoration renders correctly', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        );

        // Verify the container is displayed
        expect(find.byType(Container), findsWidgets);
      });

      testWidgets('Card widget renders correctly', (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('Card Content'),
                ),
              ),
            ),
          ),
        );

        // Verify the card and its content are displayed
        expect(find.byType(Card), findsOneWidget);
        expect(find.text('Card Content'), findsOneWidget);
      });
    });
  });
}
