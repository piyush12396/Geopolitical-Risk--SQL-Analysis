-- =====================================================
-- 03_Market_Returns.sql
-- Project: Geopolitical Risk & Financial Market Analysis
-- Purpose: Calculate daily market returns
-- =====================================================

USE GeopoliticalRiskDB;
GO


-- =====================================================
-- 1. Create Market Prices View
-- =====================================================

CREATE VIEW dbo.vw_MarketPrices AS
SELECT
    TradingDate,
    SP500Price,
    GoldPrice,
    NASDAQPrice,
    OilPrice
FROM dbo.MarketPrices_Raw;
GO


-- =====================================================
-- 2. Create View with Previous-Day Prices
-- =====================================================

CREATE VIEW dbo.vw_AllMarketReturns AS
SELECT
    TradingDate,
    SP500Price,
    GoldPrice,
    NASDAQPrice,
    OilPrice,

    LAG(SP500Price) OVER
        (ORDER BY TradingDate) AS PreviousSP500Price,

    LAG(GoldPrice) OVER
        (ORDER BY TradingDate) AS PreviousGoldPrice,

    LAG(NASDAQPrice) OVER
        (ORDER BY TradingDate) AS PreviousNASDAQPrice,

    LAG(OilPrice) OVER
        (ORDER BY TradingDate) AS PreviousOilPrice

FROM dbo.vw_MarketPrices;
GO


-- =====================================================
-- 3. Calculate Daily Returns
-- =====================================================

CREATE VIEW dbo.vw_DailyReturns AS
SELECT
    TradingDate,

    (
        (
            TRY_CONVERT(decimal(18,4), SP500Price)
            -
            TRY_CONVERT(decimal(18,4), PreviousSP500Price)
        )
        /
        NULLIF(
            TRY_CONVERT(decimal(18,4), PreviousSP500Price),
            0
        )
    ) * 100 AS SP500DailyReturn,

    (
        (
            TRY_CONVERT(decimal(18,4), GoldPrice)
            -
            TRY_CONVERT(decimal(18,4), PreviousGoldPrice)
        )
        /
        NULLIF(
            TRY_CONVERT(decimal(18,4), PreviousGoldPrice),
            0
        )
    ) * 100 AS GoldDailyReturn,

    (
        (
            TRY_CONVERT(decimal(18,4), NASDAQPrice)
            -
            TRY_CONVERT(decimal(18,4), PreviousNASDAQPrice)
        )
        /
        NULLIF(
            TRY_CONVERT(decimal(18,4), PreviousNASDAQPrice),
            0
        )
    ) * 100 AS NASDAQDailyReturn,

    (
        (
            TRY_CONVERT(decimal(18,4), OilPrice)
            -
            TRY_CONVERT(decimal(18,4), PreviousOilPrice)
        )
        /
        NULLIF(
            TRY_CONVERT(decimal(18,4), PreviousOilPrice),
            0
        )
    ) * 100 AS OilDailyReturn

FROM dbo.vw_AllMarketReturns;
GO


-- =====================================================
-- 4. Check Daily Returns
-- =====================================================

SELECT TOP 10 *
FROM dbo.vw_DailyReturns
ORDER BY TradingDate;