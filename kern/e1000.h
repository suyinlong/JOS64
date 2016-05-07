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
#define E1000_STATUS		0x00008 / 4	// Device Status - RO

#define E1000_MTA		0x05200 / 4	// Multicast Table Array - RW

#define E1000_TCTL		0x00400 / 4	// TX Control - RW
#define E1000_TIPG		0x00410 / 4	// TX Inter-packet Gap - RW
#define E1000_RCTL		0x00100 / 4	// RX Control - RW

#define E1000_TDBAL		0x03800 / 4	// TX Descriptor Base Address Low - RW
#define E1000_TDBAH		0x03804 / 4	// TX Descriptor Base Address High - RW
#define E1000_TDLEN		0x03808 / 4	// TX Descriptor Length - RW
#define E1000_TDH		0x03810 / 4	// TX Descriptor Head - RW
#define E1000_TDT		0x03818 / 4	// TX Descriptor Tail - RW

#define E1000_RDBAL		0x02800 / 4	// RX Descriptor Base Address Low - RW
#define E1000_RDBAH		0x02804 / 4	// RX Descriptor Base Address High - RW
#define E1000_RDLEN		0x02808 / 4	// RX Descriptor Length - RW
#define E1000_RDH		0x02810 / 4	// RX Descriptor Head - RW
#define E1000_RDT		0x02818 / 4	// RX Descriptor Tail - RW
#define E1000_RAL		0x05400 / 4	// RX Address Low - RW
#define E1000_RAH		0x05404 / 4	// RX Address High - RW

// transmit control bits
#define E1000_TCTL_EN		0x00000002	// enable tx
#define E1000_TCTL_PSP		0x00000008	// pad short packets
#define E1000_TCTL_CT		0x00000ff0	// collision threshold
#define E1000_TCTL_COLD		0x003ff000	// collision distance

// transmit descriptor bits
#define E1000_TXD_CMD_EOP	0x00000008	// end of packet
#define E1000_TXD_CMD_RS	0x00000001	// report status
#define E1000_TXD_STAT_DD	0x00000001	// descriptor done

// receive control bits
#define E1000_RCTL_EN		0x00000002	// enable rx
#define E1000_RCTL_LPE		0x00000020	// allow long packets
#define E1000_RCTL_LBM		0x000000C0	// loopback mode
#define E1000_RCTL_RDMTS	0x00000300	// min size
#define E1000_RCTL_MO		0x00003000	// multicast offset shift
#define E1000_RCTL_BAM		0x00008000	// enable broadcast
#define E1000_RCTL_SZ		0x00030000	// rx buffer size
#define E1000_RCTL_SECRC	0x04000000	//strip Ethernet CRC

// receive descriptor bits
#define E1000_RAH_AV		0x80000000	// receive descriptor valid
#define E1000_RXD_STAT_DD	0x00000001	// descriptor done
#define E1000_RXD_STAT_EOP	0x00000002	// end of packet

// define error code for return values
#define E_E1000_TX		1		// transmitting error
#define E_E1000_RX		1		// receiving error

// transmit descriptor structure
// borrowed and simplified from given header 'e1000_hw.h', remove unused spaces
// use '__attribute__((packed))' instead of 'union' for clear code and continuous memory
struct e1000_tx_desc {
	uint64_t addr;
	uint16_t length;
	uint8_t cso;
	uint8_t cmd;
	uint8_t status;
	uint8_t css;
	uint16_t special;
} __attribute__((packed));

// transmit packet structure
// borrowed and simplified from given header 'e1000_hw.h', remove unused spaces
// use '__attribute__((packed))' instead of 'union' for clear code and continuous memory
struct e1000_tx_pkt {
	uint8_t buf[E1000_TX_PKT];
} __attribute__((packed));

// receive descriptor structure
// borrowed and simplified from given header 'e1000_hw.h', remove unused spaces
// use '__attribute__((packed))' instead of 'union' for clear code and continuous memory
struct e1000_rx_desc {
	uint64_t addr;
	uint16_t length;
	uint16_t chksum;
	uint8_t status;
	uint8_t errors;
	uint16_t special;
} __attribute__((packed));

// receive packet structure
// borrowed and simplified from given header 'e1000_hw.h', remove unused spaces
// use '__attribute__((packed))' instead of 'union' for clear code and continuous memory
struct e1000_rx_pkt {
	uint8_t buf[E1000_RX_PKT];
} __attribute__((packed));

int e1000_pci_attach (struct pci_func *f);
int e1000_transmit (char *data, int len);
int e1000_receive (char *data);

#endif	// JOS_KERN_E1000_H
