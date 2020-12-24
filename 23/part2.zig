const std = @import("std");

const SIZE = 1_000_000;
const ITERS = 10_000_000;

var next: [SIZE]u32 = undefined;

fn init(input: []const u8) u32 {
    const first: u32 = input[0] - '1';
    var prev = first;
    for (input[1..]) |c| {
        next[prev] = c - '1';
        prev = c - '1';
    }
    var i = @intCast(u32, input.len);
    while (i < SIZE) : (i += 1) {
        next[prev] = i;
        prev = i;
    }
    next[prev] = first;
    return first;
}

fn part2(input: []const u8) u64 {
    var current = init(input);

    var i: usize = 0;
    while (i < ITERS) : (i += 1) {
        const a = next[current];
        const b = next[a];
        const c = next[b];
        var dest = if (current == 0) SIZE - 1 else current - 1;
        while (dest == a or dest == b or dest == c) {
            dest = if (dest == 0) SIZE - 1 else dest - 1;
        }
        next[current] = next[c];
        next[c] = next[dest];
        next[dest] = a;

        current = next[current];
    }

    return @as(u64, next[0] + 1) * (next[next[0]] + 1);
}

pub fn main() void {
    var input: []const u8 = undefined;
    if (std.os.argv.len == 2) {
        input = std.mem.span(@ptrCast([*:0]const u8, std.os.argv[1]));
    } else if (std.os.argv.len < 2) {
        input = "784235916";
    } else {
        const prog_name = std.mem.span(std.os.argv[0]);
        std.debug.print("Usage: {} [INPUT]\n", .{prog_name});
        std.process.exit(1);
    }
    std.debug.print("part 2: {}\n", .{part2(input)});
}
