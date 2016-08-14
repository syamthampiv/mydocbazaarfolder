alter table product_classification drop column asset_id,
                                   add column classification_type character varying(100);
											 
INSERT INTO  product_classification(
            id, name, tenant_id, description, classification_sequence, classification_type)
    VALUES ('e8998c58-cb34-4764-bc5e-0d217b63d853', 'Main Image', 'f562846d-f8ed-4977-a90f-7ca01ae78c43', 'Main Image', 1, 'images');

INSERT INTO  product_classification(
            id, name, tenant_id, description, classification_sequence, classification_type)
    VALUES ('c2b9e66b-b773-4784-a197-976deefac5af', 'Images', 'f562846d-f8ed-4977-a90f-7ca01ae78c43', 'Images', 2, 'images');    

INSERT INTO  product_classification(
            id, name, tenant_id, description, classification_sequence, classification_type)
    VALUES ('64de64ee-400b-45df-bf8b-51760b9c81dd', 'Videos', 'f562846d-f8ed-4977-a90f-7ca01ae78c43', 'Videos', 3, 'videos');    

INSERT INTO  product_classification(
            id, name, tenant_id, description, classification_sequence, classification_type)
    VALUES ('cde0213f-aba2-48d2-aded-c83bcfba4aa6', 'Brochures', 'f562846d-f8ed-4977-a90f-7ca01ae78c43', 'Brochures', 4, 'brochures');    

INSERT INTO  product_classification(
            id, name, tenant_id, description, classification_sequence, classification_type)
    VALUES ('8a59ffcc-6006-43e4-9b2a-c4fac80d1b8d', 'Certificates', 'f562846d-f8ed-4977-a90f-7ca01ae78c43', 'Certificates', 5, 'certificates');  											 