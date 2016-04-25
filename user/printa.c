/*
* @Author: Yinlong Su
* @Date:   2016-04-13 23:13:40
* @Last Modified by:   Yinlong Su
* @Last Modified time: 2016-04-13 23:35:53
*/

// print A

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
    int i = 0;
    for (i = 0; i < 5; i++) {
        cprintf("A\n");
        sys_yield();
    }
}
