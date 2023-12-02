#[derive(Debug)]
struct PacketPair {
    left: String,
    right: String,
}

fn main() {
    dbg!(pb1(include_str!("input.txt")));
}

fn pb1(lines: &str) {
    let mut a = vec![];
    let mut t = vec![];
    for line in lines.lines() {
        if !line.is_empty() {
            t.push(line);
        }
        if t.len() == 2 {
            a.push(PacketPair {
                left: t[0].into(),
                right: t[1].into(),
            });
            t.clear();
        }
    }
    dbg!(a);
}

#[test]
fn test_pb1() {
    assert_eq!((), pb1(include_str!("test.txt")));
}
