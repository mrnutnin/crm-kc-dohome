create table if not exists public.opportunity_products (
  opportunity_id uuid not null references public.opportunities(id) on delete cascade,
  product_id uuid not null references public.products(id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (opportunity_id, product_id)
);

alter table public.opportunity_products enable row level security;
do $$ begin
  create policy "authenticated read opportunity_products" on public.opportunity_products for select to authenticated using (true);
exception when duplicate_object then null; end $$;
do $$ begin
  create policy "authenticated write opportunity_products" on public.opportunity_products for all to authenticated using (true) with check (true);
exception when duplicate_object then null; end $$;
