import numpy as np

# =========================================================
# Golden model for the 4x4 systolic array
#   1. make A and B, compute the correct answer C = A @ B
#   2. build the conveyor belts (what goes on A_in / B_in each tick)
#   3. write 3 files the Verilog testbench will read
# =========================================================

N     = 4            # 4x4 array
TICKS = 3*N - 2      # 10 ticks (latency from the spec)
SEED  = 1            # same seed = same test every run. change it for a new test
LOW, HIGH = 0, 10    # numbers 0..9 for now. later: -128, 128 for full int8

np.random.seed(SEED)
A = np.random.randint(LOW, HIGH, size=(N, N))
B = np.random.randint(LOW, HIGH, size=(N, N))
C = A @ B            # @ = matrix multiply (row . column)

print("A =\n", A)
print("B =\n", B)
print("C = A @ B =\n", C)

# ---------------------------------------------------------
# Conveyor belts
#   A: row r starts r ticks late, feeds A[r][0], A[r][1], ...
#   B: column c starts c ticks late, feeds B[0][c], B[1][c], ...
#   not started yet / already finished -> 0
# ---------------------------------------------------------
def a_belts(t):
    vals = []
    for r in range(N):
        k = t - r                 # how far along row r's belt is
        if 0 <= k <= N-1:
            vals.append(int(A[r][k]))
        else:
            vals.append(0)
    return vals

def b_belts(t):
    vals = []
    for c in range(N):
        k = t - c                 # how far along column c's belt is
        if 0 <= k <= N-1:
            vals.append(int(B[k][c]))  # note: going DOWN column c
        else:
            vals.append(0)
    return vals

# ---------------------------------------------------------
# Pack 4 numbers into one 32-bit word, the same order as A_in:
#   row 0 -> bits [7:0], row 1 -> [15:8], row 2 -> [23:16], row 3 -> [31:24]
# "& 0xFF" keeps 8 bits (so negative numbers become two's complement)
# ---------------------------------------------------------
def pack(vals):
    word = 0
    for i in range(N):
        word = word | ((int(vals[i]) & 0xFF) << (8*i))
    return word

# ---------------------------------------------------------
# Write the files (hex, one value per line, for $readmemh)
# ---------------------------------------------------------
print("\ntick | A_in (rows 0..3) | B_in (cols 0..3)")
with open("a_in.mem", "w") as fa, open("b_in.mem", "w") as fb:
    for t in range(TICKS):
        av = a_belts(t)
        bv = b_belts(t)
        print(f"{t:4} | {av} | {bv}")
        fa.write(f"{pack(av):08x}\n")
        fb.write(f"{pack(bv):08x}\n")

# expected answers, in acc_all order: acc #(r*4 + c)
with open("c_expected.mem", "w") as fc:
    for r in range(N):
        for c in range(N):
            fc.write(f"{int(C[r][c]) & 0xFFFFFFFF:08x}\n")

print("\nwrote a_in.mem, b_in.mem, c_expected.mem")
