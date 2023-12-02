from typing import List


TEST = """1abc2
pqr3stu8vwx
a1b2c3d4e5f
treb7uchet""".split()

TEST2 = """two1nine
eightwothree
abcone2threexyz
xtwone3four
4nineeightseven2
zoneight234
7pqrstsixteen""".split()

NUMS = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]


def day1(lines: List[str]) -> int:
    count = 0
    for line in lines:
        nums = [
            c for c in line if c in ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        ]
        count = count + int(nums[0] + nums[-1])
    return count


def find_first(line: str) -> str:
    for i in range(0, len(line)):
        if line[i] in ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]:
            return line[i]
        else:
            word = line[i : i + 5]
            for n in NUMS:
                if n in word[0 : len(n)]:
                    return str(NUMS.index(n) + 1)
    return ""


def find_last(_line: str) -> str:
    line = _line[::-1]
    for i in range(0, len(line)):
        if line[i] in ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]:
            return line[i]
        else:
            word = line[i : i + 5]
            for n in NUMS:
                if n[::-1] in word[0 : len(n)]:
                    return str(NUMS.index(n) + 1)
    return ""


def day1_1(lines: List[str]) -> int:
    return sum(
        [int(find_first(line.strip()) + find_last(line.strip())) for line in lines]
    )


def test_find_last():
    assert find_last("two1nine") == "9"
    assert find_last("eightwothree") == "3"
    assert find_last("abcone2threexyz") == "3"
    assert find_last("xtwone3four") == "4"
    assert find_last("4nineeightseven2") == "2"
    assert find_last("zoneight234") == "4"
    assert find_last("7pqrstsixteen") == "6"


def test_find_first():
    assert find_first("two1nine") == "2"
    assert find_first("eightwothree") == "8"
    assert find_first("abcone2threexyz") == "1"
    assert find_first("xtwone3four") == "2"
    assert find_first("4nineeightseven2") == "4"
    assert find_first("zoneight234") == "1"
    assert find_first("7pqrstsixteen") == "7"


if __name__ == "__main__":
    with open("day1.txt", "r") as f:
        lines = f.readlines()
        print(day1(lines))
        print(day1_1(lines))
