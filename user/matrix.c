/*
* @Author: Yinlong Su
* @Date:   2016-04-14 18:11:20
* @Last Modified by:   Yinlong Su
* @Last Modified time: 2016-04-14 23:11:50
*/

// Matrix multiplication
//
// +---+    +---+    +---+    +---+    +---+
// | I | → |1,0| → |1,1| → |1,2| → |1,3|
// | N |    +---+    +---+    +---+    +---+
// | P |               ↓        ↓        ↓
// | U |    +---+    +---+    +---+    +---+
// | T | → |2,0| → |2,1| → |2,2| → |2,3|
// |   |    +---+    +---+    +---+    +---+
// | S |               ↓        ↓        ↓
// | T |    +---+    +---+    +---+    +---+
// | R | → |3,0| → |3,1| → |3,2| → |3,3|
// | E |    +---+    +---+    +---+    +---+
// | A |               ↓        ↓        ↓
// | M +-----------------------------------+
// | +           OUTPUT STREAM             |
// +---------------------------------------+


#include <inc/lib.h>

#define SIGN 0x80000000
#define ENVID(i, j) ids[((i - 1) << 2) + j + 1]

uint32_t A[][3] = {
    {1, 2, 3},
    {4, 5, 6},
    {7, 8, 9}
};

uint32_t IN[][3] = {
    {1, 2, 3},
    {4, 5, 6},
    {7, 8, 9}
};

envid_t ids[13];

// for input nodes (1, 0) (2, 0) (3, 0)     j == 0
// recv from the parent then send to its right node (1, 1) (2, 1) (3, 1)
// recv/send 3 times
void inputnode(int k) {
    envid_t envid;
    int i = ((k - 1) >> 2) + 1, c, t;
    for (c = 0; c < 3; c++) {
        t = ipc_recv(&envid, 0, 0);
        ipc_send(ENVID(i, 1), t, 0, 0);
    }
}

// for center nodes (1, x) (2, x) (3, x)  x is in [1,3]
// recv from the left node and top node then send to right node and bottom node
// recv/send 3 times
//
// convention: we make the highest bit as the input direction
//             0 = left 1 = top
void centernode(int k) {
    envid_t envid;
    int i = ((k - 1) >> 2) + 1, j = (k - 1) % 4, c, x = 0, y = 0;
    uint32_t a = A[i-1][j-1], left[3], top[3], t;
    // top row, the top input is 0
    if (i == 1) {
        top[0] = top[1] = top[2] = 0;
        y = 3;
    }
    for (c = 0; c < 3; c++) {
        // must wait for both left and top inputs to proceed
        while (x <= c || y <= c) {
            t = ipc_recv(&envid, 0, 0);
            if (t & SIGN)
                top[y++] = t & ~SIGN;
            else
                left[x++] = t;
        }

        // if j = 3 do not send to right
        if (j < 3)
            ipc_send(ENVID(i, j + 1), left[c], 0, 0);
        // if i < 3 send to bottom
        if (i < 3)
            ipc_send(ENVID(i + 1, j), (top[c] + left[c] * a) | SIGN, 0, 0);
        // if i = 3 send to our parent node
        else if (i == 3)
            ipc_send(ids[0], top[c] + left[c] * a, 0, 0);
    }
}

void umain(int argc, char **argv) {
    int i, j, c, x = 0, y = 0, z = 0;
    envid_t who;
    uint32_t OUT[3][3], t;
    // save the envid of self
    ids[0] = sys_getenvid();
    // fork children
    // by this order, every child knows its right and bottom envids
    // but the child still need to know the sender of the received number
    // we use the highest bit to indicate the direction
    for (c = 12; c > 0; c--) {
        who = fork();
        if (who == 0) {
            // child
            if (c % 4 == 1)
                inputnode(c);
            else
                centernode(c);
            return;
        }
        // parent save the envid
        ids[c] = who;
    }
    // feed the input stream
    for (i = 0; i < 3; i++)
        for (j = 0; j < 3; j++)
            ipc_send(ENVID(j + 1, 0), IN[i][j], 0, 0);

    // wait for the answers
    for (c = 0; c < 9; c++) {
        t = ipc_recv(&who, 0, 0);
        if (who == ENVID(3, 1))
            OUT[x++][0] = t;
        else if (who == ENVID(3, 2))
            OUT[y++][1] = t;
        else if (who == ENVID(3, 3))
            OUT[z++][2] = t;
    }
    // print the answer
    for (i = 0; i < 3; i++) {
        for (j = 0; j < 3; j++)
            cprintf("%3d ", OUT[i][j]);
        cprintf("\n");
    }

}
