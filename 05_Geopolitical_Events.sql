-- =====================================================
-- 05_Geopolitical_Events.sql
-- Project: Geopolitical Risk & Financial Market Analysis
-- Purpose: Analyze market reactions around geopolitical events
-- =====================================================

USE GeopoliticalRiskDB;
GO


-- =====================================================
-- 1. Event-Day Market Reaction
-- =====================================================

SELECT
    e.EventDate,
    e.EventName,
    e.EventType,
    e.Severity,

    r.SP500DailyReturn,
    r.GoldDailyReturn,
    r.NASDAQDailyReturn,
    r.OilDailyReturn

FROM dbo.GeopoliticalEvents AS e

LEFT JOIN dbo.vw_DailyReturns AS r
    ON e.EventDate = r.TradingDate

ORDER BY e.EventDate;


-- =====================================================
-- 2. First Trading Day After Each Event
-- =====================================================

SELECT
    e.EventDate,
    e.EventName,
    e.EventType,
    e.Severity,

    r.TradingDate AS NextTradingDate,

    r.SP500DailyReturn,
    r.GoldDailyReturn,
    r.NASDAQDailyReturn,
    r.OilDailyReturn

FROM dbo.GeopoliticalEvents AS e

CROSS APPLY
(
    SELECT TOP 1
        TradingDate,
        SP500DailyReturn,
        GoldDailyReturn,
        NASDAQDailyReturn,
        OilDailyReturn

    FROM dbo.vw_DailyReturns

    WHERE TradingDate > e.EventDate

    ORDER BY TradingDate

) AS r

ORDER BY e.EventDate;


-- =====================================================
-- 3. Third Trading Day After Each Event
-- =====================================================

SELECT
    e.EventDate,
    e.EventName,
    e.EventType,
    e.Severity,

    r.TradingDate AS ThirdTradingDate,

    r.SP500DailyReturn,
    r.GoldDailyReturn,
    r.NASDAQDailyReturn,
    r.OilDailyReturn

FROM dbo.GeopoliticalEvents AS e

CROSS APPLY
(
    SELECT
        TradingDate,
        SP500DailyReturn,
        GoldDailyReturn,
        NASDAQDailyReturn,
        OilDailyReturn

    FROM
    (
        SELECT
            *,
            ROW_NUMBER() OVER
            (
                ORDER BY TradingDate
            ) AS DayNumber

        FROM dbo.vw_DailyReturns

        WHERE TradingDate > e.EventDate

    ) AS x

    WHERE DayNumber = 3

) AS r

ORDER BY e.EventDate;


-- =====================================================
-- 4. Fifth Trading Day After Each Event
-- =====================================================

SELECT
    e.EventDate,
    e.EventName,
    e.EventType,
    e.Severity,

    r.TradingDate AS FifthTradingDate,

    r.SP500DailyReturn,
    r.GoldDailyReturn,
    r.NASDAQDailyReturn,
    r.OilDailyReturn

FROM dbo.GeopoliticalEvents AS e

CROSS APPLY
(
    SELECT
        TradingDate,
        SP500DailyReturn,
        GoldDailyReturn,
        NASDAQDailyReturn,
        OilDailyReturn

    FROM
    (
        SELECT
            *,
            ROW_NUMBER() OVER
            (
                ORDER BY TradingDate
            ) AS DayNumber

        FROM dbo.vw_DailyReturns

        WHERE TradingDate > e.EventDate

    ) AS x

    WHERE DayNumber = 5

) AS r

ORDER BY e.EventDate;


-- =====================================================
-- 5. Event-Day Analysis by Severity
-- =====================================================

SELECT
    e.Severity,
    COUNT(*) AS NumberOfEvents,

    AVG(r.SP500DailyReturn) AS AvgSP500Return,
    STDEV(r.SP500DailyReturn) AS SP500Volatility,

    AVG(r.GoldDailyReturn) AS AvgGoldReturn,
    STDEV(r.GoldDailyReturn) AS GoldVolatility,

    AVG(r.NASDAQDailyReturn) AS AvgNASDAQReturn,
    STDEV(r.NASDAQDailyReturn) AS NASDAQVolatility,

    AVG(r.OilDailyReturn) AS AvgOilReturn,
    STDEV(r.OilDailyReturn) AS OilVolatility

FROM dbo.GeopoliticalEvents AS e

INNER JOIN dbo.vw_DailyReturns AS r
    ON e.EventDate = r.TradingDate

GROUP BY e.Severity

ORDER BY e.Severity;


-- =====================================================
-- 6. Strongest Market Movement on Event Days
-- =====================================================

SELECT
    e.EventDate,
    e.EventName,
    e.EventType,
    e.Severity,

    r.SP500DailyReturn,
    ABS(r.SP500DailyReturn) AS SP500Movement,

    r.GoldDailyReturn,
    ABS(r.GoldDailyReturn) AS GoldMovement,

    r.NASDAQDailyReturn,
    ABS(r.NASDAQDailyReturn) AS NASDAQMovement,

    r.OilDailyReturn,
    ABS(r.OilDailyReturn) AS OilMovement

FROM dbo.GeopoliticalEvents AS e

INNER JOIN dbo.vw_DailyReturns AS r
    ON e.EventDate = r.TradingDate

ORDER BY SP500Movement DESC;