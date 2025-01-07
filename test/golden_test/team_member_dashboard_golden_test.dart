import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized(); // Ensures the test environment is initialized
    await Firebase.initializeApp(); // Initializes Firebase for the tests
  });

  test('Test Firestore data', () async {
    final fakeFirestore = FakeFirebaseFirestore();

    // Add mock data
    await fakeFirestore.collection('users').doc('user1').set({
      'email': '123@email.com',
      'role': 'Admin',
    });

    // Fetch the data
    final doc = await fakeFirestore.collection('users').doc('user1').get();

    expect(doc.data(), isNotNull);
    expect(doc['email'], '123@email.com');
    expect(doc['role'], 'Admin');
  });
}
