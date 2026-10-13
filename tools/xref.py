import struct, os, sys
from capstone import Cs, CS_ARCH_ARM64, CS_MODE_LITTLE_ENDIAN
from capstone.arm64 import ARM64_OP_IMM, ARM64_OP_REG

d = open(os.path.expanduser('~/apk_out/libyuanshen.so'), 'rb').read()
TEXT_OFF = 0x4304420
TEXT_SIZE = 0x378eb30

# all string VAs of interest
strs = {}
for o in [4823337, 5482976, 5703256]:
    strs[o] = 'global-metadata.dat'
strs[5003722] = 'startup-metadata.dat'
# also compute VA of each (VA==off for these sections)
want = {va: n for va, n in strs.items()}

md = Cs(CS_ARCH_ARM64, CS_MODE_LITTLE_ENDIAN)
md.detail = True

hits = []
end = TEXT_OFF + TEXT_SIZE
CH = 1 << 20
for base in range(TEXT_OFF, end, CH):
    chunk = d[base:min(base+CH, end)]
    regs = {}
    for insn in md.disasm(chunk, base):
        m = insn.mnemonic
        ops = insn.operands
        if m == 'adrp' and len(ops) >= 2 and ops[1].type == ARM64_OP_IMM:
            regs[insn.reg_name(ops[0].reg)] = ops[1].imm
        elif m == 'add' and len(ops) == 3 and ops[2].type == ARM64_OP_IMM and ops[0].type == ARM64_OP_REG and ops[1].type == ARM64_OP_REG:
            r0 = insn.reg_name(ops[0].reg); r1 = insn.reg_name(ops[1].reg)
            if regs.get(r1) is not None:
                t = regs[r1] + ops[2].imm
                if t in want:
                    hits.append((insn.address, want[t]))
            regs[r0] = None
        elif m in ('ldr', 'mov', 'movz', 'movk') and len(ops) >= 1 and ops[0].type == ARM64_OP_REG:
            regs[insn.reg_name(ops[0].reg)] = None
    if hits:
        break
print("hits:", len(hits))
for a, n in hits[:40]:
    print(f"  code_va={a:#x} -> {n}")
