#include <iostream>

struct Advertising {
  int numAds;
  float percClick, avgClickProfit;
};

Advertising generator() {
  std::cout << "Enter number of ads shown to readers." << std::endl;
  int numAds;
  std::cin >> numAds;

  std::cout << "Enter percentage of users who clicked on ads." << std::endl;
  float percClick;
  std::cin >> percClick;

  std::cout << "Enter average profit from each ad clicked ($)." << std::endl;
  float avgClickProfit;
  std::cin >> avgClickProfit;

  return {numAds, percClick, avgClickProfit};
}

void revenueCalc(Advertising ad_factors) {
  std::cout << "Your revenue is $" << ad_factors.numAds * ad_factors.percClick / 100 * ad_factors.avgClickProfit << std::endl;
}

int main() {
  Advertising ad_components = generator();
  revenueCalc(ad_components);

  return 0;
}
