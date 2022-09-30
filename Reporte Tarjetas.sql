--TRUNCATE table glpi_plugin_fields_printerinfopanels 
SELECT * FROM glpi_plugin_fields_printerinfopanels pinfo; # info cuadros de texto pluging tarjetas. id tarjeta (items_id)
#abonado sucursal, cajeros, ip , mascara, puerta de enlace, id canal principal, id ip server panel, compas, teclado virt
# cambio respuesta, novedad linea, automatizacion, id ref de panel,  id, departament, id ciudad
SELECT * FROM glpi_printers pr # listado de los paneles de alarma 
SELECT * FROM glpi_printermodels prm ; # modelo de los Paneles
SELECT * from glpi_plugin_fields_referenciadelpaneldealarmasfielddropdowns; # N° de referencia de los panel


SELECT pr.id, pr.NAME "Nombre Panel", prm.NAME AS "Modelo", pr.SERIAL AS "Serial", pr.otherserial AS "Placa invent",
pinfo.abonadofield2 AS "Cod. Abonado", pinfo.sucursalfield AS "Cod. Suc", pinfo.ipalarmafield AS "IP panel", pinfo.mascaraalarmafield AS "Masc. de Red", 
pinfo.puertadeenlacegatewayfield AS "P. de Enlace ",pinfo.compassdlsfield AS "Compass", 
pinfo.tecladovirtualfield AS "Teclado virtual", pinfo.cajero1field2, pinfo.cajero2field2, pinfo.cajero3field2, pinfo.cajero4field2
FROM glpi_printers pr
left JOIN glpi_printermodels prm ON prm.id = pr.printermodels_id
LEFT JOIN glpi_plugin_fields_printerinfopanels pinfo ON pinfo.items_id = pr.id
LEFT JOIN glpi_plugin_fields_referenciadelpaneldealarmasfielddropdowns pref
ON pinfo.plugin_fields_referenciadelpaneldealarmasfielddropdowns_id = pref.id
ORDER BY pr.id














