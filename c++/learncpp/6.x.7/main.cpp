#include <iostream>
#include <array>
#include <random>

// enums
enum class CardRank {
  TWO,
  THREE,
  FOUR,
  FIVE,
  SIX,
  SEVEN,
  EIGHT,
  NINE,
  TEN,
  JACK,
  QUEEN,
  KING,
  ACE
};

enum class CardSuit {
  CLUBS,
  DIAMONDS,
  HEARTS,
  SPADES
};

// structs
struct Card {
  CardRank rank;
  CardSuit suit;
};

// utility functions
int rdmNum(int max) {
  std::random_device rd;
  std::mt19937 mersenne(rd());
  return mersenne() % max;
}

// card functions
void printCard(const Card &card) {
  switch (card.rank) {
    case CardRank::TWO:
      std::cout << "2"; break;
    case CardRank::THREE:
      std::cout << "3"; break;
    case CardRank::FOUR:
      std::cout << "4"; break;
    case CardRank::FIVE:
      std::cout << "5"; break;
    case CardRank::SIX:
      std::cout << "6"; break;
    case CardRank::SEVEN:
      std::cout << "7"; break;
    case CardRank::EIGHT:
      std::cout << "8"; break;
    case CardRank::NINE:
      std::cout << "9"; break;
    case CardRank::TEN:
      std::cout << "10"; break;
    case CardRank::JACK:
      std::cout << "J"; break;
    case CardRank::QUEEN:
      std::cout << "Q"; break;
    case CardRank::KING:
      std::cout << "K"; break;
    case CardRank::ACE:
      std::cout << "A"; break;
  }

  switch (card.suit) {
    case CardSuit::CLUBS:
      std::cout << "C"; break;
    case CardSuit::DIAMONDS:
      std::cout << "D"; break;
    case CardSuit::HEARTS:
      std::cout << "H"; break;
    case CardSuit::SPADES:
      std::cout << "S"; break;
  }

  std::cout << std::endl;
}

void printDeck(const std::array<Card, 52> &deck) {
  for (const auto &card : deck) {
    printCard(card);
    std::cout << ' ';
  }

  std::cout << std::endl;
}

void swapCard(Card &card_one, Card &card_two) {
  auto tmp = card_one;
  card_one = card_two;
  card_two = tmp;
}

void shuffleDeck(std::array<Card, 52> &deck) {
  for (auto i = 0; i < deck.size(); ++i)
    swapCard(deck[i], deck[rdmNum(52)]);
}

short getCardValue(const Card &card) {
  switch (card.rank) {
    case CardRank::TWO:
      return 2;
    case CardRank::THREE:
      return 3;
    case CardRank::FOUR:
      return 4;
    case CardRank::FIVE:
      return 5;
    case CardRank::SIX:
      return 6;
    case CardRank::SEVEN:
      return 7;
    case CardRank::EIGHT:
      return 8;
    case CardRank::NINE:
      return 9;
    case CardRank::TEN:
    case CardRank::JACK:
    case CardRank::QUEEN:
    case CardRank::KING:
      return 10;
    case CardRank::ACE:
      return 11;
  }
}

// blackjack
bool playBlackjack(const std::array<Card, 52> &deck) {
  // initialize current card in deck
  const auto *cardPtr = &deck[0];

  // deal initial cards
  auto dealerScore = getCardValue(*cardPtr++);
  auto playerScore = getCardValue(*cardPtr++);
  playerScore += getCardValue(*cardPtr++);

  std::cout << "The dealer is showing " << dealerScore << std::endl;

  // player turn
  for (;;) {
    std::cout << "Your score is " << playerScore << std::endl;

    // player busts
    if (playerScore > 21)
      return false;

    // player hits or stands
    std::cout << "Would you like to hit (y/n)?" << std::endl;
    char choice;
    std::cin >> choice;

    if (choice == 'y')
      playerScore += getCardValue(*cardPtr++);
    else if (choice == 'n')
      break;
  }

  // dealer turn
  while (dealerScore < 17) {
    dealerScore += getCardValue(*cardPtr++);
    std::cout << "The dealer now has " << dealerScore << std::endl;
  }

  // dealer busts
  if (dealerScore > 21)
    return true;

  // determine outcome
  return (playerScore > dealerScore);
}

// main
int main() {
  // initialize deck
  std::array<Card, 52> deck;

  for (auto suit = 0; suit < 4; ++suit)
    for (auto rank = 0; rank < 13; ++rank) {
      auto card_index = rank + (suit * 13);
      deck[card_index].suit = static_cast<CardSuit>(suit);
      deck[card_index].rank = static_cast<CardRank>(rank) ;
    }

  // shuffle the deck
  shuffleDeck(deck);

  // begin the game
  auto result = playBlackjack(deck);
  result ? std::cout << "You win." : std::cout << "You lose.";
  std::cout << std::endl;

  return 0;
}
