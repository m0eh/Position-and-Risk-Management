//+------------------------------------------------------------------+
//|                                                       Open Long  |
//|                              Copyright © 2011, BeyondMarkets.com |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2011, BeyondMarkets.com"
#property show_inputs
#include <WinUser32.mqh>
//+------------------------------------------------------------------+
//| script program start function                                    |
//+------------------------------------------------------------------+

extern bool   MicroOrdersAllowed = true;
extern bool   MiniOrdersAllowed = true;

extern bool   UseMoneyManagement = true;
extern double RiskPercent = 0.5;
extern double OrderVolume = 0.01;
extern int          Magic = 0;

int start()
  { 
  if ((ObjectFind("StopLine1") >= 0) || (ObjectFind("StopLine2") >= 0)) {
    double StopLine1 = 99999999;
    double StopLine2 = 99999999;
    if (ObjectFind("StopLine1") >= 0) StopLine1 = ObjectGet("StopLine1", OBJPROP_PRICE1);
    if (ObjectFind("StopLine2") >= 0) StopLine2 = ObjectGet("StopLine2", OBJPROP_PRICE1);
    double StopLoss = 0;
    double TakeProfit = 0;
    double Risk = RiskPercent / 100;
    int OrdersizeAllowed = 0;
    double Lots = OrderVolume;
    double Entry = 0;
    int Mode = 0;
    if (ObjectFind("EntryLine1") >= 0) {
      Entry = NormalizeDouble(ObjectGet("EntryLine1", OBJPROP_PRICE1),Digits);
      if (Ask > Entry) Mode = OP_BUYLIMIT;
      if (Ask < Entry) Mode = OP_BUYSTOP;
    } else {
      Mode = OP_BUY;
      Entry = Ask;
    }       
    if (StopLine1 > StopLine2) { StopLoss = StopLine2; TakeProfit = StopLine1; } else { StopLoss = StopLine1; TakeProfit = StopLine2; }   
    if (TakeProfit == 99999999) TakeProfit = 0;
    if (MiniOrdersAllowed) OrdersizeAllowed=1;
    if (MicroOrdersAllowed) OrdersizeAllowed=2;    
    if (UseMoneyManagement) Lots = NormalizeDouble(AccountBalance()*Risk/(Entry-StopLoss)*Point/(MarketInfo(Symbol(), MODE_TICKVALUE)),OrdersizeAllowed);
    if ((Lots < 0.01&&MicroOrdersAllowed) || (Lots < 0.1&&MiniOrdersAllowed&&MicroOrdersAllowed==false))
    {
      Comment("Your order volume is too small to place an order!");
      return(0);
    }
    double RR = (TakeProfit-Entry)/(Entry-StopLoss);
    double PossibleLoss = Lots*(Entry-StopLoss)/Point*MarketInfo(Symbol(), MODE_TICKVALUE);
    double PossibleProfit = Lots*(TakeProfit-Entry)/Point*MarketInfo(Symbol(), MODE_TICKVALUE);
    int confirmdialog = MessageBox("Order Size: "+DoubleToStr(Lots,2)+", R/R: "+DoubleToStr(RR,2)+" (Risk: "+DoubleToStr(PossibleLoss,2)+" ("+DoubleToStr(PossibleLoss/AccountBalance()*100,2)+"%), Reward: "+DoubleToStr(PossibleProfit,2)+" ("+DoubleToStr(PossibleProfit/AccountBalance()*100,2)+"%))","Are you sure you want to place this BUY order?",MB_YESNO|MB_ICONQUESTION);
    if (confirmdialog == IDYES) double ticket = OrderSend(Symbol(),Mode, Lots, Entry, 2, 0, 0, "",Magic, NULL, Green); else return (0);
    if (ticket > 0) {
      OrderSelect(ticket,SELECT_BY_TICKET);
      OrderModify(OrderTicket(),OrderOpenPrice(),StopLoss,TakeProfit,0,Green);
      if (ObjectFind("StopLine1") >= 0) ObjectDelete("StopLine1");
      if (ObjectFind("StopLine2") >= 0) ObjectDelete("StopLine2");
      if (ObjectFind("EntryLine1") >= 0) ObjectDelete("EntryLine1");
      ObjectsRedraw();
    } else {  
      Print("Error opening order: ", GetLastError());
    }  
    
  }
   return(0);
  }
//+------------------------------------------------------------------+