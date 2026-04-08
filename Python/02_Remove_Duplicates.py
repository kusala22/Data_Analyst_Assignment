# ============================================================
#  02_Remove_Duplicates.py
#  Remove duplicate characters from a string using a loop
#  Example: "programming" -> "progamin"
# ============================================================

def remove_duplicates(input_string):
    result = ""

    for char in input_string:
        if char not in result:      # only add if not seen before
            result += char

    return result


# ── Test Cases ───────────────────────────────────────────────
test_strings = [
    "programming",
    "hello world",
    "aabbccdd",
    "PlatinumRx",
    "mississippi",
    "abcabc",
]

for s in test_strings:
    print(f"Input : {s}")
    print(f"Output: {remove_duplicates(s)}")
    print()
