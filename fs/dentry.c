/*
* @Author: Yinlong Su
* @Date:   2016-05-04 10:15:14
* @Last Modified by:   Yinlong Su
* @Last Modified time: 2016-05-04 10:32:54
*/

#include <inc/string.h>

#include "fs.h"

static struct Dentry *dentry_free_list;
static struct Dentry dentry[MAXDENTRY];

void init_dentry() {
    int i;
    struct Dentry *last = NULL;
    for (i = 0; i < MAXDENTRY; i++) {
        memset(dentry[i].d_name, 0, MAXNAMELEN);
        dentry[i].d_inode = -1;
        dentry[i].d_child = NULL;
        dentry[i].d_prev = NULL;
        dentry[i].d_next = NULL;
        dentry[i].d_parent = NULL;

        dentry[i].d_free_list = last;
        last = &dentry[i];
    }
    dentry_free_list = last;

    // now walk through the File and create dentry objects

}