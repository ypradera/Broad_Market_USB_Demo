/****************************************************************************/
/**
 *
 * @file lsc_endpoint.h
 * @addtogroup lscusb Overview
 * @{
 *
 *
 *
 *****************************************************************************/

#ifndef LSC_ENDPOINT_H_
#define LSC_ENDPOINT_H_

#ifdef __cplusplus
extern "C" {
#endif

/***************************** Include Files *********************************/

/**************************** Type Definitions *******************************/

/************************** Constant Definitions *****************************/

/* Device Generic Command Register */
#define LSC_DGCMD_SET_LMP                   0x00000001 /**< Set LMP */
#define LSC_DGCMD_SET_PERIODIC_PAR          0x00000002 /**< Set Periodic Parameters */
#define LSC_DGCMD_XMIT_FUNCTION             0x00000003 /**< Transmit Function */

/* These apply for core versions 1.94a and later */
#define LSC_DGCMD_SET_SCRATCHPAD_ADDR_LO    0x00000004 /**< Set Scratchpad Buffer Array Address Lo */
#define LSC_DGCMD_SET_SCRATCHPAD_ADDR_HI    0x00000005 /**< Set Scratchpad Buffer Array Address Hi */

#define LSC_DGCMD_SELECTED_FIFO_FLUSH       0x00000009 /**< Selected FIFO Flush */
#define LSC_DGCMD_ALL_FIFO_FLUSH            0x0000000a /**< All FIFO Flush */
#define LSC_DGCMD_SET_ENDPOINT_NRDY         0x0000000c /**< Set Endpoint NRDY */
#define LSC_DGCMD_RUN_SOC_BUS_LOOPBACK      0x00000010 /**< Run SoC Bus LoopBack Test */

#define LSC_DGCMD_STATUS(n)                 (((uint32_t)(n) >> 15) & 1) /**< Command Status */
#define LSC_DGCMD_CMDACT                    0x00000400 /**< Command Active - bit 10 */
#define LSC_DGCMD_CMDIOC                    0x00000100 /**< Command Interrupt on Complete - bit 8 */

/* Device Generic Command Parameter Register */
#define LSC_DGCMDPAR_FORCE_LINKPM_ACCEPT    (0x00000001 << 0) /**< Link PM acceept */
#define LSC_DGCMDPAR_FIFO_NUM(n)            ((uint32_t)(n) << 0) /**< FIFO NUM */
#define LSC_DGCMDPAR_RX_FIFO                (0x00000000 << 5) /**< RX FIFO */
#define LSC_DGCMDPAR_TX_FIFO                (0x00000001 << 5) /**< TX FIFO */
#define LSC_DGCMDPAR_LOOPBACK_DIS           (0x00000000 << 0) /**< Loopback disable */
#define LSC_DGCMDPAR_LOOPBACK_ENA           (0x00000001 << 0) /**< Loopback enable */

/* Device Endpoint Command Register */
#define LSC_DEPCMD_PARAM_SHIFT              16 /**< Command parameter shift by 16 bit */
#define LSC_DEPCMD_PARAM(x)                 ((uint32_t)(x) << LSC_DEPCMD_PARAM_SHIFT)
/**< Command Parameters
 *   Or Event Parameters
 */
#define LSC_DEPCMD_GET_RSC_IDX(x)           (((uint32_t)(x) >> LSC_DEPCMD_PARAM_SHIFT) & \
                                                (uint32_t)0x0000007f) /**< Transfer Resource Index */
#define LSC_DEPCMD_STATUS(x)                (((uint32_t)(x) >> 12) & (uint32_t)0xF) /**< Command Status */
#define LSC_DEPCMD_HIPRI_FORCERM            0x00000800 /**< HighPriority/ForceRM bit 11 */
#define LSC_DEPCMD_CMDACT                   0x00000400 /**< Command Active bit 10U */
#define LSC_DEPCMD_CMDIOC                   0x00000100 /**< Command Interrupt on Complete bit 8U */

#define LSC_DEPCMD_DEPSTARTCFG              0x00000009 /**< Start New Configuration */
#define LSC_DEPCMD_ENDTRANSFER              0x00000008 /**< End Transfer */
#define LSC_DEPCMD_UPDATETRANSFER           0x00000007 /**< Update Transfer */
#define LSC_DEPCMD_STARTTRANSFER            0x00000006 /**< Start Transfer */
#define LSC_DEPCMD_CLEARSTALL               0x00000005 /**< Clear Stall */
#define LSC_DEPCMD_SETSTALL                 0x00000004 /**< Set Stall */
#define LSC_DEPCMD_GETEPSTATE               0x00000003 /**< Get Endpoint State */
#define LSC_DEPCMD_SETTRANSFRESOURCE        0x00000002 /**< Set Endpoint Transfer Resource Configuration */
#define LSC_DEPCMD_SETEPCONFIG              0x00000001 /**< Set Endpoint Configuration */

/* The EP number goes 0..31 so ep0 is always out and ep1 is always in */
#define LSC_DALEPENA_EP(n)                  ((uint32_t)0x00000001 << (n))
/**< Device Active USB Endpoint
 *   Enable Register
 */

#define LSC_DEPCFG_INT_NUM(n)               ((uint32_t)(n) << 0) /**< Interrupt number */
#define LSC_DEPCFG_XFER_COMPLETE_EN         0x00000100 /**< XferComplete Enable bit 8 */
#define LSC_DEPCFG_XFER_IN_PROGRESS_EN      0x00000200 /**< XferInProgress Enable bit 9 */
#define LSC_DEPCFG_XFER_NOT_READY_EN        0x00000400 /**< XferNotReady Enable bit 10 */
#define LSC_DEPCFG_FIFO_ERROR_EN            0x00000800 /**< FIFO error Enable bit 11 */
#define LSC_DEPCFG_STREAM_EVENT_EN          0x00002000 /**< stream event Enable  bit 13 */
#define LSC_DEPCFG_BINTERVAL_M1(n)          ((uint32_t)(n) << 16) /**< BInterval */
#define LSC_DEPCFG_STREAM_CAPABLE           0x01000000 /**< Indicates this endpoint is stream-capable bit 24 */
#define LSC_DEPCFG_EP_NUMBER(n)             ((uint32_t)(n) << 25) /**< USB Endpoint Number */
#define LSC_DEPCFG_BULK_BASED               0x40000000 /**< Bulk based bit 30 */
#define LSC_DEPCFG_FIFO_BASED               0x80000000 /**< FIFO based bit 31 */

/* DEPCFG parameter 0 */
#define LSC_DEPCFG_EP_TYPE(n)               ((uint32_t)(n) << 1) /**< Endpoint Type */
#define LSC_DEPCFG_MAX_PACKET_SIZE(n)       ((uint32_t)(n) << 3) /**< Maximum Packet Size */
#define LSC_DEPCFG_FIFO_NUMBER(n)           ((uint32_t)(n) << 17) /**< FIFO Number */
#define LSC_DEPCFG_BURST_SIZE(n)            ((uint32_t)(n) << 22) /**< Burst Size 0: Burst length = 1, and so on, up to 16. */

#define LSC_DEPCFG_DATA_SEQ_NUM(n)          ((uint32_t)(n) << 26) /**< Data sequence number */
/* This applies for core versions earlier than 1.94a */
#define LSC_DEPCFG_IGN_SEQ_NUM              (0x00000001 << 31) /**< IGN sequence number*/
/* These apply for core versions 1.94a and later */
#define LSC_DEPCFG_ACTION_INIT              0x00000000 /**< Initialize endpoint state */
#define LSC_DEPCFG_ACTION_RESTORE           0x40000000 /**< Restore endpoint state bit 30 */
#define LSC_DEPCFG_ACTION_MODIFY            0x80000000 /**< Modify endpoint state bit 30 */

/* DEPXFERCFG parameter 0 */
#define LSC_DEPXFERCFG_NUM_XFER_RES(n)      ((uint32_t)(n) & (uint32_t)0xFFFF) /**< parameter0 transfer number */

#define LSC_DEPCMD_TYPE_BULK                2 /**< Bulk Type */
#define LSC_DEPCMD_TYPE_INTR                3 /**< Interrupt Type */

/* TRB Length, PCM and Status */
#define LSC_TRB_SIZE_MASK                   (0x00ffffff) /**< TRB size mask */
#define LSC_TRB_SIZE_LENGTH(n)              ((uint32_t)(n) & LSC_TRB_SIZE_MASK) /**< TRB length */
#define LSC_TRB_SIZE_PCM1(n)                (((uint32_t)(n) & (uint32_t)0x03) << 24) /**< TRB PCM1 */
#define LSC_TRB_SIZE_TRBSTS(n)              (((uint32_t)(n) & ((uint32_t)0x0f << 28)) >> 28) /**< TRB status */

#define LSC_TRBSTS_OK                       0 /**< TRB Status OK */
#define LSC_TRBSTS_MISSED_ISOC              1 /**< TRB missed ISOC */
#define LSC_TRBSTS_SETUP_PENDING            2 /**< TRB Setup Pending */
#define LSC_TRB_STS_XFER_IN_PROG            4 /**< TRB Transfer In-Progress */

/* TRB Control */
#define LSC_TRB_CTRL_HWO                    ((uint32_t)0x00000001 << 0) /**< Indicates that hardware owns the TRB */
#define LSC_TRB_CTRL_LST                    ((uint32_t)0x00000001 << 1) /**< XferComplete event */
#define LSC_TRB_CTRL_CHN                    ((uint32_t)0x00000001 << 2) /**< Chain Buffers */
#define LSC_TRB_CTRL_CSP                    ((uint32_t)0x00000001 << 3) /**< Continue on Short Packet */
#define LSC_TRB_CTRL_TRBCTL(n)              (((uint32_t)(n) & (uint32_t)0x3F) << 4) /**< TRB Control Stage */
#define LSC_TRB_CTRL_ISP_IMI                0x00000400 /**< Interrupt on Missed ISOC - bit 10 */
#define LSC_TRB_CTRL_IOC                    0x00000800 /**< Interrupt on Complete - bit 11 */
#define LSC_TRB_CTRL_SID_SOFN(n)            (((uint32_t)(n) & (uint32_t)0xFFFF) << 14) /**< Stream ID / SOF Number */

#define LSC_TRBCTL_NORMAL                   LSC_TRB_CTRL_TRBCTL(1) /**< Normal (Control-Data-2+ / Bulk / Interrupt) */
#define LSC_TRBCTL_CONTROL_SETUP            LSC_TRB_CTRL_TRBCTL(2) /**< Control-Setup */
#define LSC_TRBCTL_CONTROL_STATUS2          LSC_TRB_CTRL_TRBCTL(3) /**< Control-Status-2 */
#define LSC_TRBCTL_CONTROL_STATUS3          LSC_TRB_CTRL_TRBCTL(4) /**< Control-Status-3 */
#define LSC_TRBCTL_CONTROL_DATA             LSC_TRB_CTRL_TRBCTL(5) /**< Control-Data */
#define LSC_TRBCTL_ISOCHRONOUS_FIRST        LSC_TRB_CTRL_TRBCTL(6) /**< Isochronous-First */
#define LSC_TRBCTL_ISOCHRONOUS              LSC_TRB_CTRL_TRBCTL(7) /**< Isochronous */
#define LSC_TRBCTL_LINK_TRB                 LSC_TRB_CTRL_TRBCTL(8) /**< Normal-ZLP */

#define MAX_BUFR_SIZE                    0x200  /**< Maximum TRB size firmware supports */
#ifdef __cplusplus
}
#endif

#endif /* LSC_ENDPOINT_H_ */

/** @} */
