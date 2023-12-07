from collections import defaultdict
import re
from typing import Dict

TEST = """Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11""".split('\n')
with open("day4.txt", "r") as f:
    INPUT = f.readlines()
# INPUT = TEST

class Card:
    def __init__(self, id, winning, ours) -> None:
        self.id = id
        self.winning = winning
        self.ours = ours
        self.copies = 1
    
    def add_copies(self, count):
        self.copies += count

    def matches(self) -> int:
        return len(list(set(self.winning) & set(self.ours)))
    
    def worth(self) -> int:
        inter = list(set(self.winning) & set(self.ours))
        return int(pow(2, len(inter)-1))

    def deep_worth(self, cards):
        matches = len(list(set(self.winning) & set(self.ours)))
        score = int(pow(2, matches-1))
        if matches > 0:
            for i in range(1, matches+1):
                score += cards[self.id + i].deep_worth(cards)
        return score


    def __str__(self) -> str:
        inter = list(set(self.winning) & set(self.ours))
        return f"{self.winning}, {self.ours}, {inter}, {self.worth}"

points = 0
copies = defaultdict(int)
cards: Dict[int, Card] = {}
for idx, line in enumerate(INPUT):
    s = line.split(':')[1].split('|')
    winning_numbers = re.findall(r"(\d+)", s[0])
    our_numbers = re.findall(r"(\d+)", s[1])
    c = Card(idx+1, winning_numbers, our_numbers)
    cards[idx+1] = c
    points += c.worth()

for idx, card in cards.items():
    for i in range(1, card.matches()+1):
        cards[idx+i].add_copies(card.copies)

total_cards = 0
for idx, card in cards.items():
    total_cards += card.copies

print(points)
print(total_cards)