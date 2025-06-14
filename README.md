# N-bit Unsigned Multiplier in Verilog

A parameterizable hardware multiplier that can handle multiplication of two N-bit unsigned binary numbers, generating a 2N-bit product. Built using array multiplier architecture with ripple carry adders. Automatically scales its hardware resources based on the bit width parameter, uses right number of gates/adders. 

## Overview

This project implements a generalized unsigned multiplier using Verilog HDL that can be configured for any operand size at synthesis time. The design uses partial product generation followed by sequential addition using ripple carry adders (RCAs).

## Architecture

### Design Approach
The multiplier uses the **array multiplier** method:
1. **Partial Product Generation**: Create N×N partial products using AND gates
2. **Sequential Addition**: Add partial products row by row using RCAs
3. **Result Formation**: Final sum represents the 2N-bit multiplication result

### Key Components

#### 1. Full Adder Module
```verilog
module fulladder(input a, input b, input cin, output s, output cout);
    // Basic building block for addition operations
endmodule
```

#### 2. N-bit Ripple Carry Adder
```verilog
module RCA_n #(parameter n=16)(input [n-1:0]a, input [n-1:0] b, output [n-1:0]sum);
    // Parameterizable adder using generate loops
endmodule
```

#### 3. Main Multiplier Module
```verilog
module N_bit_mul #(parameter N=8) (input[N-1:0] op1,op2, output[2*N-1:0] res);
    // Handles special case for N=1
    // Generates partial products for N>1
    // Sequentially adds partial products using RCAs
endmodule
```

## How It Works

### Step 1: Partial Product Generation
For N-bit operands, create N×N partial products:
```
For each bit i in op1 and bit j in op2:
    p[i][j] = op1[i] & op2[j]
```

### Step 2: Partial Product Addition
Add partial products using weighted positions:
- First addition: `p[0]` + `p[1]` (shifted left by 1)
- Subsequent additions: Previous sum + `p[i]` (shifted left by i)

### Step 3: Result Output
The final sum from the last RCA represents the complete 2N-bit product.

## Module Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `N` | Bit width of input operands | 8 |

**Input/Output Specifications:**
- `op1[N-1:0]`: First N-bit unsigned operand
- `op2[N-1:0]`: Second N-bit unsigned operand  
- `res[2*N-1:0]`: Resulting 2N-bit unsigned product

## Usage Examples

### 4-bit Multiplication
```verilog
N_bit_mul #(.N(4)) mult4 (
    .op1(4'b1010),  // 10 in decimal
    .op2(4'b0011),  // 3 in decimal
    .res(result)    // 8-bit result = 30
);
```

### 16-bit Multiplication
```verilog
N_bit_mul #(.N(16)) mult16 (
    .op1(multiplicand),
    .op2(multiplier),
    .res(product)   // 32-bit result
);
```

## Testing and Validation

### Test Environment
The design includes comprehensive testing infrastructure:

**Files:**
- `bonus.v`: Main multiplier implementation
- `tb_bonus.v`: Testbench for validation
- `test_bonus.sh`: Automated testing script

### Running Tests
```bash
# Make the test script executable
chmod +x test_bonus.sh

# Run tests with your testbench
./test_bonus.sh tb_bonus.v
```

### Test Coverage
The testbench validates:
- Various operand sizes (1-bit to 32-bit)
- Edge cases (all zeros, all ones, maximum values)
- Random test vectors
- Arithmetic correctness verification

## Implementation Details

### Resource Requirements
For N-bit multiplication:
- **Partial Products**: N² AND gates
- **Adders**: (N-1) RCA modules of width 2N
- **Total Gates**: Approximately N² + N×(2N) logic elements

### Timing Characteristics
- **Combinational Design**: Pure combinational logic
- **Propagation Delay**: Proportional to N (due to ripple carry)
- **Critical Path**: Through all RCA stages

NOTE : Other multipliers like Wallace tree multiplier, Booth multiplier, Dadda Multiplier run faster and are space efficient (industrial level) and the implementation here does not exploit parallelism.

## File Structure

```
n-bit-multiplier/
├── src/
│   └── n-bit_multiplier.v           # Main multiplier implementation
├── tb/
│   ├── tb.v        # Testbench
│   └── test.sh     # Test automation script
README.md             # This file
```

This implementation provides a solid foundation for understanding multiplication in digital hardware.
