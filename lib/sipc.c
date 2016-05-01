/*
* @Author: Yinlong Su
* @Date:   2016-04-21 18:44:30
* @Last Modified by:   Yinlong Su
* @Last Modified time: 2016-04-30 21:17:29
*/

#include <inc/lib.h>

uint64_t sipc_recv(envid_t from, envid_t *from_env_store) {
    uint64_t r;

sipc_recv_dequeue:
    if ((r = sys_sipc_recv(from)) < 0) {
        return r;
    }

    if (thisenv->env_sipc_recving == 1)
        goto sipc_recv_dequeue;

    if (from_env_store != NULL)
        *from_env_store = thisenv->env_sipc_from;

    return thisenv->env_sipc_value;
}

uint64_t sipc_send(envid_t to, uint64_t value) {
    int r;

    r = sys_sipc_try_send(to, value);
    if (r != 0)
        return r;

    r = sys_sipc_try_send_2(to, value);
    return r;
}
