CREATE TABLE follow_products
(
  id uuid NOT NULL,
  user_id uuid,
  product_id uuid,
  CONSTRAINT pk_follow_products PRIMARY KEY (id)
);