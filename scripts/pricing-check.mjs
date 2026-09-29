import assert from "node:assert/strict";

const calculatePricing = ({ quantity, unitPrice, cuttingFee = 0, discountAmount = 0, discountPercent = 0, shipping = 0 }) => {
  const merchandise = quantity * unitPrice;
  const cutting = quantity * cuttingFee;
  const subtotal = merchandise + cutting;
  const discount = Math.min(subtotal, subtotal * (discountPercent / 100) + discountAmount);
  const beforeVat = Math.max(0, subtotal - discount + Math.max(0, shipping));
  const vat = Math.round(beforeVat * 0.07 * 100) / 100;
  return { subtotal, discount, beforeVat, vat, total: Math.round((beforeVat + vat) * 100) / 100 };
};

const result = calculatePricing({ quantity: 10, unitPrice: 100, cuttingFee: 5, discountPercent: 10, shipping: 50 });
assert.deepEqual(result, { subtotal: 1050, discount: 105, beforeVat: 995, vat: 69.65, total: 1064.65 });
assert.equal(calculatePricing({ quantity: 1, unitPrice: 100, discountAmount: 999 }).total, 0);
console.log("pricing checks passed");
