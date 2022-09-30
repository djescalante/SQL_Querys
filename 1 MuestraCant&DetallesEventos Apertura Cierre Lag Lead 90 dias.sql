	
select [Sensor Name],[Sensor State],[Event Report],LAG(Fecha) over (PARTITION by SensorHardwareID order by fecha) As Fecha_anteriorFecha,Fecha,AbonadoHiD,SensorHardwareID,[Group Name],GroupLocation,LAG([Sensor -Mode-]) over (PARTITION by SensorHardwareID order by fecha) As Estado_Anterior, [Sensor -Mode-] 
from(

select DATEADD(HOUR, -5, SensorEvents.ReportTime) as "Fecha", 
replace (PARSENAME(REPLACE(replace (SensorHardwareID,'.','$'),'-','.'),2),'$','.') as AbonadoHiD,

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
, SSG.GroupLocation
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
		WHEN SensorEvents.SensorMode LIKE '1' THEN 'Cierre'
		WHEN SensorEvents.SensorMode LIKE '2' THEN 'Apertura'
		WHEN SensorEvents.SensorMode LIKE '3' THEN 'Baypased'
		
		
	else ' ' end ) 'Sensor -Mode-'


from SensorEvents 
inner join Sensors
on Sensors.SensorID = SensorEvents.SensorEntityID and Deleted is null
--where SensorEvents.ReportTime >= @FechaInicio AND SensorEvents.ReportTime  <= @FechaFin 
JOIN  SensorGroup	ON Sensors.GroupID = SensorGroup.GroupID 
join situator.dbo.SensorGroup SSG on ssg.GroupID =  SensorGroup.GroupID 
where ltrim(rtrim(isnull(convert(varchar(max),EventReport),''))) <> '' 
		--AND SensorEvents.ReportTime >= @FechaInicio AND SensorEvents.ReportTime  <= @FechaFin
		--AND SensorEvents.ReportTime >= DATEADD (HOUR, 5, DATEADD (MONTH, -3, CAST(CAST(GETDATE() AS DATE) AS DATETIME) ) ) 
		AND SensorEvents.ReportTime >=DATEADD (HOUR, 5, DATEADD (MONTH, DATEDIFF(MONTH,0,DATEADD (HOUR, 5,GETDATE()))-3,0 ) ) 
		--AND SensorEvents.ReportTime >DATEADD (MONTH, DATEDIFF(MONTH,0,DATEADD (HOUR, -5,GETDATE()))-3,0 ) 
		--AND SensorEvents.ReportTime <= DATEADD(hour, 0,GETDATE()) -- Finaliza con la Hora actual
and (SensorEvents.EventReport LIKE '%apertura%' or  SensorEvents.EventReport LIKE '%cierre%')
and SensorName like '%%' and sensors.SensorTypeID like '289'
and SensorGroup.GroupName like '%%' ) as Tabla


