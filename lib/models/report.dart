class Report {
  final String id;
  final String userId;
  final String userName;
  final String outletId;
  final String outletName;
  final ReportInputType inputType;
  final String content;
  final List<String> extractedEntities;
  final List<CompetitorSignal> competitorSignals;
  final AIAnalysis? aiAnalysis;
  final ReportStatus status;
  final ReportConfidence confidence;
  final double? confidenceScore;
  final DateTime createdAt;
  final DateTime? processedAt;
  final DateTime? confirmedAt;
  final int pointsEarned;
  final List<String> tags;
  final List<String> attachments;
  final ReportMetadata metadata;

  Report({
    required this.id,
    required this.userId,
    required this.userName,
    required this.outletId,
    required this.outletName,
    required this.inputType,
    required this.content,
    required this.extractedEntities,
    required this.competitorSignals,
    this.aiAnalysis,
    required this.status,
    required this.confidence,
    this.confidenceScore,
    required this.createdAt,
    this.processedAt,
    this.confirmedAt,
    required this.pointsEarned,
    required this.tags,
    required this.attachments,
    required this.metadata,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      id: json['id'],
      userId: json['userId'],
      userName: json['userName'],
      outletId: json['outletId'],
      outletName: json['outletName'],
      inputType: ReportInputType.values.firstWhere(
        (e) => e.name == json['inputType'],
        orElse: () => ReportInputType.text,
      ),
      content: json['content'],
      extractedEntities: List<String>.from(json['extractedEntities']),
      competitorSignals: (json['competitorSignals'] as List)
          .map((item) => CompetitorSignal.fromJson(item))
          .toList(),
      aiAnalysis: json['aiAnalysis'] != null
          ? AIAnalysis.fromJson(json['aiAnalysis'])
          : null,
      status: ReportStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => ReportStatus.draft,
      ),
      confidence: ReportConfidence.values.firstWhere(
        (e) => e.name == json['confidence'],
        orElse: () => ReportConfidence.medium,
      ),
      confidenceScore: (json['confidenceScore'] as num?)?.toDouble(),
      createdAt: DateTime.parse(json['createdAt']),
      processedAt: json['processedAt'] != null
          ? DateTime.parse(json['processedAt'])
          : null,
      confirmedAt: json['confirmedAt'] != null
          ? DateTime.parse(json['confirmedAt'])
          : null,
      pointsEarned: json['pointsEarned'],
      tags: List<String>.from(json['tags']),
      attachments: List<String>.from(json['attachments']),
      metadata: ReportMetadata.fromJson(json['metadata']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'outletId': outletId,
      'outletName': outletName,
      'inputType': inputType.name,
      'content': content,
      'extractedEntities': extractedEntities,
      'competitorSignals': competitorSignals.map((e) => e.toJson()).toList(),
      'aiAnalysis': aiAnalysis?.toJson(),
      'status': status.name,
      'confidence': confidence.name,
      'confidenceScore': confidenceScore,
      'createdAt': createdAt.toIso8601String(),
      'processedAt': processedAt?.toIso8601String(),
      'confirmedAt': confirmedAt?.toIso8601String(),
      'pointsEarned': pointsEarned,
      'tags': tags,
      'attachments': attachments,
      'metadata': metadata.toJson(),
    };
  }
}

class CompetitorSignal {
  final String brand;
  final String product;
  final double? price;
  final double? stockLevel;
  final String promotion;
  final String signalType;
  final double confidence;

  CompetitorSignal({
    required this.brand,
    required this.product,
    this.price,
    this.stockLevel,
    required this.promotion,
    required this.signalType,
    required this.confidence,
  });

  factory CompetitorSignal.fromJson(Map<String, dynamic> json) {
    return CompetitorSignal(
      brand: json['brand'],
      product: json['product'],
      price: (json['price'] as num?)?.toDouble(),
      stockLevel: (json['stockLevel'] as num?)?.toDouble(),
      promotion: json['promotion'],
      signalType: json['signalType'],
      confidence: (json['confidence'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'brand': brand,
      'product': product,
      'price': price,
      'stockLevel': stockLevel,
      'promotion': promotion,
      'signalType': signalType,
      'confidence': confidence,
    };
  }
}

class AIAnalysis {
  final String summary;
  final List<String> keyFindings;
  final List<String> recommendations;
  final Map<String, dynamic> structuredData;
  final double overallScore;
  final String sentiment;
  final List<EntityExtraction> extractedEntities;

  AIAnalysis({
    required this.summary,
    required this.keyFindings,
    required this.recommendations,
    required this.structuredData,
    required this.overallScore,
    required this.sentiment,
    required this.extractedEntities,
  });

  factory AIAnalysis.fromJson(Map<String, dynamic> json) {
    return AIAnalysis(
      summary: json['summary'],
      keyFindings: List<String>.from(json['keyFindings']),
      recommendations: List<String>.from(json['recommendations']),
      structuredData: Map<String, dynamic>.from(json['structuredData']),
      overallScore: (json['overallScore'] as num).toDouble(),
      sentiment: json['sentiment'],
      extractedEntities: (json['extractedEntities'] as List)
          .map((item) => EntityExtraction.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'summary': summary,
      'keyFindings': keyFindings,
      'recommendations': recommendations,
      'structuredData': structuredData,
      'overallScore': overallScore,
      'sentiment': sentiment,
      'extractedEntities': extractedEntities.map((e) => e.toJson()).toList(),
    };
  }
}

class EntityExtraction {
  final String entity;
  final String type;
  final String value;
  final double confidence;

  EntityExtraction({
    required this.entity,
    required this.type,
    required this.value,
    required this.confidence,
  });

  factory EntityExtraction.fromJson(Map<String, dynamic> json) {
    return EntityExtraction(
      entity: json['entity'],
      type: json['type'],
      value: json['value'],
      confidence: (json['confidence'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'entity': entity,
      'type': type,
      'value': value,
      'confidence': confidence,
    };
  }
}

class ReportMetadata {
  final int wordCount;
  final int characterCount;
  final int processingTimeSeconds;
  final List<String> validationWarnings;
  final bool isVerified;
  final DateTime? verificationDate;
  final String? verifiedBy;

  ReportMetadata({
    required this.wordCount,
    required this.characterCount,
    required this.processingTimeSeconds,
    required this.validationWarnings,
    required this.isVerified,
    this.verificationDate,
    this.verifiedBy,
  });

  factory ReportMetadata.fromJson(Map<String, dynamic> json) {
    return ReportMetadata(
      wordCount: json['wordCount'],
      characterCount: json['characterCount'],
      processingTimeSeconds: json['processingTimeSeconds'],
      validationWarnings: List<String>.from(json['validationWarnings']),
      isVerified: json['isVerified'],
      verificationDate: json['verificationDate'] != null
          ? DateTime.parse(json['verificationDate'])
          : null,
      verifiedBy: json['verifiedBy'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'wordCount': wordCount,
      'characterCount': characterCount,
      'processingTimeSeconds': processingTimeSeconds,
      'validationWarnings': validationWarnings,
      'isVerified': isVerified,
      'verificationDate': verificationDate?.toIso8601String(),
      'verifiedBy': verifiedBy,
    };
  }
}

enum ReportInputType { voice, text }

enum ReportStatus {
  draft,
  submitted,
  processing,
  aiReview,
  needsConfirmation,
  confirmed,
  completed,
  failed,
  archived,
}

enum ReportConfidence { low, medium, high, veryHigh }
