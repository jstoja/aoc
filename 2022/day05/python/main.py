from collections import defaultdict
import sys
import re

class Move:
    def __init__(self, num, _from, to) -> None:
        self.num = int(num)
        self._f = int(_from) - 1
        self._t = int(to) - 1

Crate = str
Stack = list[Crate]

def apply_to(
    moves: list[Move], stacks: dict[int, Stack], ordered: bool = False
) -> dict[int, Stack]:
    for move in moves:
        tmp_stack: Stack = []
        for _ in range(move.num):
            tmp_stack += stacks[move._f].pop()
        if ordered:
            tmp_stack.reverse()
        stacks[move._t] += tmp_stack
    return stacks


def pb(filename: str, ordered: bool = False) -> str:
    stacks = defaultdict(Stack)
    moves: list[Move] = []
    with open(filename, "r") as f:
        while True:
            line = f.readline()
            if not line:
                break
            line = line.strip("\n")
            if (not line) or (line[1] == "1"):
                # we don't care about those lines
                continue
            elif "[" in line:
                num_stack = int((len(line) + 1) / 4)
                for i in range(num_stack):
                    crate = line[i * 3 + (i + 1)]
                    if crate != " ":
                        stacks[i].insert(0, crate)
            else:
                m = re.search("move ([0-9]+) from ([0-9]+) to ([0-9]+)", line)
                if m:
                    moves.append(Move(m.group(1), m.group(2), m.group(3)))
    apply_to(moves, stacks, ordered)
    res = ""
    for i in range(len(stacks)):
        res += stacks[i][-1]
    return res


if __name__ == "__main__":
    print(pb("input.txt"))
    print(pb("input.txt", True))
