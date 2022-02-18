//+------------------------------------------------------------------+
//|                                          TradeRectVisualizer.mqh |
//|                                               Svetozar Pasulschi |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "SimonG"
#property link      "https://www.mql5.com"
#property strict

#define VIZ_TRADE_SL1 "SL1"
#define VIZ_TRADE_SL  "SL"
#define VIZ_TRADE_TP  "TP"

#define WINDOW_MAIN 0
#define CHART_ID 0

class TradeRectVisualizer{
   private:
      color colorArrowSL;
      color colorArrowTP;
      color colorRectSL;
      color colorRectTP;
      bool canDrawArrow;
      bool canDrawRectangle;
      int thicknessArrow;
      int thicknessRect;
      bool shouldFillRect;
      bool shouldUseBackColRect;
    
      void vizFullyColored (int tradeMagicNum, int tradeTicketNum, bool doDrawArrows, int thiccArrow, bool doDrawRectangleSlTp, bool doFill, bool withBackCol, int thiccRect);
      void vizHalfHallow (int tradeMagicNum, int tradeTicketNum, bool doDrawArrows, int thiccArrow, bool doDrawRectangleSlTp, bool doFill, bool withBackCol, int thiccRect);
      void drawArrowTrade( int magicNumer, int ticketNumer, datetime T0, double P0, datetime T1, double P1, color clr, int thickness, bool doShowAlert);
      void drawRectTrade( int magicNumer, int ticketNumer, string rectTradeType, datetime T0, double P0, datetime T1, double P1, color clr, int thickness, bool doFill, bool withBackCol, bool doShowAlert);
      bool createArrow(string nameArrow, datetime T0, double P0, datetime T1, double P1, color clr, int thickness, bool doShowAlert=false);
      bool createRentangle(string nameRect, datetime time1, double price1, datetime time2, double price2, color clr, ENUM_LINE_STYLE style=STYLE_SOLID, 
                     int width=1, bool fill=true, bool back=false, bool selectionMove=false, bool hidden=true, long z_order=0, bool doShowAlert=false);
      bool modifyRentangle(string nameRect, datetime newTime2, double newPrice2, bool doShowAlert=false);
      bool modifyRectTrade (int magicNumer, int ticketNumer, string rectTradeType, datetime newTime2, double newPrice2, bool doShowAlert=false);
      string composeArrowObjectName (int magicNumer, int ticketNumer);
      string composeRectObjectName (int magicNumer, int ticketNumer, string rectTradeType);
      
      
   public:
      ~TradeRectVisualizer();
      TradeRectVisualizer();
      void vizualizeHalfHollowTradeRect (int tradeMagicNum, int tradeTicketNum);
      void vizualizeFullyColoredTradeRect (int tradeMagicNum, int tradeTicketNum);
      void setTradeRectAndArrowColors (color slArrowColor, color slRectColor, color tpArrowColor, color tpRectColor);
      void setTradeArrowProperties (color slArrowColor, color tpArrowColor, int arrowThickness);
      void setTradeRectProperties (color slRectColor, color tpRectColor, bool doFillRect, bool doUseBackColRect, int rectThickness);
      void setWhatToDraw (bool doDrawArrow, bool doDrawRectangle);
};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
TradeRectVisualizer :: ~TradeRectVisualizer(){}
TradeRectVisualizer :: TradeRectVisualizer(){
   this.colorArrowSL = clrRed;
   this.colorRectSL = clrLightPink;
   this.colorArrowTP = clrForestGreen;
   this.colorRectTP = clrPaleTurquoise;
   this.canDrawArrow = true;
   this.thicknessArrow = 2;
   this.thicknessRect = 1;
   this.canDrawRectangle = true;
   this.shouldFillRect = true;
   this.shouldUseBackColRect = true;
}

void TradeRectVisualizer :: setTradeRectAndArrowColors (color slArrowColor, color slRectColor, color tpArrowColor, color tpRectColor){
   this.colorArrowSL = slArrowColor;
   this.colorRectSL = slRectColor;
   this.colorArrowTP = tpArrowColor;
   this.colorRectTP = tpRectColor;
}

void TradeRectVisualizer :: setTradeArrowProperties (color slArrowColor, color tpArrowColor, int arrowThickness){
   this.colorArrowSL = slArrowColor;
   this.colorArrowTP = tpArrowColor;
   this.thicknessArrow = arrowThickness;
}

void TradeRectVisualizer :: setTradeRectProperties (color slRectColor, color tpRectColor, bool doFillRect, bool doUseBackColRect, int rectThickness){
   this.colorRectSL = slRectColor;
   this.colorRectTP = tpRectColor;
   this.shouldFillRect = doFillRect;
   this.shouldUseBackColRect = doUseBackColRect;
   this.thicknessRect = rectThickness;
}

void TradeRectVisualizer :: setWhatToDraw (bool doDrawArrow, bool doDrawRectangle){
   this.canDrawArrow = doDrawArrow;
   this.canDrawRectangle = doDrawRectangle;
}

//+------------------------------------------------------------------------------------------------------------------------------+


// -------------------------------------------------- VISUALIZE RECT AND ARROW --------------------------------------------------+
// ------------------------------------------------------------------------------------------------------------------------------+
// @TESTED OK
void TradeRectVisualizer :: vizualizeHalfHollowTradeRect (int tradeMagicNum, int tradeTicketNum){
   this.vizHalfHallow (tradeMagicNum, tradeTicketNum, this.canDrawArrow, this.thicknessArrow, this.canDrawRectangle, this.shouldFillRect, this.shouldUseBackColRect, this.thicknessRect);
}

// @TESTED OK
void TradeRectVisualizer :: vizualizeFullyColoredTradeRect (int tradeMagicNum, int tradeTicketNum){
   this.vizFullyColored (tradeMagicNum, tradeTicketNum, this.canDrawArrow, this.thicknessArrow, this.canDrawRectangle, this.shouldFillRect, this.shouldUseBackColRect, this.thicknessRect);
}

// @TESTED OK
void TradeRectVisualizer :: vizFullyColored (int tradeMagicNum, int tradeTicketNum, bool doDrawArrows, int thiccArrow, bool doDrawRectangleSlTp, bool doFill, bool withBackCol, int thiccRect){
   bool doAlert = false;
   if(OrderMagicNumber() == tradeMagicNum){
      if(OrderSelect(tradeTicketNum, SELECT_BY_TICKET) == true){  // Order was selected
         if(OrderCloseTime() > 0){                             // Order was closed
            string nameLine = StringConcatenate( tradeMagicNum, "_",tradeTicketNum);
            if(doDrawArrows == true){
               if(OrderProfit() < 0.0)          // Loss
                  drawArrowTrade( tradeMagicNum, tradeTicketNum, OrderOpenTime(), OrderOpenPrice(), OrderCloseTime(), OrderClosePrice(), colorArrowSL, thiccArrow, doAlert);
               else if(OrderProfit() >= 0.0)    // Profit
                  drawArrowTrade( tradeMagicNum, tradeTicketNum, OrderOpenTime(), OrderOpenPrice(), OrderCloseTime(), OrderClosePrice(), colorArrowTP, thiccArrow, doAlert);
            }
            if(doDrawRectangleSlTp == true){
               if(OrderProfit() < 0.0){         // Loss
                  drawRectTrade( tradeMagicNum, tradeTicketNum, VIZ_TRADE_SL, OrderOpenTime(), OrderOpenPrice(), OrderCloseTime(), OrderStopLoss(), colorRectSL, thiccRect, doFill, withBackCol, doAlert);
                  if(OrderTakeProfit() != 0.0)
                     drawRectTrade( tradeMagicNum, tradeTicketNum, (VIZ_TRADE_TP +"a"), OrderOpenTime(), OrderOpenPrice(), OrderCloseTime(), OrderTakeProfit(), colorRectTP, thiccRect, doFill, withBackCol, doAlert);
               }
               else if(OrderProfit() >= 0.0){   // Profit
                  drawRectTrade( tradeMagicNum, tradeTicketNum, VIZ_TRADE_SL, OrderOpenTime(), OrderOpenPrice(), OrderCloseTime(), OrderStopLoss(), colorRectSL, thiccRect, doFill, withBackCol, doAlert);
                  drawRectTrade( tradeMagicNum, tradeTicketNum, (VIZ_TRADE_TP +"a"), OrderOpenTime(), OrderOpenPrice(), OrderCloseTime(), OrderClosePrice(), colorRectTP, thiccRect, doFill, withBackCol, doAlert);
               }
            }
         }  else  Alert(" Cannot visualize trade 3 - NOT CLOSED YET!!");
      } else  Alert(" Cannot visualize trade 2 - FAILED TO SELECT TICKET!!");
   } else  Alert(" Cannot visualize trade 1 - MISMATCHING MAGIC NUMBER!! -   ", OrderMagicNumber(), " vs ", tradeMagicNum);
}


// @TESTED OK
void TradeRectVisualizer :: vizHalfHallow (int tradeMagicNum, int tradeTicketNum, bool doDrawArrows, int thiccArrow, bool doDrawRectangleSlTp, bool doFill, bool withBackCol, int thiccRect){
   bool doAlert = false;
   if(OrderSelect(tradeTicketNum, SELECT_BY_TICKET) == true){  // Order was selected
      if(OrderMagicNumber() == tradeMagicNum){
         if(OrderCloseTime() > 0){                             // Order was closed
            string nameLine = StringConcatenate( tradeMagicNum, "_",tradeTicketNum);
            if(OrderProfit() < 0.0){         // Loss
               if(doDrawArrows == true)
                  drawArrowTrade( tradeMagicNum, tradeTicketNum, OrderOpenTime(), OrderOpenPrice(), OrderCloseTime(), OrderClosePrice(), colorArrowSL, thiccArrow, doAlert);
                  
               if(doDrawRectangleSlTp == true){
                  drawRectTrade( tradeMagicNum, tradeTicketNum, (VIZ_TRADE_SL +"a"), OrderOpenTime(), OrderOpenPrice(), OrderCloseTime(), OrderStopLoss(), colorRectSL, thiccRect, doFill, withBackCol, false);
                  if(OrderTakeProfit() > 0)
                     drawRectTrade( tradeMagicNum, tradeTicketNum, (VIZ_TRADE_TP +"b"), OrderOpenTime(), OrderOpenPrice(), OrderCloseTime(), OrderTakeProfit(), colorRectTP, thiccRect, false, false, false);
               }
            }
            else if(OrderProfit() >= 0.0){   // Profit
               if(doDrawArrows == true)
                  drawArrowTrade( tradeMagicNum, tradeTicketNum, OrderOpenTime(), OrderOpenPrice(), OrderCloseTime(), OrderClosePrice(), colorArrowTP, thiccArrow, doAlert);
               if(doDrawRectangleSlTp == true){
                  drawRectTrade( tradeMagicNum, tradeTicketNum, (VIZ_TRADE_SL +"b"), OrderOpenTime(), OrderOpenPrice(), OrderCloseTime(), OrderStopLoss(), colorRectSL, thiccRect, false, false, false);
                  drawRectTrade( tradeMagicNum, tradeTicketNum, (VIZ_TRADE_TP +"b"), OrderOpenTime(), OrderOpenPrice(), OrderCloseTime(), OrderClosePrice(), colorRectTP, thiccRect, doFill, withBackCol, false);
               }
            }
         } else  Alert(" Cannot visualize trade 3 - NOT CLOSED YET!!");
      } else  Alert(" Cannot visualize trade 2 - FAILED TO SELECT TICKET!!");
   } else  Alert(" Cannot visualize trade 1 - MISMATCHING MAGIC NUMBER!! -   ", OrderMagicNumber(), " vs ", tradeMagicNum);
}


// ------------------------------------------------------- DRAW FUNCTIONS -------------------------------------------------------+
// ------------------------------------------------------------------------------------------------------------------------------+

// @TESTED OK
void TradeRectVisualizer :: drawArrowTrade( int magicNumer, int ticketNumer, datetime T0, double P0, datetime T1, double P1, color clr, int thickness, bool doShowAlert){
   string nameArrow = composeArrowObjectName( magicNumer, ticketNumer);
   if( !createArrow( nameArrow, T0, P0, T1, P1, clr, thickness, doShowAlert) )
      Alert("Did not create arrow named - ", nameArrow);
}

// @TESTED OK
void TradeRectVisualizer :: drawRectTrade(int magicNumer, int ticketNumer, string rectTradeType, datetime T0, double P0, datetime T1, double P1, color clr, int thickness, bool doFill, bool withBackCol, bool doShowAlert){
   string nameRect = composeRectObjectName( magicNumer, ticketNumer, rectTradeType);
   if(doShowAlert)
      Alert(" D R A W --------- RECT   Ticket=", ticketNumer,"   Type=", rectTradeType," is     :     ", nameRect);
   if( !createRentangle( nameRect, T0, P0, T1, P1, clr, STYLE_SOLID, thickness, doFill, withBackCol, false, false, 0, doShowAlert) )
      Alert("Did not create rectangle named - ", nameRect);
}

string TradeRectVisualizer :: composeArrowObjectName (int magicNumer, int ticketNumer){
   return StringConcatenate( "ARROW", "__", "MN", magicNumer, "__", "TRADE", ticketNumer);
}
string TradeRectVisualizer :: composeRectObjectName (int magicNumer, int ticketNumer, string rectTradeType){
   return StringConcatenate( "RECT", "__", "MN", magicNumer, "__", "TRADE", ticketNumer, "__", rectTradeType);
}

bool TradeRectVisualizer :: modifyRectTrade (int magicNumer, int ticketNumer, string rectTradeType, datetime newTime2, double newPrice2, bool doShowAlert=false){
   string nameRect = composeRectObjectName( magicNumer, ticketNumer, rectTradeType);
   if(doShowAlert)
      Alert(" M O D I F Y --------- RECT   Ticket=", ticketNumer,"   Type=", rectTradeType," is     :     ", nameRect);
   if( !modifyRentangle( nameRect, newTime2, newPrice2, doShowAlert=false) )
      return false;
   return true;
}


// @TESTED OK
bool TradeRectVisualizer :: createArrow (string nameArrow, datetime T0, double P0, datetime T1, double P1, color clr, int thickness, bool doShowAlert=false){
   bool ray = false;
   if(ObjectMove(nameArrow, 0, T0, P0))
      ObjectMove(nameArrow, 1, T1, P1);
   else if( !ObjectCreate(nameArrow, OBJ_TREND, WINDOW_MAIN, T0, P0, T1, P1) && doShowAlert==true){
      if(doShowAlert==true)         Alert("ObjectCreate(",nameArrow,",TREND) failed: ", GetLastError() );
      return(false);
   }
   ObjectSet( nameArrow, OBJPROP_RAY, ray);
   ObjectSet(nameArrow, OBJPROP_WIDTH, thickness);
   ObjectSet(nameArrow, OBJPROP_COLOR, clr);
   string label = StringConcatenate(DoubleToStr(P0, Digits), " to ", DoubleToStr(P1, Digits));
   ObjectSetText(nameArrow, label, 10);
   return(true); 
}

// @TESTED OK
bool TradeRectVisualizer :: createRentangle (string nameRect, datetime time1, double price1, datetime time2, double price2, color clr, ENUM_LINE_STYLE style=STYLE_SOLID, 
                                             int width=1, bool fill=true, bool back=false, bool selectionMove=false, bool hidden=true, long z_order=0, bool doShowAlert=false){
   ResetLastError();    //--- reset the error value
   if( !ObjectCreate( nameRect, OBJ_RECTANGLE, WINDOW_MAIN, time1, price1, time2, price2) ){       //--- create a rectangle by the given coordinates
         if(doShowAlert==true)  Alert(__FUNCTION__, ": failed to create a rectangle! Error code = ", GetLastError()); 
         return(false); 
   }
   ObjectSetInteger(CHART_ID, nameRect, OBJPROP_COLOR, clr);      //--- set rectangle color
   ObjectSetInteger(CHART_ID, nameRect, OBJPROP_STYLE, style);    //--- set the style of rectangle lines
   ObjectSetInteger(CHART_ID, nameRect, OBJPROP_WIDTH, width);    //--- set width of the rectangle lines
   ObjectSetInteger(CHART_ID, nameRect, OBJPROP_FILL, fill);      //--- enable (true) or disable (false) the mode of filling the rectangle
   ObjectSetInteger(CHART_ID, nameRect, OBJPROP_BACK, back);      //--- display in the foreground (false) or background (true)
   //--- enable (true) or disable (false) the mode of highlighting the rectangle for moving 
   //--- when creating a graphical object using ObjectCreate function, the object cannot be 
   //--- highlighted and moved by default. Inside this method, selection parameter 
   //--- is true by default making it possible to highlight and move the object 
   ObjectSetInteger(CHART_ID, nameRect, OBJPROP_SELECTABLE, selectionMove);
   ObjectSetInteger(CHART_ID, nameRect, OBJPROP_SELECTED, selectionMove);
   ObjectSetInteger(CHART_ID, nameRect, OBJPROP_HIDDEN, hidden);  //--- hide (true) or display (false) graphical object name in the object list
   ObjectSetInteger(CHART_ID, nameRect, OBJPROP_ZORDER, z_order); //--- set the priority for receiving the event of a mouse click in the chart
   return(true);                                                  //--- successful execution 
} 

bool TradeRectVisualizer :: modifyRentangle (string nameRect, datetime newTime2, double newPrice2, bool doShowAlert=false){    
   ResetLastError();    //--- reset the error value
   if( ObjectFind( CHART_ID, nameRect) < 0){                      //--- check if rectangle exists
      if(doShowAlert==true)  Alert(__FUNCTION__, ": failed to find a rectangle! Error code = ", GetLastError()); 
      return(false);    
   }
   ObjectMove(CHART_ID, nameRect, 1, newTime2, newPrice2);
   return(true);                                                  //--- successful execution 
} 


// ---------------------------------------------------------------------------------------------------------------
// ---------------------------------------------------------------------------------------------------------------



/*+------------------------------------------------------------------+
//|                            HOW TO                                |
//+------------------------------------------------------------------+

1. Include in file:
      #include <__SimonG\Helpers\TradeRectVisualizer.mqh>

2. Create a public EA variable of type TradeRectVisualizer:
      TradeRectVisualizer * rectVisualizer;

3. Instantiante and customize in OnInit():
      rectVisualizer = new TradeRectVisualizer();
      rectVisualizer.setWhatToDraw (true, true);
      rectVisualizer.setTradeArrowProperties (clrDeepPink, clrDarkTurquoise, 3);
      rectVisualizer.setTradeRectProperties (clrLightPink, clrPaleTurquoise, true, true, 2);

4. In your onTick() or any function :
         if(OrderSelect(currentOrderTicket, SELECT_BY_TICKET) == true)
            if(OrderCloseTime() > 0){
               isThereAnOpenTrade = false;
               if(doGraphTradesArrRect == true && hasDrawnArrRect == false){
                  rectVisualizer.vizualizeHalfHollowTradeRect ( magicNumber, currentOrderTicket);
                  // rectVisualizer.vizualizeFullyColoredTradeRect ( magicNumber, currentOrderTicket);
                  hasDrawnArrRect = true;
               }
            }else isThereAnOpenTrade = true;
      ...
      And then, when you open a new trade:
         OrderSend(..........);
         hasDrawnArrRect = false;
*/