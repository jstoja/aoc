use std::collections::HashMap;
use regex::Regex;

#[derive(Debug)]
struct Move(usize, usize, usize);

fn apply_to(moves: &Vec<Move>, stacks: & mut HashMap::<usize, Vec<char>>, ordered: bool) {
    for m in moves {
        let mut tmp_stack: Vec<char> = vec![];
        for _ in 0..m.0 {
            if let Some(u) = stacks.get_mut(&m.1) {
                if let Some(b) = u.pop() {
                    tmp_stack.push(b)
                }
            }
        }
        if ordered {
            tmp_stack.reverse();
        }
        if let Some(u) = stacks.get_mut(&m.2) {
            u.append(&mut tmp_stack)
        }
    }
}

fn pb(ordered: bool) {
    let lines = include_str!("input.txt").lines();
    let mut stacks:HashMap::<usize, Vec<char>> = HashMap::new();
    let mut moves: Vec<Move> = vec![];
    let re = Regex::new(r"move ([0-9]+) from ([0-9]+) to ([0-9]+)").unwrap();
    for line in lines {
        let line_chars = line.chars().collect::<Vec<_>>();
        if line.is_empty() || (line_chars[0] == ' ' && line_chars[1] == '1') {
            continue
        } else if line.contains('[') {
            let num_stack = (line.len() + 1) / 4;
            for i in 0..num_stack {
                let c = line_chars[i*3 + i + 1];
                if c != ' ' {
                    stacks
                        .entry(i)
                        .or_default()
                        .insert(0, c);
                }
            }
        } else {
            let caps = re.captures(line).unwrap();
            let regex_args = (1..4).map(|c| {
                caps.get(c).unwrap().as_str().parse::<usize>().unwrap()
            }).collect::<Vec<usize>>();
            moves.push(Move(regex_args[0], regex_args[1]-1, regex_args[2]-1));
        }
    }

    apply_to(&moves, & mut stacks, ordered);

    let mut res: String = "".into();
    for i in 0..stacks.len() {
        res.push(*stacks.get(&i).unwrap().last().unwrap());
    }
    println!("{}", res);
}

fn main() {
    pb(false);
    pb(true);
}
