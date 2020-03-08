//+------------------------------------------------------------------+
//|                                               Close_All_Open.mq4 |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property script_show_inputs
//--- input parameters
input string   vCurrencyPair;
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart(){

   int total= OrdersTotal();
   int ticket;
   string curr = vCurrencyPair;
   
   
   StringToUpper( curr ) ; 
   
   bool result = false;
         
   for(int i=total-1;i>=0;i--){
      
         ticket = OrderSelect(i,SELECT_BY_POS);
         int type=OrderType();
         
         string symbol=OrderSymbol();
         StringToUpper(symbol);
          
         if( StringLen(curr) > 0  && curr  != symbol) 
            continue;
         
         
         
         
         switch(type)
         {
            //Close opened long positions
             case OP_BUY       : result = OrderClose( OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_BID), 5, Red );
             break;

            //Close opened short positions
            case OP_SELL      : result = OrderClose( OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_ASK), 5, Red );
            break;
         }
   
   }
   if(result == false){
      Alert("Order " , OrderTicket() , " failed to close. Error:" , GetLastError() );
      Sleep(1000);
   }
  

}
//+------------------------------------------------------------------+
