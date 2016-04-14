/*
* @Author: Yinlong Su
* @Date:   2016-04-13 23:14:15
* @Last Modified by:   Yinlong Su
* @Last Modified time: 2016-04-13 23:36:00
*/

// print B

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
    int i = 0;
    for (i = 0; i < 5; i++) {
        cprintf("B\n");
        sys_yield();
    }
}
