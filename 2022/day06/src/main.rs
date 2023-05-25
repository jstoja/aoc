use itertools::Itertools;

fn find_start_seq(datastream: &str, seq_len: usize) -> Option<usize> {
    for i in 0.. {
        if datastream.chars().skip(i).take(seq_len).into_iter().unique().count() == seq_len {
            return Some(i+seq_len)
        }
    }
    None
}

// fn find_start_seq2(datastream: &str) -> usize {
//     let mut res = 0;
//     for i in 0..(datastream.len()-14) {
//         let mut tmp_chars = vec![];
//         for c in datastream[i..i+1+14].chars() {
//             if tmp_chars.len() >= 14 {
//                 return res+tmp_chars.len()
//             } else if tmp_chars.contains(&c) {
//                 break
//             } else {
//                 tmp_chars.push(c);
//             }
//         }
//         res += 1;
//     }
//     res
// }


fn main() {
    let _input = include_str!("input.txt");
    for line in _input.lines() {
        println!("{:?}", find_start_seq(line, 4));
        println!("{:?}", find_start_seq(line, 14));
    }
}

#[test]
fn test_start_seqs() {
    let cases = vec![
        ("mjqjpqmgbljsphdztnvjfqwrcgsmlb", 7, 19),
        ("bvwbjplbgvbhsrlpgdmjqwftvncz", 5, 23),
        ("nppdvjthqldpwncqszvftbrmjlhg", 6, 23),
        ("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg", 10, 29),
        ("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw", 11, 26),
    ];
    for (input, solution1, solution2) in cases {
        assert_eq!(Some(solution1), find_start_seq(input, 4));
        assert_eq!(Some(solution2), find_start_seq(input, 14));

    }
}