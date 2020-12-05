use a::*;
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
    c.bench_function("O(n³)", |b| b.iter(|| lin_2(black_box(&vals[..]))));
    c.bench_function("O(n³) early continue", |b| {
        b.iter(|| lin(black_box(&vals[..])))
    });
    c.bench_function("O(n²)", |b| b.iter(|| hm_2(black_box(&vals[..]))));
    c.bench_function("O(n²) early continue", |b| {
        b.iter(|| hm(black_box(&vals[..])))
    });
}

criterion_group!(benches, criterion_benchmark);
criterion_main!(benches);
