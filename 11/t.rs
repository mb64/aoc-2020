fn step(bs: &Vec<Vec<u8>>, bs1: &mut Vec<Vec<u8>>) -> bool {
    let mut edits = 0;
    let width = bs[0].len() as isize;
    for (i, j) in (0isize..bs.len() as isize)
        .map(|i| (0isize..width).map(move |j| (i, j)))
        .flatten()
    {
        let mut ct = 0;
        for (a, b) in (-1isize..=1)
            .map(|a| (-1isize..=1).map(move |b| (a, b)))
            .flatten()
        {
            if a == 0 && b == 0 {
                continue;
            }
            let mut x = i + a;
            let mut y = j + b;
            loop {
                if x >= bs.len() as isize {
                    break;
                }
                if y >= bs[0].len() as isize {
                    break;
                }
                if x < 0 {
                    break;
                }
                if y < 0 {
                    break;
                }
                match bs[x as usize][y as usize] {
                    b'.' => {
                        x += a;
                        y += b;
                    }
                    b'#' => {
                        ct += 1;
                        break;
                    }
                    b'L' => {
                        break;
                    }
                    _ => panic!(),
                }
            }
        }

        bs1[i as usize][j as usize] = bs[i as usize][j as usize];
        if bs[i as usize][j as usize] == b'#' {
            if ct >= 5 {
                bs1[i as usize][j as usize] = b'L';
                edits += 1;
            }
        } else if bs[i as usize][j as usize] == b'L' {
            if ct == 0 {
                bs1[i as usize][j as usize] = b'#';
                edits += 1;
            }
        }
    }

    println!("edits: {}", edits);
    return edits > 0;
}

fn main() {
    let mut bs: Vec<Vec<u8>> = include_str!("input.txt")
        .lines()
        .map(|l| l.as_bytes().to_vec())
        .collect();
    let mut bs1 = bs.clone();

    let mut n = 0;
    loop {
        let did_edit = step(&bs, &mut bs1);
        if !did_edit {
            break;
        }
        println!("{}", n);
        n += 1;
        let t = bs;
        bs = bs1;
        bs1 = t;
    }

    let mut ct = 0;
    for r in &bs {
        for &b in r {
            if b == b'#' {
                ct += 1;
            }
        }
    }
    println!("{}", ct);
}
