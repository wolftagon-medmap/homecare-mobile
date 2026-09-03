import 'package:m2health/features/guided_booking/domain/entities/issue_catalogue.dart';

class IssueOptionModel extends IssueOption {
  const IssueOptionModel({
    required super.code,
    required super.label,
    super.description,
  });

  factory IssueOptionModel.fromJson(Map<String, dynamic> json) {
    return IssueOptionModel(
      code: json['code'] as String,
      label: json['label'] as String,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'code': code,
        'label': label,
        'description': description,
      };
}

class IssueSubCategoryModel extends IssueSubCategory {
  const IssueSubCategoryModel({
    required super.code,
    required super.label,
    super.description,
    super.image,
    super.background,
    super.serviceCode,
    super.legacyFlow,
    super.issues,
  });

  factory IssueSubCategoryModel.fromJson(Map<String, dynamic> json) {
    return IssueSubCategoryModel(
      code: json['code'] as String,
      label: json['label'] as String,
      description: json['description'] as String?,
      image: json['image'] as String?,
      background: json['background'] as String?,
      serviceCode: json['service_code'] as String?,
      legacyFlow: json['legacy_flow'] as String?,
      issues: _parseIssues(json['issues']),
    );
  }

  Map<String, dynamic> toJson() => {
        'code': code,
        'label': label,
        'description': description,
        'image': image,
        'background': background,
        'service_code': serviceCode,
        'legacy_flow': legacyFlow,
        'issues': issues.map(_issueToJson).toList(),
      };
}

class IssueCatalogueModel extends IssueCatalogue {
  const IssueCatalogueModel({
    required super.category,
    required super.title,
    required super.pricingModel,
    super.pricingCategory,
    super.serviceCode,
    super.issues,
    super.subCategories,
  });

  factory IssueCatalogueModel.fromJson(Map<String, dynamic> json) {
    final subs = (json['sub_categories'] as List?) ?? const [];
    return IssueCatalogueModel(
      category: json['category'] as String,
      title: json['title'] as String? ?? '',
      pricingModel: json['pricing_model'] as String? ?? 'per_package',
      pricingCategory: json['pricing_category'] as String?,
      serviceCode: json['service_code'] as String?,
      issues: _parseIssues(json['issues']),
      subCategories: subs
          .map((sub) =>
              IssueSubCategoryModel.fromJson(sub as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'category': category,
        'title': title,
        'pricing_model': pricingModel,
        'pricing_category': pricingCategory,
        'service_code': serviceCode,
        'issues': issues.map(_issueToJson).toList(),
        'sub_categories': subCategories
            .map((sub) => IssueSubCategoryModel(
                  code: sub.code,
                  label: sub.label,
                  description: sub.description,
                  image: sub.image,
                  background: sub.background,
                  serviceCode: sub.serviceCode,
                  legacyFlow: sub.legacyFlow,
                  issues: sub.issues,
                ).toJson())
            .toList(),
      };
}

Map<String, dynamic> _issueToJson(IssueOption issue) => IssueOptionModel(
      code: issue.code,
      label: issue.label,
      description: issue.description,
    ).toJson();

List<IssueOptionModel> _parseIssues(Object? raw) {
  final list = (raw as List?) ?? const [];
  return list
      .map((issue) => IssueOptionModel.fromJson(issue as Map<String, dynamic>))
      .toList();
}
