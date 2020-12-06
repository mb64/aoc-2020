fn main() {
    let mut input: Vec<i32> = include_str!("input.txt")
        .lines()
        .map(|l| l.chars().fold(0, |x, c| 2 * x + (!(c as i32 >> 2) & 1)))
        .collect();

    input.sort();

    println!("part 1: {}", input[input.len() - 1]);

    let mut prev = input[0];
    for &i in &input[1..] {
        if i != prev + 1 {
            println!("part 2: {}", prev + 1);
        }
        prev = i;
    }
}
