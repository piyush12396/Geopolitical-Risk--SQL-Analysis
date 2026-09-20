-- =====================================================
-- 06_Event_Impact_Analysis.sql
-- Project: Geopolitical Risk & Financial Market Analysis
-- Purpose: Measure market impact following geopolitical events
-- =====================================================

USE GeopoliticalRiskDB;
GO


-- =====================================================
-- 1. Five-Day Event Windows
-- =====================================================

WITH EventWindows AS
(
    SELECT
        e.EventDate,
        e.EventName,
        e.EventType,
        e.Severity,

        r.TradingDate,
        r.SP500DailyReturn,
        r.GoldDailyReturn,
        r.NASDAQDailyReturn,
        r.OilDailyReturn,

        ROW_NUMBER() OVER
        (
            PARTITION BY e.EventDate
            ORDER BY r.TradingDate
        ) AS DayNumber

    FROM dbo.GeopoliticalEvents AS e

    INNER JOIN dbo.vw_DailyReturns AS r
        ON r.TradingDate > e.EventDate
)

SELECT *
FROM EventWindows
WHERE DayNumber <= 5
ORDER BY EventDate, TradingDate;


-- =====================================================
-- 2. Five-Day Cumulative Returns After Events
-- =====================================================

SELECT
    e.EventDate,
    e.EventName,
    e.EventType,
    e.Severity,

    (
        EXP(SUM(LOG(1 + r.SP500DailyReturn / 100))) - 1
    ) * 100 AS SP500_5DayCumulativeReturn,

    (
        EXP(SUM(LOG(1 + r.GoldDailyReturn / 100))) - 1
    ) * 100 AS Gold_5DayCumulativeReturn,

    (
        EXP(SUM(LOG(1 + r.NASDAQDailyReturn / 100))) - 1
    ) * 100 AS NASDAQ_5DayCumulativeReturn,

    (
        EXP(SUM(LOG(1 + r.OilDailyReturn / 100))) - 1
    ) * 100 AS Oil_5DayCumulativeReturn

FROM dbo.GeopoliticalEvents AS e

CROSS APPLY
(
    SELECT TOP 5
        SP500DailyReturn,
        GoldDailyReturn,
        NASDAQDailyReturn,
        OilDailyReturn

    FROM dbo.vw_DailyReturns

    WHERE TradingDate > e.EventDate

    ORDER BY TradingDate

) AS r

GROUP BY
    e.EventDate,
    e.EventName,
    e.EventType,
    e.Severity

ORDER BY e.EventDate;


-- =====================================================
-- 3. Event-Day vs Normal-Day Comparison
-- =====================================================

WITH ClassifiedDays AS
(
    SELECT
        r.TradingDate,

        CASE
            WHEN EXISTS
            (
                SELECT 1
                FROM dbo.GeopoliticalEvents
                WHERE EventDate = r.TradingDate
            )
            THEN 'Event Day'
            ELSE 'Normal Day'
        END AS DayType,

        r.SP500DailyReturn,
        r.GoldDailyReturn,
        r.NASDAQDailyReturn,
        r.OilDailyReturn

    FROM dbo.vw_DailyReturns AS r
)

SELECT
    DayType,
    COUNT(*) AS NumberOfDays,

    AVG(SP500DailyReturn) AS AvgSP500Return,
    STDEV(SP500DailyReturn) AS SP500Volatility,

    AVG(GoldDailyReturn) AS AvgGoldReturn,
    STDEV(GoldDailyReturn) AS GoldVolatility,

    AVG(NASDAQDailyReturn) AS AvgNASDAQReturn,
    STDEV(NASDAQDailyReturn) AS NASDAQVolatility,

    AVG(OilDailyReturn) AS AvgOilReturn,
    STDEV(OilDailyReturn) AS OilVolatility

FROM ClassifiedDays

GROUP BY DayType

ORDER BY DayType;


-- =====================================================
-- 4. Five-Day Volatility Following Each Event
-- =====================================================

WITH EventWindows AS
(
    SELECT
        e.EventDate,
        e.EventName,
        e.EventType,
        e.Severity,

        r.TradingDate,
        r.SP500DailyReturn,
        r.GoldDailyReturn,
        r.NASDAQDailyReturn,
        r.OilDailyReturn,

        ROW_NUMBER() OVER
        (
            PARTITION BY e.EventDate
            ORDER BY r.TradingDate
        ) AS DayNumber

    FROM dbo.GeopoliticalEvents AS e

    INNER JOIN dbo.vw_DailyReturns AS r
        ON r.TradingDate > e.EventDate
)

SELECT
    EventDate,
    EventName,
    EventType,
    Severity,

    STDEV(SP500DailyReturn) AS SP500_5DayVolatility,
    STDEV(GoldDailyReturn) AS Gold_5DayVolatility,
    STDEV(NASDAQDailyReturn) AS NASDAQ_5DayVolatility,
    STDEV(OilDailyReturn) AS Oil_5DayVolatility

FROM EventWindows

WHERE DayNumber <= 5

GROUP BY
    EventDate,
    EventName,
    EventType,
    Severity

ORDER BY EventDate;


-- =====================================================
-- 5. Average Event-Window Volatility
-- =====================================================

WITH EventWindows AS
(
    SELECT
        e.EventDate,

        r.TradingDate,
        r.SP500DailyReturn,
        r.GoldDailyReturn,
        r.NASDAQDailyReturn,
        r.OilDailyReturn,

        ROW_NUMBER() OVER
        (
            PARTITION BY e.EventDate
            ORDER BY r.TradingDate
        ) AS DayNumber

    FROM dbo.GeopoliticalEvents AS e

    INNER JOIN dbo.vw_DailyReturns AS r
        ON r.TradingDate > e.EventDate
),

EventVolatility AS
(
    SELECT
        EventDate,

        STDEV(SP500DailyReturn) AS SP500_5DayVolatility,
        STDEV(GoldDailyReturn) AS Gold_5DayVolatility,
        STDEV(NASDAQDailyReturn) AS NASDAQ_5DayVolatility,
        STDEV(OilDailyReturn) AS Oil_5DayVolatility

    FROM EventWindows

    WHERE DayNumber <= 5

    GROUP BY EventDate
)

SELECT
    AVG(SP500_5DayVolatility)
        AS AvgEventWindowSP500Volatility,

    AVG(Gold_5DayVolatility)
        AS AvgEventWindowGoldVolatility,

    AVG(NASDAQ_5DayVolatility)
        AS AvgEventWindowNASDAQVolatility,

    AVG(Oil_5DayVolatility)
        AS AvgEventWindowOilVolatility

FROM EventVolatility;


-- =====================================================
-- 6. Final Event-Impact Summary
-- =====================================================

WITH EventDay AS
(
    SELECT
        e.EventDate,
        e.EventName,
        e.EventType,
        e.Severity,

        r.SP500DailyReturn AS EventDaySP500Return,
        r.GoldDailyReturn AS EventDayGoldReturn,
        r.NASDAQDailyReturn AS EventDayNASDAQReturn,
        r.OilDailyReturn AS EventDayOilReturn

    FROM dbo.GeopoliticalEvents AS e

    INNER JOIN dbo.vw_DailyReturns AS r
        ON e.EventDate = r.TradingDate
),

EventWindow AS
(
    SELECT
        e.EventDate,

        STDEV(r.SP500DailyReturn)
            AS SP500_5DayVolatility,

        STDEV(r.GoldDailyReturn)
            AS Gold_5DayVolatility,

        STDEV(r.NASDAQDailyReturn)
            AS NASDAQ_5DayVolatility,

        STDEV(r.OilDailyReturn)
            AS Oil_5DayVolatility,

        (
            EXP(SUM(LOG(1 + r.SP500DailyReturn / 100))) - 1
        ) * 100 AS SP500_5DayCumulativeReturn,

        (
            EXP(SUM(LOG(1 + r.GoldDailyReturn / 100))) - 1
        ) * 100 AS Gold_5DayCumulativeReturn,

        (
            EXP(SUM(LOG(1 + r.NASDAQDailyReturn / 100))) - 1
        ) * 100 AS NASDAQ_5DayCumulativeReturn,

        (
            EXP(SUM(LOG(1 + r.OilDailyReturn / 100))) - 1
        ) * 100 AS Oil_5DayCumulativeReturn

    FROM dbo.GeopoliticalEvents AS e

    CROSS APPLY
    (
        SELECT TOP 5
            SP500DailyReturn,
            GoldDailyReturn,
            NASDAQDailyReturn,
            OilDailyReturn

        FROM dbo.vw_DailyReturns

        WHERE TradingDate > e.EventDate

        ORDER BY TradingDate

    ) AS r

    GROUP BY e.EventDate
)

SELECT
    d.EventDate,
    d.EventName,
    d.EventType,
    d.Severity,

    d.EventDaySP500Return,
    d.EventDayGoldReturn,
    d.EventDayNASDAQReturn,
    d.EventDayOilReturn,

    w.SP500_5DayCumulativeReturn,
    w.Gold_5DayCumulativeReturn,
    w.NASDAQ_5DayCumulativeReturn,
    w.Oil_5DayCumulativeReturn,

    w.SP500_5DayVolatility,
    w.Gold_5DayVolatility,
    w.NASDAQ_5DayVolatility,
    w.Oil_5DayVolatility

FROM EventDay AS d

INNER JOIN EventWindow AS w
    ON d.EventDate = w.EventDate

ORDER BY d.EventDate;