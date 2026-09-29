alter table public.products
  add column if not exists supplier_price_per_meter numeric(14,2) not null default 0;

create table if not exists public.supplier_quotations (
  id uuid primary key default gen_random_uuid(),
  quotation_number text unique not null,
  opportunity_id uuid not null references public.opportunities(id) on delete cascade,
  opportunity_name text not null,
  supplier_id uuid not null references public.suppliers(id),
  supplier_name text not null,
  subtotal numeric(14,2) not null default 0,
  vat numeric(14,2) not null default 0,
  total_amount numeric(14,2) not null default 0,
  status text not null default 'Received',
  created_at timestamptz not null default now()
);

create table if not exists public.supplier_quotation_items (
  id uuid primary key default gen_random_uuid(),
  supplier_quotation_id uuid not null references public.supplier_quotations(id) on delete cascade,
  product_id uuid references public.products(id) on delete set null,
  product_name text not null,
  quantity numeric(14,2) not null default 0,
  unit_price numeric(14,2) not null default 0,
  line_total numeric(14,2) not null default 0
);

alter table public.supplier_quotations enable row level security;
alter table public.supplier_quotation_items enable row level security;

create policy "authenticated read supplier_quotations" on public.supplier_quotations for select to authenticated using (true);
create policy "authenticated write supplier_quotations" on public.supplier_quotations for all to authenticated using (true) with check (true);
create policy "authenticated read supplier_quotation_items" on public.supplier_quotation_items for select to authenticated using (true);
create policy "authenticated write supplier_quotation_items" on public.supplier_quotation_items for all to authenticated using (true) with check (true);
