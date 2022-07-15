
-- set search path 
set search_path = panama

-- add uuid extension
create extension if not exists "uuid-ossp";

-- add site p.key  
ALTER TABLE site 
ADD COLUMN site_id_u UUID DEFAULT (uuid_generate_v4());

-- add visit p.key  then add empty site_id_u f.key, then join site_id_u column on unique relationship 
ALTER TABLE visit 
ADD COLUMN visit_id_u UUID DEFAULT (uuid_generate_v4());

alter table visit  
add column site_id_u UUID;


update visit a 
set site_id_u  = 
	(select s.site_id_u
	from site s
	where (s.region, s.site) = (a.region, a.site)); 


-- add survey_id_u p.key, then add empty visit_id_u f.key, then join survey_id_u column on unique relationship 
ALTER TABLE survey_table  
ADD COLUMN survey_id_u UUID DEFAULT (uuid_generate_v4());

alter table survey_table 
add column visit_id_u UUID;


update survey_table a 
set visit_id_u = 
	(select s.visit_id_u 
	from visit s
	where (s."date", s.survey_time) = (a."date" , a.survey_time));
	
-- add capture_id_u p.key, then add empty survey_id_u f.key, then join capture_id_u column on unique relationship 
ALTER TABLE capture  
ADD COLUMN capture_id_u UUID DEFAULT (uuid_generate_v4());


alter table capture 
add column survey_id_u UUID;


update capture a 
set survey_id_u = 
	(select s.survey_id_u 
	from survey_table s
	where (s."date", s.detection_type) = (a."date", a.detection_type));
	

-- add capture_id_u p.key, then add empty survey_id_u f.key, then join capture_id_u column on unique relationship 
ALTER TABLE visual_aural 
ADD COLUMN visual_aural_id_u UUID DEFAULT (uuid_generate_v4());


alter table visual_aural  
add column survey_id_u UUID;


update visual_aural a 
set survey_id_u = 
	(select s.survey_id_u 
	from survey_table s
	where (s."date", s.detection_type) = (a."date", a.detection_type));


select count(*)
from capture c 


