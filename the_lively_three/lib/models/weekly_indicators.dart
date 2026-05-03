// lib/models/weekly_indicators.dart

/// Model class representing weekly health indicators for a user
class WeeklyIndicators {
  final double? healthScoreWeekly;
  final double? averagePortionsWeekly;
  final double? consistencyScoreWeekly;
  final int? currentStreak;
  final int? longestStreak;
  final int? diversityCurrentStreak;
  final int? diversityLongestStreak;
  final int? colorCurrentStreak;
  final int? colorLongestStreak;
  final int? healthScoreCurrentStreak;
  final int? healthScoreLongestStreak;
  final ColorGapsData? colorGaps;
  final int calendarWeek;
  final int calendarYear;

  WeeklyIndicators({
    this.healthScoreWeekly,
    this.averagePortionsWeekly,
    this.consistencyScoreWeekly,
    this.currentStreak,
    this.longestStreak,
    this.diversityCurrentStreak,
    this.diversityLongestStreak,
    this.colorCurrentStreak,
    this.colorLongestStreak,
    this.healthScoreCurrentStreak,
    this.healthScoreLongestStreak,
    this.colorGaps,
    required this.calendarWeek,
    required this.calendarYear,
  });

  // ✅ Helper methods for type conversion
  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  /// Factory constructor to create WeeklyIndicators from database response
  factory WeeklyIndicators.fromJson(List<dynamic> jsonList) {
    double? healthScore;
    double? avgPortions;
    double? consistency;
    int? currentStreak;
    int? longestStreak;
    int? diversityCurrentStreak;
    int? diversityLongestStreak;
    int? colorCurrentStreak;
    int? colorLongestStreak;
    int? healthScoreCurrentStreak;
    int? healthScoreLongestStreak;
    ColorGapsData? colorGaps;
    int week = 0;
    int year = 0;

    print('Parsing ${jsonList.length} indicators from response');

    // Parse each indicator from the list
    for (var item in jsonList) {
      final name = item['indicator_name'] as String?;
      final value = _toDouble(item['indicator_value']);
      final jsonbValue = item['indicator_jsonb_value'];

      print('Processing indicator: $name = $value, jsonb: $jsonbValue');

      // Get week and year from first item
      if (week == 0) {
        week = _toInt(item['calendar_week']);
        year = _toInt(item['calendar_year']);
      }

      // Map indicators based on their ACTUAL name in the database
      switch (name) {
        case 'healthscoreweekly_i':
          healthScore = value;
          break;
        case 'averageportionsweekly_i':
          avgPortions = value;
          break;
        case 'consistencyscoreweekly_i':
          consistency = value;
          break;
        case 'portionstreakcurrent_i':  // Daily portion streak
          currentStreak = value.toInt();
          break;
        case 'portionstreaklongest_i':  // Daily portion streak
          longestStreak = value.toInt();
          break;
        case 'diversitystreakcurrent_i':  // Weekly plant diversity streak
          diversityCurrentStreak = value.toInt();
          break;
        case 'diversitystreaklongest_i':  // Weekly plant diversity streak
          diversityLongestStreak = value.toInt();
          break;
        case 'colorstreakcurrent_i':  // Weekly color streak
          colorCurrentStreak = value.toInt();
          break;
        case 'colorstreaklongest_i':  // Weekly color streak
          colorLongestStreak = value.toInt();
          break;
        case 'healthscorestreakcurrent_i':  // Weekly health score streak
          healthScoreCurrentStreak = value.toInt();
          break;
        case 'healthscorestreaklongest_i':  // Weekly health score streak
          healthScoreLongestStreak = value.toInt();
          break;
        case 'colorgapsdaily_i':
        case 'colorgapsweekly_i':
          if (jsonbValue != null) {
            colorGaps = ColorGapsData.fromJson(
              jsonbValue is Map<String, dynamic>
                  ? jsonbValue
                  : Map<String, dynamic>.from(jsonbValue),
            );
          }
          break;
      }
    }

    print('Parsed values - Health: $healthScore, Avg Portions: $avgPortions, '
        'Consistency: $consistency, Current Streak: $currentStreak, '
        'Longest Streak: $longestStreak, Diversity Current: $diversityCurrentStreak, '
        'Diversity Longest: $diversityLongestStreak, Color Current: $colorCurrentStreak, '
        'Color Longest: $colorLongestStreak, Health Score Current: $healthScoreCurrentStreak, '
        'Health Score Longest: $healthScoreLongestStreak, Color Gaps: $colorGaps');

    return WeeklyIndicators(
      healthScoreWeekly: healthScore,
      averagePortionsWeekly: avgPortions,
      consistencyScoreWeekly: consistency,
      currentStreak: currentStreak,
      longestStreak: longestStreak,
      diversityCurrentStreak: diversityCurrentStreak,
      diversityLongestStreak: diversityLongestStreak,
      colorCurrentStreak: colorCurrentStreak,
      colorLongestStreak: colorLongestStreak,
      healthScoreCurrentStreak: healthScoreCurrentStreak,
      healthScoreLongestStreak: healthScoreLongestStreak,
      colorGaps: colorGaps,
      calendarWeek: week,
      calendarYear: year,
    );
  }

  /// Factory constructor to create an empty WeeklyIndicators object
  factory WeeklyIndicators.empty() {
    return WeeklyIndicators(
      calendarWeek: 0,
      calendarYear: 0,
    );
  }

  /// Convert to JSON (useful for debugging or caching)
  Map<String, dynamic> toJson() {
    return {
      'healthScoreWeekly': healthScoreWeekly,
      'averagePortionsWeekly': averagePortionsWeekly,
      'consistencyScoreWeekly': consistencyScoreWeekly,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'diversityCurrentStreak': diversityCurrentStreak,
      'diversityLongestStreak': diversityLongestStreak,
      'colorCurrentStreak': colorCurrentStreak,
      'colorLongestStreak': colorLongestStreak,
      'healthScoreCurrentStreak': healthScoreCurrentStreak,
      'healthScoreLongestStreak': healthScoreLongestStreak,
      'colorGaps': colorGaps?.toJson(),
      'calendarWeek': calendarWeek,
      'calendarYear': calendarYear,
    };
  }

  /// Check if all indicators are null (no data available)
  bool get isEmpty {
    return healthScoreWeekly == null &&
        averagePortionsWeekly == null &&
        consistencyScoreWeekly == null &&
        currentStreak == null &&
        longestStreak == null &&
        diversityCurrentStreak == null &&
        diversityLongestStreak == null &&
        colorCurrentStreak == null &&
        colorLongestStreak == null &&
        healthScoreCurrentStreak == null &&
        healthScoreLongestStreak == null &&
        colorGaps == null;
  }

  /// Get the number of colors achieved (7 minus missing colors)
  int get colorsAchieved {
    return 7 - (colorGaps?.missingCount ?? 7);
  }

  /// Get total portions for the week
  double get totalPortionsWeekly {
    return (averagePortionsWeekly ?? 0) * 7;
  }

  @override
  String toString() {
    return 'WeeklyIndicators(week: $calendarWeek, year: $calendarYear, '
        'healthScore: $healthScoreWeekly, avgPortions: $averagePortionsWeekly, '
        'consistency: $consistencyScoreWeekly, currentStreak: $currentStreak, '
        'longestStreak: $longestStreak, diversityCurrentStreak: $diversityCurrentStreak, '
        'diversityLongestStreak: $diversityLongestStreak, colorCurrentStreak: $colorCurrentStreak, '
        'colorLongestStreak: $colorLongestStreak, healthScoreCurrentStreak: $healthScoreCurrentStreak, '
        'healthScoreLongestStreak: $healthScoreLongestStreak, colorGaps: $colorGaps)';
  }
}

/// Model class representing color gaps data (missing colors from rainbow)
class ColorGapsData {
  final List<String> missingColors;
  final int missingCount;

  ColorGapsData({
    required this.missingColors,
    required this.missingCount,
  });

  // ✅ Helper method for type conversion
  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  /// Factory constructor to create ColorGapsData from JSON
  factory ColorGapsData.fromJson(Map<String, dynamic> json) {
    List<String> colors = [];
    
    if (json['missing_colors'] != null) {
      if (json['missing_colors'] is List) {
        colors = List<String>.from(json['missing_colors']);
      } else if (json['missing_colors'] is String) {
        colors = [json['missing_colors'] as String];
      }
    }

    return ColorGapsData(
      missingColors: colors,
      missingCount: _toInt(json['missing_count']),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'missing_colors': missingColors,
      'missing_count': missingCount,
    };
  }

  /// Check if all colors are present
  bool get allColorsComplete {
    return missingCount == 0;
  }

  /// Get percentage of colors completed
  double get completionPercentage {
    return ((7 - missingCount) / 7) * 100;
  }

  @override
  String toString() {
    return 'ColorGapsData(missingColors: $missingColors, missingCount: $missingCount)';
  }
}

/// Enum for health score levels
enum HealthScoreLevel {
  excellent, // 80-100
  good, // 60-79
  fair, // 40-59
  needsImprovement, // 0-39
}

/// Extension to add helper methods to WeeklyIndicators
extension WeeklyIndicatorsExtension on WeeklyIndicators {
  /// Get health score level based on score value
  HealthScoreLevel get healthScoreLevel {
    final score = healthScoreWeekly ?? 0;
    if (score >= 80) return HealthScoreLevel.excellent;
    if (score >= 60) return HealthScoreLevel.good;
    if (score >= 40) return HealthScoreLevel.fair;
    return HealthScoreLevel.needsImprovement;
  }

  /// Get motivational message based on health score
  String get motivationalMessage {
    switch (healthScoreLevel) {
      case HealthScoreLevel.excellent:
        return "Excellent! You're crushing it!";
      case HealthScoreLevel.good:
        return "You're good! Keep going!";
      case HealthScoreLevel.fair:
        return "Good start! Keep improving!";
      case HealthScoreLevel.needsImprovement:
        return "Let's get started on your health journey!";
    }
  }

  /// Check if user has an active daily portion streak
  bool get hasActiveStreak {
    return (currentStreak ?? 0) > 0;
  }

  /// Check if user has an active plant diversity streak
  bool get hasActiveDiversityStreak {
    return (diversityCurrentStreak ?? 0) > 0;
  }

  /// Check if user has an active color streak
  bool get hasActiveColorStreak {
    return (colorCurrentStreak ?? 0) > 0;
  }

  /// Check if user has an active health score streak
  bool get hasActiveHealthScoreStreak {
    return (healthScoreCurrentStreak ?? 0) > 0;
  }

  /// Check if current streak matches longest streak (personal best)
  bool get isPersonalBest {
    return currentStreak != null &&
        longestStreak != null &&
        currentStreak == longestStreak &&
        currentStreak! > 0;
  }

  /// Check if current diversity streak matches longest diversity streak (personal best)
  bool get isDiversityPersonalBest {
    return diversityCurrentStreak != null &&
        diversityLongestStreak != null &&
        diversityCurrentStreak == diversityLongestStreak &&
        diversityCurrentStreak! > 0;
  }

  /// Check if current color streak matches longest color streak (personal best)
  bool get isColorPersonalBest {
    return colorCurrentStreak != null &&
        colorLongestStreak != null &&
        colorCurrentStreak == colorLongestStreak &&
        colorCurrentStreak! > 0;
  }

  /// Check if current health score streak matches longest health score streak (personal best)
  bool get isHealthScorePersonalBest {
    return healthScoreCurrentStreak != null &&
        healthScoreLongestStreak != null &&
        healthScoreCurrentStreak == healthScoreLongestStreak &&
        healthScoreCurrentStreak! > 0;
  }

  /// Get diversity streak message
  String get diversityStreakMessage {
    final current = diversityCurrentStreak ?? 0;
    final longest = diversityLongestStreak ?? 0;
    
    if (current == 0) {
      if (longest > 0) {
        return "Your longest diversity streak was $longest weeks. You can do it again!";
      }
      return "Start your plant diversity streak by eating 30 different plants this week!";
    }
    
    if (current == 1) {
      return "Great start! 1 week of 30+ plants. Keep it going!";
    }
    
    if (isDiversityPersonalBest) {
      return "🎉 Personal Best! $current weeks of 30+ plant diversity!";
    }
    
    return "$current weeks of 30+ plant diversity! Your best is $longest weeks.";
  }

  /// Get portion streak message
  String get portionStreakMessage {
    final current = currentStreak ?? 0;
    final longest = longestStreak ?? 0;
    
    if (current == 0) {
      if (longest > 0) {
        return "Your longest streak was $longest days. You can do it again!";
      }
      return "Start your streak by eating 5 portions daily!";
    }
    
    if (current == 1) {
      return "Great! 1 day streak. Keep it up!";
    }
    
    if (isPersonalBest) {
      return "🎉 Personal Best! $current days streak!";
    }
    
    return "$current days streak! Your best is $longest days.";
  }

  /// Get color streak message
  String get colorStreakMessage {
    final current = colorCurrentStreak ?? 0;
    final longest = colorLongestStreak ?? 0;
    
    if (current == 0) {
      if (longest > 0) {
        return "Your longest rainbow streak was $longest weeks. You can do it again!";
      }
      return "Eat the rainbow! Consume 3+ plants from each of the 7 colors this week!";
    }
    
    if (current == 1) {
      return "Amazing! 1 week of eating all 7 colors. Keep it going!";
    }
    
    if (isColorPersonalBest) {
      return "🌈 Personal Best! $current weeks of eating the full rainbow!";
    }
    
    return "$current weeks of rainbow eating! Your best is $longest weeks.";
  }

  /// Get health score streak message
  String get healthScoreStreakMessage {
    final current = healthScoreCurrentStreak ?? 0;
    final longest = healthScoreLongestStreak ?? 0;
    
    if (current == 0) {
      if (longest > 0) {
        return "Your longest perfect health streak was $longest weeks. You can do it again!";
      }
      return "Achieve a perfect 100% health score to start your streak!";
    }
    
    if (current == 1) {
      return "Perfect! 1 week of 100% health score. Keep it up!";
    }
    
    if (isHealthScorePersonalBest) {
      return "🏆 Personal Best! $current weeks of perfect health scores!";
    }
    
    return "$current weeks of perfect health! Your best is $longest weeks.";
  }
}