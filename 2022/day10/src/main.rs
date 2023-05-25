use std::{collections::HashMap};
use int_enum::IntEnum;

fn main() {
    dbg!(pb1(include_str!("input.txt")));
}

#[derive(Debug)]
struct ClockCircuit {
    cycle: u64,
    register: i64,
    registers_history: HashMap<u64, i64>,
}

#[repr(u8)]
#[derive(Clone, Copy, Debug, Eq, PartialEq, IntEnum)]
enum InstructionType {
    Addx = 2,
    Noop = 1,
}

#[derive(Debug, Clone, Copy)]
struct Instruction {
    instruction_type: InstructionType,
    argument: i64,
}

impl ClockCircuit {
    fn new() -> Self {
        let registers_history = HashMap::new();
        Self { cycle: 1, register: 1, registers_history }
    }

    fn run(&mut self, mut instructions: Vec<Instruction>) {
        self.cycle = 1;
        let mut current_instruction_finishes_at = 0;
        let mut current_instruction: Option<Instruction> = None;

        let mut crt_row = "".to_string();
        let mut finish = false;
        while !finish {
            // Start of cycle, if no current operation, take one
            if current_instruction.is_none() {
                match instructions.pop() {
                    Some(instruction) => {
                        // println!("Current instruction is now {:?} with argument {}", instruction.instruction_type, instruction.argument);
                        current_instruction_finishes_at = self.cycle + instruction.instruction_type.int_value() as u64;        
                        current_instruction = Some(instruction);
                    },
                    None => {
                        finish = true;
                    },
                }
            }
            self.registers_history.insert(self.cycle, self.register);
            {
                // Do printing
                let sprite_pos = self.register;
                let crt_pixel = (self.cycle as i64 -1) % 40;
                if [sprite_pos-1, sprite_pos, sprite_pos+1].contains(&crt_pixel) {
                    crt_row += "#";
                } else {
                    crt_row += ".";
                }
                if &self.cycle % 40 == 0 {
                    println!("{crt_row}");
                    crt_row = "".to_string();
                }
            }
            self.cycle += 1;
            // End of cycle
            // check if operation is supposed to finish
            if current_instruction_finishes_at == self.cycle {
                // println!("Finishing {:?} with argument {}", current_instruction.unwrap().instruction_type, current_instruction.unwrap().argument);
                match current_instruction {
                    Some(instruction) => {
                        match instruction.instruction_type {
                            InstructionType::Addx => {
                                self.register += instruction.argument;
                            }
                            InstructionType::Noop => {},
                        }    
                    },
                    None => todo!(),
                }
                current_instruction_finishes_at = 0;
                current_instruction = None;
            }
        }
    }
}

fn pb1(lines: &str) -> i64 {
    let mut instructions:Vec<Instruction> = vec![];
    let mut circuit = ClockCircuit::new();
    for line in lines.lines() {
        if line.starts_with("addx") {
            let ops: Vec<&str> = line.split(' ').collect();
            let arg = ops.last().unwrap().parse::<i64>().unwrap();
            instructions.push(Instruction {
                instruction_type: InstructionType::Addx,
                argument: arg,
            });
        } else {
            instructions.push(Instruction {
                instruction_type: InstructionType::Noop,
                argument: 0,
            });
        }
    }
    // dbg!(&circuit);
    instructions.reverse();
    circuit.run(instructions);
    println!();
    // dbg!(&circuit);
    [20,60,100,140,180,220].map(|i| {
        (i, *circuit.registers_history.get(&i).unwrap())
    }).iter().fold(0, |acc, (i, r)| {
        acc + *i as i64 * *r
    })
}

#[test]
fn test_pb1() {
    assert_eq!(13140, pb1(include_str!("test.txt")));
}