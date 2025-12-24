from enum import IntEnum

# ---------------------- User-defined variables ----------------------
ASSEMBLY_FILE_NAME = "fibonacci.txt"
ASSEMBLY_FILE_PATH = "./Assembly/" + ASSEMBLY_FILE_NAME
EXECUTABLE_FILE_PATH = "./instructions.mem"
# ---------------------- End of user-defined variables ----------------------

class INSTRUCTIONS(IntEnum):
    NOP = 0
    ADD = 1
    SUB = 2
    AND = 3
    OR = 4
    NOT = 5
    MOV = 6
    LD = 7
    ST = 8
    CMP = 9
    BEQ = 10
    BNE = 11
    JMP = 12
    JR = 13
    # RET = 14
    SLT = 15

class INSTRUCTION_TYPES(IntEnum):
    I_TYPE = 1
    J_TYPE = 2

INSTRUCTION_STR_TO_ENUM = {inst.name: inst for inst in INSTRUCTIONS}
INSTRUCTIONS_ENUM_TO_STR = {inst: inst.name for inst in INSTRUCTIONS}
symbol_table = {}

def get_opcode_type(opcode):
    if opcode in {INSTRUCTIONS.ADD, INSTRUCTIONS.SUB, INSTRUCTIONS.AND, INSTRUCTIONS.OR,
                  INSTRUCTIONS.NOT, INSTRUCTIONS.CMP, INSTRUCTIONS.SLT, INSTRUCTIONS.JR,
                  INSTRUCTIONS.LD, INSTRUCTIONS.ST}:
        return INSTRUCTION_TYPES.R_TYPE
    elif opcode == INSTRUCTIONS.MOV:
        return INSTRUCTION_TYPES.I_TYPE
    elif opcode in {INSTRUCTIONS.JMP, INSTRUCTIONS.NOP,
                    INSTRUCTIONS.BEQ, INSTRUCTIONS.BNE}:
        return INSTRUCTION_TYPES.J_TYPE
    
def get_register_number(register_str):
    register_str = register_str.upper()
    if register_str.startswith("R"):
        return int(register_str[1:])
    elif register_str == "ZERO":
        return 0
    elif register_str == "SP":
        return 13
    elif register_str == "GP":
        return 14
    elif register_str == "PC":
        return 15
    raise ValueError(f"Invalid register format: {register_str}")

def is_integer(s):
    try:
        int(s)
        return True
    except ValueError:
        return False

def parse_operand(operand_str):
    operand_str = operand_str.strip().upper()
    if operand_str.startswith("#"):
        return int(operand_str[1:], 0)
    elif (operand_str.startswith("R") and is_integer(operand_str[1:])) or operand_str in {"ZERO", "SP", "GP", "PC"}:
        return get_register_number(operand_str)
    elif operand_str in symbol_table:
        value = symbol_table[operand_str]
        assert value < 0xFFF, "Label address exceeds 12 bits"
        return value
    else:
        raise ValueError(f"Invalid operand format: {operand_str}")

def encode_instruction(opcode, opcode_type, instruction_parts):
    if opcode_type == INSTRUCTION_TYPES.R_TYPE:
        if opcode in {INSTRUCTIONS.CMP, INSTRUCTIONS.JR}:
            instruction_parts.insert(1, "ZERO")
        if opcode in  {INSTRUCTIONS.JR, INSTRUCTIONS.NOT, INSTRUCTIONS.LD, INSTRUCTIONS.ST}:
            instruction_parts.insert(2, "ZERO")
        dest, src1, src2 = map(parse_operand, instruction_parts[1:])
        machine_code = (opcode << 12) | (dest << 8) | (src1 << 4) | src2
    elif opcode_type == INSTRUCTION_TYPES.I_TYPE:
        dest = parse_operand(instruction_parts[1])
        imm = parse_operand(instruction_parts[2])
        machine_code = (opcode << 12) | (dest << 8) | (imm & 0xFF)
    else:
        imm = parse_operand(instruction_parts[1]) if len(instruction_parts) > 1 else 0
        machine_code = (opcode << 12) | (imm & 0xFFF)
    return f"{machine_code:04X}"

def push(reg):
    return [
        f"ST {reg}, SP",  
        "MOV R1, #1",
        "SUB SP, SP, R1"
    ]

def pop(reg):
    return [
        f"LD {reg}, SP",
        "MOV R1, #1",
        "ADD SP, SP, R1"
    ]

def expand_pseudo_instructions(lines):
    expanded_lines = []
    for line in lines:
        line = line.strip()
        if not line or line.startswith("#") or line.isspace():
            continue

        parts = line.upper().replace(",", "").split()
        op = parts[0]

        # Pseudo: CALL <label>
        if op == "CALL":
            label = parts[1]
            expanded_lines += [
                "MOV R1, #5",
                "ADD GP, PC, R1"
            ]
            expanded_lines += push("GP")
            expanded_lines += [
                f"JMP {label}"
            ]

        # Pseudo: RET
        elif op == "RET":
            expanded_lines += pop("GP")
            expanded_lines += [
                "JR GP"
            ]

        elif op == "PUSH":
            expanded_lines += push(parts[1])

        elif op == "POP":
            expanded_lines += pop(parts[1])
        
        else:
            expanded_lines.append(line)
    
    return expanded_lines

def assemble():
    print("Reading assembly file: ", ASSEMBLY_FILE_PATH)
    with open(ASSEMBLY_FILE_PATH, "r") as assembly_file:
        assembly_instructions = assembly_file.readlines()

    expanded_instructions = expand_pseudo_instructions(assembly_instructions)
    
    instruction_address = 0
    clean_lines = []
    for line in expanded_instructions:
        if not line or line.startswith("#") or line.isspace():
            continue

        line = line.strip()
        if ":" in line:
            label, *rest = line.split(":")
            label = label.strip().upper()
            symbol_table[label] = instruction_address
            if rest and rest[0].strip():
                line = rest[0].strip()
            else:
                continue
        clean_lines.append(line)
        instruction_address += 1

    machine_code_instructions = [f"{len(clean_lines):04X}"]
    for instruction in clean_lines:
        instruction = instruction.strip()
        if not instruction or instruction.startswith("#"):
            continue

        instruction = instruction.upper().replace(",", "")
        instruction_parts = instruction.split()
        instruction_operation = instruction_parts[0]

        if instruction_operation not in INSTRUCTION_STR_TO_ENUM:
            raise ValueError(f"Unknown instruction: {instruction_operation}")

        opcode_enum = INSTRUCTION_STR_TO_ENUM[instruction_operation]
        opcode_type = get_opcode_type(opcode_enum)

        machine_code = encode_instruction(opcode_enum, opcode_type, instruction_parts)
        machine_code_instructions.append(machine_code)

    print("Writing executable file: ", EXECUTABLE_FILE_PATH)
    with open(EXECUTABLE_FILE_PATH, "w") as executable_file:
        for code in machine_code_instructions:
            executable_file.write(code + "\n")

    print("Assembly completed successfully!")

if __name__ == "__main__":
    assemble()
