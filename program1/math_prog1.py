def int_to_float(int_in):

    float_M = 0

    # Extract sign bit (MSB)
    sign = (int_in >> 15) & 0x1 # keep sign 1-bit

    # Get absolute value of int_in
    if sign:
        half = (~int_in + 1) & 0xFFFF  # Two's complement and keep it 16-bit
    else:
        half = int_in

    # Special case: zero or pure sign bit
    if (int_in & 0x7FFF) == 0:
        exp_biased = 22 if sign else 0  # 22 is used as bias for -0
        exp_biased <<= 10               # shift to position bits 14-10
        float_M = (sign << 15) | exp_biased  # sign + exp (mantissa = 0)
        return float_M

    # Normal conversion
    exp_unb = 21
    while exp_unb > 6 and (half & 0x4000) == 0:
        half <<= 1
        half &= 0xFFFF  # keep it 16-bit
        exp_unb -= 1

    exp_biased = exp_unb << 10  # shift exponent into bits 14-10

    # Compose float value
    float_M = (sign << 15) | exp_biased

    # Align mantissa
    if exp_unb < 16:            # all low 8-bit are mantissa
        mantissa = half >> (21-exp_unb)
    else:
        mantissa = half >> 4    # bits after first 1 are mantissa
        
    float_M |= mantissa & 0x3FF  # keep mantissa 10 bits

    return float_M



print(format(int_to_float(0x743C), '016b'))  # 01110100_00111100
print(format(int_to_float(0x34DC), '016b'))  # 00110100_11011100
print(format(int_to_float(0x14CA), '016b'))  # 00010100_11001010
print(format(int_to_float(0xF12E), '016b'))  # 11110001_00101110
print(format(int_to_float(0x8001), '016b'))  # 10000000_00000001
print(format(int_to_float(0xFFFA), '016b'))  # 11111111_11111010
print(format(int_to_float(0x0000), '016b'))  # 00000000_00000000
print(format(int_to_float(0xFFFF), '016b'))  # 11111111_11111111
print(format(int_to_float(0x7FFF), '016b'))  # 01111111_11111111
print(format(int_to_float(0x8000), '016b'))  # 10000000_00000000

