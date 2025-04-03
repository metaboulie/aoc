// cargo run -- --path ./input.txt
use clap::Parser;
use regex::Regex;
use std::collections::HashMap;
use std::fs::File;
use std::io::{self, BufRead};
use std::path::Path;

#[derive(Parser, Debug)]
#[command(author, version, about, long_about = None)]
struct Args {
    #[arg(short, long, default_value = "./input.txt")]
    path: String,
}

#[derive(Debug)]
struct Vent {
    x1: i64,
    y1: i64,
    x2: i64,
    y2: i64,
}

impl Vent {
    fn points(&self) -> impl Iterator<Item = (i64, i64)> + '_ {
        let x_step = (self.x2 - self.x1).signum();
        let y_step = (self.y2 - self.y1).signum();
        let mut x = self.x1;
        let mut y = self.y1;

        std::iter::from_fn(move || {
            if x != self.x2 + x_step || y != self.y2 + y_step {
                let point = (x, y);
                x += x_step;
                y += y_step;
                Some(point)
            } else {
                None
            }
        })
    }
}

struct Grid {
    points: HashMap<(i64, i64), i64>,
}

impl Grid {
    fn new() -> Self {
        Self {
            points: HashMap::new(),
        }
    }

    fn add_vent(&mut self, vent: &Vent) {
        for point in vent.points() {
            *self.points.entry(point).or_insert(0) += 1;
        }
    }

    fn count_dangerous_points(&self) -> usize {
        self.points.values().filter(|&&count| count >= 2).count()
    }
}

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let args = Args::parse();
    let re = Regex::new(r"(\d+),(\d+) -> (\d+),(\d+)")?;
    let mut grid = Grid::new();

    for line in read_lines(&args.path)? {
        let line = line?;
        if let Some(cap) = re.captures(&line) {
            let vent = Vent {
                x1: cap[1].parse()?,
                y1: cap[2].parse()?,
                x2: cap[3].parse()?,
                y2: cap[4].parse()?,
            };
            grid.add_vent(&vent);
        }
    }

    println!(
        "Number of dangerous points: {}",
        grid.count_dangerous_points()
    );
    Ok(())
}

fn read_lines<P>(filename: P) -> io::Result<io::Lines<io::BufReader<File>>>
where
    P: AsRef<Path>,
{
    let file = File::open(filename)?;
    Ok(io::BufReader::new(file).lines())
}
