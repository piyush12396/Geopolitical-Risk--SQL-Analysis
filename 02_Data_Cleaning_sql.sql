-- =====================================================
-- 02_Data_Cleaning.sql
-- Project: Geopolitical Risk & Financial Market Analysis
-- Purpose: Data quality checks and validation
-- =====================================================

USE GeopoliticalRiskDB;
GO


-- =====================================================
-- 1. Check Total Number of Records
-- =====================================================

SELECT
    COUNT(*) AS TotalRows
FROM dbo.MarketPrices_Raw;


-- =====================================================
-- 2. Check Missing Values
-- =====================================================

SELECT
    COUNT(*) AS TotalRows,

    SUM(CASE
        WHEN TradingDate IS NULL THEN 1
        ELSE 0
    END) AS MissingTradingDate,

    SUM(CASE
        WHEN SP500Price IS NULL THEN 1
        ELSE 0
    END) AS MissingSP500,

    SUM(CASE
        WHEN GoldPrice IS NULL THEN 1
        ELSE 0
    END) AS MissingGold,

    SUM(CASE
        WHEN NASDAQPrice IS NULL THEN 1
        ELSE 0
    END) AS MissingNASDAQ,

    SUM(CASE
        WHEN OilPrice IS NULL THEN 1
        ELSE 0
    END) AS MissingOil

FROM dbo.MarketPrices_Raw;


-- =====================================================
-- 3. Identify Rows with Missing S&P 500 Values
-- =====================================================

SELECT *
FROM dbo.MarketPrices_Raw
WHERE SP500Price IS NULL;


-- =====================================================
-- 4. Check for Duplicate Trading Dates
-- =====================================================

SELECT
    TradingDate,
    COUNT(*) AS NumberOfRows
FROM dbo.MarketPrices_Raw
GROUP BY TradingDate
HAVING COUNT(*) > 1
ORDER BY TradingDate;


-- =====================================================
-- 5. Check Date Range
-- =====================================================

SELECT
    MIN(TradingDate) AS FirstDate,
    MAX(TradingDate) AS LastDate,
    COUNT(*) AS TotalRows
FROM dbo.MarketPrices_Raw;


-- =====================================================
-- 6. Preview Imported Market Data
-- =====================================================

SELECT TOP 10 *
FROM dbo.MarketPrices_Raw;