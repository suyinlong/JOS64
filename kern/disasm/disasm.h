
#define DISASM_MAH_BUFFER 16
#define DISASM_ASM_BUFFER 128

#define DISASM_ERR_INVALIDCMD "\033[0;31mDisassembler disabled: not in a debug environment.\033[0m\n"

int disasm_s(int argc, char **argv, struct Trapframe *tf);
int disasm_c(int argc, char **argv, struct Trapframe *tf);