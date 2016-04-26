#ifndef JOS_KERN_E1000_H
#define JOS_KERN_E1000_H

// implemented in LAB 6
#include <kern/pci.h>
#include <kern/pmap.h>
#include <inc/string.h>

// Intel E1000 Manual - Table 5.1 82540EM-A desktop version
#define E1000_VENDOR_ID		0x8086
#define E1000_DEVICE_ID		0x100e

// define number of transmit & receive descriptors
#define E1000_TX_DESC		64
#define E1000_RX_DESC		64

// define transmit & receive packet size
#define E1000_TX_PKT		2048
#define E1000_RX_PKT		2048

// define transmit & receive buffer size in number of packets
#define E1000_TX_BUFF		1518
#define E1000_RX_BUFF		1518

// constants defined by Intel E1000 manual
// borrowed and simplified from given header 'e1000_hw.h', only keep vital ones
#define E1000_STATUS		0x00008		// Device Status - RO
#define E1000_TCTL		0x00400		// TX Control - RW
#define E1000_TIPG		0x00410		// TX Inter-packet Gap - RW

#define E1000_TDBAL		0x03800		// TX Descriptor Base Address Low - RW
#define E1000_TDBAH		0x03804		// TX Descriptor Base Address High - RW
#define E1000_TDLEN		0x03808		// TX Descriptor Length - RW
#define E1000_TDH		0x03810		// TX Descriptor Head - RW
#define E1000_TDT		0x03818		// TX Descriptor Tail - RW

// transmit control bits
#define E1000_TCTL_EN		0x00000002	// enable tx
#define E1000_TCTL_PSP		0x00000008	// pad short packets
#define E1000_TCTL_CT		0x00000ff0	// collision threshold
#define E1000_TCTL_COLD		0x003ff000	// collision distance

// transmit descriptor bits
#define E1000_TXD_CMD_EOP	0x01000000	// end of packet
#define E1000_TXD_CMD_RS	0x08000000	// report status
#define E1000_TXD_STAT_DD	0x00000001	// descriptor done

// define error code for return values
#define E_E1000_TX		1		// transmitting error
#define E_E1000_RX		1		// receiving error

// define macros for easy 4-byte register addressing
#define E1000			*(uint32_t *)&e1000

// transmit descriptor structure
// borrowed and simplified from given header 'e1000_hw.h', remove unused spaces
// use '__attribute__((packed))' instead of 'union' for clear code and continuous memory
struct e1000_tx_desc {
	uint64_t addr;				// address of the descriptor's data buffer
	uint16_t length;			// data buffer length
	uint8_t cso;				// checksum offset
	uint8_t cmd;				// descriptor control
	uint8_t status;				// descriptor status
	uint8_t css;				// checksum start
	uint16_t special;			// for 64-bit alignment
} __attribute__((packed));

// receive descriptor structure
// borrowed and simplified from given header 'e1000_hw.h', remove unused spaces
// use '__attribute__((packed))' instead of 'union' for clear code and continuous memory
struct e1000_rx_desc {
	uint64_t addr;				// address of the descriptor's data buffer
	uint16_t length;			// length of data DMAed into data buffer
	uint16_t csum;				// packet checksum
	uint8_t status;				// descriptor status
	uint8_t errors;				// descriptor errors
	uint16_t special;			// for 64-bit alignment
} __attribute__((packed));

// transmit packet structure
// borrowed and simplified from given header 'e1000_hw.h', remove unused spaces
// use '__attribute__((packed))' instead of 'union' for clear code and continuous memory
struct e1000_tx_pkt {
	uint8_t buf[E1000_TX_PKT];
} __attribute__((packed));

// receive packet structure
// borrowed and simplified from given header 'e1000_hw.h', remove unused spaces
// use '__attribute__((packed))' instead of 'union' for clear code and continuous memory
struct e1000_rx_pkt {
	uint8_t buf[E1000_RX_PKT];
} __attribute__((packed));

int	e1000_pci_attach(struct pci_func *pci);
int	e1000_transmit(void *addr, size_t len);
int	e1000_receive(void *addr);

#endif	// JOS_KERN_E1000_H
