"""Builds web/src/data/rides.json from the ride bookings dataset.

The dataset is not in the repo (file size). Put it where the notebook expects it, Dataset/ride_cleaned.csv and
Dataset/ncr_ride_bookings.xlsx (or .csv), or point RIDE_DATA_DIR at the folder. Run from the repo root:
    python web/scripts/build_data.py
Only aggregated counts and sums are written, so the dashboard stays small and no booking-level data is published.
"""
import json
import os
from pathlib import Path

import pandas as pd

ROOT = Path(__file__).resolve().parents[2]
DATA = Path(os.environ.get("RIDE_DATA_DIR", ROOT / "Dataset"))
c = pd.read_csv(DATA / "ride_cleaned.csv")
REASON_COLS = ["Booking ID", "Reason for cancelling by Customer", "Driver Cancellation Reason", "Incomplete Rides Reason"]
# The raw file (for the text cancellation reasons) may be the original .xlsx or a .csv export
raw_csv = DATA / "ncr_ride_bookings.csv"
raw = pd.read_csv(raw_csv, usecols=REASON_COLS) if raw_csv.exists() else pd.read_excel(DATA / "ncr_ride_bookings.xlsx", usecols=REASON_COLS)
# Both files list the same bookings in the same order (booking IDs repeat, so a join would duplicate rows)
assert (c["booking_id"].str.strip('"').values == raw["Booking ID"].str.strip('"').values).all()
for col in REASON_COLS[1:]:
    c[col] = raw[col].values

c["month"] = c["date"].str.slice(0, 7)
c["quarter"] = "Q" + ((c["date"].str.slice(5, 7).astype(int) - 1) // 3 + 1).astype(str)
c["hour"] = c["time"].str.slice(0, 2).astype(int)
c["payment"] = c["payment_method"].fillna("Not paid")

vehicles = sorted(c["vehicle_type"].unique())
statuses = ["Completed", "Cancelled by Driver", "Cancelled by Customer", "No Driver Found", "Incomplete"]
payments = ["UPI", "Cash", "Uber Wallet", "Credit Card", "Debit Card", "Not paid"]
months = sorted(c["month"].unique())
vi, si, pi, mi = ({v: i for i, v in enumerate(x)} for x in (vehicles, statuses, payments, months))

def num(s):
    return [round(float(s.sum()), 2), int(s.notna().sum())]

# Main cube: month x vehicle x status x payment -> bookings, value sum/n, distance sum/n, driver rating sum/n, customer rating sum/n
main = []
for (m, v, s, p), g in c.groupby(["month", "vehicle_type", "booking_status", "payment"]):
    main.append([mi[m], vi[v], si[s], pi[p], len(g), *num(g["booking_value"]), *num(g["ride_distance"]), *num(g["driver_rating"]), *num(g["customer_rating"])])

quarters = ["Q1", "Q2", "Q3", "Q4"]
qi = {q: i for i, q in enumerate(quarters)}
# Smaller cubes by quarter (the dashboard's time filter)
hours = [[int(h), qi[q], vi[v], si[s], len(g)] for (h, q, v, s), g in c.groupby(["hour", "quarter", "vehicle_type", "booking_status"])]
locations = sorted(c["pickup_location"].unique())
li = {l: i for i, l in enumerate(locations)}
pickups = [[li[l], qi[q], vi[v], si[s], len(g)] for (l, q, v, s), g in c.groupby(["pickup_location", "quarter", "vehicle_type", "booking_status"])]

reasons, cube_r = [], []
for col, kind in [("Reason for cancelling by Customer", "customer"), ("Driver Cancellation Reason", "driver"), ("Incomplete Rides Reason", "incomplete")]:
    for (r, q, v), g in c.dropna(subset=[col]).groupby([col, "quarter", "vehicle_type"]):
        key = f"{kind}|{r}"
        if key not in reasons:
            reasons.append(key)
        cube_r.append([reasons.index(key), qi[q], vi[v], len(g)])

out = {"months": months, "quarters": quarters, "vehicles": vehicles, "statuses": statuses, "payments": payments, "locations": locations, "reasons": reasons,
       "main": main, "hours": hours, "pickups": pickups, "reasonCounts": cube_r,
       "fields": {"main": "month,vehicle,status,payment,bookings,valueSum,valueN,distSum,distN,driverRatingSum,driverRatingN,customerRatingSum,customerRatingN",
                  "hours": "hour,quarter,vehicle,status,bookings", "pickups": "location,quarter,vehicle,status,bookings", "reasonCounts": "reason,quarter,vehicle,bookings"}}
dest = ROOT / "web" / "src" / "data" / "rides.json"
dest.parent.mkdir(parents=True, exist_ok=True)
dest.write_text(json.dumps(out, separators=(",", ":"), ensure_ascii=False), encoding="utf-8")
print(f"{len(c):,} bookings -> {dest.relative_to(ROOT)} ({dest.stat().st_size/1024:.0f} KB); main {len(main)}, hours {len(hours)}, pickups {len(pickups)}, reasons {len(cube_r)}")
v = c.groupby("vehicle_type")["booking_value"].sum()
print(f"revenue {c.booking_value.sum():,.0f} | completed {(c.booking_status=='Completed').mean():.1%} | Auto {v['Auto']/v.sum():.1%} | avg value {c.booking_value.mean():.1f} | avg km {c.ride_distance.mean():.2f} | driver rating {c.driver_rating.mean():.2f}")
