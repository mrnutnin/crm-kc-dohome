insert into public.suppliers (name, status) values ('KC','Active'), ('Steel Partner Co.','Active') on conflict (name) do nothing;
insert into public.supplier_entitlements (supplier_id, entitlement_type, active)
select id, case when name = 'KC' then 'Included Partner' else 'Paid Add-on' end, name = 'KC' from public.suppliers
on conflict do nothing;
insert into public.customers (name, segment, contact_name, phone) values
('บริษัท บ้านดี จำกัด','บริษัทรับสร้างบ้าน','คุณกิตติ','02-100-1000'),
('โครงการสุขใจ เรสซิเดนซ์','หมู่บ้านจัดสรร','คุณอร','02-100-2000'),
('ไทยโปรเจกต์ คอนสตรัคชั่น','ผู้รับเหมาก่อสร้าง','คุณเอก','02-100-3000')
on conflict do nothing;
insert into public.products (name, category, model, height_type, section, thickness, length, price_per_meter, cutting_fee) values
('แปสำเร็จรูป C75','แปสำเร็จรูปสูงและเตี้ย','C75','สูง','75x45','1.6',6,145,15),
('เมทัลชีทติด PU','เมทัลชีทติด PU','PU-25',null,null,'0.35',4,290,0),
('Tank Truss T01','Tank Truss','T01',null,'มาตรฐาน','1.2',6,430,20)
on conflict do nothing;
insert into public.products (name, category, model, thickness, length, price_per_meter, cutting_fee) values
('ประตูม้วนอุตสาหกรรม R01', 'ประตูม้วน', 'R01', '0.8', 5, 1250, 50),
('หลังคาเมทัลชีท M01', 'หลังคาเมทัลชีท', 'M01', '0.47', 6, 360, 0)
on conflict do nothing;

insert into public.customers (name, segment, contact_name, phone)
select 'ลูกค้า Demo ' || lpad(n::text, 2, '0'),
  (array['บริษัทรับสร้างบ้าน','หมู่บ้านจัดสรร','โกดัง','โรงงาน','ผู้รับเหมาก่อสร้าง'])[((n - 1) % 5) + 1],
  'ผู้ติดต่อ Demo ' || n, '02-200-' || lpad(n::text, 4, '0')
from generate_series(1, 12) n
on conflict do nothing;

insert into public.projects (name, segment, customer_id)
select c.name || ' Project', c.segment, c.id from public.customers c
where not exists (select 1 from public.projects p where p.name = c.name || ' Project');
insert into public.customer_contacts (customer_id, name, phone, is_primary)
select c.id, coalesce(c.contact_name, 'ผู้ติดต่อ'), c.phone, true from public.customers c
where not exists (select 1 from public.customer_contacts cc where cc.customer_id = c.id and cc.is_primary);

insert into public.opportunities (name, customer_id, customer_name, expected_value, stage, lead_source)
select 'บ้านดี เฟส 2', id, name, 850000, 'Won', 'Project' from public.customers where name = 'บริษัท บ้านดี จำกัด'
on conflict do nothing;
insert into public.opportunities (name, customer_id, customer_name, expected_value, stage, lead_source)
select 'คลังสินค้า WH-01', id, name, 420000, 'Proposal', 'Direct Sale' from public.customers where name = 'ไทยโปรเจกต์ คอนสตรัคชั่น'
on conflict do nothing;
insert into public.opportunities (name, customer_id, customer_name, expected_value, stage, lead_source, project_id, project_segment)
select 'Demo Opportunity ' || lpad(n::text, 2, '0'), c.id, c.name, 150000 + (n * 25000),
  (array['New','Qualified','Proposal','Won','Lost'])[((n - 1) % 5) + 1], 'Project', p.id, c.segment
from generate_series(1, 8) n
cross join lateral (select c2.* from public.customers c2 order by c2.created_at offset ((n - 1) % 5) limit 1) c
left join lateral (select p2.id from public.projects p2 where p2.customer_id = c.id order by p2.created_at limit 1) p on true
on conflict do nothing;

insert into public.opportunity_products (opportunity_id, product_id)
select o.id, p.id
from public.opportunities o
cross join lateral (select p2.id from public.products p2 order by p2.created_at, p2.name limit 2) p
where o.name in ('บ้านดี เฟส 2', 'คลังสินค้า WH-01')
on conflict do nothing;

insert into public.quotations (quotation_number, opportunity_id, opportunity_name, customer_name, subtotal, vat, total_amount, status, sync_status)
select 'QT-2026-0001', o.id, o.name, o.customer_name, 794392.52, 55557.48, 850000, 'Won', 'Synced' from public.opportunities o where o.name = 'บ้านดี เฟส 2'
on conflict (quotation_number) do nothing;
insert into public.quotations (quotation_number, opportunity_id, opportunity_name, customer_name, subtotal, vat, total_amount, status, sync_status)
select 'QT-2026-0002', o.id, o.name, o.customer_name, 392523.36, 27476.64, 420000, 'Sent', 'Pending' from public.opportunities o where o.name = 'คลังสินค้า WH-01'
on conflict (quotation_number) do nothing;
insert into public.quotations (quotation_number, opportunity_id, opportunity_name, customer_name, subtotal, vat, total_amount, status, sync_status)
select 'QT-2026-' || lpad(n::text, 4, '0'), o.id, o.name, o.customer_name, 100000 + n * 10000, (100000 + n * 10000) * .07, (100000 + n * 10000) * 1.07, 'Draft', 'Pending'
from generate_series(3, 6) n
join lateral (select o2.* from public.opportunities o2 order by o2.created_at offset ((n - 1) % 6) limit 1) o on true
on conflict (quotation_number) do nothing;

insert into public.purchase_requisitions (pr_number, quotation_id, status)
select 'PR-2026-0001', id, 'Approved' from public.quotations where quotation_number = 'QT-2026-0001'
on conflict (pr_number) do nothing;
insert into public.purchase_requisitions (pr_number, quotation_id, status)
select 'PR-2026-' || lpad(n::text, 4, '0'), q.id, case when n = 2 then 'Pending Approval' else 'Draft' end
from generate_series(2, 4) n
join lateral (select q2.* from public.quotations q2 order by q2.created_at offset ((n - 1) % 5) limit 1) q on true
on conflict (pr_number) do nothing;
insert into public.purchase_orders (po_number, pr_id, supplier_id, supplier_name, total_amount, status, sync_status)
select 'PO-2026-0001', pr.id, s.id, s.name, 850000, 'In Production', 'Synced'
from public.purchase_requisitions pr cross join public.suppliers s where pr.pr_number = 'PR-2026-0001' and s.name = 'KC'
on conflict (po_number) do nothing;
insert into public.purchase_orders (po_number, supplier_id, supplier_name, total_amount, status, sync_status)
select 'PO-2026-0002', s.id, s.name, 420000, 'Shipped', 'Failed' from public.suppliers s where s.name = 'KC'
on conflict (po_number) do nothing;
insert into public.purchase_orders (po_number, supplier_id, supplier_name, total_amount, status, sync_status)
select 'PO-2026-0003', s.id, s.name, 175000, 'Draft', 'Pending' from public.suppliers s where s.name = 'KC'
on conflict (po_number) do nothing;

insert into public.fulfillment_updates (po_id, status, note)
select id, status, 'Seed demo status' from public.purchase_orders where po_number in ('PO-2026-0001','PO-2026-0002');
insert into public.sync_logs (document_type, document_id, document_number, status, last_synced_at)
select 'Quotation', id, quotation_number, sync_status, now() from public.quotations
on conflict do nothing;
insert into public.sync_logs (document_type, document_id, document_number, status, last_synced_at)
select 'Purchase Order', id, po_number, sync_status, now() from public.purchase_orders
on conflict do nothing;
insert into public.sync_logs (document_type, document_id, document_number, status, last_synced_at)
select 'PR', id, pr_number, status, now() from public.purchase_requisitions
on conflict do nothing;

insert into public.crm_activities (title, customer_id, customer_name, date, time, owner_name, status, note)
select 'Follow up บ้านดี เฟส 2', id, name, '2026-09-22', '10:00', 'DoHome Sales', 'Planned', 'ติดตามการยืนยันสเปก' from public.customers where name = 'บริษัท บ้านดี จำกัด'
and not exists (select 1 from public.crm_activities where title = 'Follow up บ้านดี เฟส 2');
insert into public.crm_activities (title, customer_id, customer_name, date, time, owner_name, status, note)
select 'ส่งใบเสนอราคา WH-01', id, name, '2026-09-23', '14:00', 'DoHome Sales', 'Completed', 'ส่ง QT-2026-0002 แล้ว' from public.customers where name = 'ไทยโปรเจกต์ คอนสตรัคชั่น'
and not exists (select 1 from public.crm_activities where title = 'ส่งใบเสนอราคา WH-01');
