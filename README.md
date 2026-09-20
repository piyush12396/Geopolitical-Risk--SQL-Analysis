# Geopolitical Risk & Financial Market Analysis Using SQL

## Project Overview

This project analyzes the relationship between selected geopolitical events and financial market movements using SQL Server.

The analysis focuses on four financial markets:

- S&P 500
- NASDAQ
- Gold
- Oil

The project calculates daily returns, volatility, annualized volatility, and market movements around selected geopolitical events.

The analysis is descriptive and does not establish causal relationships.

---

## Project Objectives

- Analyze daily movements in major financial markets.
- Calculate market returns and volatility using SQL.
- Identify market movements around selected geopolitical events.
- Measure volatility during the five trading days following events.
- Compare event-day market behavior with normal trading days.
- Demonstrate practical SQL and financial-risk analysis skills.

---

## Markets Analyzed

| Market | Description |
|---|---|
| S&P 500 | U.S. equity market benchmark |
| NASDAQ | U.S. technology-focused equity index |
| Gold | Precious-metal market |
| Oil | Global energy market |

---

## Geopolitical Events

The dataset includes selected events from 2020–2023, including:

- COVID-19 pandemic
- Global market crisis
- Russia-Ukraine conflict
- Russia-related sanctions escalation
- Oil price shock
- Israel-Gaza conflict
- Middle East market uncertainty

---

## SQL Techniques Used

The project demonstrates:

- SELECT
- WHERE
- GROUP BY
- ORDER BY
- JOIN
- CROSS APPLY
- CASE
- EXISTS
- LAG()
- ROW_NUMBER()
- Common Table Expressions (CTEs)
- AVG()
- MAX()
- MIN()
- STDEV()
- SUM()
- LOG()
- EXP()
- TRY_CONVERT()
- SQL Views

---

## Key Analysis

### 1. Daily Returns

Daily returns were calculated using:

**Daily Return = (Today's Price − Previous Price) / Previous Price × 100**

### 2. Volatility

Daily volatility was calculated using standard deviation.

Annualized volatility was estimated using:

**Annualized Volatility = Daily Volatility × √252**

### 3. Event-Day Analysis

Market returns on geopolitical event dates were compared across the four markets.

### 4. Five-Day Event Window

The project analyzes the first five trading days following each geopolitical event.

This includes:

- Five-day cumulative returns
- Five-day volatility
- Market-specific reactions

### 5. Event-Day vs Normal-Day Analysis

Market behavior on event days was compared with normal trading days using:

- Average returns
- Volatility

---

## Key Findings

In this sample, the five trading days following geopolitical events showed higher volatility than overall normal-day volatility across all four analyzed markets.

The analysis also showed that market reactions differed across asset classes. Some markets experienced positive returns while others experienced negative returns around particular events.

Because the event sample is limited, these findings should be interpreted as descriptive observations rather than causal evidence.

---

## Data Quality Checks

The project includes checks for:

- Missing values
- Duplicate trading dates
- Date ranges
- Invalid date conversions
- Extreme daily returns
- Event-window availability

---

## Tools & Technologies

- Microsoft SQL Server
- SQL Server Management Studio (SSMS)
- SQL
- Financial market data
- Geopolitical event data 
