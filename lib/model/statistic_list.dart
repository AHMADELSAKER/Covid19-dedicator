import 'dart:convert';

class StatisticList{
  final List<StatisticModel> statistics;
  StatisticList({
    this.statistics,
  });

  factory StatisticList.fromJson(List<dynamic> parsedJson) {
    List<StatisticModel> statistics = new List<StatisticModel>();
    statistics = parsedJson.map((i) => StatisticModel.fromJson(i)).toList();
    return StatisticList(statistics: statistics);
  }
}

List<StatisticModel> statisticModelFromJson(String str) => List<StatisticModel>.from(json.decode(str).map((x) => StatisticModel.fromJson(x)));

String statisticModelToJson(List<StatisticModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class StatisticModel {
  StatisticModel({
    this.updated,
    this.country,
    this.countryInfo,
    this.cases,
    this.todayCases,
    this.deaths,
    this.todayDeaths,
    this.recovered,
    this.todayRecovered,
    this.active,
    this.critical,
    this.casesPerOneMillion,
    this.deathsPerOneMillion,
    this.tests,
    this.testsPerOneMillion,
    this.population,
    this.continent,
    this.oneCasePerPeople,
    this.oneDeathPerPeople,
    this.oneTestPerPeople,
    this.undefined,
    this.activePerOneMillion,
    this.recoveredPerOneMillion,
    this.criticalPerOneMillion,
  });

  int updated;
  String country;
  CountryInfo countryInfo;
  int cases;
  int todayCases;
  int deaths;
  int todayDeaths;
  int recovered;
  int todayRecovered;
  int active;
  int critical;
  int casesPerOneMillion;
  double deathsPerOneMillion;
  int tests;
  int testsPerOneMillion;
  int population;
  Continent continent;
  int oneCasePerPeople;
  int oneDeathPerPeople;
  int oneTestPerPeople;
  double undefined;
  double activePerOneMillion;
  double recoveredPerOneMillion;
  double criticalPerOneMillion;

  ///this method will prevent the override of toString
  bool statisticFilterByCountry(String filter) {
    return this?.country?.toLowerCase()?.contains(filter.toLowerCase());
  }

  ///custom comparing function to check if two users are equal
  bool isEqual(StatisticModel model) {
    return this?.countryInfo?.id == model?.countryInfo?.id;
  }

  factory StatisticModel.fromJson(Map<String, dynamic> json) => StatisticModel(
    updated: json["updated"] == null ? null : json["updated"],
    country: json["country"] == null ? null : json["country"],
    countryInfo: json["countryInfo"] == null ? null : CountryInfo.fromJson(json["countryInfo"]),
    cases: json["cases"] == null ? null : json["cases"],
    todayCases: json["todayCases"] == null ? null : json["todayCases"],
    deaths: json["deaths"] == null ? null : json["deaths"],
    todayDeaths: json["todayDeaths"] == null ? null : json["todayDeaths"],
    recovered: json["recovered"] == null ? null : json["recovered"],
    todayRecovered: json["todayRecovered"] == null ? null : json["todayRecovered"],
    active: json["active"] == null ? null : json["active"],
    critical: json["critical"] == null ? null : json["critical"],
    casesPerOneMillion: json["casesPerOneMillion"] == null ? null : json["casesPerOneMillion"],
    deathsPerOneMillion: json["deathsPerOneMillion"] == null ? null : json["deathsPerOneMillion"].toDouble(),
    tests: json["tests"] == null ? null : json["tests"],
    testsPerOneMillion: json["testsPerOneMillion"] == null ? null : json["testsPerOneMillion"],
    population: json["population"] == null ? null : json["population"],
    continent: json["continent"] == null ? null : continentValues.map[json["continent"]],
    oneCasePerPeople: json["oneCasePerPeople"] == null ? null : json["oneCasePerPeople"],
    oneDeathPerPeople: json["oneDeathPerPeople"] == null ? null : json["oneDeathPerPeople"],
    oneTestPerPeople: json["oneTestPerPeople"] == null ? null : json["oneTestPerPeople"],
    undefined: json["undefined"] == null ? null : json["undefined"].toDouble(),
    activePerOneMillion: json["activePerOneMillion"] == null ? null : json["activePerOneMillion"].toDouble(),
    recoveredPerOneMillion: json["recoveredPerOneMillion"] == null ? null : json["recoveredPerOneMillion"].toDouble(),
    criticalPerOneMillion: json["criticalPerOneMillion"] == null ? null : json["criticalPerOneMillion"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "updated": updated == null ? null : updated,
    "country": country == null ? null : country,
    "countryInfo": countryInfo == null ? null : countryInfo.toJson(),
    "cases": cases == null ? null : cases,
    "todayCases": todayCases == null ? null : todayCases,
    "deaths": deaths == null ? null : deaths,
    "todayDeaths": todayDeaths == null ? null : todayDeaths,
    "recovered": recovered == null ? null : recovered,
    "todayRecovered": todayRecovered == null ? null : todayRecovered,
    "active": active == null ? null : active,
    "critical": critical == null ? null : critical,
    "casesPerOneMillion": casesPerOneMillion == null ? null : casesPerOneMillion,
    "deathsPerOneMillion": deathsPerOneMillion == null ? null : deathsPerOneMillion,
    "tests": tests == null ? null : tests,
    "testsPerOneMillion": testsPerOneMillion == null ? null : testsPerOneMillion,
    "population": population == null ? null : population,
    "continent": continent == null ? null : continentValues.reverse[continent],
    "oneCasePerPeople": oneCasePerPeople == null ? null : oneCasePerPeople,
    "oneDeathPerPeople": oneDeathPerPeople == null ? null : oneDeathPerPeople,
    "oneTestPerPeople": oneTestPerPeople == null ? null : oneTestPerPeople,
    "undefined": undefined == null ? null : undefined,
    "activePerOneMillion": activePerOneMillion == null ? null : activePerOneMillion,
    "recoveredPerOneMillion": recoveredPerOneMillion == null ? null : recoveredPerOneMillion,
    "criticalPerOneMillion": criticalPerOneMillion == null ? null : criticalPerOneMillion,
  };
}

enum Continent { ASIA, EUROPE, AFRICA, NORTH_AMERICA, SOUTH_AMERICA, AUSTRALIA_OCEANIA, EMPTY }

final continentValues = EnumValues({
  "Africa": Continent.AFRICA,
  "Asia": Continent.ASIA,
  "Australia-Oceania": Continent.AUSTRALIA_OCEANIA,
  "": Continent.EMPTY,
  "Europe": Continent.EUROPE,
  "North America": Continent.NORTH_AMERICA,
  "South America": Continent.SOUTH_AMERICA
});

class CountryInfo {
  CountryInfo({
    this.id,
    this.iso2,
    this.iso3,
    this.lat,
    this.long,
    this.flag,
  });

  int id;
  String iso2;
  String iso3;
  double lat;
  double long;
  String flag;

  factory CountryInfo.fromJson(Map<String, dynamic> json) => CountryInfo(
    id: json["_id"] == null ? null : json["_id"],
    iso2: json["iso2"] == null ? null : json["iso2"],
    iso3: json["iso3"] == null ? null : json["iso3"],
    lat: json["lat"] == null ? null : json["lat"].toDouble(),
    long: json["long"] == null ? null : json["long"].toDouble(),
    flag: json["flag"] == null ? null : json["flag"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id == null ? null : id,
    "iso2": iso2 == null ? null : iso2,
    "iso3": iso3 == null ? null : iso3,
    "lat": lat == null ? null : lat,
    "long": long == null ? null : long,
    "flag": flag == null ? null : flag,
  };
}

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
