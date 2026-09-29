# KC × DoHome CRM MVP

Functional MVP สำหรับ Demo partnership CRM ใช้ Next.js และ Supabase จริง โดยยังจำลองการเชื่อมต่อ KC และ DoHome Legacy เป็น Mock status

## Local setup

1. ติดตั้ง dependencies: `npm install`
2. สร้าง Supabase project และเปิด `Authentication → Providers → Anonymous Sign-ins`
3. คัดลอก `.env.example` เป็น `.env.local` แล้วใส่ Supabase URL และ Publishable key; เก็บ `SUPABASE_DB_PASSWORD` ไว้สำหรับ CLI/migration เท่านั้น
4. รัน migration `supabase/migrations/20260921000100_init.sql` และ seed `supabase/seed.sql` ใน Supabase SQL Editor
5. ตั้งค่า local URL `http://localhost:3000` ใน Supabase Auth URL Configuration
6. รัน `npm run dev`

หน้า Sign in ใช้ Anonymous Sign-in เพื่อสร้าง authenticated session ส่วน role ที่เลือกเป็น simulated Demo role สำหรับ UX เท่านั้น ไม่ใช่ authorization production

## Demo roles

- DoHome Sales: Customer, Opportunity, Quotation
- DoHome Purchasing: PR approval, PO creation and sending
- KC Admin: PO fulfillment updates
- System Admin: Supplier entitlement

## Checks

```bash
npm run typecheck
npm run build
```

สำหรับ production ควรเปลี่ยน simulated role เป็น Supabase Auth users และใช้ role claims หรือ server-side authorization เพิ่มเติม
