import 'package:equatable/equatable.dart';

class IssueOption extends Equatable {
  final String code;
  final String label;
  final String? description;

  const IssueOption({
    required this.code,
    required this.label,
    this.description,
  });

  @override
  List<Object?> get props => [code, label, description];
}

class IssueSubCategory extends Equatable {
  final String code;
  final String label;
  final String? description;
  final String? image;
  final String? background;
  final String? serviceCode;
  final List<IssueOption> issues;

  const IssueSubCategory({
    required this.code,
    required this.label,
    this.description,
    this.image,
    this.background,
    this.serviceCode,
    this.issues = const [],
  });

  bool get inheritsIssues => issues.isEmpty;

  @override
  List<Object?> get props =>
      [code, label, description, image, background, serviceCode, issues];
}

class IssueCatalogue extends Equatable {
  final String category;
  final String title;
  final String pricingModel;

  final String pricingCategory;

  final String? serviceCode;
  final List<IssueOption> issues;
  final List<IssueSubCategory> subCategories;

  const IssueCatalogue({
    required this.category,
    required this.title,
    required this.pricingModel,
    String? pricingCategory,
    this.serviceCode,
    this.issues = const [],
    this.subCategories = const [],
  }) : pricingCategory = pricingCategory ?? category;

  bool get hasAddOns => pricingModel == 'per_item';

  bool get needsSubServiceStep => subCategories.length > 1;

  IssueSubCategory? subCategory(String? code) {
    if (code == null) return null;
    for (final sub in subCategories) {
      if (sub.code == code) return sub;
    }
    return null;
  }

  List<IssueOption> issuesFor(String? subCategoryCode) {
    final sub = subCategory(subCategoryCode);
    if (sub == null) {
      return subCategories.length == 1 && subCategories.first.issues.isNotEmpty
          ? subCategories.first.issues
          : issues;
    }
    return sub.inheritsIssues ? issues : sub.issues;
  }

  List<String> serviceCodesFor(String? subCategoryCode) {
    final code = subCategory(subCategoryCode)?.serviceCode ?? serviceCode;
    return code == null ? const [] : [code];
  }

  String labelFor(String issueCode, String? subCategoryCode) {
    for (final issue in issuesFor(subCategoryCode)) {
      if (issue.code == issueCode) return issue.label;
    }
    return issueCode;
  }

  @override
  List<Object?> get props => [
        category,
        title,
        pricingModel,
        pricingCategory,
        serviceCode,
        issues,
        subCategories,
      ];
}
