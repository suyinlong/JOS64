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
	// make sure the 4-byte status register is full duplex link at 1000 Mb/s 0x80080783
	if (*((uint32_t *)&e1000[E1000_STATUS]) != 0x80080783)
		panic("Intel E1000 in wrong status = %x", *((uint32_t *)&e1000[E1000_STATUS]));

	// Initialize Transmit Buffer and Settings
	// see Intel E1000 Manual section 14.5 for details

	// #1 - program the transimit descriptor base address with the address of the region
	// paragraph 1: .. both TDBAL and TDBAH are used for 64-bit addresses ..
	E1000[E1000_TDBAL] = PADDR(tx_desc);
	E1000[E1000_TDBAH] = PADDR(tx_desc) >> 32;

	// #2 - set the transmit descriptor length register to the size of descriptor ring
	// paragraph 2: .. this register must be 128-byte aligned ..
	E1000[E1000_TDLEN] = E1000_TX_DESC * sizeof(struct e1000_tx_desc);

	// #3 - initialize transmit descriptor head & tail
	// paragraph 3: .. software should write 0b to both these registers to ensure this ..
	E1000[E1000_TDH] = 0x0;
	E1000[E1000_TDT] = 0x0;

	// #4 - initialize the transmit control register(TCTL)
	// paragraph 4.1: Set the Enable (TCTL.EN) bit to 1b for normal operation.
	E1000[E1000_TCTL] = E1000_TCTL_EN;
	// paragraph 4.2: Set the Pad Short Packets (TCTL.PSP) bit to 1b.
	E1000[E1000_TCTL] |= E1000_TCTL_PSP;
	// paragraph 4.3: Configure the Collision Threshold (TCTL.CT) to the desired value.
	// paragraph 4.3: Ethernet standard is 10h.
	E1000[E1000_TCTL] &= ~E1000_TCTL_CT;
	E1000[E1000_TCTL] |= (0x10) << 4;
	// paragraph 4.4: Configure the Collision Distance (TCTL.COLD) to its expected value.
	// paragraph 4.4: For gigabit half duplex, this value should be set to 200h.
	E1000[E1000_TCTL] &= ~E1000_TCTL_COLD;
	E1000[E1000_TCTL] |= (0x200) << 12;

	// #5 - program the transmit IPG register
	// paragraph 5: .. with the following decimal values to get the minimum legal Inter Packet Gap ..
	// note: according to lab spec, do refer to Table 13-77 in the Intel E1000 Manual, IEEE 802.3 standard IPG value
	// table 13-77: IPGT - .. the value that should be programmed into IPGT is 10 ..
	E1000[E1000_TIPG] = 10;
	// table 13-77: IPGR1 - .. IPGR1 should be 2/3 of IPGR2 value ..
	E1000[E1000_TIPG] |= 4 << 10;
	// table 13-77: IPGR2 - .. the value that should be programmed into IPGR2 is six ..
	E1000[E1000_TIPG] |= 6 << 20;

	// Initialize Receive Buffer and Settings


	return 0;
}

int
e1000_transmit(void *addr, size_t len) {
	// wrong size of packet to transfer
	if(len > E1000_TX_PKT)///////////////////////////////////////////////////////
		return -E_E1000_TX;

	// simply drop the packet when the transmit queue is full
	if((tx_desc[E1000[E1000_TDT]].status & E1000_TXD_STAT_DD) == 0)
		return -E_E1000_TX;

	// it is safe to recycle tail descriptor and use it to transmit another packet
	memmove(tx_buff[E1000[E1000_TDT]].buf, addr, len);
	tx_desc[E1000[E1000_TDT]].length = len;
	tx_desc[E1000[E1000_TDT]].status = 0;
	tx_desc[E1000[E1000_TDT]].cmd |= E1000_TXD_CMD_RS | E1000_TXD_CMD_EOP;

	// update the tail of transmit descriptor
	E1000[E1000_TDT] = (E1000[E1000_TDT] + 1) / E1000_TX_DESC;

	return 0;
}

int
e1000_receive(void *addr) {
	return 0;
}
