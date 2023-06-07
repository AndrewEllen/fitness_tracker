import 'package:openfoodfacts/openfoodfacts.dart';

void setOpenFoodFactsAPISettings() {

  OpenFoodAPIConfiguration.userAgent = const UserAgent(name: "Stay FIT", url: "https://github.com/AndrewEllen");

  OpenFoodAPIConfiguration.globalLanguages = <OpenFoodFactsLanguage>[
    OpenFoodFactsLanguage.ENGLISH
  ];

  OpenFoodAPIConfiguration.globalCountry = OpenFoodFactsCountry.UNITED_KINGDOM;

}

