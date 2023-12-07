import re
from typing import List


TEST = """seeds: 79 14 55 13

seed-to-soil map:
50 98 2
52 50 48

soil-to-fertilizer map:
0 15 37
37 52 2
39 0 15

fertilizer-to-water map:
49 53 8
0 11 42
42 0 7
57 7 4

water-to-light map:
88 18 7
18 25 70

light-to-temperature map:
45 77 23
81 45 19
68 64 13

temperature-to-humidity map:
0 69 1
1 0 69

humidity-to-location map:
60 56 37
56 93 4""".strip()

# with open("day5.txt", "r") as f:
#     TEST = f.read().strip()

class Mapper:
    def __init__(self, dest_range_start: int, source_range_start: int, range_length: int) -> None:
        self.dest_range_start = dest_range_start
        self.source_range_start = source_range_start
        self.range_length = range_length

    def __str__(self) -> str:
        return f"[{self.dest_range_start}, {self.source_range_start}, {self.range_length}]"

    def convert(self, source: int) -> int | None:
        if self.source_range_start <= source < self.source_range_start+self.range_length:
            return self.dest_range_start+(source-self.source_range_start)
        return None

    def unconvert(self, destination: int) -> int | None:
        if self.dest_range_start <= destination < self.dest_range_start+self.range_length:
            return self.source_range_start+(destination-self.dest_range_start)
        return None
    
    def __lt__(self, other) -> bool:
        return self.dest_range_start > other.dest_range_start


def seed_range(seeds: List[int]) -> List[List[int]]:
    r: List[List[int]] = []
    for i in range(0, len(seeds), 2):
        r.append([seeds[i], seeds[i+1]])
    return r

def is_in_seed_range(seed, seed_ranges) -> bool:
    for seed_range in seed_ranges:
        if seed_range[0] <= seed < seed_range[0]+seed_range[1]:
            return True
    return False


seeds = []
seeds_from_range = []
mappings = {}
for block in TEST.split('\n\n'):
    if re.match(r'^seeds:', block):
        seeds = list(map(int, block.split(':')[1].split()))
        seeds_from_range = seed_range(seeds)
    else:
        lines = block.split('\n') 
        header = lines[0].split()[0]
        values = lines[1:]
        maps = []
        for value in values:
            v = value.split()
            maps.append(Mapper(int(v[0]), int(v[1]), int(v[2])))
        mappings[header] = maps

def convert(mappings, source: int) -> int:
    for map in mappings:
        v = map.convert(source)
        if v:
            return v
    return source

def unconvert(mappings, destination: int) -> int:
    for map in mappings:
        v = map.unconvert(destination)
        if v:
            return v
    return destination

def check(init: int, order: List[str], f) -> int:
    v = init
    for key in order:
        v = f(mappings[key], v)
    return v

ORDER = [
    "seed-to-soil",
    "soil-to-fertilizer",
    "fertilizer-to-water",
    "water-to-light",
    "light-to-temperature",
    "temperature-to-humidity",
    "humidity-to-location"
]

locations = []
for seed in seeds:
    locations.append(check(seed, ORDER, convert))
print(min(locations))

sorted_loc = list(sorted(mappings["humidity-to-location"]))
for loc2 in sorted_loc:
    for loc in range(0, loc2.dest_range_start):
        seed = check(loc, list(reversed(ORDER)), unconvert)
        if is_in_seed_range(seed, seeds_from_range):
            raise Exception(loc)
