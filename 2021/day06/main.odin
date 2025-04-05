package main

import "core:fmt"
import "core:os"
import "core:strings"
import "core:strconv"

Timer :: [9]u64

initial_timer :: proc(filepath: string) -> (Timer, bool) {
    data, ok := os.read_entire_file(filepath, context.allocator)
    if !ok {
        fmt.println("Error reading file")
        return {}, false
    }
    defer delete(data, context.allocator)

    initial := Timer{}
    it := strings.split(strings.trim_space(string(data)), ",")
    for fish in it {
        if timer, ok := strconv.parse_int(fish); ok && timer >= 0 && timer <= 6 {
            initial[timer] += 1
        }
    }
    return initial, true
}

iterate :: proc(initial: Timer, n_iter: int) -> Timer {
    timer := initial
    for _ in 1..=n_iter {
        new_timer := Timer{}
        for i in 0..<8 {
            new_timer[i] = timer[i + 1]
        }
        new_timer[6] += timer[0]
        new_timer[8] = timer[0]
        timer = new_timer
    }
    return timer
}

sum_timer :: proc(timer: Timer) -> u64 {
    sum: u64 = 0
    for count in timer {
        sum += count
    }
    return sum
}

main :: proc() {
    initial, ok := initial_timer("./input.txt")
    if !ok {
        fmt.println("Failed to initialize timer")
        return
    }
    
    fmt.println("Part 1:", sum_timer(iterate(initial, 80)))
    fmt.println("Part 2:", sum_timer(iterate(initial, 256)))
}
