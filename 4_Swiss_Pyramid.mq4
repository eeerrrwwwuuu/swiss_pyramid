//+------------------------------------------------------------------+
//|                                              RW_SwissPyramid.mq4 |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property script_show_inputs
//--- input parameters
input int      vNumberOfPositions=10;
input float    vPositionSize=0.01;
input string   vOperation="BUY"; // sell 
input int      vStaticSL=22;
input bool     vTakeProfit;
input string   vRectangle="Rectangle";
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  { 
  
   int Precision  = MarketInfo(Symbol(),MODE_DIGITS); 
   

   Print(vRectangle); 
     
   Print("PRECISION "    + Precision);
        
   Print( ObjectFind(0, vRectangle) ); 
   
   if ( ObjectFind(0, vRectangle) == 0)
   {     
        double vTopPrice    =  NormalizeDouble(ObjectGetDouble(0,vRectangle, OBJPROP_PRICE1),Precision);
        double vBottomPrice =  NormalizeDouble(ObjectGetDouble(0,vRectangle, OBJPROP_PRICE2),Precision);
        
        // possibility to draw rectangle in both directions 
        if(vBottomPrice > vTopPrice)
        {
         double cpy     = vBottomPrice;
         vBottomPrice   = vTopPrice;
         vTopPrice      = cpy;
        }
        
        double Size         =  NormalizeDouble(vTopPrice - vBottomPrice,Precision);
        double Step         =  NormalizeDouble((Size/vNumberOfPositions),Precision);
         
        
        double SLRange      =  NormalizeDouble( Size * ( vStaticSL * 0.01 ) , Precision ) ;
        
        // storing step size within magic number 
        int    MagicNumber  =  Step * 1000;
        
      
        Print("PRECISION "    + Precision);
        Print("TOP PRICE "    + vTopPrice);
        Print("BOTTOM PRICE " + vBottomPrice);
        Print("SIZE "         + Size);
        Print("STEP "         + Step);
        Print("SL RANGE     " + SLRange) ;
        
 
        for( int i = 0 ; i < vNumberOfPositions;  i++ )
        { 
           if( vOperation == "BUY" ){          
             OrderSend(Symbol(), 
               OP_BUYSTOP,
               vPositionSize, 
               NormalizeDouble(( vBottomPrice + (i * Step)),Precision), // open price 
               2,                       
               NormalizeDouble( (vBottomPrice - SLRange), Precision) ,   // sl range  
               vTakeProfit ? NormalizeDouble(vTopPrice, Precision) : 0 ,
               DoubleToString( Step ), 
               MagicNumber, 
               NULL, 
               Red
              );
           }else{ // SELL       
             OrderSend(Symbol(), 
               OP_SELLSTOP,
               vPositionSize, 
               NormalizeDouble(( vTopPrice - (i * Step)),Precision), // open price 
               2,                       
               NormalizeDouble( (vTopPrice + SLRange), Precision) ,   // sl range  
               vTakeProfit ? NormalizeDouble(vBottomPrice, Precision) : 0  , 
               DoubleToString( Step ), 
               MagicNumber, 
               NULL, 
               Red
              );
           } 
           
        }
            
        Sleep(300);
        
        ObjectDelete( vRectangle );
   }
}