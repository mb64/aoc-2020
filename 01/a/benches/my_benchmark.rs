use a::{hm, somebody};
use criterion::{black_box, criterion_group, criterion_main, Criterion};

fn input() -> Vec<i32> {
    include_str!("input.txt")
        .lines()
        .map(|l| l.parse())
        .collect::<Result<_, _>>()
        .unwrap()
}

pub fn criterion_benchmark(c: &mut Criterion) {
    let vals = input();
    c.bench_function("hash table", |b| b.iter(|| hm(black_box(&vals[..]))));
    c.bench_function("somebody", |b| b.iter(|| somebody(black_box(&vals[..]))));
}

criterion_group!(benches, criterion_benchmark);
criterion_main!(benches);
