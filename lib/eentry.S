#include <inc/mmu.h>
#include <inc/memlayout.h>
#include <kern/macro.h>

#define EXCEPTION_UPCALL(name, handler) \
.text;                                  \
    .globl name;                        \
    name:                               \
    movq  %rsp,%rdi;                    \
    movabs handler, %rax;               \
    call *%rax;                         \
    movq %rsp, %rax;                    \
    movq 0x88(%rsp), %rbx;              \
    movq 0x98(%rsp), %rsp;              \
    pushq %rbx;                         \
    movq %rsp, 0x98(%rax);              \
    movq %rax, %rsp;                    \
    addq $0x8, %rsp;                    \
    addq $0x8, %rsp;                    \
    POPA_;                              \
    addq $0x8, %rsp;                    \
    popfq;                              \
    popq %rsp;                          \
    ret

EXCEPTION_UPCALL(_exception_divide_upcall, _exception_divide_handler)
EXCEPTION_UPCALL(_exception_debug_upcall, _exception_debug_handler)
EXCEPTION_UPCALL(_exception_nmi_upcall, _exception_nmi_handler)
EXCEPTION_UPCALL(_exception_brkpt_upcall, _exception_brkpt_handler)
EXCEPTION_UPCALL(_exception_oflow_upcall, _exception_oflow_handler)
EXCEPTION_UPCALL(_exception_bound_upcall, _exception_bound_handler)
EXCEPTION_UPCALL(_exception_illop_upcall, _exception_illop_handler)
EXCEPTION_UPCALL(_exception_device_upcall, _exception_device_handler)
EXCEPTION_UPCALL(_exception_dblflt_upcall, _exception_dblflt_handler)
EXCEPTION_UPCALL(_exception_coproc_upcall, _exception_coproc_handler)
EXCEPTION_UPCALL(_exception_tss_upcall, _exception_tss_handler)
EXCEPTION_UPCALL(_exception_segnp_upcall, _exception_segnp_handler)
EXCEPTION_UPCALL(_exception_stack_upcall, _exception_stack_handler)
EXCEPTION_UPCALL(_exception_gpflt_upcall, _exception_gpflt_handler)
EXCEPTION_UPCALL(_exception_pgflt_upcall, _exception_pgflt_handler)
EXCEPTION_UPCALL(_exception_res_upcall, _exception_res_handler)
EXCEPTION_UPCALL(_exception_fperr_upcall, _exception_fperr_handler)
EXCEPTION_UPCALL(_exception_align_upcall, _exception_align_handler)
EXCEPTION_UPCALL(_exception_mchk_upcall, _exception_mchk_handler)
EXCEPTION_UPCALL(_exception_simderr_upcall, _exception_simderr_handler)
