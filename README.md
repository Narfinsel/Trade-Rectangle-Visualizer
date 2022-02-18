# Trade-Rectangle-Visualizer
Trade-Rectangle Visualizer is a utility class that helps algorithmic traders get a general idea about how well their EA is doing, just by having a quick glance at your chart, without the need to dig through trading logs and reports.

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


## 1. Intro
<strong>Motivation</strong> Many online traders preffer to automate their trading strategies, but they don't have good, reliable scripts, to help confidently detect candle-stick pattern like stars, engulfings and consolidation. I struggled with this alot and decided to make things easier for myself and other traders, by programming in and sharing this MQL5 Metatrader script.
<strong>Problem</strong> One of the biggest problems in trading with EAs (Expert Advisors/ trading bots) is finding reliable signals that can actually be used in code. There are many scripts in the marketplace that do visually idendify patterns on the chart, by drawing visual aids. But very few (if any) convert these candle-patterns into usable, code-ready objects, that can easily be incorporated as part of the internal making of an algorithm. Too many scripts only show patterns on the graphs, but that is useless for the trading bots, since they need objects from which to read data, to base decisions on.
<strong>Solution</strong> My script identifies reversal patterns, it converts them into objects stored in an array. There is an option to customize how rigid the pattern-detection should be, to mark out only the strongest reversal signals. Visual square markings can be customized as well (color, style and thickness), for bullish and bearish patterns. I even optimized memory usage, by making sure to delete older patterns, or broken ones. Reversal patterns have many attributes and my code can read, change, and distinguish reversals based on their properties - to decide which trading actions to undertake.


## 2. Table of Contents
1. [Intro](#1-intro)
2. [Table of Contents](#2-table-of-contents)
3. [Project Description](#3-project-description)
   - [Definition & Terminology](#definition--terminology)
4. [How to Install and Run the Project](#4-how-to-install-and-run-the-project)
5. [Configure the Properties and Functionality](#5-configure-the-properties-and-functionality)
6. [How to Use the Project](#6-how-to-use-the-project)
7. [Credits](#7-credits)
8. [License](#8-license)



## 3. Project Description

### Definitions



## 4. How to Install and Run the Project



## 5. Configure the Properties and Functionality



## 6. How to Use the Project



## 7. Credits



## 8. License
