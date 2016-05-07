/*
* @Author: Yinlong Su
* @Date:   2016-05-04 14:54:43
* @Last Modified by:   Yinlong Su
* @Last Modified time: 2016-05-04 16:15:17
*/

// link test

#include <inc/lib.h>

const char *msg = "This is the LINK test!";
char buf1[512], buf2[512], buf3[512];

void
umain(int argc, char **argv)
{
    int fd1, fd2, fd3, r, n, n2;

    cprintf("  > Create 'base'\n");
    if ((fd1 = open("base", O_RDWR | O_CREAT)) < 0)
        panic("open base: %e", fd1);
    seek(fd1, 0);

    cprintf("  > Write '%s' to 'base'\n", msg);
    if ((r = write(fd1, msg, strlen(msg) + 1)) < 0)
        panic("write error: %e", r);
    if (r != strlen(msg) + 1)
        panic("write error: wrong number of bytes\n");

    cprintf("  > Create link 'mylink1' to 'base'\n");
    if ((r = link("base", "mylink1")) < 0)
        panic("link1 error: %e", r);

    cprintf("  > Open link 'mylink1'\n");
    if ((fd2 = open("mylink1", O_RDONLY)) < 0)
        panic("open mylink1: %e", fd2);
    seek(fd2, 0);

    cprintf("  > Create link 'mylink2' to 'mylink1'\n");
    if ((r = link("mylink1", "mylink2")) < 0)
        panic("link2 error: %e", r);

    cprintf("  > Open link 'mylink2'\n");
    if ((fd3 = open("mylink2", O_RDONLY)) < 0)
        panic("open mylink2: %e", fd3);
    seek(fd3, 0);

    cprintf("  > Read the content of 'base'\n");
    seek(fd1, 0);
    if ((r = readn(fd1, buf1, 512)) < 0)
        panic("read base: %e", r);
    if (r != strlen(msg) + 1)
        panic("read base: wrong number of bytes\n");
    cprintf("    %s\n", buf1);

    cprintf("  > Read the content of 'mylink1'\n");
    if ((r = readn(fd2, buf2, 512)) < 0)
        panic("read mylink1: %e", r);
    if (r != strlen(msg) + 1)
        panic("read mylink1: wrong number of bytes\n");
    cprintf("    %s\n", buf2);

    cprintf("  > Read the content of 'mylink2'\n");
    if ((r = readn(fd3, buf3, 512)) < 0)
        panic("read mylink2: %e", r);
    if (r != strlen(msg) + 1)
        panic("read mylink2: wrong number of bytes\n");
    cprintf("    %s\n", buf3);

    cprintf("  > Try to remove 'base'\n");
    if ((r = remove("base")) == 0)
        panic("remove error: 'base' should not be deleted\n");

    cprintf("  > Try to remove 'mylink1'\n");
    if ((r = remove("mylink1")) < 0)
        panic("remove mylink1: %e", r);

    cprintf("  > Try to remove 'base'\n");
    if ((r = remove("base")) == 0)
        panic("remove error: 'base' should not be deleted\n");

    cprintf("  > Try to remove 'mylink2'\n");
    if ((r = remove("mylink2")) < 0)
        panic("remove mylink2: %e", r);

    cprintf("  > Try to remove 'base'\n");
    if ((r = remove("base")) < 0)
        panic("remove base: %e", r);

    close(fd1);
    close(fd2);
    close(fd3);
    cprintf("  < Finish link test\n");

}
