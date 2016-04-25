/*
* @Author: Yinlong Su
* @Date:   2016-04-21 18:44:30
* @Last Modified by:   Yinlong Su
* @Last Modified time: 2016-04-23 12:39:03
*/

#include <inc/lib.h>

uint64_t sipc_recv(envid_t from, envid_t *from_env_store) {
    int r;

    if ((r = sys_sipc_recv(from)) < 0) {
        return r;
    }
    //cprintf("sipc_recv after sys_sipc_recv r=%d value=%d from=%08x\n", r, thisenv->env_sipc_value, thisenv->env_sipc_from);
    if (from_env_store != NULL)
        *from_env_store = thisenv->env_sipc_from;

    return thisenv->env_sipc_value;
}

void sipc_send(envid_t to, uint64_t value) {
    int r;
    while ((r = sys_sipc_try_send(to, value)) == -E_IPC_NOT_RECV)
        sys_yield();
}
