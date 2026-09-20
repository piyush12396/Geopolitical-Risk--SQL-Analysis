-- =====================================================
-- 01_Data_Setup.sql
-- Project: Geopolitical Risk & Financial Market Analysis
-- Database: GeopoliticalRiskDB
-- Purpose: Database and table setup
-- =====================================================

USE GeopoliticalRiskDB;
GO


-- =====================================================
-- 1. Create Market Prices Table
-- =====================================================

CREATE TABLE dbo.MarketPrices_Raw
(
    TradingDate DATE,
    SP500Price NVARCHAR(50),
    GoldPrice NVARCHAR(50),
    NASDAQPrice NVARCHAR(50),
    OilPrice NVARCHAR(50)
);


-- =====================================================
-- 2. Load Financial Market Data
--    Source: financial_data_Import
-- =====================================================

INSERT INTO dbo.MarketPrices_Raw
(
    TradingDate,
    SP500Price,
    GoldPrice,
    NASDAQPrice,
    OilPrice
)
SELECT
    TRY_CONVERT(DATE, [Date]),
    TRY_CONVERT(DECIMAL(12,2), [S_P_500]),
    TRY_CONVERT(DECIMAL(12,2), [Gold]),
    TRY_CONVERT(DECIMAL(12,2), [Nasdaq]),
    TRY_CONVERT(DECIMAL(12,2), [Oil])
FROM dbo.financial_data_Import
WHERE TRY_CONVERT(DATE, [Date]) IS NOT NULL;


-- =====================================================
-- 3. Create Geopolitical Events Table
-- =====================================================

CREATE TABLE dbo.GeopoliticalEvents
(
    EventID INT IDENTITY(1,1) PRIMARY KEY,
    EventDate DATE NOT NULL,
    EventName VARCHAR(200) NOT NULL,
    EventType VARCHAR(100),
    Severity VARCHAR(50),
    Description VARCHAR(500)
);


-- =====================================================
-- 4. Insert Geopolitical Events
-- =====================================================

INSERT INTO dbo.GeopoliticalEvents
(
    EventDate,
    EventName,
    EventType,
    Severity,
    Description
)
VALUES
(
    '2020-03-11',
    'COVID-19 Pandemic Declared',
    'Global Crisis',
    'High',
    'WHO declared COVID-19 a pandemic, increasing global economic uncertainty'
),
(
    '2020-03-23',
    'Global Market Crisis',
    'Economic Crisis',
    'High',
    'Global financial markets experienced severe volatility during the COVID-19 crisis'
),
(
    '2022-02-24',
    'Russia-Ukraine War',
    'Armed Conflict',
    'High',
    'Russia launched a full-scale invasion of Ukraine, creating significant geopolitical uncertainty'
),
(
    '2022-02-28',
    'Russia Sanctions Escalation',
    'Economic Sanctions',
    'High',
    'Major economies announced additional sanctions and financial restrictions on Russia'
),
(
    '2022-03-08',
    'Oil Price Shock',
    'Energy Crisis',
    'High',
    'Global energy markets experienced significant disruption following the Russia-Ukraine escalation'
),
(
    '2023-10-07',
    'Israel-Gaza War Begins',
    'Armed Conflict',
    'High',
    'The outbreak of major fighting increased geopolitical uncertainty in the Middle East'
),
(
    '2023-10-09',
    'Middle East Market Uncertainty',
    'Regional Conflict',
    'Medium',
    'Escalating regional tensions increased uncertainty across global markets'
);