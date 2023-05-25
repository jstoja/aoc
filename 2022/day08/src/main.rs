#[derive(Debug, Default)]
struct Tree {
    height: u32,
    visible: bool,
    score: u64,
}

impl Tree {
    fn new(height: u32) -> Self {
        Self {
            height,
            visible: false,
            score: 1,
        }
    }
}

#[derive(PartialEq)]
enum TreeSightCheck {
    Top,
    Bottom,
    Left,
    Right,
}

fn get_total_sight_left(forest: &mut [Vec<Tree>], t_height: u32, x: usize, y: usize) -> u64 {
    let mut max_reached = false;
    let mut total_sight = 0;
    for x2 in 1..x+1 {
        let scanned_tree = forest.get(y).unwrap().get(x-x2).unwrap();
        if max_reached {
            break;
        } else if scanned_tree.height >= t_height {
            max_reached = true;
        }
        total_sight += 1;
    }
    println!("tree {x},{y} height={t_height} has total_sight_left={total_sight}");
    total_sight
}

fn get_total_sight_right(forest: &mut [Vec<Tree>], t_height: u32, x: usize, y: usize) -> u64 {
    let mut max_reached = false;
    let mut total_sight = 0;
    let x_max = forest.first().unwrap().len();
    for x2 in 1..(x_max-x) {
        let scanned_tree = forest.get(y).unwrap().get(x+x2).unwrap();
        if max_reached {
            break;
        } else if scanned_tree.height >= t_height {
            max_reached = true;
        }
        total_sight += 1;
    }
    println!("tree {x},{y} height={t_height} has total_sight_right={total_sight}");
    total_sight
}

fn get_total_sight_top(forest: &mut [Vec<Tree>], t_height: u32, x: usize, y: usize) -> u64 {
    let mut max_reached = false;
    let mut total_sight = 0;
    for y2 in 1..y+1 {
        let scanned_tree = forest.get(y-y2).unwrap().get(x).unwrap();
        if max_reached {
            break;
        } else if scanned_tree.height >= t_height {
            max_reached = true;
        }
        total_sight += 1;
    }
    println!("tree {x},{y} height={t_height} has total_sight_top={total_sight}");
    total_sight
}

fn get_total_sight_bottom(forest: &mut [Vec<Tree>], t_height: u32, x: usize, y: usize) -> u64 {
    let mut max_reached = false;
    let mut total_sight = 0;
    let y_max = forest.len();
    for y2 in 1..(y_max-y) {
        let scanned_tree = forest.get(y+y2).unwrap().get(x).unwrap();
        if max_reached {
            break;
        } else if scanned_tree.height >= t_height {
            max_reached = true;
        }
        total_sight += 1;
    }
    println!("tree {x},{y} height={t_height} has total_sight_bottom={total_sight}");
    total_sight
}

fn check2(forest: &mut [Vec<Tree>],x: usize, y: usize, check: TreeSightCheck) {
    let y_max = forest.len();
    let x_max = forest.first().unwrap().len();
    let t_height = forest.get(y).unwrap().get(x).unwrap().height;
    let total_sight = if x == 0 || y == 0 || y == y_max-1 || x == x_max-1 {
        0
    } else {
        match check {
            TreeSightCheck::Top => get_total_sight_top(forest, t_height, x, y),
            TreeSightCheck::Bottom => get_total_sight_bottom(forest, t_height, x, y),
            TreeSightCheck::Left => get_total_sight_left(forest, t_height, x, y),
            TreeSightCheck::Right => get_total_sight_right(forest, t_height, x, y),
        }
    };
    forest.get_mut(y).unwrap().get_mut(x).unwrap().score *= total_sight;
}

fn pb2(lines: &str) -> u64 {
    let mut forest:Vec<Vec<Tree>> = vec![];
    for line in lines.lines() {
        let mut tree_line = vec![];
        for c in line.chars() {
            let h = c.to_digit(10).unwrap();
            tree_line.push(Tree::new(h));
        }
        forest.push(tree_line);
    }

    let y_max = forest.len();
    let x_max = forest.first().unwrap().len();

    for y in 0..y_max {
        for x in 0..x_max {
            check2(&mut forest, x, y, TreeSightCheck::Left);
            check2(&mut forest, x, y, TreeSightCheck::Top);
            check2(&mut forest, x, y, TreeSightCheck::Right);
            check2(&mut forest, x, y, TreeSightCheck::Bottom);
        }
    }
    forest.iter().map(|tree_line| {
        tree_line.iter().inspect(|t| {
            dbg!(t);
        }).map(|t| { t.score }).max().unwrap()
    }).max().unwrap()
}

fn pb1(lines: &str) -> u64 {
    let mut forest:Vec<Vec<Tree>> = vec![];
    for (line_y, line) in lines.lines().enumerate() {
        let mut tree_line = vec![];
        for (line_x, c) in line.chars().enumerate() {
            let h = c.to_digit(10).unwrap();
            let mut t = Tree::new(h);
            if line_y == 0_usize || line_x == 0 || line_x == line.len()-1 {
                t.visible = true;
            }
            tree_line.push(t);
        }
        forest.push(tree_line);
    }
    for t in forest.last_mut().unwrap().iter_mut() {
        t.visible = true
    }

    // Visit from TOP
    for x in 0..forest.first().unwrap().len() {
        let mut visited_top_max: u32 = 0;
        let mut visited_bottom_max: u32 = 0;

        for y in 0..forest.len() {
            let t = forest.get_mut(y).unwrap().get_mut(x).unwrap();
            if visited_top_max < t.height {
                t.visible = true;
                visited_top_max = t.height;
            }
        }

        for y in (0..forest.len()).rev() {
            let t = forest.get_mut(y).unwrap().get_mut(x).unwrap();
            if visited_bottom_max < t.height {
                t.visible = true;
                visited_bottom_max = t.height;
            }
        }
    }

    for y in 0..forest.len() {
        // VISIT LEFT
        let mut visited_left_max: u32 = 0;
        for x in 0..forest.first().unwrap().len() {
            let t = forest.get_mut(y).unwrap().get_mut(x).unwrap();
            if visited_left_max < t.height {
                t.visible = true;
                visited_left_max = t.height;
            }
        }

        // VISIT RIGHT
        let mut visited_right_max: u32 = 0;
        for x in (0..forest.first().unwrap().len()).rev() {
            let t = forest.get_mut(y).unwrap().get_mut(x).unwrap();
            if visited_right_max < t.height {
                t.visible = true;
                visited_right_max = t.height;
            }
        }
    }

    let mut acc = 0;
    for tree_line in forest {
        for tree in tree_line {
            if tree.visible {
                acc += 1;
            }
        }
    }
    acc
}

fn main() {
    let lines = include_str!("input.txt");
    dbg!(pb1(lines));
    dbg!(pb2(lines));
}

#[test]
fn test_pb1() {
    let lines = include_str!("test.txt");
    assert_eq!(21, pb1(lines));
    assert_eq!(8, pb2(lines));
}