alter table product_spec_keys 
add column tenant_id uuid,
add constraint fk_prod_spec_key_tenant foreign key (tenant_id) references tenant (id);

alter table product_spec_keys rename  to product_specification;