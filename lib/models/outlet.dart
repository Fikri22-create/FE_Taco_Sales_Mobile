class Outlet {
  final String id;
  final String name;
  final String address;
  final String city;
  final String region;
  final String category;
  final String type;
  final double latitude;
  final double longitude;
  final int visitCount;
  final DateTime lastVisit;
  final DateTime createdAt;
  final OutletStatus status;
  final List<String> recentReports;
  final OutletStats stats;

  Outlet({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
    required this.region,
    required this.category,
    required this.type,
    required this.latitude,
    required this.longitude,
    required this.visitCount,
    required this.lastVisit,
    required this.createdAt,
    required this.status,
    required this.recentReports,
    required this.stats,
  });

  factory Outlet.fromJson(Map<String, dynamic> json) {
    return Outlet(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      city: json['city'],
      region: json['region'],
      category: json['category'],
      type: json['type'],
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      visitCount: json['visitCount'],
      lastVisit: DateTime.parse(json['lastVisit']),
      createdAt: DateTime.parse(json['createdAt']),
      status: OutletStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => OutletStatus.active,
      ),
      recentReports: List<String>.from(json['recentReports']),
      stats: OutletStats.fromJson(json['stats']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'city': city,
      'region': region,
      'category': category,
      'type': type,
      'latitude': latitude,
      'longitude': longitude,
      'visitCount': visitCount,
      'lastVisit': lastVisit.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'status': status.name,
      'recentReports': recentReports,
      'stats': stats.toJson(),
    };
  }
}

class OutletStats {
  final int totalReports;
  final double averageReportScore;
  final String topBrand;
  final double averageStockLevel;
  final double averagePricePoint;
  final int competitorSignals;
  final List<RecentActivity> recentActivities;

  OutletStats({
    required this.totalReports,
    required this.averageReportScore,
    required this.topBrand,
    required this.averageStockLevel,
    required this.averagePricePoint,
    required this.competitorSignals,
    required this.recentActivities,
  });

  factory OutletStats.fromJson(Map<String, dynamic> json) {
    return OutletStats(
      totalReports: json['totalReports'],
      averageReportScore: (json['averageReportScore'] as num).toDouble(),
      topBrand: json['topBrand'],
      averageStockLevel: (json['averageStockLevel'] as num).toDouble(),
      averagePricePoint: (json['averagePricePoint'] as num).toDouble(),
      competitorSignals: json['competitorSignals'],
      recentActivities: (json['recentActivities'] as List)
          .map((item) => RecentActivity.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalReports': totalReports,
      'averageReportScore': averageReportScore,
      'topBrand': topBrand,
      'averageStockLevel': averageStockLevel,
      'averagePricePoint': averagePricePoint,
      'competitorSignals': competitorSignals,
      'recentActivities': recentActivities.map((e) => e.toJson()).toList(),
    };
  }
}

class RecentActivity {
  final String userId;
  final String userName;
  final DateTime timestamp;
  final String activityType;
  final String? details;

  RecentActivity({
    required this.userId,
    required this.userName,
    required this.timestamp,
    required this.activityType,
    this.details,
  });

  factory RecentActivity.fromJson(Map<String, dynamic> json) {
    return RecentActivity(
      userId: json['userId'],
      userName: json['userName'],
      timestamp: DateTime.parse(json['timestamp']),
      activityType: json['activityType'],
      details: json['details'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userName': userName,
      'timestamp': timestamp.toIso8601String(),
      'activityType': activityType,
      'details': details,
    };
  }
}

enum OutletStatus {
  active,
  inactive,
  newOutlet,
  archived,
}

enum OutletCategory {
  supermarket,
  minimarket,
  convenienceStore,
  traditionalMarket,
  wholesaler,
  restaurant,
  cafe,
  other,
}

enum OutletType {
  modernTrade,
  traditionalTrade,
  hospitality,
  institutional,
}