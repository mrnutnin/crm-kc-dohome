# Prompt: สร้าง MVP Mockup ระบบ CRM Partnership รถถัง × ดูโฮม

คุณคือ Senior Product Engineer และ UI/UX Engineer จงสร้าง MVP Mockup แบบใช้งานได้สำหรับนำเสนอความร่วมมือระหว่าง **รถถัง (KC)** และ **ดูโฮม (DoHome)**

เป้าหมายของระบบคือช่วยให้พนักงานดูโฮมบริหารลูกค้า เสนอราคาสินค้ารถถังได้รวดเร็ว สร้าง PR/PO ถึงรถถัง และแสดงสถานะการ Sync กลับสู่ระบบเดิมของดูโฮม ระบบนี้เป็น **CRM-first** และไม่ใช่ระบบทดแทน POS/ERP เดิมของดูโฮม

## ขอบเขต MVP

สร้างเป็น Functional MVP สำหรับ Demo ผู้บริหาร โดยใช้ Supabase จริงสำหรับ Auth session, PostgreSQL, CRUD, migration, seed และ RLS แต่ยังไม่ต้องเชื่อมต่อ API จริงกับรถถังหรือระบบเดิมของดูโฮม

ระบบไม่ต้องมี registration และ login แบบ production ให้หน้า Sign in แสดง Demo Users และให้ผู้ใช้เลือก role เพื่อจำลองการเข้าสู่ระบบ โดยระบบต้องเรียก Supabase anonymous sign-in เพื่อให้เกิด authenticated session สำหรับการใช้งาน RLS จากนั้นเก็บ Demo role ที่เลือกไว้ใน session/local state และแสดง role นั้นใน UI

README ต้องระบุวิธีเปิดใช้งาน Anonymous Sign-ins ใน Supabase Auth และวิธีตั้งค่า redirect URL สำหรับ local และ Vercel

- ทุกปุ่มและทุก Flow หลักต้องกดใช้งานได้จริงและบันทึกข้อมูลลง Supabase ไม่ใช่แค่เปลี่ยนหน้า หรือแสดง Toast
- การ Sync ให้เป็นสถานะ Mock เช่น `Pending`, `Synced`, `Failed` พร้อมวันที่ล่าสุด
- สร้างเอกสารใบเสนอราคาและ PO ในหน้าพรีวิวที่สามารถกด Print ได้
- ไม่ต้องทำระบบบัญชี สต็อกจริง รับชำระเงิน หรือคำนวณต้นทุนจริง
- หลีกเลี่ยงการใส่ความสามารถ Enterprise ที่ไม่จำเป็นต่อการ Demo

## Tech Stack

- Next.js 15+ ด้วย App Router และ TypeScript
- Tailwind CSS
- shadcn/ui สำหรับ components พื้นฐาน
- Lucide icons
- Supabase: Auth, PostgreSQL และ Row Level Security แบบพื้นฐาน
- TanStack Query สำหรับ data fetching และ mutation
- Zod + React Hook Form สำหรับ validation
- Deploy บน Vercel ได้ทันที

ห้ามใช้ backend server แยกต่างหาก และห้ามใส่ secrets ลงใน source code ใช้เฉพาะ Supabase browser client และ public environment variables เท่านั้น

## แนวทาง UI/UX

- Mobile First อย่างแท้จริง ใช้งานได้ดีที่ความกว้าง 375px
- Desktop ใช้ sidebar, Mobile ใช้ bottom navigation หรือ compact navigation
- โทนสะอาด: พื้นขาว/เทาอ่อน, น้ำเงินเข้มเป็นสีหลักของรถถัง, ส้มเป็นสีเน้นของดูโฮม
- ใช้ card, spacing และ typography ที่อ่านง่าย ไม่ทำหน้าจอแน่นแบบ ERP รุ่นเก่า
- ทุกสถานะต้องใช้สีและข้อความร่วมกัน เช่น Draft, Pending Approval, Approved, Sent, Synced, Failed
- ใส่โลโก้ KC และ DoHome ในหน้า Sign in, Dashboard และเอกสารใบเสนอราคา/PO

## บทบาทผู้ใช้งานสำหรับ Demo

1. **DoHome Sales**: สร้างลูกค้า, Opportunity, ใบเสนอราคา และส่งขออนุมัติ
2. **DoHome Purchasing**: อนุมัติ PR, สร้างและส่ง PO
3. **KC Admin**: จัดการสินค้า/ราคา, รับ PO, อัปเดตสถานะผลิตและจัดส่ง
4. **System Admin**: ดูภาพรวมและจัดการ Supplier entitlement

สำหรับ MVP ให้มี Demo User ดังนี้ และสลับบทบาทได้จากเมนู Profile โดยไม่ต้องสร้างระบบสมัครสมาชิกสมบูรณ์:

- `sales@demo.local` — DoHome Sales
- `purchasing@demo.local` — DoHome Purchasing
- `supplier@demo.local` — KC Admin
- `admin@demo.local` — System Admin

การสลับ role เป็นการจำลอง session สำหรับ Demo และต้องแสดง role ปัจจุบันอย่างชัดเจน ห้ามใช้ role ที่เลือกเพื่ออ้างว่าเป็นระบบ authentication production

## โครงสร้างเมนู

- Dashboard
- CRM
  - Customers
  - Opportunities
- Quotations
- Procurement
  - Purchase Requisitions (PR)
  - Purchase Orders (PO)
- Supplier Portal
  - Products & Pricing
  - PO Fulfillment
- Sync Center
- Settings
  - Suppliers & Entitlements

## Flow หลักที่ต้องทำให้ Demo ได้

### 1. CRM → Quotation

1. พนักงานเลือกหรือสร้างลูกค้า
2. สร้าง Opportunity พร้อมประเภทโครงการ เช่น บ้านจัดสรร, โกดัง, โรงงาน, อาคารพาณิชย์
3. เลือกสินค้าและกำหนดสเปก
4. ระบบคำนวณราคาเบื้องต้น
5. สร้างใบเสนอราคา
6. เปิดหน้าพรีวิวและ Print ใบเสนอราคาได้
7. เปลี่ยนสถานะเป็น `Won` เพื่อไปขั้นตอน PR

กติกา:

- Quotation ใหม่เริ่มที่ `Draft`
- Quotation ต้องมีสินค้าอย่างน้อย 1 รายการก่อนบันทึกหรือส่งต่อ
- Quotation เปลี่ยนเป็น `Won` หรือ `Lost` ได้จากผู้ใช้ Sales
- เมื่อเป็น `Won` แล้ว ห้ามแก้ไขรายการสินค้าและยอดรวม

### 2. Quotation → PR → PO → KC

1. กด `Create PR` จาก Quotation ที่ชนะ โดยดึงรายการสินค้าเดิมมาอัตโนมัติ
2. PR มีสถานะ Draft → Pending Approval → Approved
3. ผู้ใช้ Purchasing สร้าง PO จาก PR ที่ Approved
4. เลือก Supplier เป็น `KC` โดยค่าเริ่มต้น
5. กด `Send PO to KC`
6. KC Admin เห็น PO ใน Supplier Portal และอัปเดตสถานะเป็น Accepted → In Production → Ready to Ship → Shipped
7. หน้าดูโฮมเห็น Timeline สถานะล่าสุดได้

กติกา:

- PR ใหม่เริ่มที่ `Draft` และต้องมีสินค้าอย่างน้อย 1 รายการ
- เฉพาะ Purchasing เท่านั้นที่เปลี่ยน PR เป็น `Approved` หรือ `Rejected`
- สร้าง PO ได้เฉพาะจาก PR ที่ `Approved`
- PO ใหม่เริ่มที่ `Draft` และส่งได้เมื่อมี Supplier และรายการสินค้าครบ
- หลังส่ง PO แล้ว ห้ามแก้ไขรายการสินค้าและยอดรวม
- KC Admin เปลี่ยน Fulfillment status ได้ตามลำดับเท่านั้น
- การ Reject หรือ Cancel ต้องมีเหตุผล

### 3. Sync กับระบบเดิมของดูโฮม

ใน MVP ไม่ต้องเชื่อมจริง แต่ทุกเอกสารสำคัญต้องมี Sync status

- Quotation: Sync sales data
- PR: Sync procurement request
- PO: Sync purchase order
- Shipment status: Sync fulfillment status

หน้าจอ Sync Center ต้องแสดงประเภทข้อมูล, เลขที่เอกสาร, ปลายทาง `DoHome Legacy System`, สถานะ, เวลาล่าสุด และปุ่ม `Retry Sync` สำหรับ Mock failed record

เมื่อสร้างหรือเปลี่ยนสถานะเอกสารสำคัญ ให้สร้าง `sync_logs` เป็น `Pending` และบันทึกเวลาใน timezone Asia/Bangkok
การกด `Retry Sync` ต้องเปลี่ยน `Failed → Pending → Synced` ภายในเวลาจำลองสั้น ๆ และเพิ่ม retry count
รายการที่ `Failed` ต้องแสดง error message และรายการที่ retry สำเร็จต้องมี timestamp ล่าสุด

### 4. Supplier Entitlement

ระบบฟรีสำหรับกระบวนการสั่งซื้อกับ **KC** เท่านั้น

- ใน Supplier Settings แสดง KC เป็น `Included Partner`
- เพิ่ม Supplier อื่นได้เฉพาะ Admin
- เมื่อกดเพิ่ม Supplier อื่น ให้แสดง Upgrade modal ระบุว่าเป็นบริการเสริมที่รถถังเรียกเก็บค่าบริการ
- สำหรับ MVP สามารถกด `Activate Demo Access` เพื่อเปิดใช้งาน Supplier ตัวอย่างได้
- แสดง badge `Paid Add-on` กับ Supplier อื่นอย่างชัดเจน

## Master Data และข้อมูลตัวอย่าง

### Product categories

- แปสำเร็จรูปสูงและเตี้ย
- Tank Truss
- หลังคาเมทัลชีท
- เมทัลชีทติด PU
- ประตูม้วน

สินค้าแปต้องมี attribute: รุ่น, ประเภทสูง/เตี้ย, หน้าตัด, ความหนา, ความยาว, ราคา/เมตร, และค่าตัด

ราคาสินค้าเป็นสกุลเงิน THB และยังไม่รวม VAT

### CRM Lead sources

- ลูกค้าเก่า: เหล็กเส้น, เสาเข็ม, คอนกรีต/ไม้แบบ, เหล็กรูปพรรณ
- Direct Sale
- Project
- หน้าร้าน
- การแนะนำต่อ

### Project segments

- บริษัทรับสร้างบ้าน
- หมู่บ้านจัดสรร
- อสังหาริมทรัพย์
- โกดัง
- โรงงาน
- อาคารพาณิชย์
- ผู้รับเหมาก่อสร้าง

สร้าง Seed data อย่างน้อย:

- ลูกค้า 12 ราย
- Opportunity 8 รายในหลายสถานะ
- Quotation 6 ใบ
- PR 4 รายการ
- PO 3 ใบที่มีสถานะต่างกัน
- Sync log 10 รายการ มีทั้ง Synced, Pending และ Failed

Seed data ต้องเชื่อมโยงกันจนสามารถทดสอบ Flow หลักได้ครบ โดยต้องมีอย่างน้อย:

- Opportunity ที่มีสถานะ `Won`
- Quotation ที่มีสถานะ `Won`
- PR ที่มีสถานะ `Approved`
- PO ของ KC ที่มี Fulfillment status แตกต่างกันอย่างน้อย 3 แบบ
- Sync log ที่ผูกกับ Quotation, PR, PO และ Shipment และมีทั้ง `Synced`, `Pending`, `Failed`
- Supplier อื่นอย่างน้อย 1 รายการที่ยังไม่ Activate entitlement

## Supabase Schema ขั้นต่ำ

สร้าง migration และ seed script สำหรับตารางต่อไปนี้:

- `profiles`
- `customers`
- `customer_contacts`
- `projects`
- `opportunities`
- `products`
- `product_price_rules`
- `quotations`
- `quotation_items`
- `purchase_requisitions`
- `purchase_requisition_items`
- `purchase_orders`
- `purchase_order_items`
- `suppliers`
- `supplier_entitlements`
- `fulfillment_updates`
- `sync_logs`

ความสัมพันธ์สำคัญ:

- Opportunity อ้างอิง Customer และ Project
- Quotation อ้างอิง Opportunity
- PR อ้างอิง Quotation
- PO อ้างอิง PR และ Supplier
- Fulfillment update อ้างอิง PO
- Sync log อ้างอิงชนิดเอกสารและ document id

เพิ่ม field มาตรฐานที่จำเป็น เช่น `created_at`, `updated_at`, `created_by`, `updated_by` และ status timestamps ในตารางเอกสารที่เกี่ยวข้อง

ตั้ง RLS ดังนี้:

- ผู้ใช้ที่มี Supabase authenticated session อ่านข้อมูล Demo ได้
- ผู้ใช้ที่มี session เขียนข้อมูล Demo ได้เฉพาะแถวที่อยู่ในขอบเขต MVP
- RLS ต้องไม่เปิดเผยข้อมูลให้ unauthenticated client
- เนื่องจาก Demo role เป็น role จำลอง ให้บังคับ permission ตาม role ใน application guard และ action guard
- Sales จัดการ Customer, Opportunity และ Quotation
- Purchasing อนุมัติ PR และสร้าง/ส่ง PO
- KC Admin อ่าน PO ของ KC และแก้ไข fulfillment
- System Admin จัดการ Supplier และ Entitlement

ห้ามเชื่อถือ role ที่ส่งมาจาก client เป็นกลไก security production และต้องระบุข้อจำกัดนี้ใน README

## หน้าจอที่ต้องมี

1. **Sign in / Demo role switcher**
2. **Dashboard**: ยอด Opportunity, ใบเสนอราคาที่รอติดตาม, PR/PO ที่รออนุมัติ, PO ที่รถถังกำลังผลิต และ Sync errors
3. **Customer & Opportunity list**: search, filter, status และสร้างรายการใหม่
4. **Opportunity detail**: customer, project, lead source, activity timeline และปุ่มสร้าง quotation
5. **Quotation builder**: เพิ่มสินค้า กำหนดสเปก จำนวน ส่วนลด ค่าขนส่ง VAT และยอดรวม
6. **Quotation preview / print**: เอกสาร A4 สะอาด มีโลโก้ทั้งสองฝ่าย
7. **PR detail & approval**
8. **PO detail**: ดูรายการ PO, ส่งให้รถถัง, เอกสาร print, Timeline fulfillment และ Sync status
9. **KC Supplier Portal**: รับ PO และอัปเดตสถานะผลิต/จัดส่ง
10. **Sync Center**: ตาราง log และ retry mock action
11. **Supplier Entitlements**: KC included, other suppliers as paid add-on

ทุกหน้าจอต้องมี loading, empty state, error state และ success/error feedback ที่เหมาะสม
หน้าจอเอกสารต้องรองรับการเปิดด้วย URL โดยตรง และหลังบันทึกสำเร็จต้อง redirect ไปยังหน้าที่เหมาะสม

## กติกาการคำนวณราคา

- ยอดสินค้าต่อรายการ = จำนวน × ราคาต่อหน่วย
- ค่าตัดให้คำนวณตามค่าใน Product และหน่วยที่ระบุในสินค้า
- ส่วนลดรองรับทั้งเปอร์เซ็นต์และจำนวนเงิน แต่ยอดส่วนลดต้องไม่เกินยอดสินค้า
- ยอดก่อน VAT = ยอดสินค้า - ส่วนลด + ค่าขนส่ง
- VAT = 7% ของยอดก่อน VAT
- ยอดสุทธิ = ยอดก่อน VAT + VAT
- แสดงเงินเป็น THB ปัดเศษ 2 ตำแหน่ง และห้ามยอดติดลบ
- ราคาที่บันทึกใน Quotation และ PO ต้องเป็น snapshot ของราคาขณะสร้างเอกสาร ไม่เปลี่ยนตาม Product price ภายหลัง

## เอกสารและการพิมพ์

- Quotation และ PO ต้องพิมพ์เป็นกระดาษ A4 แนวตั้งผ่าน browser print dialog
- โหมดพิมพ์ต้องซ่อน sidebar, navigation, ปุ่ม และ control ที่ไม่ใช่เอกสาร
- เอกสารต้องมีเลขที่เอกสาร, วันที่, วันหมดอายุหรือวันที่ต้องการสินค้า, ข้อมูลคู่ค้า, รายการสินค้า, ส่วนลด, ค่าขนส่ง, VAT, ยอดสุทธิ และช่องลายเซ็น
- ใช้ข้อมูลบริษัทและโลโก้จาก mock master data หากยังไม่มี asset จริง และระบุจุดที่เปลี่ยน asset ได้ใน README

## Acceptance Criteria สำหรับ Demo

- ผู้ใช้สามารถเริ่มจาก Customer แล้วจบที่ PO ส่งให้รถถังได้ภายใน 3–5 นาที
- ใบเสนอราคาและ PO แสดงข้อมูล/ยอดรวมถูกต้องตามรายการ Mock
- PR/PO และสถานะ Fulfillment มี Timeline ที่เข้าใจง่าย
- Quotation, PR, PO แสดงสถานะ Sync ของระบบเดิมดูโฮม
- Supplier อื่นไม่สามารถสร้าง PO ได้จนกว่าจะ Activate entitlement
- ทุกหน้าจอ responsive บนมือถือและ desktop
- `npm run build` ผ่าน และ deploy Vercel ได้โดยตั้งค่า Environment Variables ตาม `.env.example`
- `npm run lint` และ `npm run typecheck` ผ่าน
- Migration และ seed สามารถรันกับ Supabase project ที่ว่างได้ และ seed รันซ้ำโดยไม่สร้างข้อมูลซ้ำ
- ผู้ใช้ที่ยังไม่มี authenticated Supabase session ไม่สามารถอ่านหรือเขียนข้อมูล Demo ได้
- ผู้ใช้แต่ละ Demo role เห็นเมนูและทำ action ได้ตาม permission ที่กำหนด
- กรณี validation, permission denied, Supabase error และ sync failure ต้องแสดงข้อความที่ผู้ใช้เข้าใจได้
- ทดสอบหน้าจอที่ viewport กว้าง 375px และ desktop โดยไม่มี horizontal overflow ที่ทำลายการใช้งาน
- Print preview แสดงเฉพาะเอกสาร A4 และยอดเงินตรงกับหน้ารายละเอียด

## Deliverables

สร้างและส่งมอบ:

1. Source code ที่รันด้วย `npm install` และ `npm run dev`
2. `.env.example` พร้อม `NEXT_PUBLIC_SUPABASE_URL` และ `NEXT_PUBLIC_SUPABASE_ANON_KEY`
3. Supabase migration และ seed data
4. `README.md` อธิบายการ setup local, Supabase และ deploy Vercel
5. ไม่มี TypeScript error, ไม่มี placeholder ที่กดแล้วไม่ทำงานใน Demo Flow
6. มีเอกสาร Demo Users, ข้อจำกัดของ simulated role session และ permission matrix ใน `README.md`
7. มี manual test checklist หรือ automated test ขนาดเล็กสำหรับ pricing calculation และ Flow หลัก

ก่อนจบงาน ให้ทดสอบ Flow นี้ด้วยข้อมูล Seed:

`Create Opportunity → Create Quotation → Mark Won → Create PR → Approve PR → Create PO → Send to KC → Update Shipment → View Sync Status`

ต้องทดสอบทั้งกรณีสำเร็จและกรณีผิดพลาดอย่างน้อย: ไม่มีสินค้าในเอกสาร, role ไม่มีสิทธิ์, Reject PR, Reject PO และ Retry failed sync
