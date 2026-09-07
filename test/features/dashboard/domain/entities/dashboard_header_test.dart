import 'package:flutter_test/flutter_test.dart';
import 'package:m2health/features/dashboard/domain/entities/dashboard_header.dart';

void main() {
  group('DashboardHeader.firstNameOf', () {
    test('takes the first name from a full name', () {
      expect(DashboardHeader.firstNameOf('Ahmad Hamdi'), 'Ahmad');
    });

    test('capitalises a lowercase name', () {
      expect(DashboardHeader.firstNameOf('ahmad hamdi'), 'Ahmad');
    });

    test('drops the domain when the name is an email address', () {
      expect(DashboardHeader.firstNameOf('ahmad.hamdi@gmail.com'), 'Ahmad');
    });

    test('splits on dots, underscores and hyphens', () {
      expect(DashboardHeader.firstNameOf('ahmad_hamdi'), 'Ahmad');
      expect(DashboardHeader.firstNameOf('ahmad-hamdi'), 'Ahmad');
    });

    test('keeps a single-token name whole', () {
      expect(DashboardHeader.firstNameOf('Hamdi'), 'Hamdi');
    });

    test('keeps a name with no whitespace intact', () {
      expect(DashboardHeader.firstNameOf('张伟'), '张伟');
    });

    test('trims surrounding whitespace', () {
      expect(DashboardHeader.firstNameOf('  Ahmad Hamdi  '), 'Ahmad');
    });

    test('returns null when there is nothing usable', () {
      expect(DashboardHeader.firstNameOf(null), isNull);
      expect(DashboardHeader.firstNameOf(''), isNull);
      expect(DashboardHeader.firstNameOf('   '), isNull);
      expect(DashboardHeader.firstNameOf('...'), isNull);
      expect(DashboardHeader.firstNameOf('@gmail.com'), isNull);
    });
  });

  group('DashboardHeader.from', () {
    test('resolves the first name and carries the rest through', () {
      final header = DashboardHeader.from(
        fullName: 'Ahmad Hamdi',
        avatarUrl: 'https://example.test/a.png',
        canSwitchProfile: true,
      );

      expect(header.firstName, 'Ahmad');
      expect(header.avatarUrl, 'https://example.test/a.png');
      expect(header.canSwitchProfile, isTrue);
      expect(header.hasName, isTrue);
    });

    test('has no name when the profile name is unusable', () {
      final header = DashboardHeader.from(fullName: '  ');

      expect(header.hasName, isFalse);
      expect(header.firstName, isNull);
    });
  });
}
