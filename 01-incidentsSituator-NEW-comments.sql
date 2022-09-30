--Incidents Report

--IncidentStatus: New = 0, Open(Acknowledged) = 1, Closed = 3
--IncidentSeverity:  Low = 1,Normal = 2,Medium = 3,	High = 4,Urgent = 5,

USE situator

Declare @searchFrom datetime
Declare @searchEnd datetime


-- UTC time 28045
-- set the period of time to search within 
set @searchFrom = '2022-06-01 05:00:00.000' -- start the search from this hour
set @searchEnd =  '2022-09-23 04:59:59.000' -- end the search at this hour

;WITH CTE
AS
(
	SELECT 
			IncidentID,
			CreationTimeUTC = dbo.udfTicksToDateTime(Incidents.CreationTime),
			CreationTimeLocal = DATEADD(HOUR, -5, dbo.udfTicksToDateTime(Incidents.CreationTime)),
			AcknowledgeTime = DATEADD(HOUR, -5, dbo.udfTicksToDateTime(Incidents.AcknowledgeTime)),
			ClosureTimeLocal = DATEADD(HOUR, -5, dbo.udfTicksToDateTime(Incidents.ClosureTime)),
			ClosureTime = DATEADD(HOUR, -5, dbo.udfTicksToDateTime(Incidents.ClosureTime)),
			Name,		
			--Description,
			Descriptions = -- elimina todos los saltos de linea de la columna Description
	REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(substring(
       (
           Select ','+ CONVERT(NVARCHAR(MAX), Incidents.Description)  AS [text()]
          From [dbo].[IncidentComments]
          Where [IncidentComments].IncidentID = Incidents.IncidentID 
           For XML PATH ('')  
       ), 2, 1000), '\r', ''), '\n', ''),CHAR(10),''),CHAR(9),''),CHAR(13),''),CHAR(160),''),
			Status,
			Severity,
			Location,
			SensorID,
			ClosureComment,
			OwnerID,
			IncidentType,
			IncidentGroupID,
			CreatedBy,
			AcknowledgedBy,
			ClosedBy
	FROM Incidents
	WHERE	
				
			 dbo.udfTicksToDateTime(Incidents.CreationTime) >= @searchFrom
			AND dbo.udfTicksToDateTime(Incidents.CreationTime) <= @searchEnd
)

SELECT 
	IncidentID,
	Incidents.CreationTimeUTC,
	Incidents.CreationTimeLocal,
	Incidents.AcknowledgeTime ,
	ClosureTimeLocal,
	ClosureTime,
	--Incidents.Name,
	replace (replace (replace (replace (replace(replace (REPLACE(CAST(Incidents.Name as NVARCHAR(MAX)), CHAR(10), ' '),CHAR(13), ' '),char(160),' '),char(9),' '),'\r', ' '), '\n', ' '),',',' ') AS 'Name',
	--Incidents.Description,
	Descriptions,
	Incidents.Status,
	Incidents.Severity,
	--Incidents.Location,
	replace (replace (replace (replace (replace(replace (REPLACE(CAST(Incidents.Location as NVARCHAR(MAX)), CHAR(10), ' '),CHAR(13), ' '),char(160),' '),char(9),' '),'\r', ' '), '\n', ' '),',',' ') AS 'Location',
	Incidents.SensorID,
	ST.TypeDescription,
	--Sensors.SensorName,
	replace (replace (replace (replace (replace(replace (REPLACE(CAST(Sensors.SensorName as NVARCHAR(MAX)), CHAR(10), ' '),CHAR(13), ' '),char(160),' '),char(9),' '),'\r', ' '), '\n', ' '),',',' ') AS 'SensorName',
	--Sensors.SensorDescription ,
	replace (replace (replace (replace (replace(replace (REPLACE(CAST(Sensors.SensorDescription as NVARCHAR(MAX)), CHAR(10), ' '),CHAR(13), ' '),char(160),' '),char(9),' '),'\r', ' '), '\n', ' '),',',' ') AS 'SensorDescription',
	Sensors.SensorHardwareID,
	--SensorGroup.GroupName SensorGroupName,
	replace (replace (replace (replace (replace(replace (REPLACE(CAST(SensorGroup.GroupName as NVARCHAR(MAX)), CHAR(10), ' '),CHAR(13), ' '),char(160),' '),char(9),' '),'\r', ' '), '\n', ' '),',',' ') AS 'SensorGroupName',
	--SensorGroup.GroupDescription SensorGroupDescription,
	replace (replace (replace (replace (replace(replace (REPLACE(CAST(SensorGroup.GroupDescription as NVARCHAR(MAX)), CHAR(10), ' '),CHAR(13), ' '),char(160),' '),char(9),' '),'\r', ' '), '\n', ' '),',',' ') AS 'SensorGroupDescription',
	CRU.Username,
	ANU.Username,
	CLU.Username,
	--Incidents.ClosureComment,
	replace (replace (replace (replace (replace(replace (REPLACE(CAST(Incidents.ClosureComment as NVARCHAR(MAX)), CHAR(10), ' '),CHAR(13), ' '),char(160),' '),char(9),' '),'\r', ' '), '\n', ' '),',',' ') AS 'ClosureComment',
	--IncidentGroupName = IncidentGroups.Name,
	replace (replace (replace (replace (replace(replace (REPLACE(CAST(IncidentGroups.Name as NVARCHAR(MAX)), CHAR(10), ' '),CHAR(13), ' '),char(160),' '),char(9),' '),'\r', ' '), '\n', ' '),',',' ') AS 'IncidentGroupName',
	OWU.Username OwnerUsername,
	--IncidentTypeName = IncidentTypes.Name,
	replace (replace (replace (replace (replace(replace (REPLACE(CAST(IncidentTypes.Name as NVARCHAR(MAX)), CHAR(10), ' '),CHAR(13), ' '),char(160),' '),char(9),' '),'\r', ' '), '\n', ' '),',',' ') AS 'IncidentTypeName',
	SensorGroup.GroupLocation,
	Comments = -- elimina todos los saltos de linea de la columna de comentarios
	replace(replace(REPLACE(REPLACE (REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(substring(
       (
           Select ','+ CONVERT(NVARCHAR(MAX), Content)  AS [text()]
          From [dbo].[IncidentComments]
          Where [IncidentComments].IncidentID = Incidents.IncidentID 
           For XML PATH ('')  
       ), 2, 1000), '\r', ''), '\n', ''),CHAR(10),''),CHAR(9),''),CHAR(13),''),CHAR(160),''),';',''),'&#x0D',''),',',', ')
	--Comments = 
	--substring(
     --   (
        --    Select ','+ CONVERT(NVARCHAR(MAX), Content)  AS [text()]
          --  From [dbo].[IncidentComments]
         --   Where [IncidentComments].IncidentID = Incidents.IncidentID 
         --   For XML PATH ('')  
      --  ), 2, 1000) 
	
		
	FROM CTE		Incidents
	LEFT JOIN IncidentTypes					ON Incidents.IncidentType = IncidentTypes.IncidentTypesID
	LEFT JOIN IncidentGroups				ON Incidents.IncidentGroupID = IncidentGroups.GroupID
    LEFT JOIN Sensors						ON Sensors.SensorID = Incidents.SensorID
	LEFT JOIN SensorGroup					ON SensorGroup.GroupID = Sensors.GroupID
	LEFT JOIN Users			CRU				ON CRU.UserID = Incidents.CreatedBy
	LEFT JOIN Users			ANU				ON ANU.UserID = Incidents.AcknowledgedBy
	LEFT JOIN Users			CLU				ON CLU.UserID = Incidents.ClosedBy
	LEFT JOIN Users			OWU				ON OWU.UserID = Incidents.OwnerID
	LEFT JOIN SensorType ST with (nolock)   ON Sensors.SensorTypeID = ST.SensorTypeID 
	--where --ANU.Username like '%YMR%'
	--where Incidents.Name like '%falla modulo%' --and Incidents.Name like '%%' and 
	 --where Incidents.Name like '%pared%' --and Incidents.Name like '%critico%'
	--where Incidents like '%%'
	--where 
	--and SensorGroup.GroupName like '%8650 8651 8652 8653 8654 8655 C CALDAS PARQUE SUC%'
	--where IncidentComments.Contentwhe
	--where incidents.IncidentID= '5871420'
	--where SensorHardwareID like '%1512%'
	

	
ORDER BY CreationTimeUTC DESC