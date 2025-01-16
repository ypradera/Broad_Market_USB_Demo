/****************************************************************************/
/**
 *
 * @file lsc_hw_regs.h
 * @addtogroup lscusb Overview
 * @{
 *
 *
 *
 *****************************************************************************/

#ifndef LSC_HW_REGS_H_
#define LSC_HW_REGS_H_

#ifdef __cplusplus
extern "C" {
#endif

/***************************** Include Files ********************************/

/************************** Constant Definitions ****************************/

/**@name Register offsets
 *
 * The following constants provide access to each of the registers of the
 * USB device.
 * @{
 */

/* Port Status and Control Register */
#define LSC_PORTSC_30                       0x430 /**< Port Status and Control Register */
#define LSC_PORTMSC_30                      0x434 /**< USB3 Port Power Management Status and Control Register */

/* XUSBPSU registers memory space boundaries */
#define LSC_GLOBALS_REGS_START              0xC100 /**< Global register start address */
#define LSC_GLOBALS_REGS_END                0xC6FF /**< Global register end address */
#define LSC_DEVICE_REGS_START               0xC700 /**< Device register start address */
#define LSC_DEVICE_REGS_END                 0xCBFF /**< Device register end address */
#define LSC_OTG_REGS_START                  0xCC00 /**< OTG register start address */
#define LSC_OTG_REGS_END                    0xCCFF /**< OTG register end address */

/* Global Registers */
#define LSC_GSBUSCFG0                       0xC100 /**< Global SoC Bus Configuration Register 0 */
#define LSC_GSBUSCFG1                       0xC104 /**< Global SoC Bus Configuration Register 1 */
#define LSC_GTXTHRCFG                       0xC108 /**< Global Tx Threshold Control Register */
#define LSC_GRXTHRCFG                       0xC10C /**< Global Rx Threshold Control Register */
#define LSC_GCTL                            0xC110 /**< Global Core Control Register */
#define LSC_GEVTEN                          0xC114 /**< Global Event Enable Register */
#define LSC_GSTS                            0xC118 /**< Global Status Register */
#define LSC_GSNPSID                         0xC120 /**< Global ID Register */
#define LSC_GGPIO                           0xC124 /**< Global General Purpose Input/Output Register */
#define LSC_GUID                            0xC128 /**< Global User ID Register This is a read/write */
#define LSC_GUCTL                           0xC12C /**< Global User Control Register */
#define LSC_GUCTL1                          0xC11C /**< Global User Control Register 1 */
#define LSC_GBUSERRADDR0                    0xC130 /**< Global SoC Bus Error Address Register - Low */
#define LSC_GBUSERRADDR1                    0xC134 /**< Global SoC Bus Error Address Register - high */
#define LSC_GPRTBIMAP0                      0xC138 /**< Global SS Port to Bus Instance Mapping Register - Low */
#define LSC_GPRTBIMAP1                      0xC13C /**< Global SS Port to Bus Instance Mapping Register - High */
#define LSC_GHWPARAMS0_OFFSET               0xC140 /**< Global Hardware Parameter Register 0 */
#define LSC_GHWPARAMS1_OFFSET               0xC144 /**< Global Hardware Parameter Register 1 */
#define LSC_GHWPARAMS2_OFFSET               0xC148 /**< Global Hardware Parameter Register 2 */
#define LSC_GHWPARAMS3_OFFSET               0xC14C /**< Global Hardware Parameter Register 3 */
#define LSC_GHWPARAMS4_OFFSET               0xC150 /**< Global Hardware Parameter Register 4 */
#define LSC_GHWPARAMS5_OFFSET               0xC154 /**< Global Hardware Parameter Register 5 */
#define LSC_GHWPARAMS6_OFFSET               0xC158 /**< Global Hardware Parameter Register 6 */
#define LSC_GHWPARAMS7_OFFSET               0xC15C /**< Global Hardware Parameter Register 7 */
#define LSC_GDBGFIFOSPACE                   0xC160 /**< Global Debug Queue/FIFO Space Available Register */
#define LSC_GDBGLTSSM                       0xC164 /**< Global Debug LTSSM Register */
#define LSC_GPRTBIMAP_HS0                   0xC180 /**< Global High-Speed Port to Bus Instance Mapping Register - Low */
#define LSC_GPRTBIMAP_HS1                   0xC184 /**< Global High-Speed Port to Bus Instance Mapping Register - High */
#define LSC_GPRTBIMAP_FS0                   0xC188 /**< Global Full-Speed Port to Bus Instance Mapping Register - Low */
#define LSC_GPRTBIMAP_FS1                   0xC18C /**< Global Full-Speed Port to Bus Instance Mapping Register - High */

#define LSC_GUSB2PHYCFG(n)                  ((uint32_t)0xc200 + ((uint32_t)(n) * (uint32_t)0x04)) /**< Global USB2 PHY Configuration Register */
#define LSC_GUSB2I2CCTL(n)                  ((uint32_t)0xc240 + ((uint32_t)(n) * (uint32_t)0x04)) /**< Reserved Register */

#define LSC_GUSB2PHYACC(n)                  ((uint32_t)0xc280 + ((uint32_t)(n) * (uint32_t)0x04)) /**< Global USB 2.0 UTMI PHY Vendor Control Register */

#define LSC_GUSB3PIPECTL(n)                 ((uint32_t)0xc2c0 + ((uint32_t)(n) * (uint32_t)0x04)) /**< Global USB 3.0 PIPE Control Register */

#define LSC_GTXFIFOSIZ(n)                   ((uint32_t)0xc300 + ((uint32_t)(n) * (uint32_t)0x04)) /**< Global Transmit FIFO Size Register */
#define LSC_GRXFIFOSIZ(n)                   ((uint32_t)0xc380 + ((uint32_t)(n) * (uint32_t)0x04)) /**< Global Receive FIFO Size Register */

#define LSC_GEVNTADRLO(n)                   ((uint32_t)0xc400 + ((uint32_t)(n) * (uint32_t)0x10)) /**< Global Event Buffer Address (Low) Register */
#define LSC_GEVNTADRHI(n)                   ((uint32_t)0xc404 + ((uint32_t)(n) * (uint32_t)0x10)) /**< Global Event Buffer Address (High) Register */
#define LSC_GEVNTSIZ(n)                     ((uint32_t)0xc408 + ((uint32_t)(n) * (uint32_t)0x10)) /**< Global Event Buffer Size Register */
#define LSC_GEVNTCOUNT(n)                   ((uint32_t)0xc40c + ((uint32_t)(n) * (uint32_t)0x10)) /**< Global Event Buffer Count Register */

#define LSC_GHWPARAMS8                      0x0000c600 /**< Global Hardware Parameters */

/* Device Registers */
#define LSC_DCFG                            0x0000c700 /**< Device Configuration Register */
#define LSC_DCTL                            0x0000c704 /**< Device Control Register */
#define LSC_DEVTEN                          0x0000c708 /**< Device Event Enable Register */
#define LSC_DSTS                            0x0000c70c /**< Device Status Register */
#define LSC_DGCMDPAR                        0x0000c710 /**< Device Generic Command Parameter Register */
#define LSC_DGCMD                           0x0000c714 /**< Device Generic Command Register */
#define LSC_DALEPENA                        0x0000c720 /**< Device Active USB Endpoint Enable Register */
#define LSC_DEPCMDPAR2(n)                   ((uint32_t)0xc800 + ((uint32_t)(n) * (uint32_t)0x10)) /**< Device Physical Endpoint-n Command Parameter 2 Register */
#define LSC_DEPCMDPAR1(n)                   ((uint32_t)0xc804 + ((uint32_t)(n) * (uint32_t)0x10)) /**< Device Physical Endpoint-n Command Parameter 1 Register */
#define LSC_DEPCMDPAR0(n)                   ((uint32_t)0xc808 + ((uint32_t)(n) * (uint32_t)0x10)) /**< Device Physical Endpoint-n Command Parameter 0 Register */
#define LSC_DEPCMD(n)                       ((uint32_t)0xc80c + ((uint32_t)(n) * (uint32_t)0x10)) /**< Device Physical Endpoint-n Command Register */

/* OTG Registers */
#define LSC_OCFG                            0x0000cc00 /**< OTG Configuration Register */
#define LSC_OCTL                            0x0000cc04 /**< OTG Control Register */
#define LSC_OEVT                            0xcc08 /**< OTG Events Register */
#define LSC_OEVTEN                          0xcc0C /**< OTG Events Enable Register */
#define LSC_OSTS                            0xcc10 /**< OTG Status Register */

/* Bit fields */

/* Global Configuration Register */
#define LSC_GCTL_PWRDNSCALE(n)              ((n) << 19) /**< Power down scale */
#define LSC_GCTL_U2RSTECN                   (1U << 16) /**< U2RSTECN */
#define LSC_GCTL_RAMCLKSEL(x)               (((x) & LSC_GCTL_CLK_MASK) << 6) /**< RAM Clock Select */
#define LSC_GCTL_CLK_BUS                    (0) /**< bus clock */
#define LSC_GCTL_CLK_PIPE                   (1) /**< pipe clock */
#define LSC_GCTL_CLK_PIPEHALF               (2) /**< pipe half clock */
#define LSC_GCTL_CLK_MASK                   (3) /**< clock mask */

#define LSC_GCTL_PRTCAP(n)                  (((n) & (3 << 12)) >> 12) /**< Port Capability */
#define LSC_GCTL_PRTCAPDIR(n)               ((uint32_t)(n) << 12) /**< Port Capability Direction */
#define LSC_GCTL_PRTCAP_HOST                1 /**< Port Capability Host */
#define LSC_GCTL_PRTCAP_DEVICE              2 /**< Port Capability Device */
#define LSC_GCTL_PRTCAP_OTG                 3 /**< Port Capability OTG */

#define LSC_GCTL_CORESOFTRESET              0x00000800 /**< Core soft reset bit 11 */
#define LSC_GCTL_SOFITPSYNC                 0x00000400 /**< SOFITPSYNC bit 10 */
#define LSC_GCTL_SCALEDOWN(n)               ((uint32_t)(n) << 4) /**< Scale Down */
#define LSC_GCTL_SCALEDOWN_MASK             LSC_GCTL_SCALEDOWN(3) /**< Scale Down mask */
#define LSC_GCTL_DISSCRAMBLE                (0x00000001 << 3) /**< Disable Scrambling */
#define LSC_GCTL_U2EXIT_LFPS                (0x00000001 << 2) /**< U2EXIT_LFPS */
#define LSC_GCTL_GBLHIBERNATIONEN           (0x00000001 << 1) /**< Global Hibernation Enable */
#define LSC_GCTL_DSBLCLKGTNG                (0x00000001 << 0) /**< Disable Clock Gating */

/* Global Status Register Device Interrupt Mask */
#define LSC_GSTS_DEVICE_IP_MASK             0x00000040 /**< Device Interrupt */
#define LSC_GSTS_CUR_MODE                   (0x00000001 << 0) /**< Current Mode of Operation */

/* Global USB2 PHY Configuration Register */
#define LSC_GUSB2PHYCFG_PHYSOFTRST                  0x80000000 /**< PHY Soft Reset */
#define LSC_GUSB2PHYCFG_SUSPHY                      (0x00000001 << 6) /**< Suspend USB2.0 HS/FS/LS PHY */
#define LSC_GUSB2PHYCFG_LSIPD_3_BIT                 (0x00000002 << 19) /**< LS Inter-Packet Time - 3 Bit Times */       //Applicable into host mode only
#define LSC_GUSB2PHYCFG_USBTRDTIM_8_BIT_UTMI_ULPI   (0x00000009 << 10) /**< LS Inter-Packet Time - 3 Bit Times */

/* Global USB3 PIPE Control Register */
#define LSC_GUSB3PIPECTL_PHYSOFTRST         0x80000000 /**< USB3 PHY Soft Reset */
#define LSC_GUSB3PIPECTL_SUSPHY             0x00020000 /**< Suspend USB3.0 SS PHY (Suspend_en) */
#define LSC_GUSB3PIPECTL_REQ_P1P2P3         (0x00000001 << 24) /**< Must be 1 for PHY */
#define LSC_GUSB3PIPECTL_DELAYP1TRANS       (0x00000001 << 18)
#define LSC_GUSB3PIPECTL_DELAYP1P2P3        (0x00000001 << 19)
#define LSC_GUSB3PIPECTL_SS_TX_DE_EMPHASIS  (0x00000001 << 1)

/* Global TX Fifo Size Register */
#define LSC_GTXFIFOSIZ_TXFDEF(n)            ((uint32_t)(n) & (uint32_t)0xffff) /**< TxFIFO Depth */
#define LSC_GTXFIFOSIZ_TXFSTADDR(n)         ((uint32_t)(n) & 0xffff0000) /**< Transmit FIFOn RAM Start Address */

/* Global Event Size Registers */
#define LSC_GEVNTSIZ_INTMASK                ((uint32_t)0x00000001 << 31) /**< Event Interrupt Mask */
#define LSC_GEVNTSIZ_SIZE(n)                ((uint32_t)(n) & (uint32_t)0xffff) /**< Event Buffer Size in bytes */

/* Global HWPARAMS1 Register */
#define LSC_GHWPARAMS1_EN_PWROPT(n)         (((uint32_t)(n) & ((uint32_t)3 << 24)) >> 24) /**< USB3_EN_PWROPT */
#define LSC_GHWPARAMS1_EN_PWROPT_NO         0 /**< No USB3_EN_PWROPT */
#define LSC_GHWPARAMS1_EN_PWROPT_CLK        1 /**< Clock gating ctrl */
#define LSC_GHWPARAMS1_EN_PWROPT_HIB        2 /**< Hibernation */
#define LSC_GHWPARAMS1_PWROPT(n)            ((uint32_t)(n) << 24) /**< Power Post */
#define LSC_GHWPARAMS1_PWROPT_MASK          LSC_GHWPARAMS1_PWROPT(3) /**< USB3_EN_PWROPT mask */

/* Global HWPARAMS4 Register */
#define LSC_GHWPARAMS4_HIBER_SCRATCHBUFS(n) (((uint32_t)(n) & ((uint32_t)0x0F << 13)) >> 13) /**< Number of external scratchpad buffers */
#define LSC_MAX_HIBER_SCRATCHBUFS           15 /**< Number of maximum scratchpad buffers */

/* Device Configuration Register */
#define LSC_DCFG_DEVADDR(addr)              ((uint32_t)(addr) << 3) /**< Device Address */
#define LSC_DCFG_DEVADDR_MASK               LSC_DCFG_DEVADDR(0x7F) /**< Device Address Mask */

#define LSC_DCFG_SPEED_MASK                 7 /**< Speed mask */
#define LSC_DCFG_SUPERSPEED                 4 /**< Super Speed */
#define LSC_DCFG_HIGHSPEED                  0 /**< High Speed */
#define LSC_DCFG_FULLSPEED2                 1 /**< Full Speed */
#define LSC_DCFG_LOWSPEED                   2 /**< Low Speed */
#define LSC_DCFG_FULLSPEED1                 3 /**< Full1 Speed */

#define LSC_DCFG_LPM_CAP                    (0x00000001 << 22) /**< LPM Capable */

/* Device Control Register */
#define LSC_DCTL_RUN_STOP                   0x80000000 /**< Run/Stop bit 31 */
#define LSC_DCTL_CSFTRST                    0x40000000 /**< Core Soft Reset bit 30 */
#define LSC_DCTL_LSFTRST                    0x20000000 /**< Reserved for DB-2.90a */
#define LSC_DCTL_LPM_NYET_THRES             (0x0000000F << 20)

#define LSC_DCTL_HIRD_THRES_MASK            0x1F000000 /**< HIRD Threshold mask */
#define LSC_DCTL_HIRD_THRES(n)              ((uint32_t)(n) << 24) /**< HIRD Threshold */

#define LSC_DCTL_APPL1RES                   (0x00000001 << 23) /**< LPM Response */

/* These apply for core versions 1.87a and earlier */
#define LSC_DCTL_TRGTULST_MASK              (0x0000000F << 17) /**< TRGTULST mask */
#define LSC_DCTL_TRGTULST(n)                ((uint32_t)(n) << 17) /**< TRGTULST */
#define LSC_DCTL_TRGTULST_U2                (LSC_DCTL_TRGTULST(2)) /**< U2 */
#define LSC_DCTL_TRGTULST_U3                (LSC_DCTL_TRGTULST(3)) /**< U3 */
#define LSC_DCTL_TRGTULST_SS_DIS            (LSC_DCTL_TRGTULST(4)) /**< SS_DIS */
#define LSC_DCTL_TRGTULST_RX_DET            (LSC_DCTL_TRGTULST(5)) /**< RX_DET */
#define LSC_DCTL_TRGTULST_SS_INACT          (LSC_DCTL_TRGTULST(6)) /**< SS_INACT */

/* These apply for core versions 1.94a and later */
#define LSC_DCTL_KEEP_CONNECT               0x00080000 /**< Keep Connect */
#define LSC_DCTL_L1_HIBER_EN                0x00040000 /**< L1 Hibernation Enable */
#define LSC_DCTL_CRS                        0x00020000 /**< Controller Restore State */
#define LSC_DCTL_CSS                        0x00010000 /**< Controller Save State */

#define LSC_DCTL_INITU2ENA                  0x00001000 /**< Initiate U2 Enable */
#define LSC_DCTL_ACCEPTU2ENA                0x00000800 /**< Accept U2 Enable */
#define LSC_DCTL_INITU1ENA                  0x00000400 /**< Initiate U1 Enable */
#define LSC_DCTL_ACCEPTU1ENA                0x00000200 /**< Accept U1 Enable */
#define LSC_DCTL_TSTCTRL_MASK               (0x0000000f << 1) /**< Test Control */

#define LSC_DCTL_ULSTCHNGREQ_MASK           (0x0000000F << 5) /**< USB/Link state change request mask value */
#define LSC_DCTL_ULSTCHNGREQ(n) (((uint32_t)(n) << 5) & LSC_DCTL_ULSTCHNGREQ_MASK) /**< USB/Link state change request */

#define LSC_DCTL_ULSTCHNG_NO_ACTION         (LSC_DCTL_ULSTCHNGREQ(0)) /**< NO_ACTION */
#define LSC_DCTL_ULSTCHNG_SS_DISABLED       (LSC_DCTL_ULSTCHNGREQ(4)) /**< SS_DISABLED */
#define LSC_DCTL_ULSTCHNG_RX_DETECT         (LSC_DCTL_ULSTCHNGREQ(5)) /**< RX_DETECT */
#define LSC_DCTL_ULSTCHNG_SS_INACTIVE       (LSC_DCTL_ULSTCHNGREQ(6)) /**< SS_INACTIVE */
#define LSC_DCTL_ULSTCHNG_RECOVERY          (LSC_DCTL_ULSTCHNGREQ(8)) /**< RECOVERY */
#define LSC_DCTL_ULSTCHNG_COMPLIANCE        (LSC_DCTL_ULSTCHNGREQ(10)) /**< COMPLIANCE */
#define LSC_DCTL_ULSTCHNG_LOOPBACK          (LSC_DCTL_ULSTCHNGREQ(11)) /**< LOOPBACK */
/** @endcond */

/* Device Event Enable Register */
#define LSC_DEVTEN_L1WKUPEVTEN              ((uint32_t)0x00000001 << 14) /**< L1 Resume/RemoteWake Event Enable */
#define LSC_DEVTEN_VNDRDEVTSTRCVEDEN        ((uint32_t)0x00000001 << 12) /**< Vendor Device Test LMP Received Event */
#define LSC_DEVTEN_EVNTOVERFLOWEN           ((uint32_t)0x00000001 << 11) /**< Reserved */
#define LSC_DEVTEN_CMDCMPLTEN               ((uint32_t)0x00000001 << 10) /**< Reserved */
#define LSC_DEVTEN_ERRTICERREN              ((uint32_t)0x00000001 << 9) /**< Erratic Error Event Enable */
#define LSC_DEVTEN_SOFEN                    ((uint32_t)0x00000001 << 7) /**< Start of (u)frame */
#define LSC_DEVTEN_EOPFEN                   ((uint32_t)0x00000001 << 6) /**< U3/L2-L1 Suspend Event Enable */
#define LSC_DEVTEN_HIBERNATIONREQEVTEN      ((uint32_t)0x00000001 << 5) /**< Hibernation Request Event */
#define LSC_DEVTEN_WKUPEVTEN                ((uint32_t)0x00000001 << 4) /**< Resume/Remote Wakeup Detected Event Enable */
#define LSC_DEVTEN_ULSTCNGEN                ((uint32_t)0x00000001 << 3) /**< Link State Change Event Enable */
#define LSC_DEVTEN_CONNECTDONEEN            ((uint32_t)0x00000001 << 2) /**< Connection Done Enable */
#define LSC_DEVTEN_USBRSTEN                 ((uint32_t)0x00000001 << 1) /**< USB Reset Enable */
#define LSC_DEVTEN_DISCONNEVTEN             ((uint32_t)0x00000001 << 0) /**< Disconnect Detected Event Enable */

/* Device Event Enable Mask */
#define LSC_DEVTEN_MASK     (LSC_DEVTEN_EVNTOVERFLOWEN | LSC_DEVTEN_WKUPEVTEN | LSC_DEVTEN_ULSTCNGEN | LSC_DEVTEN_CONNECTDONEEN | LSC_DEVTEN_USBRSTEN | LSC_DEVTEN_DISCONNEVTEN | LSC_DEVTEN_L1WKUPEVTEN)

/* Device Status Register */
#define LSC_DSTS_DCNRD                      0x40000000 /**< Device Controller Not Ready */

/* This applies for core versions 1.87a and earlier */
#define LSC_DSTS_PWRUPREQ                   0x01000000 /**< Reserved */

/* These apply for core versions 1.94a and later */
#define LSC_DSTS_RSS                        0x02000000 /**< RSS Restore State Status */
#define LSC_DSTS_SSS                        0x01000000 /**< SSS Save State Status */

#define LSC_DSTS_COREIDLE                   0x00800000 /**< Core Idle */
#define LSC_DSTS_DEVCTRLHLT                 0x00400000 /**< Device Controller Halted */

#define LSC_DSTS_USBLNKST_MASK              0x003C0000 /**< USB/Link State mask */
#define LSC_DSTS_USBLNKST(n) (((uint32_t)(n) & LSC_DSTS_USBLNKST_MASK) >> 18) /**< USB/Link State */

#define LSC_DSTS_RXFIFOEMPTY                (0x00000001 << 17) /**< RxFIFO Empty */

#define LSC_DSTS_SOFFN_MASK                 (0x00003FFF << 3) /**< Frame/Microframe Number of the Received SOF mask */
#define LSC_DSTS_SOFFN(n)                   (((uint32_t)(n) & LSC_DSTS_SOFFN_MASK) >> 3) /**< Frame/Microframe Number of the Received SOF */

#define LSC_DSTS_CONNECTSPD                 (0x00000007 << 0) /**< Connected Speed mask */

#define LSC_DSTS_SUPERSPEED                 (4 << 0) /**< Connected Super Speed */
#define LSC_DSTS_HIGHSPEED                  (0 << 0) /**< Connected High Speed */
#define LSC_DSTS_FULLSPEED2                 (1 << 0) /**< Connected Full Speed */
#define LSC_DSTS_LOWSPEED                   (2 << 0) /**< Connected Low Speed */
#define LSC_DSTS_FULLSPEED1                 (3 << 0) /**< Connected Full_Speed */

/* AXI-cache bits offset DATRDREQINFO */
#define LSC_GSBUSCFG0_BITMASK               0xFFFF0000 /**< Global SoC Bus Configuration mask */

/* Coherency Mode Register Offset */
//#define LSC_COHERENCY                     0x005C /**< Coherency Mode Register offset */
//#define LSC_COHERENCY_MODE_ENABLE         0x01 /**< Coherency Mode Enable */
/*Portpmsc 3.0 bit field*/
//#define LSC_PORTMSC_30_FLA_MASK               (1 << 16) /**< Force Link PM Accept */
//#define LSC_PORTMSC_30_U2_TIMEOUT_MASK        0xFF00 /**< U2 TIMEOUT mask */
//#define LSC_PORTMSC_30_U2_TIMEOUT_SHIFT       (8) /**< U2 TIMEOUT  */
//#define LSC_PORTMSC_30_U1_TIMEOUT_MASK        0xFF /**< U1 TIMEOUT mask */
//#define LSC_PORTMSC_30_U1_TIMEOUT_SHIFT       (0) /**< U2 TIMEOUT */
/** @} */

/************************** Function Prototypes ******************************/
uint8_t lsc_8_read (uint32_t reg_addr);
uint8_t lsc_8_write (uint32_t reg_addr, uint8_t value);

uint16_t lsc_16_read (uint32_t reg_addr);
uint8_t lsc_16_write (uint32_t reg_addr, uint16_t value);

uint32_t lsc_32_read (uint32_t reg_addr);
uint8_t lsc_32_write (uint32_t reg_addr, uint32_t value);

int lsc_uart_tx(char *c);

#ifdef __cplusplus
}
#endif

#endif /* LSC_HW_REGS_H_ */

/** @} */
