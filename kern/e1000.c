#include <kern/e1000.h>

// LAB 6: Your driver code here

volatile char * e1000;				// memory mapping IO address for E1000

struct e1000_tx_desc tx_desc[E1000_TX_DESC];	// set up certain number of transmit descriptors
struct e1000_rx_desc rx_desc[E1000_RX_DESC];	// set up certain number of receive descriptors

struct e1000_tx_pkt tx_buff[E1000_TX_BUFF];	// set up some number of packets as transmit buffer
struct e1000_rx_pkt rx_buff[E1000_RX_BUFF];	// set up some number of packets as receive buffer

int
e1000_pci_attach(struct pci_func *f) {
	int i;

	// setup and enable PCI function
	pci_func_enable(f);

	// allocate and map memory for E1000 IO operations
	// according to lab spec, base & size are stored in reg_base[0] & reg_size[0]
	e1000 = mmio_map_region(f->reg_base[0], f->reg_size[0]);

	// test mapping in exercise 4
	// make sure the 4-byte status register is full duplex link at 1000 MB/s 0x80080783
	if (*((uint32_t *)&e1000[E1000_STATUS]) != 0x80080783)
		panic("Intel E1000 in wrong status = %x", *((uint32_t *)&e1000[E1000_STATUS]));

	// initialize transmit buffer and settings


	// initialize receive buffer and settings


	return 0;
}

int
e1000_transmit(void *addr, size_t len) {
	return 0;
}

int
e1000_receive(void *addr, size_t len) {
	return 0;
}
