-- =============================================================
-- ============= SPRINT 01 y 02 ================================
--drop view if exists vw_permisos_api;
CREATE VIEW vw_permisos_api AS 
SELECT  ROW_NUMBER()OVER(ORDER BY rol.id, asi.mapping) as row_id, rol.nombre_rol, asi."mapping", ca.http_get , ca.http_post, ca.http_update , ca.http_delete 
FROM 	rol_capacidad_api rcs
INNER JOIN permisos_api asi on rcs.permisos_api_id = asi.id 
INNER JOIN capacidad ca on ca.id = rcs.capacidad_id 
INNER JOIN rol on rol.id = rcs.rol_id
ORDER BY LENGTH(asi."mapping") desc, asi."mapping", ca.http_get, ca.http_post, ca.http_update , ca.http_delete; --asi.api_orden, 

-- Vista promedio productos
-- DROP VIEW IF EXISTS vw_producto_puntuacion;
CREATE VIEW vw_producto_puntuacion AS
SELECT pr.id as producto_id, ROUND(AVG(COALESCE(pp.estrellas, 0))::numeric, 2) as promedio, COUNT(pp.id) as total
FROM   producto pr
LEFT JOIN producto_puntuacion pp on pp.producto_id = pr.id
GROUP BY 1;
