# format_sms spec
Implement format_sms(msg: str, limit: int) -> str in sms.py.
1. First collapse every run of consecutive spaces in msg to a single space
   (do not trim leading/trailing). Then apply the rules below to the collapsed string.
2. If the collapsed string's length is at or under limit, return it unchanged.
3. Otherwise return a truncated string ending in "..." whose total length is at most limit.
4. The cut must happen at the last space at or before index limit-3 (0-indexed).
   If such a space exists, cut there (the space itself is not kept) and append "...".
   If no space exists at or before that index, keep exactly limit-3 characters and append "...".
