`timescale 100 ps/100 ps
(* black_box_pad_pin="RESEXTUSB3,RESEXTUSB2,DP,DM,RXM,RXP,TXM,TXP,VBUS,ID,XOIN18,XOOUT18,REFINCLKEXTM,REFINCLKEXTP" *)module USB23 (
  USB_SUSPENDCLK,
  USB3_MCUCLK,
  USB_RESETN,
  USB3_SYSRSTN,
  USB2_RESET,
  LMMICLK,
  LMMIRESETN,
  LMMIREQUEST,
  LMMIWRRD_N,
  LMMIOFFSET,
  LMMIWDATA,
  LMMIRDATAVALID,
  LMMIREADY,
  LMMIRDATA,
  XMAWID,
  XMAWADDR,
  XMAWLEN,
  XMAWSIZE,
  XMAWBURST,
  XMAWLOCK,
  XMAWCACHE,
  XMAWPROT,
  XMAWVALID,
  XMAWMISC_INFO,
  XMAWREADY,
  XMWID,
  XMWVALID,
  XMWLAST,
  XMWDATA,
  XMWSTRB,
  XMWREADY,
  XMBID,
  XMBVALID,
  XMBRESP,
  XMBMISC_INFO,
  XMBREADY,
  XMARID,
  XMARVALID,
  XMARADDR,
  XMARLEN,
  XMARSIZE,
  XMARBURST,
  XMARLOCK,
  XMARCACHE,
  XMARPROT,
  XMARMISC_INFO,
  XMARREADY,
  XMRID,
  XMRVALID,
  XMRLAST,
  XMRDATA,
  XMRMISC_INFO,
  XMRRESP,
  XMRREADY,
  XMCSYSREQ,
  XMCSYSACK,
  XMCACTIVE,
  STARTRXDETU3RXDET,
  DISRXDETU3RXDET,
  DISRXDETU3RXDETACK,
  INTERRUPT,
  SS_RX_ACJT_EN,
  SS_RX_ACJT_ININ,
  SS_RX_ACJT_INIP,
  SS_RX_ACJT_INIT_EN,
  SS_RX_ACJT_MODE,
  SS_TX_ACJT_DRVEN,
  SS_TX_ACJT_DATAIN,
  SS_TX_ACJT_HIGHZ,
  SS_RX_ACJT_OUTN,
  SS_RX_ACJT_OUTP,
  SCANEN_CTRL,
  SCANEN_USB3PHY,
  SCANEN_CGUSB3PHY,
  SCANEN_USB2PHY,
  USBPHY_REFCLK_ALT,
  RESEXTUSB3,
  RESEXTUSB2,
  DP,
  DM,
  RXM,
  RXP,
  TXM,
  TXP,
  VBUS,
  ID,
  XOIN18,
  XOOUT18,
  REFINCLKEXTM,
  REFINCLKEXTP
)
;
input USB_SUSPENDCLK ;
input USB3_MCUCLK ;
input USB_RESETN ;
input USB3_SYSRSTN ;
input USB2_RESET ;
input LMMICLK ;
input LMMIRESETN ;
input LMMIREQUEST ;
input LMMIWRRD_N ;
input [14:0] LMMIOFFSET ;
input [31:0] LMMIWDATA ;
output LMMIRDATAVALID ;
output LMMIREADY ;
output [31:0] LMMIRDATA ;
output [7:0] XMAWID ;
output [31:0] XMAWADDR ;
output [7:0] XMAWLEN ;
output [2:0] XMAWSIZE ;
output [1:0] XMAWBURST ;
output [1:0] XMAWLOCK ;
output [3:0] XMAWCACHE ;
output [2:0] XMAWPROT ;
output XMAWVALID ;
output [3:0] XMAWMISC_INFO ;
input XMAWREADY ;
output [7:0] XMWID ;
output XMWVALID ;
output XMWLAST ;
output [63:0] XMWDATA ;
output [7:0] XMWSTRB ;
input XMWREADY ;
input [7:0] XMBID ;
input XMBVALID ;
input [1:0] XMBRESP ;
input [3:0] XMBMISC_INFO ;
output XMBREADY ;
output [7:0] XMARID ;
output XMARVALID ;
output [31:0] XMARADDR ;
output [7:0] XMARLEN ;
output [2:0] XMARSIZE ;
output [1:0] XMARBURST ;
output [1:0] XMARLOCK ;
output [3:0] XMARCACHE ;
output [2:0] XMARPROT ;
output [3:0] XMARMISC_INFO ;
input XMARREADY ;
input [7:0] XMRID ;
input XMRVALID ;
input XMRLAST ;
input [63:0] XMRDATA ;
input [3:0] XMRMISC_INFO ;
input [1:0] XMRRESP ;
output XMRREADY ;
input XMCSYSREQ ;
output XMCSYSACK ;
output XMCACTIVE ;
input STARTRXDETU3RXDET ;
input DISRXDETU3RXDET ;
output DISRXDETU3RXDETACK ;
output INTERRUPT ;
input SS_RX_ACJT_EN ;
input SS_RX_ACJT_ININ ;
input SS_RX_ACJT_INIP ;
input SS_RX_ACJT_INIT_EN ;
input SS_RX_ACJT_MODE ;
input SS_TX_ACJT_DRVEN ;
input SS_TX_ACJT_DATAIN ;
input SS_TX_ACJT_HIGHZ ;
output SS_RX_ACJT_OUTN ;
output SS_RX_ACJT_OUTP ;
input SCANEN_CTRL ;
input SCANEN_USB3PHY ;
input SCANEN_CGUSB3PHY ;
input SCANEN_USB2PHY ;
input USBPHY_REFCLK_ALT ;
inout RESEXTUSB3 /* synthesis syn_tristate = 1 */ ;
inout RESEXTUSB2 /* synthesis syn_tristate = 1 */ ;
inout DP /* synthesis syn_tristate = 1 */ ;
inout DM /* synthesis syn_tristate = 1 */ ;
input RXM ;
input RXP ;
output TXM ;
output TXP ;
inout VBUS /* synthesis syn_tristate = 1 */ ;
input ID ;
input XOIN18 ;
output XOOUT18 ;
input REFINCLKEXTM ;
input REFINCLKEXTP ;
endmodule /* USB23 */

module PLL (
  INTFBKOP,
  INTFBKOS,
  INTFBKOS2,
  INTFBKOS3,
  INTFBKOS4,
  INTFBKOS5,
  DIR,
  DIRSEL,
  LOADREG,
  DYNROTATE,
  LMMICLK,
  LMMIRESET_N,
  LMMIREQUEST,
  LMMIWRRD_N,
  LMMIOFFSET,
  LMMIWDATA,
  LMMIRDATA,
  LMMIRDATAVALID,
  LMMIREADY,
  PLLPOWERDOWN_N,
  REFCK,
  CLKOP,
  CLKOS,
  CLKOS2,
  CLKOS3,
  CLKOS4,
  CLKOS5,
  ENCLKOP,
  ENCLKOS,
  ENCLKOS2,
  ENCLKOS3,
  ENCLKOS4,
  ENCLKOS5,
  FBKCK,
  INTLOCK,
  LEGACY,
  LEGRDYN,
  LOCK,
  PFDDN,
  PFDUP,
  PLLRESET,
  STDBY,
  REFMUXCK,
  REGQA,
  REGQB,
  REGQB1,
  CLKOUTDL,
  ROTDEL,
  DIRDEL,
  ROTDELP1,
  GRAYTEST,
  BINTEST,
  DIRDELP1,
  GRAYACT,
  BINACT
)
;
output INTFBKOP ;
output INTFBKOS ;
output INTFBKOS2 ;
output INTFBKOS3 ;
output INTFBKOS4 ;
output INTFBKOS5 ;
input DIR ;
input [2:0] DIRSEL ;
input LOADREG ;
input DYNROTATE ;
input LMMICLK ;
input LMMIRESET_N ;
input LMMIREQUEST ;
input LMMIWRRD_N ;
input [6:0] LMMIOFFSET ;
input [7:0] LMMIWDATA ;
output [7:0] LMMIRDATA ;
output LMMIRDATAVALID ;
output LMMIREADY ;
input PLLPOWERDOWN_N ;
input REFCK ;
output CLKOP ;
output CLKOS ;
output CLKOS2 ;
output CLKOS3 ;
output CLKOS4 ;
output CLKOS5 ;
input ENCLKOP ;
input ENCLKOS ;
input ENCLKOS2 ;
input ENCLKOS3 ;
input ENCLKOS4 ;
input ENCLKOS5 ;
input FBKCK ;
output INTLOCK ;
input LEGACY ;
output LEGRDYN ;
output LOCK ;
output PFDDN ;
output PFDUP ;
input PLLRESET ;
input STDBY ;
output REFMUXCK ;
output REGQA ;
output REGQB ;
output REGQB1 ;
output CLKOUTDL ;
input ROTDEL ;
input DIRDEL ;
input ROTDELP1 ;
input [4:0] GRAYTEST ;
input [1:0] BINTEST ;
input DIRDELP1 ;
input [4:0] GRAYACT ;
input [1:0] BINACT ;
endmodule /* PLL */

module CCU2 (
  A0,
  B0,
  C0,
  D0,
  A1,
  B1,
  C1,
  D1,
  CIN,
  COUT,
  S0,
  S1
)
;
input A0 ;
input B0 ;
input C0 ;
input D0 ;
input A1 ;
input B1 ;
input C1 ;
input D1 ;
input CIN ;
output COUT ;
output S0 ;
output S1 ;
parameter INIT0="0x0000";
parameter INIT1="0x0000";
parameter INJECT="NO";
endmodule /* CCU2 */

module DCC (
  CE,
  CLKI,
  CLKO
)
;
input CE ;
input CLKI ;
output CLKO ;
endmodule /* DCC */

(* black_box_pad_pin="TDI,TCK,TMS,TDO" *)module JTAGH19 (
  TDI,
  TCK,
  TMS,
  TDO,
  JTCK,
  JTDI,
  JSHIFT,
  JUPDATE,
  JRSTN,
  JCE2,
  CDN,
  IP_ENABLE,
  ER2_TDO
)
;
input TDI ;
input TCK ;
input TMS ;
output TDO ;
output JTCK ;
output JTDI ;
output JSHIFT ;
output JUPDATE ;
output JRSTN ;
output JCE2 ;
output CDN ;
output [18:0] IP_ENABLE ;
input [18:0] ER2_TDO ;
endmodule /* JTAGH19 */

module LRAM (
  ADA,
  ADB,
  BENA_N,
  BENB_N,
  CEA,
  CEB,
  CLK,
  CSA,
  CSB,
  DIA,
  DIB,
  DOA,
  DOB,
  DPS,
  ERRDECA,
  ERRDECB,
  OCEA,
  OCEB,
  OEA,
  OEB,
  RSTA,
  RSTB,
  WEA,
  WEB,
  ERRDET,
  LRAMREADY
)
;
input [13:0] ADA ;
input [13:0] ADB ;
input [3:0] BENA_N ;
input [3:0] BENB_N ;
input CEA ;
input CEB ;
input CLK ;
input CSA ;
input CSB ;
input [31:0] DIA ;
input [31:0] DIB ;
output [31:0] DOA ;
output [31:0] DOB ;
input DPS ;
output [1:0] ERRDECA ;
output [1:0] ERRDECB ;
input OCEA ;
input OCEB ;
output OEA ;
output OEB ;
input RSTA ;
input RSTB ;
input WEA ;
input WEB ;
output ERRDET ;
output LRAMREADY ;
endmodule /* LRAM */

