import { z } from "zod";

export const customerSchema = z.object({ name: z.string().trim().min(2), segment: z.string().min(1), contact: z.string().trim().min(2), phone: z.string().trim().min(6) });
export const opportunitySchema = z.object({ name: z.string().trim().min(2), customer: z.string().min(1), segment: z.string().min(1), value: z.coerce.number().nonnegative(), source: z.string().min(1) });
export const quotationSchema = z.object({ opportunity: z.string().min(1), quantity: z.coerce.number().positive(), price: z.coerce.number().nonnegative(), discount: z.coerce.number().nonnegative(), shipping: z.coerce.number().nonnegative() });
