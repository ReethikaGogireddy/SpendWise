def parse_receipt_text(text: str) -> dict:
    lines = text.splitlines()

    merchant_name = lines[0] if lines else None
    total_amount = None

    for line in lines:
        if "Total" in line:
            parts = line.replace("Total", "").strip().split()
            try:
                total_amount = float(parts[-1])
            except Exception:
                total_amount = None

    return {
        "merchant_name": merchant_name,
        "receipt_date": None,
        "total_amount": total_amount,
    }