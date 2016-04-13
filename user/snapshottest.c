/*
* @Author: Yinlong Su
* @Date:   2016-04-13 11:02:19
* @Last Modified by:   Yinlong Su
* @Last Modified time: 2016-04-13 13:52:07
*/

#include <inc/lib.h>

#include <inc/lib.h>
#include <inc/env.h>

void
umain(int argc, char **argv)
{
    envid_t who;
    char c;
    int i, j, r;
    struct EnvSnapshot *ess;

    cprintf("\033[0;34m  > Please input a number [0-9] for child environment: ");
    do {
        j = sys_cgetc();
    } while (j == 0 || j < 48 || j > 57);
    j -= 48;
    cprintf("%d\033[0m\n", j);

    // fork a child process
    who = fork();

    // print a message and yield to the other a few times
    if (who) {
        // parent
        for (i = 0; i < 10; i++) {
            cprintf("\033[0;32mIteration 0:%d I am the parent!\033[0m\n", i);
            if (i == 1) {
                cprintf("\033[0;34m  > Save snapshot on environment %08x\033[0m\n", who);

                // use our malloc function to malloc a EnvSnapshot data
                ess = (struct EnvSnapshot *)sys_b_malloc(sizeof(struct EnvSnapshot));
                if ((r = sys_env_save(who, ess)) < 0)
                    panic("sys_env_save: %e", r);
            } else if (i == 8) {
                cprintf("\033[0;34m  > Load snapshot on environment %08x\033[0m\n", who);
                if ((r = sys_env_load(who, ess)) < 0)
                    panic("sys_env_load: %e", r);
                // free the data
                sys_b_free(ess);
            }
            sys_yield();
        }
    }
    else {
        // child
        for (i = j; i < j + 25; i++) {
            cprintf("\033[0;33mIteration 1:%d I am the child!\033[0m\n", i);
            sys_yield();
        }
    }

}
