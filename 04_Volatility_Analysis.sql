-- =====================================================
-- 04_Volatility_Analysis.sql
-- Project: Geopolitical Risk & Financial Market Analysis
-- Purpose: Analyze market returns and volatility
-- =====================================================

USE GeopoliticalRiskDB;
GO


-- =====================================================
-- 1. Return Summary
-- =====================================================

SELECT
    AVG(SP500DailyReturn) AS AverageSP500Return,
    MAX(SP500DailyReturn) AS HighestSP500Return,
    MIN(SP500DailyReturn) AS LowestSP500Return,

    AVG(GoldDailyReturn) AS AverageGoldReturn,
    MAX(GoldDailyReturn) AS HighestGoldReturn,
    MIN(GoldDailyReturn) AS LowestGoldReturn,

    AVG(NASDAQDailyReturn) AS AverageNASDAQReturn,
    MAX(NASDAQDailyReturn) AS HighestNASDAQReturn,
    MIN(NASDAQDailyReturn) AS LowestNASDAQReturn,

    AVG(OilDailyReturn) AS AverageOilReturn,
    MAX(OilDailyReturn) AS HighestOilReturn,
    MIN(OilDailyReturn) AS LowestOilReturn

FROM dbo.vw_DailyReturns;


-- =====================================================
-- 2. Daily Volatility
-- =====================================================

SELECT
    STDEV(SP500DailyReturn) AS SP500DailyVolatility,
    STDEV(GoldDailyReturn) AS GoldDailyVolatility,
    STDEV(NASDAQDailyReturn) AS NASDAQDailyVolatility,
    STDEV(OilDailyReturn) AS OilDailyVolatility

FROM dbo.vw_DailyReturns;


-- =====================================================
-- 3. Annualized Volatility
--    Assumption: 252 trading days per year
-- =====================================================

SELECT
    STDEV(SP500DailyReturn) * SQRT(252)
        AS AnnualSP500Volatility,

    STDEV(GoldDailyReturn) * SQRT(252)
        AS AnnualGoldVolatility,

    STDEV(NASDAQDailyReturn) * SQRT(252)
        AS AnnualNASDAQVolatility,

    STDEV(OilDailyReturn) * SQRT(252)
        AS AnnualOilVolatility

FROM dbo.vw_DailyReturns;


-- =====================================================
-- 4. Combined Return and Volatility Summary
-- =====================================================

SELECT
    AVG(SP500DailyReturn) AS AvgSP500Return,
    STDEV(SP500DailyReturn) AS DailySP500Volatility,
    STDEV(SP500DailyReturn) * SQRT(252)
        AS AnnualSP500Volatility,

    AVG(GoldDailyReturn) AS AvgGoldReturn,
    STDEV(GoldDailyReturn) * SQRT(252)
        AS AnnualGoldVolatility,

    AVG(NASDAQDailyReturn) AS AvgNASDAQReturn,
    STDEV(NASDAQDailyReturn) * SQRT(252)
        AS AnnualNASDAQVolatility,

    AVG(OilDailyReturn) AS AvgOilReturn,
    STDEV(OilDailyReturn) * SQRT(252)
        AS AnnualOilVolatility

FROM dbo.vw_DailyReturns;


-- =====================================================
-- 5. Identify Extreme Daily Returns
-- =====================================================

SELECT
    TradingDate,
    SP500DailyReturn,
    GoldDailyReturn,
    NASDAQDailyReturn,
    OilDailyReturn

FROM dbo.vw_DailyReturns

WHERE ABS(SP500DailyReturn) > 10
   OR ABS(GoldDailyReturn) > 10
   OR ABS(NASDAQDailyReturn) > 10
   OR ABS(OilDailyReturn) > 10

ORDER BY TradingDate;