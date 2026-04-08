# ============================================================
#  01_Time_Converter.py
#  Convert integer minutes into human readable format
#  Example: 130 -> "2 hrs 10 minutes"
# ============================================================

def convert_minutes(total_minutes):
    if total_minutes < 0:
        return "Invalid input: minutes cannot be negative"
    
    hours = total_minutes // 60       # integer division
    minutes = total_minutes % 60      # remainder

    if hours == 0:
        return f"{minutes} minutes"
    elif minutes == 0:
        return f"{hours} hrs"
    else:
        return f"{hours} hrs {minutes} minutes"


# ── Test Cases ───────────────────────────────────────────────
test_values = [130, 110, 60, 45, 0, 120, 95, 200]

for mins in test_values:
    print(f"{mins:>4} minutes  ->  {convert_minutes(mins)}")
