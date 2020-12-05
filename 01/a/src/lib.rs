use std::collections::HashSet;

pub fn lin(vals: &[i32]) -> i64 {
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

pub fn lin_2(vals: &[i32]) -> i64 {
    for i in 0..vals.len() - 2 {
        let x = vals[i];
        for j in i + 1..vals.len() - 1 {
            let y = vals[j];
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

pub fn hm_2(vals: &[i32]) -> i64 {
    let hs: HashSet<i32> = vals.iter().copied().collect();

    for i in 0..vals.len() - 2 {
        let x = vals[i];
        for j in i + 1..vals.len() - 1 {
            let y = vals[j];
            if hs.contains(&(2020 - x - y)) {
                return (x as i64) * (y as i64) * ((2020 - x - y) as i64);
            }
        }
    }
    panic!()
}
