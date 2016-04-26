#ifndef JOS_KERN_E1000_H
#define JOS_KERN_E1000_H

// implemented in LAB 6
#include <kern/pci.h>
#include <kern/pmap.h>

// Intel E1000 Manual - Table 5.1 82540EM-A desktop version
#define E1000_VENDOR_ID	0x8086
#define E1000_DEVICE_ID	0x100e

// define number of transmit & receive descriptors
#define E1000_TX_DESC	64
#define E1000_RX_DESC	64

// define transmit & receive packet size
#define E1000_TX_PKT	2048
#define E1000_RX_PKT	2048

// define transmit & receive buffer size in number of packets
#define E1000_TX_BUFF	2048
#define E1000_RX_BUFF	2048

// constants defined by Intel E1000 manual
// borrowed and simplified from given header 'e1000_hw.h', only keep vital ones
#define E1000_STATUS	0x00008		// Device Status - RO

// transmit descriptor structure
// borrowed and simplified from given header 'e1000_hw.h', remove unused spaces
// use '__attribute__((packed))' instead of 'union' for clear code and continuous memory
struct e1000_tx_desc {
	uint64_t addr;			// address of the descriptor's data buffer
	uint16_t length;		// data buffer length
	uint8_t cso;			// checksum offset
	uint8_t cmd;			// descriptor control
	uint8_t status;			// descriptor status
	uint8_t css;			// checksum start
	uint16_t special;		// for 64-bit alignment
} __attribute__((packed));

// receive descriptor structure
// borrowed and simplified from given header 'e1000_hw.h', remove unused spaces
// use '__attribute__((packed))' instead of 'union' for clear code and continuous memory
struct e1000_rx_desc {
	uint64_t addr;			// address of the descriptor's data buffer
	uint16_t length;		// length of data DMAed into data buffer
	uint16_t csum;			// packet checksum
	uint8_t status;			// descriptor status
	uint8_t errors;			// descriptor errors
	uint16_t special;		// for 64-bit alignment
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
int	e1000_receive(void *addr, size_t len);

#endif	// JOS_KERN_E1000_H
