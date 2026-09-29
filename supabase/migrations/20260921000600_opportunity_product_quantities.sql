alter table public.opportunity_products
  add column if not exists quantity numeric not null default 1;
