use std::collections::HashSet;
use std::time::Instant;

// fn main() {
//     let vals: Vec<i32> = include_str!("input.txt")
//         .lines()
//         .map(|l| l.parse())
//         .collect::<Result<_, _>>()
//         .unwrap();

//     let now = Instant::now();
//     println!(
//         "result: {}",
//         (0..100).map(|_| somebody(&vals[..])).sum::<i64>()
//     );
//     println!("{:?} (somebody)", now.elapsed());

//     let now = Instant::now();
//     println!("result: {}", (0..100).map(|_| hm(&vals[..])).sum::<i64>());
//     println!("{:?} (hm)", now.elapsed());
// }

pub fn somebody(vals: &[i32]) -> i64 {
    for i in 0..vals.len() - 2 {
        let x = vals[i];
        for j in i + 1..vals.len() - 1 {
            let y = vals[j];
            if x + y >= 2020 {
                continue;
            }
            if vals[j + 1..].contains(&(2020 - x - y)) {
                return (x as i64) * (y as i64) * ((2020 - x - y) as i64);
            }
        }
    }
    panic!()
}

pub fn hm(vals: &[i32]) -> i64 {
    let hs: HashSet<i32> = vals.iter().copied().collect();

    for i in 0..vals.len() - 2 {
        let x = vals[i];
        for j in i + 1..vals.len() - 1 {
            let y = vals[j];
            if x + y >= 2020 {
                continue;
            }
            if hs.contains(&(2020 - x - y)) {
                return (x as i64) * (y as i64) * ((2020 - x - y) as i64);
            }
        }
    }
    panic!()
}
