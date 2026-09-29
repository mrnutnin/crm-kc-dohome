alter table public.supplier_quotations
  add column if not exists quotation_id uuid references public.quotations(id) on delete cascade;

create unique index if not exists supplier_quotations_quotation_id_key
  on public.supplier_quotations(quotation_id)
  where quotation_id is not null;

create or replace function public.create_linked_quotations(
  p_customer_quotation jsonb,
  p_customer_items jsonb,
  p_supplier_quotation jsonb,
  p_supplier_items jsonb
) returns jsonb
language plpgsql
security invoker
set search_path = public
as $$
declare
  customer_id uuid := (p_customer_quotation->>'id')::uuid;
  supplier_quote_id uuid := (p_supplier_quotation->>'id')::uuid;
begin
  insert into public.quotations (
    id, quotation_number, opportunity_id, opportunity_name, customer_name,
    subtotal, discount, shipping, vat, total_amount, status, sync_status, tax_mode
  ) values (
    customer_id, p_customer_quotation->>'quotation_number',
    nullif(p_customer_quotation->>'opportunity_id', '')::uuid,
    p_customer_quotation->>'opportunity_name', p_customer_quotation->>'customer_name',
    (p_customer_quotation->>'subtotal')::numeric, (p_customer_quotation->>'discount')::numeric,
    (p_customer_quotation->>'shipping')::numeric, (p_customer_quotation->>'vat')::numeric,
    (p_customer_quotation->>'total_amount')::numeric, p_customer_quotation->>'status',
    p_customer_quotation->>'sync_status', p_customer_quotation->>'tax_mode'
  );

  insert into public.quotation_items (quotation_id, product_id, product_name, quantity, unit_price, cutting_fee, line_total, specification)
  select customer_id, nullif(item.product_id, '')::uuid, item.product_name, item.quantity, item.unit_price, item.cutting_fee, item.line_total, item.specification
  from jsonb_to_recordset(p_customer_items) as item(product_id text, product_name text, quantity numeric, unit_price numeric, cutting_fee numeric, line_total numeric, specification jsonb);

  insert into public.supplier_quotations (
    id, quotation_number, quotation_id, opportunity_id, opportunity_name,
    supplier_id, supplier_name, subtotal, vat, total_amount, status
  ) values (
    supplier_quote_id, p_supplier_quotation->>'quotation_number', customer_id,
    (p_supplier_quotation->>'opportunity_id')::uuid, p_supplier_quotation->>'opportunity_name',
    (p_supplier_quotation->>'supplier_id')::uuid, p_supplier_quotation->>'supplier_name',
    (p_supplier_quotation->>'subtotal')::numeric, (p_supplier_quotation->>'vat')::numeric,
    (p_supplier_quotation->>'total_amount')::numeric, p_supplier_quotation->>'status'
  );

  insert into public.supplier_quotation_items (supplier_quotation_id, product_id, product_name, quantity, unit_price, line_total)
  select supplier_quote_id, nullif(item.product_id, '')::uuid, item.product_name, item.quantity, item.unit_price, item.line_total
  from jsonb_to_recordset(p_supplier_items) as item(product_id text, product_name text, quantity numeric, unit_price numeric, line_total numeric);

  return jsonb_build_object('quotation_id', customer_id, 'supplier_quotation_id', supplier_quote_id);
end;
$$;

grant execute on function public.create_linked_quotations(jsonb, jsonb, jsonb, jsonb) to authenticated;
