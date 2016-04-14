/*
* @Author: Yinlong Su
* @Date:   2016-04-13 23:14:15
* @Last Modified by:   Yinlong Su
* @Last Modified time: 2016-04-13 23:36:07
*/

// print D

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
    int i = 0;
    for (i = 0; i < 5; i++) {
        cprintf("D\n");
        sys_yield();
    }
}
