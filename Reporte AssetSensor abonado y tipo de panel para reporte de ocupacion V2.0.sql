use situator
select SensorDescription As Abonado,
replace (PARSENAME(REPLACE(replace (SensorName,'.','$'),'-','.'),3),'$','.') as Codigo, -- esto se hace para  no tomar en cuentla los puntos en el nombre del sensorname
SensorGroup.GroupName As Nombre,
replace (PARSENAME(REPLACE(replace (SensorName,'.','$'),'-','.'),1),'$','.') as 'Nombre del Sitio',
sensorname AS 'Sensor Name',
GroupLocation AS Ubicacion,
PARSENAME(REPLACE(convert (nvarchar(max),SensorAdditionalInfo),'-','.'),2) as Receptora,
PARSENAME(REPLACE(convert (nvarchar(max),SensorAdditionalInfo),'-','.'),1) as 'Tipo de Panel',
--PARSENAME(REPLACE(SensorName,'-','.'),2) as 'Tipo de Sitio',
replace (PARSENAME(REPLACE(replace (SensorName,'.','$'),'-','.'),2),'$','.') as 'Tipo de Sitio',
sensors.SensorLocation,

--SensorMode,SensorState, Deleted,
(CASE	WHEN convert (nvarchar(max),SensorAdditionalInfo) LIKE '%ALARMNET-VISTA 128FBPT%' THEN '150' 
		WHEN convert (nvarchar(max),SensorAdditionalInfo) LIKE '%S3-PC 1832%' THEN '72'
		WHEN convert (nvarchar(max),SensorAdditionalInfo) LIKE '%S3-3032%' THEN '72'
		WHEN convert (nvarchar(max),SensorAdditionalInfo) LIKE '%S3-3128%' THEN '1000'
		WHEN convert (nvarchar(max),SensorAdditionalInfo) LIKE '%S3-3248%' THEN '1000'
		WHEN convert (nvarchar(max),SensorAdditionalInfo) LIKE '%S3-PC 4020%' THEN '1500'
		WHEN convert (nvarchar(max),SensorAdditionalInfo) LIKE '%S3-PC 1864%' THEN '95'
		WHEN convert (nvarchar(max),SensorAdditionalInfo) LIKE '%ALARMNET-VISTA 32 FBPT%' THEN '75'
		WHEN convert (nvarchar(max),SensorAdditionalInfo) LIKE '%S3-PC 5020NA%' THEN '36'
		WHEN convert (nvarchar(max),SensorAdditionalInfo) LIKE '%PANEL LPL NO IDENTIFICABLE%' THEN 'No Capacity Info'

		
else 'Tipo de Panel Erroneo' end 

) AS 'Capacidad Del Panel'
from sensors with (nolock)
left join SensorType with (nolock) on SensorType.SensorTypeID=Sensors.SensorTypeID
left join SensorGroup on SensorGroup.GroupID= Sensors.GroupID
--where (sensors.SensorHardwareID like '%-atm-%' or sensors.SensorHardwareID like '%-SUC-%') and sensors.Deleted is null
--where (sensors.SensorHardwareID not like '%-atm-%' and sensors.SensorHardwareID not like '%-SUC-%') and sensors.Deleted is null and SensorType.TypeDescription like 'AssetSensor' 
-- and sensortype.TypeDescription like '%alarm%'--or sensortype.TypeDescription like '%alarm%') 
 --and SensorType.TypeName like '%AlarmPanel%' and sensors.Deleted is null
where SensorType.TypeDescription like 'AssetSensor' and Deleted is null -- and SensorName like '%4187%'

order by SensorHardwareID

