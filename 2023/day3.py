import re
from typing import List

class Symbol:
    def __init__(self, y, x, value) -> None:
        self.y = y
        self.x = x
        self.value = value

    def __str__(self) -> str:
        return f"Symbol (x: {self.x}, y: {self.y})"
    
    def is_gear(self):
        if self.value == "*":
            return True 
        return False
    
    def parts_around(self, parts):
        p = []
        for part in parts:
            line_b = (self.y-1 <= part.y <= self.y+1)
            row_b = ((part.start <= self.x-1 <= part.end-1) or (part.start <= self.x+1 <= part.end-1) or (part.start <= self.x <= part.end-1))
            if line_b and row_b:
                p.append(part)
        return p


class Part:
    def __init__(self, y, start, end, value) -> None:
        self.y = y
        self.start = start
        self.end = end
        self.value = int(value)

    def __str__(self) -> str:
        return f"{self.value} (x: {self.start}, y: {self.y})"

    def has_symbol_around(self, symbols: List[Symbol]):
        for symbol in symbols:
            line_b = (self.y-1 <= symbol.y <= self.y+1)
            row_b = (self.start-1 <= symbol.x <= self.end)
            if line_b and row_b:
                return symbol 
        return None

def find_parts(map: List[str]) -> List[Part]:
    parts: List[Part] = []

    for line_num, line in enumerate(map):
        part = re.finditer(r"\d+", line)
        for p in part:
            parts.append(Part(line_num, p.span()[0], p.span()[1], p.group()))

    return parts

def find_symbols(map: List[str]):
    symbols = []
    for line_num, line in enumerate(map):
        symbol = re.finditer(r"(\*|-)", line)
        for p in symbol:
            symbols.append(Symbol(line_num, p.span()[0], p.group()))
    return symbols

def one(map) -> int:
    parts = find_parts(map)
    symbols = find_symbols(map)
    count = 0
    for part in parts:
        found = part.has_symbol_around(symbols)
        if found:
            count += part.value
    return count


def two(map) -> int:
    parts = find_parts(map)
    symbols = find_symbols(map)
    count = 0
    for sym in symbols:
        if sym.is_gear():
            found = sym.parts_around(parts)
            if len(found) == 2:
                ratio = found[0].value * found[1].value
                count += ratio
    return count


with open("day3.txt", "r") as f:
    input = f.read().strip()

syms = list(set(re.sub(r"(\d|\.)", "", input).replace('\n', '')))
syms.remove('*')
for sym in syms:
    input = input.replace(sym, '-')
map = input.split()

print(one(map))
print(two(map))