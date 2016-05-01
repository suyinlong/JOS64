/*
* @Author: Yinlong Su
* @Date:   2016-04-30 21:01:34
* @Last Modified by:   Yinlong Su
* @Last Modified time: 2016-04-30 21:25:46
*/

// IPC test

// Test our two-phase sleep & wake-up IPC can handle the multiple environments
// send to one environment at the same time correctly
//
// Parent env forks 6 children and sends a number to each of them
// The children send back the number to the parent
// But parent only accepts 3 numbers
//
// We want to see 1. If the children sending request has been correctly queued
//                2. If the children can exit when the parent exits
//

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
    int i, k = 0, r;
    envid_t who, from;

    for (i = 0; i < 6; i++) {
        who = fork();
        if (who == 0)
            break;
        else {
            cprintf("\033[0;34mParent send %d to child %08x\033[0m\n", k, who);
            r = ipc_send(who, k, 0, 0);
        }
        k++;
    }
    if (who == 0) {
        r = ipc_recv(&from, 0, 0);
        cprintf("\033[0;32mChild %08x received %d from %08x, sending back...\033[0m\n", sys_getenvid(), r, from);
        r = ipc_send(from, k, 0, 0);
        cprintf("\033[0;32mChild %08x send %s\033[0m\n", sys_getenvid(), (r == 0) ? "\033[0;33msuccess" : "\033[0;31mfailed");
    } else {
        cprintf("\033[0;34mI'm parent and I only receive 3 numbers.\033[0m\n");
        for (i = 0; i < 3; i++) {

            r = ipc_recv(&from, 0, 0);
            cprintf("\033[0;34mParent received %d from %08x\033[0m\n", r, from);
        }
        cprintf("\033[0;34mNow I'm out.\033[0m\n");
    }


}
