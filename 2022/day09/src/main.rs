use std::fmt;

use itertools::Itertools;

#[derive(Debug)]
enum Direction {
    Up,
    Down,
    Left,
    Right,
}

#[derive(Debug)]
struct Move {
    direction: Direction,
    steps: u32,
}

#[derive(Debug, Clone, PartialEq, Hash, PartialOrd, Ord)]
struct Point {
    x: i32,
    y: i32,
}
impl Eq for Point {}
struct Map {
    head: Point,
    knots: Vec<Point>,
    visited: Vec<Point>,
}

impl Move {
    fn new(dir: &str, steps: &str) -> Self {
        let dir = match dir {
            "U" => Direction::Up,
            "D" => Direction::Down,
            "L" => Direction::Left,
            "R" => Direction::Right,
            _ => panic!("Invalid input")
        };
        let n = steps.parse::<u32>().expect("Unvalid input");
        Self { direction:dir, steps: n }
    }
}


impl Map {
    fn new(num_tails: usize) -> Self {
        let x = 12;
        let y = 13;
        Self {
            head: Point{x, y},
            knots: vec![Point{x, y}; num_tails],
            visited: vec![Point{x, y}],
        }
    }

    fn touching(head: &Point, tail: &Point) -> bool {
        let x_diff= head.x.abs_diff(tail.x);
        let y_diff = head.y.abs_diff(tail.y);
        (head == tail) || ((x_diff+y_diff == 2) && (x_diff == y_diff)) || (x_diff+y_diff == 1)
    }

    fn apply_move(&mut self, m: &Move) {
        println!("== {:?} {} ==", m.direction, m.steps);
        for _ in 0..m.steps {
            match m.direction {
                Direction::Up => {
                    self.head.y -= 1
                },
                Direction::Down => {
                    self.head.y += 1
                },
                Direction::Left => {
                    self.head.x -= 1
                },
                Direction::Right => {
                    self.head.x += 1
                },
            }
            let mut head = self.head.clone();
            let knots_number = self.knots.len();
            for (i,knot) in self.knots.iter_mut().enumerate() {
                if !Map::touching(&head, knot) {
                    let x_diff: i32 = head.x - knot.x;
                    let y_diff: i32 = head.y - knot.y;
                    if x_diff == 0  && y_diff != 0 {
                        // same column
                         if y_diff < 0 {knot.y -= 1} else {knot.y += 1};
                    } else if y_diff == 0 && x_diff != 0 {
                        // same line
                        if x_diff < 0 {knot.x -= 1} else {knot.x += 1};
                    } else {
                        //diag
                        if y_diff < 0 {knot.y -= 1} else {knot.y += 1};
                        if x_diff < 0 {knot.x -= 1} else {knot.x += 1};
                    }
                    if i == knots_number-1 {
                        self.visited.push(knot.clone());
                    }
                }
                head = knot.clone();
            }
        }
        dbg!(&self);
    }
}

impl fmt::Debug for Map {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        writeln!(f)?;
        for y in 0..21 {
            for x in 0..26 {
                let c = Point{x,y};
                let i = self.knots.binary_search_by(|p| { p.cmp(&c) });
                if c == self.head {
                    write!(f, "H")?;
                } else if i.is_ok() {
                    write!(f, "{}", i.unwrap())?;
                } else if (x,y) == (12,13) {
                    write!(f, "s")?;
                } else {
                    write!(f, ".")?;
                }
            }
            writeln!(f)?;
        }
        Ok(())
    }
}


fn pb1(lines: &str) -> u32 {
    let mut moves:Vec<Move> = vec![];
    for line in lines.lines() {
        let dir_n: Vec<&str> = line.split(' ').collect();
        moves.push(Move::new(
            dir_n.first().unwrap(),
            dir_n.get(1).unwrap(),
        ));
    }
    let mut map = Map::new(1);
    // dbg!(&moves);
    dbg!(&map);
    for m in moves {
        map.apply_move(&m);
    }
    // for (i, visit) in map.visited.iter().unique().enumerate() {
    //     println!("Visited {i} (x:{},y:{})", visit.x, visit.y);
    // }
    map.visited.iter().unique().count() as u32
}

fn pb2(lines: &str) -> u32 {
    let mut moves:Vec<Move> = vec![];
    for line in lines.lines() {
        let dir_n: Vec<&str> = line.split(' ').collect();
        moves.push(Move::new(
            dir_n.first().unwrap(),
            dir_n.get(1).unwrap(),
        ));
    }
    let mut map = Map::new(9);
    dbg!(&moves);
    dbg!(&map);
    for m in moves {
        map.apply_move(&m);
    }
    for (i, visit) in map.visited.iter().unique().enumerate() {
        println!("Visited {i} (x:{},y:{})", visit.x, visit.y);
    }
    map.visited.iter().unique().count() as u32
}

fn main() {
    let lines = include_str!("input.txt");
    dbg!(pb1(lines));
    dbg!(pb2(lines));
}


#[test]
fn test_pb1() {
    assert_eq!(13, pb1(include_str!("test.txt")));
}

#[test]
fn test_pb2() {
    assert_eq!(36, pb2(include_str!("test2.txt")));
}