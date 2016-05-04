/*
* @Author: Yinlong Su
* @Date:   2016-05-04 17:30:41
* @Last Modified by:   Yinlong Su
* @Last Modified time: 2016-05-04 17:42:04
*/

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
    int r;
    cprintf("i am parent environment %08x\n", thisenv->env_id);
    if ((r = execl("/bin/hello", "hello", 0)) < 0)
        panic("execl(hello) failed: %e", r);

    cprintf("i am parent environment %08x\n", thisenv->env_id);

}
