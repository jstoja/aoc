use id_tree::{TreeBuilder, Node, Tree};
use id_tree::InsertBehavior::{AsRoot, UnderNode};

#[derive(Debug)]
struct FsNode {
    size: u64,
}

fn directory_size(tree: &Tree<FsNode>, node: &Node<FsNode>) -> u64 {
    let mut total_size = node.data().size;
    for c in node.children() {
        total_size += directory_size(tree, tree.get(c).unwrap())
    }
    total_size
}

fn get_tree(lines:&str) -> Tree<FsNode> {
    let mut tree= TreeBuilder::<FsNode>::new().build();
    let root = tree.insert(Node::new(FsNode{size: 0}), AsRoot).unwrap();
    let mut current_dir = root;

    for line in lines.lines() {
        if line.starts_with('$') {
            let command: Vec<&str> = line.split(' ').skip(1).collect();
            if command[0] == "cd" {
                match command[1] {
                    "/" => {},
                    ".." => current_dir = tree.get(&current_dir).unwrap().parent().unwrap().clone(),
                    _ => {
                        let new_dir = tree.insert(
                            Node::new(FsNode{size: 0}),
                            UnderNode(&current_dir)
                        );
                        current_dir = new_dir.unwrap();        
                    },
                }
            }
        } else if line.starts_with("dir") {
            continue;
        } else {
            let file: Vec<&str> = line.split(' ').collect();
            let size = file[0].parse::<u64>().unwrap();
            tree.insert(
                Node::new(FsNode{size}),
                UnderNode(&current_dir)
            ).unwrap();
        }
    }
    tree
}

fn pb1(tree: &Tree<FsNode>) -> u64 {
    tree.traverse_level_order(tree.root_node_id().unwrap()).unwrap()
        .filter(|n| !n.children().is_empty())
        .map(|n| directory_size(tree, n))
        .filter(|s| s <= &100_000)
        .sum()
}


fn pb2(tree: &Tree<FsNode>) -> u64 {
    let fs_avail = 70_000_000;
    let required_size = 30_000_000;
    let total_size = directory_size(tree, tree.get(tree.root_node_id().unwrap()).unwrap());

    let least_to_free = required_size - (fs_avail - total_size);
    tree.traverse_level_order(tree.root_node_id().unwrap()).unwrap()
        .filter(|n| !n.children().is_empty())
        .map(|n| directory_size(tree, n))
        .filter(|s| s > &least_to_free)
        .min().unwrap()
}

fn main() -> color_eyre::Result<()> {
    color_eyre::install().unwrap();
 
    let lines = include_str!("input.txt");
    let t = get_tree(lines);
    println!("{}", pb1(&t));
    println!("{}", pb2(&t));
    Ok(())
}

#[test]
fn test_pb1() {
    let lines = include_str!("test.txt");
    let t = get_tree(lines);
    assert_eq!(95437, pb1(&t));
    assert_eq!(24933642, pb2(&t));
}