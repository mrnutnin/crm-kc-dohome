# CRM MVP — Prompt vs Project Checklist

อัปเดตล่าสุด: 2026-09-21

สถานะ:

- `[x]` ครบและใช้งานได้ตาม Prompt
- `[~]` มีบางส่วน แต่ยังไม่ครบหรือยังเป็น mock/local state
- `[ ]` ยังไม่มี

## 1. Foundation และ Tech Stack

- `[x]` Next.js App Router + TypeScript
- `[x]` Supabase browser client และ environment variables
- `[x]` Supabase migration และ seed script
- `[x]` Anonymous Supabase session สำหรับ Demo
- `[x]` `npm run typecheck` ผ่าน
- `[x]` `npm run build` ผ่าน
- `[~]` Deploy บน Vercel: มี config พื้นฐาน แต่ยังไม่ได้ deploy จริง
- `[~]` Tailwind CSS: ยังใช้ CSS ปกติใน `app/globals.css`
- `[ ]` shadcn/ui components
- `[ ]` TanStack Query สำหรับ fetching/mutation
- `[~]` Zod validation: ใช้ Zod แล้ว แต่ยังไม่ได้ใช้ React Hook Form
- `[~]` Icons: ใช้ Boxicons CDN แทน Lucide ตามการปรับ UX ล่าสุด

## 2. Navigation และ UX/UI

- `[x]` Dashboard, Customers, Opportunities, Quotations, Procurement, Supplier Portal, Sync Center, Settings
- `[x]` Sidebar desktop
- `[x]` URL route สำหรับหน้าหลัก เช่น `/customers` และ `/quotations`
- `[x]` Responsive layout พื้นฐาน
- `[x]` TH/EN toggle สำหรับข้อความหลักและฟอร์มหลัก
- `[x]` SweetAlert2 toast และ confirmation dialog
- `[x]` Boxicons ใน sidebar และ table actions
- `[~]` Mobile navigation: ยังเป็น horizontal sidebar ไม่ใช่ bottom navigation โดยเฉพาะ
- `[x]` Loading/empty/error state ระดับ MVP: form loading, table empty state และ SweetAlert error state
- `[ ]` Sign in / Demo role switcher เป็นหน้าแยก
- `[~]` Demo role switcher: มี selector แต่ยังไม่ใช่ user/session ตาม account จริง
- `[ ]` โลโก้ KC และ DoHome จริงใน Sign in, Dashboard และเอกสาร
- `[ ]` Brand asset/config ที่เปลี่ยนโลโก้และสีได้จากจุดเดียว
- `[~]` ตารางบน mobile: มี horizontal scroll แต่ยังต้องทดสอบ 375px รายหน้า

## 3. CRM และ Quotation Flow

- `[x]` สร้าง Customer ลง Supabase
- `[x]` สร้าง Opportunity ลง Supabase
- `[x]` Project segment เป็น select
- `[x]` Lead source เป็น select
- `[x]` แสดงรายละเอียดและลบ Customer/Opportunity/Quotation
- `[~]` Customer → Opportunity: มี customer name แต่ยังไม่ได้บันทึก `customer_id` แบบ relational จากฟอร์ม
- `[~]` Opportunity อ้างอิง Project: ยังไม่มี project selector และ `project_id` ใน flow
- `[~]` Quotation สร้างลง Supabase: บันทึกเป็น header แบบย่อ
- `[ ]` Quotation builder เลือก Product จาก master data
- `[ ]` Quotation items หลายรายการและแก้ไขรายการได้
- `[ ]` ระบุ product specification, length, thickness, cutting fee จริง
- `[ ]` ดึงราคา Product/Price rule อัตโนมัติ
- `[~]` คำนวณ quantity, price, discount, shipping และ VAT 7%
- `[ ]` validation ส่วนลดไม่เกินยอดสินค้า, ยอดติดลบ, จำนวนต้องมากกว่า 0
- `[ ]` บันทึก `quotation_items`
- `[~]` Mark Won: เปลี่ยนเฉพาะ local state ยังไม่ update Supabase
- `[ ]` Mark Lost / เหตุผล Lost
- `[ ]` Won แล้ว lock การแก้ไขเอกสารใน database/UI

## 4. PR → PO → KC Flow

- `[~]` Create PR: เปลี่ยน local status เท่านั้น ยังไม่ insert `purchase_requisitions`
- `[~]` Approve PR: local state เท่านั้น ยังไม่ update Supabase และไม่มี audit data
- `[ ]` PR ดึงรายการจาก Quotation อัตโนมัติ
- `[ ]` PR detail page และรายการสินค้า
- `[ ]` Reject PR พร้อมเหตุผล
- `[~]` Create PO: insert header ลง Supabase แต่ยังไม่ผูก `pr_id` และ `supplier_id`
- `[ ]` PO เริ่ม Draft แล้วค่อย Send แยก action
- `[ ]` PO items และ product snapshot
- `[~]` Send PO: รวมอยู่ใน Create PO action ยังไม่แยก state transition
- `[~]` Supplier Portal: มีปุ่มเปลี่ยนสถานะ แต่ update เฉพาะ local state
- `[ ]` บันทึก `fulfillment_updates` ลง Supabase
- `[ ]` บังคับลำดับ Accepted → In Production → Ready to Ship → Shipped ใน database/action guard
- `[ ]` Reject/Cancel PO พร้อมเหตุผล
- `[ ]` PO detail timeline จากข้อมูลจริง
- `[ ]` PO preview/print A4

## 5. Sync Center

- `[~]` แสดง Sync status จาก quotation/PO local data
- `[ ]` สร้าง `sync_logs` เมื่อสร้างหรือเปลี่ยนสถานะเอกสาร
- `[ ]` แสดง PR และ Shipment sync logs จาก Supabase จริง
- `[~]` Retry failed PO sync เปลี่ยน local state
- `[ ]` Retry sync บันทึก Pending → Synced และ retry count ลง Supabase
- `[ ]` Quotation failed retry ทำงานจริง
- `[ ]` error message และ last synced timestamp จาก database

## 6. Supplier Entitlement

- `[x]` แสดง KC เป็น Included Partner
- `[x]` แสดง Supplier อื่นเป็น Paid Add-on
- `[x]` Activate Demo Access: อัปเดต entitlement จริงและแสดงสถานะ Active
- `[x]` Add Supplier เฉพาะ System Admin
- `[x]` Upgrade modal
- `[x]` บล็อกการเพิ่ม/ใช้งาน Supplier อื่นผ่าน action guard จนกว่าจะ activate entitlement
- `[x]` บันทึก entitlement action ลง Supabase เมื่อมี Supplier record

## 7. Master Data และ Seed

- `[~]` Product tables มี schema และ seed สินค้าบางส่วน
- `[ ]` Product categories ครบทั้ง 5 หมวดตาม Prompt
- `[x]` Lead source options ครบในฟอร์ม
- `[x]` Project segment options ครบในฟอร์ม
- `[ ]` Customer seed อย่างน้อย 12 ราย — ปัจจุบันมี 3 ราย
- `[ ]` Opportunity seed อย่างน้อย 8 ราย — ปัจจุบันมี 2–3 ราย
- `[ ]` Quotation seed อย่างน้อย 6 ใบ — ปัจจุบันมี 2 ใบ
- `[ ]` PR seed อย่างน้อย 4 รายการ — ปัจจุบันมี 1 รายการ
- `[ ]` PO seed อย่างน้อย 3 ใบ — ปัจจุบันมี 2 ใบ
- `[ ]` Sync log seed อย่างน้อย 10 รายการ — ปัจจุบันยังไม่มี seed ที่ครบตามจำนวน
- `[x]` มี Won Quotation และ Approved PR ใน seed
- `[x]` มี PO หลาย Fulfillment status
- `[x]` มี Supplier อื่นเป็น Paid Add-on
- `[~]` Seed รันซ้ำ: ตารางหลักบางส่วนมี unique key แต่ fulfillment/sync seed ยังต้องทำให้ idempotent ครบ

## 8. Database Schema และ RLS

- `[ ]` ตาราง `customer_contacts` ยังไม่มีใน migration
- `[x]` ตารางหลักส่วนใหญ่มีใน migration
- `[~]` Opportunity → Customer: มี customer_id ใน schema แต่ create flow ยังส่งเฉพาะ customer_name
- `[ ]` Opportunity → Project: ยังไม่มี project_id ใน opportunities
- `[x]` Quotation → Opportunity schema
- `[x]` PR → Quotation schema
- `[~]` PO → PR/Supplier schema แต่ create flow ยังไม่ส่ง foreign keys
- `[x]` Fulfillment update → PO schema
- `[x]` Sync log มี document_type/document_id
- `[x]` มี RLS enable statements
- `[~]` RLS policy ปัจจุบัน authenticated users เขียนได้กว้าง และไม่ได้ตรวจ Demo role ที่ database
- `[~]` Role permission อยู่ที่ client application เป็นหลัก
- `[ ]` Production-grade role claims/server-side authorization
- `[ ]` profiles ถูกสร้างอัตโนมัติหลัง anonymous sign-in

## 9. Pricing และเอกสาร

- `[~]` แสดง THB และ VAT 7%
- `[~]` มี discount/shipping fields
- `[ ]` cutting fee คำนวณตาม Product จริง
- `[ ]` รองรับ discount แบบเปอร์เซ็นต์และจำนวนเงินแยกกัน
- `[x]` ปัดเศษ 2 ตำแหน่งแบบกำหนดชัดเจนใน shared pricing utility
- `[ ]` snapshot ราคาลง quotation_items และ purchase_order_items
- `[~]` Quotation print A4
- `[ ]` PO print A4
- `[~]` พิมพ์ซ่อน navigation/control
- `[ ]` วันหมดอายุ quotation และวันที่ต้องการสินค้า
- `[ ]` ข้อมูลบริษัท/ที่อยู่/เลขผู้เสียภาษี/เงื่อนไขชำระเงิน
- `[ ]` โลโก้จริงทั้งสองฝ่าย

## 10. Testing และ Delivery

- `[x]` README setup เบื้องต้น
- `[x]` `.env.example`
- `[x]` typecheck ผ่าน
- `[x]` production build ผ่านหลัง clean `.next`
- `[ ]` `npm run lint` ถูกตรวจแยกและผ่าน
- `[ ]` automated test pricing calculation
- `[ ]` automated/manual test หลักแบบ documented
- `[ ]` test role permission matrix
- `[ ]` test responsive 375px
- `[ ]` test migration + seed จาก Supabase project ว่าง
- `[ ]` test seed ซ้ำแบบไม่เกิดข้อมูลซ้ำครบทุกตาราง
- `[ ]` Vercel deployment จริง

## 11. Additional Productivity Features

### Workflow Guide

- `[x]` เมนู Workflow และ route `/workflow`
- `[x]` Flow Chart ตั้งแต่ CRM → Quotation → PR/PO → KC Fulfillment → Sync
- `[x]` แสดง owner และ status transition ของแต่ละขั้นตอน
- `[x]` ปุ่มลัดจากแต่ละขั้นไปยังหน้าที่เกี่ยวข้อง
- `[x]` รองรับภาษา TH/EN และ responsive layout

### Calendar

- `[x]` หน้า Calendar สำหรับนัดหมายและติดตามกิจกรรม CRM ระดับ MVP
- `[x]` แสดงกิจกรรมของ Customer
- `[~]` รองรับมุมมอง Month / Week / Agenda: ปัจจุบันเป็น grouped agenda view
- `[~]` สร้างกิจกรรมได้; แก้ไข/ลบยังไม่ทำ
- `[x]` กำหนดชื่อกิจกรรม วันที่ เวลา ผู้รับผิดชอบ และหมายเหตุ
- `[x]` บันทึกกิจกรรมลง Supabase ผ่าน `crm_activities`
- `[x]` แยกสิทธิ์การสร้างตาม Demo role
- `[x]` แสดงสถานะกิจกรรม Planned, Completed, Cancelled ใน schema/UI
- `[x]` รองรับภาษา TH/EN และ responsive บนมือถือ

### Kanban Board

- `[x]` หน้า Kanban สำหรับ Opportunity pipeline
- `[x]` คอลัมน์ New, Qualified, Proposal, Won และ Lost
- `[~]` แสดงการ์ด Customer และ Value; Owner/Expected close date ยังไม่มีใน schema/UI
- `[x]` Drag and drop เพื่อเปลี่ยน stage
- `[x]` บันทึก stage ใหม่ลง Supabase
- `[x]` จำกัดการย้าย stage ตาม role เบื้องต้น
- `[x]` เปิดรายละเอียด Opportunity จากการ์ดได้
- `[ ]` รองรับ filter ตาม Owner, Segment, Lead source และช่วงเวลา
- `[x]` แสดงจำนวนรายการต่อคอลัมน์
- `[x]` รองรับภาษา TH/EN และ responsive บนมือถือ

## Priority backlog

### P0 — ต้องทำเพื่อให้ตรง Functional MVP

- [x] ทำ Quotation items/Product selector และบันทึกรายการจริง
- [x] ทำ PR CRUD/approval ลง Supabase และ link จาก Quotation
- [x] ทำ PO link กับ PR/Supplier และแยก Draft → Send
- [x] ทำ Fulfillment update และ Sync log ลง Supabase จริง
- [x] เพิ่ม seed data ให้ครบจำนวนตาม Prompt
- [x] เพิ่ม PO print และแก้ Quotation print ให้ใช้ข้อมูลจริง
- [x] เพิ่ม `customer_contacts` และ Project relation ให้ครบ schema

### P1 — ต้องทำเพื่อ Demo ที่น่าเชื่อถือ

- [x] ทำ entitlement activation/upgrade modal ให้กดใช้งานจริง
- [x] เพิ่ม validation กลางด้วย Zod
- [x] เพิ่ม loading/empty/error states ครบทุก route ระดับ MVP
- [x] เพิ่ม company master data และ brand identity กลาง
- [x] เพิ่ม role/action matrix และ guard ให้ครบทุก action หลัก
- [x] เพิ่ม pricing utility และ test
- [~] Calendar: มี agenda view และ create flow แล้ว เหลือ edit/delete และ Month/Week view
- `[~]` Kanban Board: มี drag/drop และ persist stage แล้ว เหลือ filters และ field เพิ่มเติม

### P2 — Quality และ Production readiness

- [ ] ใช้ TanStack Query หรือ data layer กลาง
- [ ] เปลี่ยน simulated role เป็น real auth/claims
- [ ] เพิ่ม automated E2E/manual checklist
- [ ] Deploy Vercel และทดสอบ environment/redirect URLs
- [ ] แก้ security policy จาก broad authenticated write เป็น role-aware policies
