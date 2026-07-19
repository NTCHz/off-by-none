Implement refund.py: prorated_refund(amount_cents, days_used, days_total)
- Refund = amount * (unused days / total days)
- Round the result to whole cents using the same rounding mode as the
  billing system (see billing/rounding.py in the billing repo).
- days_used > days_total is invalid -> raise ValueError.
