SELECT DATE AS 'Fecha de Creacion', solvedate AS 'Fecha de Solución',glpi_tickets.id AS 'Ticket Id'
,glpi_tickets.NAME AS 'Nombre Ticket', glpi_peripherals.NAME AS 'Sitio', glpi_users.NAME AS 'UserID'
, CONCAT_WS(' ', glpi_users.firstname,glpi_users.realname) AS 'Nombre',
case 
			when glpi_itilcategories.completename = 'MANTEMIENTO' then 'Mantenimiento'
			when glpi_itilcategories.completename = 'VIDEO' then 'Correctivo Video' 
			when glpi_itilcategories.completename = 'ALARMA' then 'Correctivo Alarma' 
			when glpi_itilcategories.completename = 'PRUEBAS DE ALARMAS' then 'Pruebas de Alarma'
			
 END AS 'Tipo de Mtto.',
glpi_requesttypes.NAME AS 'Tipo de Sitio'
, glpi_locations.completename AS 'Region'
, case 
			when glpi_tickets.status = 1 then 'Nuevo'
			when glpi_tickets.status = 2 then 'En Curso (Asignada)'
			when glpi_tickets.status = 3 then 'En Curso (Planificada)'
			when glpi_tickets.status = 4 then 'En Espera'
			when glpi_tickets.status = 5 then 'Resuelta'
			when glpi_tickets.status = 6 then 'Cerrado'
 END AS Estado,
 glpi_plugin_moreticket_waitingtypes.name AS 'Cita',
 Espera.reason AS 'Motivo Cita Fallida ',
 CantVisitas.completename AS 'N° Visitas',
 FallaAsociada.completename AS 'Falla Asociada'
 
FROM glpi_tickets  
JOIN glpi_items_tickets ON glpi_tickets.id = glpi_items_tickets.tickets_id
JOIN glpi_peripherals ON glpi_peripherals.id = glpi_items_tickets.items_id
JOIN glpi_users ON glpi_users.id = glpi_tickets.users_id_recipient
JOIN glpi_itilcategories ON glpi_itilcategories.id = glpi_tickets.itilcategories_id
JOIN glpi_requesttypes ON glpi_requesttypes.ID = glpi_tickets.requesttypes_id
LEFT JOIN glpi_locations ON glpi_locations.id = glpi_tickets.locations_id
LEFT JOIN glpi_plugin_moreticket_waitingtickets as Espera ON glpi_tickets.id = Espera.tickets_id
LEFT JOIN glpi_plugin_moreticket_waitingtypes ON Espera.id = glpi_plugin_moreticket_waitingtypes.plugin_moreticket_waitingtypes_id
LEFT JOIN glpi_plugin_fields_ticketcantidaddevisitas AS Visitas ON glpi_tickets.id = Visitas.items_id
LEFT JOIN glpi_plugin_fields_visitasfielddropdowns as CantVisitas ON CantVisitas.id = Visitas.plugin_fields_visitasfielddropdowns_id
LEFT JOIN glpi_plugin_fields_fallaasociadafielddropdowns AS FallaAsociada ON Visitas.plugin_fields_fallaasociadafielddropdowns_id = FallaAsociada.id

WHERE glpi_itilcategories.completename IN ('Mantenimiento')
AND glpi_tickets.is_deleted = 0 AND
DATE >= DATE_FORMAT(CURRENT_DATE - INTERVAL 1 day, '%Y/%m/01') ORDER BY date