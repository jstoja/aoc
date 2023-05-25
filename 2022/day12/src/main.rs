use std::collections::HashMap;
use pathfinding::prelude::dijkstra;
use pathfinding::prelude::bfs;

fn main() {
    dbg!(pb1(include_str!("input.txt")));
}

#[derive(Debug)]
struct Point {
}

#[derive(Clone, Copy, Debug, Eq, Hash, Ord, PartialEq, PartialOrd)]
struct Cell {
    x: usize,
    y: usize,
    elevation: char,
    elevation_num: u32,
}

#[derive(Debug)]
struct HeightMap {
    grid: HashMap<usize, HashMap<usize, Cell>>,
    max_x: usize,
    max_y: usize,
}

impl std::fmt::Display for HeightMap {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        for y in 0..self.grid.len() {
            let y_line = self.grid.get(&y).unwrap();
            let mut line = "".to_string();
            for x in 0..y_line.len() {
                let c = y_line.get(&x).unwrap();
                line += &c.elevation.to_string();
            }
            writeln!(f, "{line}")?;
        }
        Ok(())
    }
}


impl HeightMap {
    fn new() -> Self {
        Self { grid: HashMap::new(), max_x: 0, max_y: 0 }
    }

    fn add(&mut self, cell: Cell) {
        let y = cell.y;
        match self.grid.get_mut(&cell.y) {
            Some(y_line) => {
                y_line.insert(cell.x, cell);
            },
            None => {
                let mut y_line = HashMap::new();
                y_line.insert(cell.x, cell);
                self.grid.insert(y, y_line);
            },
        }
        if cell.x > self.max_x {
            self.max_x = cell.x
        }
        if cell.y > self.max_y {
            self.max_y = cell.y
        }
    }

    fn get_cell(&self, x: usize, y:usize) -> Option<&Cell> {
        match self.grid.get(&y) {
            Some(y_line) => {
                match y_line.get(&x) {
                    Some(v) => Some(v),
                    None => None,
                }
            },
            None => None,
        }
    }
}

impl Cell {
    fn new(x: usize, y: usize, elevation: char) -> Self {
        let elevation_num;
        if elevation == 'S' {
            elevation_num = 10u32;
        } else if elevation == 'E' {
            elevation_num = 35u32;
        } else {
            elevation_num = elevation.to_digit(36).unwrap();
        }
        Self { x, y, elevation, elevation_num }
    }

    fn successors(&self, grid: &HeightMap) -> Vec<(Cell, usize)> {
        let mut cells = vec![];
        if self.x < grid.max_x+2 {
            cells.push(grid.get_cell(self.x+1, self.y));
        }
        if self.x > 0 {
            cells.push(grid.get_cell(self.x-1, self.y));
        }
        if self.y < grid.max_y+2 {
            cells.push(grid.get_cell(self.x, self.y+1));
        }
        if self.y > 0 {
            cells.push(grid.get_cell(self.x, self.y-1));
        }

        cells.into_iter().filter(|c| {
            c.is_some()
        }).filter(|s| {
            self.elevation_num+1 >= s.unwrap().elevation_num
        }).map(|c| {
            // let score = c.unwrap().elevation.to_digit(10).unwrap() as usize;
            (*c.unwrap(), 1)
        }).collect()
    }
}

fn pb1(lines: &str) -> usize {
    let mut grid = HeightMap::new();
    let mut goal_coord = (0, 0);
    let mut start_coord = (0, 0);
    for (y,line) in lines.lines().enumerate() {
        for (x, c) in line.chars().enumerate() {
            grid.add(Cell::new(x, y, c));
            if c == 'E' {
                goal_coord = (x, y);
            } else if c == 'S' {
                start_coord = (x, y);
            }
        }
    }
    println!("{}", grid);
    let goal = grid.get_cell(goal_coord.0, goal_coord.1).unwrap();
    let result = dijkstra(
        grid.get_cell(start_coord.0, start_coord.1).unwrap(),
        |p| {

            p.successors(&grid)
        },
        |p| *p == *goal
    );
    match result {
        Some(r) => {
            //dbg!(&r);
            r.1
        },
        None => 0,
    }
}

#[test]
fn test_pb1() {
    assert_eq!(31, pb1(include_str!("test.txt")));
}
