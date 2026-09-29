export type PricingInput = { quantity: number; unitPrice: number; cuttingFee?: number; discountAmount?: number; discountPercent?: number; shipping?: number };

export function calculatePricing(input: PricingInput) {
  const merchandise = input.quantity * input.unitPrice;
  const cutting = input.quantity * (input.cuttingFee ?? 0);
  const subtotal = merchandise + cutting;
  const discount = Math.min(subtotal, subtotal * ((input.discountPercent ?? 0) / 100) + (input.discountAmount ?? 0));
  const shipping = Math.max(0, input.shipping ?? 0);
  const beforeVat = Math.max(0, subtotal - discount + shipping);
  const vat = Math.round(beforeVat * 0.07 * 100) / 100;
  const total = Math.round((beforeVat + vat) * 100) / 100;
  return { merchandise, cutting, subtotal, discount, shipping, beforeVat, vat, total };
}
