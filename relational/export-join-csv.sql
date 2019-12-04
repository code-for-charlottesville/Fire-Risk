\COPY (SELECT * from all_sources) TO 'parcels.csv' WITH CSV DELIMITER ',' HEADER
