use std::collections::{VecDeque, HashMap};
use regex::Regex;

#[derive(Debug)]
enum Operand {
    Multiply,
    Add
}

#[derive(Debug)]
struct MonkeyOperation {
    // Use none for "Old"
    left: Option<u64>,
    op: Operand,
    right: Option<u64>,
}

#[derive(Debug)]
struct Monkey {
    items: VecDeque<u64>,
    operation: MonkeyOperation,
    destination_monkey_true: usize,
    destination_monkey_false: usize,
    divisible_test: u64,
    inspect_count: u64,
    worrying_monkey: bool,
}

impl Monkey {
    fn parse_monkey(lines: &str, worrying_monkey: bool) -> Self {
        let mut id = 42;
        let mut items = VecDeque::new();
        let mut operation = MonkeyOperation{ left: None, op: Operand::Add, right: None };
        let mut divisible_test = 0;
        let mut destination_monkey_true = 0;
        let mut destination_monkey_false = 0;
        for line in lines.lines() {
            if line.starts_with("Monkey") {
                let re = Regex::new(r"^Monkey (\d)").unwrap();
                let caps = re.captures(line).unwrap();
                id = caps.get(1).map_or(id, |m| m.as_str().parse::<u8>().unwrap());
            } else if line.contains("Starting") {
                let re = Regex::new(r"\d+").unwrap();
                for x in re.find_iter(line) {
                    items.push_back(x.as_str().parse::<u64>().unwrap());
                }
            } else if line.contains("Operation") {
                let re = Regex::new(r".+=\s(.+)\s(\*|\+)\s(.+)").unwrap();
                let caps = re.captures(line).unwrap();
                let left = caps.get(1).map_or("", |m| m.as_str());
                let op = caps.get(2).map_or("", |m| m.as_str());
                let right = caps.get(3).map_or("", |m| m.as_str());
                if left != "old" {
                    operation.left = Some(left.parse::<u64>().unwrap());
                }
                if right != "old" {
                    operation.left = Some(right.parse::<u64>().unwrap());
                }
                operation.op = match op {
                    "*" => Operand::Multiply,
                    "+" => Operand::Add,
                    _ => panic!(),
                };
            } else if line.contains("Test") {
                let re = Regex::new(r"\d+").unwrap();
                divisible_test = *re.find_iter(line).map(|x| {
                    x.as_str().parse::<u64>().unwrap()
                }).collect::<Vec<u64>>().first().unwrap();
            } else if line.contains("If true") {
                let re = Regex::new(r"\d+").unwrap();
                destination_monkey_true = *re.find_iter(line).map(|x| {
                    x.as_str().parse::<usize>().unwrap()
                }).collect::<Vec<usize>>().first().unwrap();
            } else if line.contains("If false") {
                let re = Regex::new(r"\d+").unwrap();
                destination_monkey_false = *re.find_iter(line).map(|x| {
                    x.as_str().parse::<usize>().unwrap()
                }).collect::<Vec<usize>>().first().unwrap();
            } else {
                panic!("Seems like we received a line we cannot parse: {}", line);
            }
        }
        Self { items, operation, divisible_test, destination_monkey_true, destination_monkey_false, inspect_count: 0, worrying_monkey }
    }

    fn apply_operation(&self, old_worry: u64) -> u64 {
        let right = match self.operation.right {
            Some(val) => val,
            None => old_worry,
        };
        let left = match self.operation.left {
            Some(val) => val,
            None => old_worry,
        };
        match self.operation.op {
            Operand::Multiply => {
                println!("planning on doing {left} * {right}"); 
                left as u64 * right as u64
            },
            Operand::Add => left as u64 + right as u64,
        }
    }

    fn inspect_item(&mut self, common_divisor: u64) -> Option<(usize, u64)> {
        match self.items.pop_front() {
            Some(item_worry) => {
                self.inspect_count += 1;
                let mut new_worry = self.apply_operation(item_worry);
                if self.worrying_monkey {
                    new_worry = (new_worry as f64 / 3.0).floor() as u64;
                } else {
                    new_worry %= common_divisor;
                }
                let next_monkey = match new_worry.rem_euclid(self.divisible_test) {
                    0 => self.destination_monkey_true,
                    _ => self.destination_monkey_false,
                };
                Some((next_monkey, new_worry))
            },
            None => None,
        }
    }

}

fn parse_monkeys(lines: &str, worrying_monkeys: bool) -> HashMap<usize, Monkey> {
    let mut monkeys:HashMap<usize, Monkey> = HashMap::new();
    for (i, block) in lines.split("\n\n").enumerate() {
        monkeys.insert(i, Monkey::parse_monkey(block, worrying_monkeys));
    }
    monkeys
}

fn apply_rounds(monkeys: &mut HashMap<usize, Monkey>, rounds: usize) {
    let common_divisor: u64 = monkeys.values().map(|m| m.divisible_test).product::<u64>();
    for _ in 1..rounds+1 {
        for i in 0..monkeys.keys().len() {
            while let Some(next_monkey_item) = monkeys.get_mut(&i).unwrap().inspect_item(common_divisor) {
                monkeys.get_mut(&next_monkey_item.0).unwrap().items.push_back(next_monkey_item.1);
            }
        }
    }
}

fn monkeys_inspection_count(monkeys: HashMap<usize, Monkey>) -> Vec<u64> {
    let mut inspected = monkeys.values().map(|m| m.inspect_count).collect::<Vec<u64>>();
    inspected.sort();
    inspected.reverse();
    inspected
}

fn pb1(lines: &str) -> u64 {
    let mut monkeys = parse_monkeys(lines, true);
    apply_rounds(&mut monkeys, 20);
    let inspected = monkeys_inspection_count(monkeys);
    inspected.into_iter().take(2).product()
}


fn pb2(lines: &str) -> u64 {
    let mut monkeys = parse_monkeys(lines, false);
    apply_rounds(&mut monkeys, 10_000);
    let inspected = monkeys_inspection_count(monkeys);
    inspected.into_iter().take(2).product()
}


fn main() {
    dbg!(pb1(include_str!("input.txt")));
    dbg!(pb2(include_str!("input.txt")));
}

#[test]
fn test_pb1() {
    assert_eq!(10605, pb1(include_str!("test.txt")));
}

#[test]
fn test_pb2() {
    assert_eq!(2713310158, pb2(include_str!("test.txt")));
}