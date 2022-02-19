# Trade-Rectangle-Visualizer
Trade-Rectangle Visualizer is a utility class that makes automatic trading easy and seamless for online traders, by offering a general idea about how well their EA is doing, just by having a quick glance at the charts, without the need to read text-formatted trading logs, results, and reports.

<p align="left" dir="auto">
  <a target="_blank" rel="noopener noreferrer" href="/img/trades-visualizations_gy.gif">
    <img src="/img/trades-visualizations_gy.gif" alt="Trade Proffit and Loses Visualization in Green/Orange">
  </a>
</p>

<p align="left" dir="auto">
  <a target="_blank" rel="noopener noreferrer" href="/img/trades-visualizations_rb.gif">
    <img src="/img/trades-visualizations_rb.gif" alt="Trade Proffit and Loses Visualization in Blue/Red">
  </a>
</p>


## 1. Introduction
**Why did I start this project?** As an online Fx & stocks trader, I often automatize my strategies - off-loading the hard work to trading bots. But when I want to monitor my bots and get a quick glance at how well they are performing, things become more complicated. There is no easy way to view the profitability of EA bots, other than spending a few minutes inside the EA reports, graphs, and results.

**Why is this a problem?** When it comes to automated trading, the main thing you want to know is how profitable your strategy / Expert Advisor (EA) are. How many recent wins and loses did it record. But this information is burried inside tester sub-windows (reports, results, graphs). If you have dozens of bots running simultanously, going into each of them is time-consuming, frustrating, and non-user friendly.

**How does my script make your life easier?** Instead of digging through countless tabs and sub-windows on dozens of charts, my script draws coloured rectangles and lines displaying profitable trades and loses directly on the graph. Just switch between your instrument charts to see the recents profits, loses, trading statistics.
<div markdown="1">Have **fun!**</div>

## 2. Table of Contents
1. [Introduction](#1-introduction)
2. [Table of Contents](#2-table-of-contents)
3. [Project Description](#3-project-description)
   - [Definitions](#definitions)
4. [How to Install and Run the Project](#4-how-to-install-and-run-the-project)
5. [Configure the Properties and Functionality](#5-configure-the-properties-and-functionality)
6. [How to Use the Project](#6-how-to-use-the-project)
7. [Credits](#7-credits)
8. [License](#8-license)



## 3. Project Description

### Definitions


## 4. How to Install and Run the Project
**Step 1.** Include the class file in your trading robot. The file-path (inside the "#include" preprocessor directive) might change depending on your folder structure or where you place the file:

```MQL5
  #include <__SimonG\Helpers\TradeRectVisualizer.mqh>
```
**Step 2.** Declare a global or local variable of type *TradeRectVisualizer*: 
```MQL5
  TradeRectVisualizer * rectVisualizer;
```


**Step 3.** Initialize the TradeRectVisualizer object. The best place for this is inside the OnInit() function.
```MQL5
int OnInit(){
   rectVisualizer = new TradeRectVisualizer();
   rectVisualizer.setWhatToDraw (true, true);
   //rectVisualizer.setTradeArrowProperties (clrDeepPink, clrDarkTurquoise, 3);
   //rectVisualizer.setTradeRectProperties (clrPink, clrPaleTurquoise, true, true, 2);
   //rectVisualizer.setTradeArrowProperties (clrDarkOrange, clrGreen, 3);
   //rectVisualizer.setTradeRectProperties (clrPeachPuff, clrLightGreen, true, true, 2);
   rectVisualizer.setTradeArrowProperties (clrRed, clrRoyalBlue, 3);
   rectVisualizer.setTradeRectProperties (clrTomato, clrDeepSkyBlue, true, true, 2);
}
```
  
  
**Step 4.** Set-up a code sequence that uses the TradeRectVisualizer object immediatly after a trade closes, either in loss or profit:
```MQL5
static int currentOrderTicket = -1;

void check_condition_open_trade (){
   // Check if there is an open trade, or if it was closed as a result of hitting Stop Loss
   static bool hasDrawnArrRect = false;
   if(OrderSelect(currentOrderTicket, SELECT_BY_TICKET) == true)
      if(OrderCloseTime() > 0){
         isThereAnOpenTrade = false;
         if(doGraphTradesArrRect == true && hasDrawnArrRect == false){
            rectVisualizer.vizualizeHalfHollowTradeRect (magicNumber, currentOrderTicket);
            //rectVisualizer.vizualizeFullyColoredTradeRect (magicNumber, currentOrderTicket);
            hasDrawnArrRect = true;
         }
      }
      else isThereAnOpenTrade = true;
   
   // Only check to open trade if no trade open yet
   if(isThereAnOpenTrade == false){
   
      conditionForBuying  = validateOpenBuy ();
      conditionForSelling = validateOpenSell ();
      double volume = 100;
      double stopLossPoints = 0.0020;
      double takeProffitMultiply = 2.0;
      int magicNumber = 18329;
      
      // OPEN BUY
      if( conditionForBuying == true ){
         double orderStopLoss   = Ask - stopLossPoints;
         double orderTakeProfit = Ask + (stopLossPoints * takeProffitMultiply);
         currentOrderTicket = OrderSend(Symbol(), OP_BUY, volume, Bid, 10, orderStopLoss, orderTakeProfit, "by me", magicNumber, clrTurquoise);
         if(OrderSelect(currentOrderTicket, SELECT_BY_TICKET) == true){
            isThereAnOpenTrade = true;
            hasDrawnArrRect = false;
         }
      }
      // OPEN SELL
      else if( conditionForSelling == true ){
         double orderStopLoss   = Bid + stopLossPoints;
         double orderTakeProfit = Bid - (stopLossPoints * takeProffitMultiply);
         currentOrderTicket = OrderSend(Symbol(), OP_SELL, volume, Bid, 10, orderStopLoss, orderTakeProfit, "by me", magicNumber, clrCrimson);
         if(OrderSelect(currentOrderTicket, SELECT_BY_TICKET) == true){
            isThereAnOpenTrade = true;
            hasDrawnArrRect = false;
         }
      }
   }
}
```


**Step 5.** Memory clean-up, object deletion. This step is necesary for high-performing scripts, otherwise the left-over objects will continue to live in MT4/MT5 memory a long time, or until you close the software.
```MQL5
void OnDeinit (const int reason){
   delete rectVisualizer;
}
```



## 5. Configure the Properties and Functionality
<table>
	<thead>
	  <tr>
		<th>Customization</th>
		<th>OPTION 1</th>
		<th>OPTION 2</th>
		<th>OPTION 3</th>
	  </tr>
	</thead>
	<tbody>
	  <tr>
		<td> <strong>Color Changes</strong> </td>
		<td> <img src="/img/settings/color-change-blue-red-250.png"><br> 
		     <i>Blue profits, red loses.</i><br>
		     <div markdown="1">
			**rectVisualizer.setTradeArrowProperties (clrRed, clrRoyalBlue, 3);** <br>
			```MQL5    
			rectVisualizer.setTradeRectProperties (clrTomato, clrDeepSkyBlue, true, true, 2);
			```
		     </div>
		</td>
		<td> <img src="/img/settings/color-change-green-orange-250.png"><br>
		     <i>Green profits, orange loses.</i><br>
		     <code>
			rectVisualizer.setTradeArrowProperties (clrDarkOrange, clrGreen, 3);<br>
			rectVisualizer.setTradeRectProperties (clrPeachPuff, clrLightGreen, true, true, 2);
		     </code>
		</td>
		<td> <img src="/img/settings/color-change-teal-pink-250.png"><br>
		     <i>Turqoise profits, pink loses.</i><br>
		     <code>
		   	rectVisualizer.setTradeArrowProperties (clrRed, clrRoyalBlue, 3);<br>
		   	rectVisualizer.setTradeRectProperties (clrTomato, clrDeepSkyBlue, true, true, 2);
		     </code>
		</td>
	  </tr>
	  <tr>
		<td> <strong>Draw Rect and Line</strong> </td>
		<td> <img src="/img/settings/draw-rect-and-line.png"><br>
		     <i>Draw Rectangle and line.</i><br>
		     <code>
			rectVisualizer.setWhatToDraw (true, true);
		     </code>
		</td>
		<td> <img src="/img/settings/draw-only-lines.png"><br>
		     <i>Draw only lines.</i><br>
		     <code>
			rectVisualizer.setWhatToDraw (true, false);
		     </code>		
		</td>
		<td> <img src="/img/settings/draw-only-rect.png"><br>
		     <i>Draw only rectangle.</i><br>
		     <code>
		   	rectVisualizer.setWhatToDraw (false, true);
		     </code>		
		</td>
	  </tr>	  
	</tbody>
</table>




## 6. How to Use the Project
The _How to Install_ section offers a great example on how to use this utility class.
| DEFAULT SCENARIO w/o SCRIPT                                                              | OPTIMIZED VISUALS with MY SCRIPT                                                                    |
| :---                                                                      | :---                                                                          	|
| <img src="/img/usage/default-trading-line.PNG"><br> <i>Can barely see the profits/loses directly on the graph. </i>   	| <img src="/img/usage/optimized-visuals-trading-line-rect.png"><br> <i>Trading rectangle visualized, easier to see profits and loses.</i>  |



## 7. Credits
I can't credit anyone directly, but this section seems appropriate because I owe special thanks to so many course & content creators, chanels, youtubers.
1. MQL4 Programming. Visit this [link](https://www.youtube.com/channel/UCIuhfiM34b2P8qv_HX_uwug/featured).
2. ForexBoat Team. Check out Kiril's course on [udemy](https://www.udemy.com/course/learn-mql4/).
These guys create amazing content and I have learned so much from them!


## 8. License
Feel free to use this project for yourself. Or to edit it, use bits of it. Do not commercialize it! My *Trade-Rectangle-Visualizer* project is licensed under the GNU AGPLv3 license. Check out the licence link to better understand what you can and cannot do with this code.


