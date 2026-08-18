class IntelCard {
  final String id;
  final String title;
  final String? subtitle;
  final String value;
  final String? change;
  final IntelCardType type;
  final IntelCardTrend trend;
  final String icon;
  final IntelCardColorScheme colorScheme;
  final bool isInteractive;
  final String? actionRoute;
  final Map<String, dynamic>? actionParams;
  final DateTime timestamp;
  final int? priority;
  final List<IntelCardTag> tags;
  final IntelCardStatus status;

  IntelCard({
    required this.id,
    required this.title,
    this.subtitle,
    required this.value,
    this.change,
    required this.type,
    required this.trend,
    required this.icon,
    required this.colorScheme,
    required this.isInteractive,
    this.actionRoute,
    this.actionParams,
    required this.timestamp,
    this.priority,
    required this.tags,
    required this.status,
  });

  factory IntelCard.fromJson(Map<String, dynamic> json) {
    return IntelCard(
      id: json['id'],
      title: json['title'],
      subtitle: json['subtitle'],
      value: json['value'],
      change: json['change'],
      type: IntelCardType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => IntelCardType.metric,
      ),
      trend: IntelCardTrend.values.firstWhere(
        (e) => e.name == json['trend'],
        orElse: () => IntelCardTrend.neutral,
      ),
      icon: json['icon'],
      colorScheme: IntelCardColorScheme.values.firstWhere(
        (e) => e.name == json['colorScheme'],
        orElse: () => IntelCardColorScheme.blue,
      ),
      isInteractive: json['isInteractive'],
      actionRoute: json['actionRoute'],
      actionParams: json['actionParams'] != null
          ? Map<String, dynamic>.from(json['actionParams'])
          : null,
      timestamp: DateTime.parse(json['timestamp']),
      priority: json['priority'],
      tags: (json['tags'] as List)
          .map((item) => IntelCardTag.fromJson(item))
          .toList(),
      status: IntelCardStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => IntelCardStatus.active,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'value': value,
      'change': change,
      'type': type.name,
      'trend': trend.name,
      'icon': icon,
      'colorScheme': colorScheme.name,
      'isInteractive': isInteractive,
      'actionRoute': actionRoute,
      'actionParams': actionParams,
      'timestamp': timestamp.toIso8601String(),
      'priority': priority,
      'tags': tags.map((e) => e.toJson()).toList(),
      'status': status.name,
    };
  }
}

class IntelCardTag {
  final String label;
  final IntelCardColorScheme color;
  final String? icon;

  IntelCardTag({required this.label, required this.color, this.icon});

  factory IntelCardTag.fromJson(Map<String, dynamic> json) {
    return IntelCardTag(
      label: json['label'],
      color: IntelCardColorScheme.values.firstWhere(
        (e) => e.name == json['color'],
        orElse: () => IntelCardColorScheme.gray,
      ),
      icon: json['icon'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'label': label, 'color': color.name, 'icon': icon};
  }
}

enum IntelCardType {
  metric,
  insight,
  achievement,
  reminder,
  notification,
  quickAction,
  trend,
  comparison,
}

enum IntelCardTrend { up, down, stable, neutral, warning }

enum IntelCardColorScheme {
  blue,
  green,
  yellow,
  red,
  purple,
  pink,
  cyan,
  gray,
  indigo,
  teal,
  orange,
}

enum IntelCardStatus { active, inactive, archived, hidden }

class IntelCardSection {
  final String id;
  final String title;
  final String? subtitle;
  final IntelCardLayout layout;
  final int priority;
  final List<IntelCard> cards;
  final bool isCollapsible;
  final bool isInitiallyCollapsed;
  final String? actionRoute;
  final String? actionText;

  IntelCardSection({
    required this.id,
    required this.title,
    this.subtitle,
    required this.layout,
    required this.priority,
    required this.cards,
    required this.isCollapsible,
    this.isInitiallyCollapsed = false,
    this.actionRoute,
    this.actionText,
  });

  factory IntelCardSection.fromJson(Map<String, dynamic> json) {
    return IntelCardSection(
      id: json['id'],
      title: json['title'],
      subtitle: json['subtitle'],
      layout: IntelCardLayout.values.firstWhere(
        (e) => e.name == json['layout'],
        orElse: () => IntelCardLayout.grid,
      ),
      priority: json['priority'],
      cards: (json['cards'] as List)
          .map((item) => IntelCard.fromJson(item))
          .toList(),
      isCollapsible: json['isCollapsible'],
      isInitiallyCollapsed: json['isInitiallyCollapsed'] ?? false,
      actionRoute: json['actionRoute'],
      actionText: json['actionText'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'layout': layout.name,
      'priority': priority,
      'cards': cards.map((e) => e.toJson()).toList(),
      'isCollapsible': isCollapsible,
      'isInitiallyCollapsed': isInitiallyCollapsed,
      'actionRoute': actionRoute,
      'actionText': actionText,
    };
  }
}

enum IntelCardLayout { grid, list, carousel, single, twoColumn, threeColumn }
