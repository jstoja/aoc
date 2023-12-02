import re
from typing import List

with open("day2.txt") as f:
    data = f.readlines()

MAX_RED = 12
MAX_GREEN = 13
MAX_BLUE = 14


class Game:
    def __init__(self, id: int, red: int, blue: int, green: int) -> None:
        self.id = id
        self.red = red
        self.blue = blue
        self.green = green

    def power(self) -> int:
        return self.red * self.green * self.blue

    def is_possible(self) -> bool:
        return self.red <= MAX_RED and self.green <= MAX_GREEN and self.blue <= MAX_BLUE


def get_data(game: List[str]) -> List[Game]:
    games: List[Game] = []
    for line in game:
        line = line.strip()
        game_id = int(re.findall(r"Game (\d+)", line)[0])
        reds = [int(a) for a in re.findall(r"(\d+) red", line)]
        greens = [int(a) for a in re.findall(r"(\d+) green", line)]
        blues = [int(a) for a in re.findall(r"(\d+) blue", line)]
        games.append(Game(game_id, max(reds), max(blues), max(greens)))
    return games


games = get_data(data)


def one(games: List[Game]) -> int:
    score = 0
    for game in games:
        if game.is_possible():
            score += game.id
    return score


def two(games: List[Game]) -> int:
    score = 0
    for game_data in games:
        score += game_data.power()
    return score


print(one(games))
print(two(games))
