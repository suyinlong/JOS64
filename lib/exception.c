/*
* @Author: Yinlong Su
* @Date:   2016-04-13 16:28:41
* @Last Modified by:   Yinlong Su
* @Last Modified time: 2016-05-01 12:24:52
*/

// User-level all exception handlers support.

#include <inc/lib.h>

typedef void (*eHandler)(struct UTrapframe *utf);

// Assembly language exception entrypoints defined in lib/eentry.S.
extern void _exception_divide_upcall(void);
extern void _exception_debug_upcall(void);
extern void _exception_nmi_upcall(void);
extern void _exception_brkpt_upcall(void);
extern void _exception_oflow_upcall(void);
extern void _exception_bound_upcall(void);
extern void _exception_illop_upcall(void);
extern void _exception_device_upcall(void);
extern void _exception_dblflt_upcall(void);
extern void _exception_coproc_upcall(void);
extern void _exception_tss_upcall(void);
extern void _exception_segnp_upcall(void);
extern void _exception_stack_upcall(void);
extern void _exception_gpflt_upcall(void);
extern void _exception_pgflt_upcall(void);
extern void _exception_res_upcall(void);
extern void _exception_fperr_upcall(void);
extern void _exception_align_upcall(void);
extern void _exception_mchk_upcall(void);
extern void _exception_simderr_upcall(void);

// Pointers to currently installed C-language exception handlers.
eHandler _exception_divide_handler;
eHandler _exception_debug_handler;
eHandler _exception_nmi_handler;
eHandler _exception_brkpt_handler;
eHandler _exception_oflow_handler;
eHandler _exception_bound_handler;
eHandler _exception_illop_handler;
eHandler _exception_device_handler;
eHandler _exception_dblflt_handler;
eHandler _exception_coproc_handler;
eHandler _exception_tss_handler;
eHandler _exception_segnp_handler;
eHandler _exception_stack_handler;
eHandler _exception_gpflt_handler;
eHandler _exception_pgflt_handler;
eHandler _exception_res_handler;
eHandler _exception_fperr_handler;
eHandler _exception_align_handler;
eHandler _exception_mchk_handler;
eHandler _exception_simderr_handler;

void set_exception_handler(int trapno, eHandler handler) {
    if (trapno < 0 || trapno > 20)
        return;

    uint64_t addr_upcall = 0, addr_handler = 0;

    switch (trapno) {
        case T_DIVIDE:
            addr_upcall = (uint64_t)_exception_divide_upcall;
            addr_handler = (uint64_t)&_exception_divide_handler;
            break;
        case T_DEBUG:
            addr_upcall = (uint64_t)_exception_debug_upcall;
            addr_handler = (uint64_t)&_exception_debug_handler;
            break;
        case T_NMI:
            addr_upcall = (uint64_t)_exception_nmi_upcall;
            addr_handler = (uint64_t)&_exception_nmi_handler;
            break;
        case T_BRKPT:
            addr_upcall = (uint64_t)_exception_brkpt_upcall;
            addr_handler = (uint64_t)&_exception_brkpt_handler;
            break;
        case T_OFLOW:
            addr_upcall = (uint64_t)_exception_oflow_upcall;
            addr_handler = (uint64_t)&_exception_oflow_handler;
            break;
        case T_BOUND:
            addr_upcall = (uint64_t)_exception_bound_upcall;
            addr_handler = (uint64_t)&_exception_bound_handler;
            break;
        case T_ILLOP:
            addr_upcall = (uint64_t)_exception_illop_upcall;
            addr_handler = (uint64_t)&_exception_illop_handler;
            break;
        case T_DEVICE:
            addr_upcall = (uint64_t)_exception_device_upcall;
            addr_handler = (uint64_t)&_exception_device_handler;
            break;
        case T_DBLFLT:
            addr_upcall = (uint64_t)_exception_dblflt_upcall;
            addr_handler = (uint64_t)&_exception_dblflt_handler;
            break;
        //case T_COPROC:
            //addr_upcall = (uint64_t)_exception_coproc_upcall;
            //addr_handler = (uint64_t)&_exception_coproc_handler;
            //break;
        case T_TSS:
            addr_upcall = (uint64_t)_exception_tss_upcall;
            addr_handler = (uint64_t)&_exception_tss_handler;
            break;
        case T_SEGNP:
            addr_upcall = (uint64_t)_exception_segnp_upcall;
            addr_handler = (uint64_t)&_exception_segnp_handler;
            break;
        case T_STACK:
            addr_upcall = (uint64_t)_exception_stack_upcall;
            addr_handler = (uint64_t)&_exception_stack_handler;
            break;
        case T_GPFLT:
            addr_upcall = (uint64_t)_exception_gpflt_upcall;
            addr_handler = (uint64_t)&_exception_gpflt_handler;
            break;
        case T_PGFLT:
            addr_upcall = (uint64_t)_exception_pgflt_upcall;
            addr_handler = (uint64_t)&_exception_pgflt_handler;
            break;
        //case T_RES:
            //addr_upcall = (uint64_t)_exception_res_upcall;
            //addr_handler = (uint64_t)&_exception_res_handler;
            //break;
        case T_FPERR:
            addr_upcall = (uint64_t)_exception_fperr_upcall;
            addr_handler = (uint64_t)&_exception_fperr_handler;
            break;
        case T_ALIGN:
            addr_upcall = (uint64_t)_exception_align_upcall;
            addr_handler = (uint64_t)&_exception_align_handler;
            break;
        case T_MCHK:
            addr_upcall = (uint64_t)_exception_mchk_upcall;
            addr_handler = (uint64_t)&_exception_mchk_handler;
            break;
        case T_SIMDERR:
            addr_upcall = (uint64_t)_exception_simderr_upcall;
            addr_handler = (uint64_t)&_exception_simderr_handler;
            break;
    }

    eHandler *ptr_handler = (eHandler *)addr_handler;
    if (*ptr_handler == 0) {
        // First time through!
        if (sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W) == 0)
            sys_env_set_exception_upcall(0, trapno, (void *)addr_upcall);
    }

    //Save handler pointer for assembly to call.
    *ptr_handler = handler;
}
