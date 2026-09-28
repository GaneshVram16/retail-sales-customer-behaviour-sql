from pathlib import Path
import numpy as np
import pandas as pd

np.random.seed(42)
ROOT = Path(__file__).resolve().parent
DATA = ROOT / "data"
DATA.mkdir(exist_ok=True)

n_customers = 8000
n_products = 120
n_orders = 30000

cities = ["Bengaluru","Mysuru","Chennai","Hyderabad","Mumbai","Pune","Delhi","Kolkata"]
segments = ["New","Regular","Loyal"]
categories = ["Electronics","Home","Fashion","Beauty","Sports","Books","Grocery","Accessories"]

customers = pd.DataFrame({
    "customer_id": np.arange(1, n_customers+1),
    "city": np.random.choice(cities, n_customers, p=[.22,.08,.12,.12,.12,.10,.14,.10]),
    "segment": np.random.choice(segments, n_customers, p=[.34,.46,.20]),
    "signup_date": pd.to_datetime("2023-01-01") + pd.to_timedelta(np.random.randint(0, 1095, n_customers), unit="D")
})

product_rows = []
for pid in range(1, n_products+1):
    cat = categories[(pid-1) % len(categories)]
    base_price = {"Electronics":8500,"Home":2200,"Fashion":1400,"Beauty":900,
                  "Sports":1800,"Books":550,"Grocery":700,"Accessories":1100}[cat]
    price = max(150, np.random.normal(base_price, base_price*0.35))
    margin = np.random.uniform(0.16, 0.42)
    product_rows.append([pid, f"{cat} Product {pid:03d}", cat, round(price,2), round(margin,3)])
products = pd.DataFrame(product_rows, columns=["product_id","product_name","category","unit_price","margin_rate"])

order_dates = pd.to_datetime("2025-01-01") + pd.to_timedelta(np.random.randint(0,365,n_orders), unit="D")
orders = pd.DataFrame({
    "order_id": np.arange(1,n_orders+1),
    "customer_id": np.random.randint(1,n_customers+1,n_orders),
    "order_date": order_dates,
    "payment_method": np.random.choice(["UPI","Credit Card","Debit Card","COD","Wallet"], n_orders, p=[.38,.23,.15,.14,.10]),
    "channel": np.random.choice(["Web","Mobile App"], n_orders, p=[.35,.65]),
    "delivery_days": np.random.choice([1,2,3,4,5,6,7,8], n_orders, p=[.09,.18,.22,.19,.13,.08,.06,.05]),
})
orders["promised_days"] = np.random.choice([2,3,4,5], n_orders, p=[.20,.35,.30,.15])
orders["delivery_status"] = np.where(orders["delivery_days"] <= orders["promised_days"], "On Time", "Late")

item_counts = np.random.choice([1,2,3,4,5], n_orders, p=[.30,.32,.22,.11,.05])
items = []
iid = 1
for order_id, cnt in zip(orders["order_id"], item_counts):
    pids = np.random.choice(products["product_id"], cnt, replace=False)
    for pid in pids:
        qty = int(np.random.choice([1,2,3], p=[.78,.18,.04]))
        p = products.loc[products["product_id"]==pid].iloc[0]
        discount = float(np.random.choice([0,.05,.10,.15,.20], p=[.44,.20,.18,.12,.06]))
        unit_price = float(p["unit_price"])
        net = unit_price * qty * (1-discount)
        cost = unit_price * qty * (1-float(p["margin_rate"]))
        items.append([iid,order_id,int(pid),qty,unit_price,discount,round(net,2),round(cost,2)])
        iid += 1
order_items = pd.DataFrame(items, columns=["order_item_id","order_id","product_id","quantity","unit_price","discount_rate","net_revenue","estimated_cost"])

scores = []
for status in orders["delivery_status"]:
    if status == "Late":
        scores.append(np.random.choice([1,2,3,4,5], p=[.20,.28,.28,.17,.07]))
    else:
        scores.append(np.random.choice([1,2,3,4,5], p=[.03,.07,.18,.35,.37]))
reviews = pd.DataFrame({"order_id":orders["order_id"],"review_score":scores})

for name, df in [("customers",customers),("products",products),("orders",orders),("order_items",order_items),("reviews",reviews)]:
    df.to_csv(DATA/f"{name}.csv", index=False)

print("Generated:", {name: len(df) for name,df in [("customers",customers),("products",products),("orders",orders),("order_items",order_items),("reviews",reviews)]})