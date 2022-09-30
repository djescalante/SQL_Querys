
Use HistorySituator
DECLARE
		@FechaInicio	DATETIME = '2020-07-01 05:00:10.000',
		@FechaFin		DATETIME = '2021-07-03 04:59:59.000',
		@Location		VARCHAR(20) = '%%'--, -- you have location in here/ yes
		--@EventReport	VARCHAR(20) = 'particion',
		--@_Site			VARCHAR(20) = 'particion',
		--@IncidentType	VARCHAR(1000)= '-Todos-'
		

select DATEADD(HOUR, -5, SensorEvents.ReportTime) as "Fecha", 
--SensorEvents.EventReport, 
replace (replace (replace (replace (replace(replace (REPLACE(CAST(EventReport as NVARCHAR(MAX)), CHAR(10), ' '),CHAR(13), ' '),char(160),' '),char(9),' '),'\r', ' '), '\n', ' '),',',' ') AS 'Event Report',
--Sensors.SensorName, 
replace (replace (replace (replace (replace(replace (REPLACE(CAST(SensorName as NVARCHAR(MAX)), CHAR(10), ' '),CHAR(13), ' '),char(160),' '),char(9),' '),'\r', ' '), '\n', ' '),',',' ') AS 'Sensor Name',
--Sensors.SensorDescription,
replace (replace (replace (replace (replace(replace (REPLACE(CAST(SensorDescription as NVARCHAR(MAX)), CHAR(10), ' '),CHAR(13), ' '),char(160),' '),char(9),' '),'\r', ' '), '\n', ' '),',',' ') AS 'Sensor Description',
Sensors.SensorHardwareID, 
--Sensors.SensorLocation, 
replace (replace (replace (replace (replace(replace (REPLACE(CAST(SensorLocation as NVARCHAR(MAX)), CHAR(10), ' '),CHAR(13), ' '),char(160),' '),char(9),' '),'\r', ' '), '\n', ' '),',',' ') AS 'Sensor Location',
--SensorGroup.GroupName,
replace (replace (replace (replace (replace(replace (REPLACE(CAST(SensorLocation as NVARCHAR(MAX)), CHAR(10), ' '),CHAR(13), ' '),char(160),' '),char(9),' '),'\r', ' '), '\n', ' '),',',' ') AS 'Group Name'
,replace (replace (replace (replace (replace(replace (REPLACE(CAST(SensorEvents.SensorMode as NVARCHAR(MAX)), CHAR(10), ' '),CHAR(13), ' '),char(160),' '),char(9),' '),'\r', ' '), '\n', ' '),',',' ') AS 'Sensor Mode',
	SensorEvents.SensorState,

	(CASE 
		WHEN SensorEvents.SensorState LIKE '0' THEN 'Desconocido'
		WHEN SensorEvents.SensorState LIKE '1' THEN 'Normal'
		WHEN SensorEvents.SensorState LIKE '2' THEN 'Alarmado'
		WHEN SensorEvents.SensorState LIKE '3' THEN 'Alarma Reconocida'
		WHEN SensorEvents.SensorState LIKE '4' THEN 'Falla'
		WHEN SensorEvents.SensorState LIKE '5' THEN 'Fallo Reconocido'
		WHEN SensorEvents.SensorState LIKE '7' THEN 'Gateway Desconectado'
	else ' ' end ) 'Sensor State',

	(CASE 
		WHEN SensorEvents.SensorMode LIKE '0' THEN 'Desconocido'
		WHEN SensorEvents.SensorMode LIKE '1' THEN 'Armado'
		WHEN SensorEvents.SensorMode LIKE '2' THEN 'Desarmado'
		WHEN SensorEvents.SensorMode LIKE '3' THEN 'Baypased'
		
		
	else ' ' end ) 'Sensor Mode'


from SensorEvents
inner join Sensors
on Sensors.SensorID = SensorEvents.SensorEntityID and Deleted is null
--where SensorEvents.ReportTime >= @FechaInicio AND SensorEvents.ReportTime  <= @FechaFin 
JOIN  SensorGroup	ON Sensors.GroupID = SensorGroup.GroupID 
where ltrim(rtrim(isnull(convert(varchar(max),EventReport),''))) <> '' 
AND SensorEvents.ReportTime >= @FechaInicio AND SensorEvents.ReportTime  <= @FechaFin
--and (EventReport not like '%no user in database%' and EventReport  not like '%No Existe el usuario en la BD%') 
	--and (eventreport like '%Reporte de Apertura ID de Usuario%' or eventreport like '%Apertura/Cierre por Usuario User ID%') 
	--and SensorDescription like 'part%'
	--and SensorHardwareID like '%7640%' --and (EventReport like '%apertura%' or EventReport like '%cierre%')
	 --and SensorHardwareID like '%-____-1'
--and sensorname like '%obst%'
and (SensorEvents.EventReport LIKE '%apertura%' or  SensorEvents.EventReport LIKE '%cierre%')
and SensorName like '%partition%' and sensors.SensorTypeID like '289'
 and SensorGroup.GroupName like '%5791%'
--and SensorGroup.GroupName like '%Avenida cero%'-- and (Sensors.SensorHardwareID like  '%1927-10-1%' or Sensors.SensorHardwareID like  '%1927-58-1%')

order by ReportTime DESC



