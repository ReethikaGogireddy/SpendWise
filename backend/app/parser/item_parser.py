import re

from app.parser.models import ReceiptItem


class ItemParser:
    """
    Responsibility:
        Extracts receipt items from OCR text.

    Input:
        Raw OCR text.

    Output:
        List[ReceiptItem]
    """

    IGNORE_KEYWORDS = {
        "NET",
        "@",
    }

    STOP_KEYWORDS = {
        "TOTAL",
        "SUBTOTAL",
        "LOYALTY",
        "CHANGE",
        "CASH",
        "TAX",
    }

    def parse(self, raw_text: str) -> list[ReceiptItem]:
        """
        Input:
            OCR text.

        Output:
            List of extracted receipt items.
        """

        lines = raw_text.splitlines()

        items = []

        current_item = None

        for line in lines:

            line = line.strip()

            if not line:
                continue

            upper = line.upper()

            # Stop parsing when totals begin.
            if any(keyword in upper for keyword in self.STOP_KEYWORDS):
                break

            # Ignore quantity/weight lines.
            if any(keyword in upper for keyword in self.IGNORE_KEYWORDS):
                continue

            # Price found.
            if self._is_price(line):

                if current_item:

                    items.append(
                        ReceiptItem(
                            name=current_item,
                            price=self._extract_price(line),
                        )
                    )

                    current_item = None

                continue

            # Otherwise treat it as an item name.
            current_item = line

        return items

    def _is_price(self, line: str) -> bool:
        """
        Checks if the line contains only a price.

        Example:
            $4.66
            4.66
        """

        return bool(
            re.match(
                r"^\$?\d+\.\d{2}$",
                line,
            )
        )

    def _extract_price(self, line: str) -> float:
        """
        Converts:

            $4.66

        into

            4.66
        """

        return float(
            line.replace("$", "")
        )