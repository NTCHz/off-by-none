def apply_discount(price, pct):
    pct = min(pct, 50)
    return price * (1 - pct / 100)

def format_price(p):
    # show price with dollar sign
    return "$" + str(int(p))
