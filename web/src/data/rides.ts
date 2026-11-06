// Aggregated ride bookings (built by web/scripts/build_data.py). Measures mirror the Power BI report.
import raw from "./rides.json"
import { ALL } from "@/components/filter-bar"

type Raw = {
  months: string[]
  quarters: string[]
  vehicles: string[]
  statuses: string[]
  payments: string[]
  locations: string[]
  reasons: string[]
  /** month, vehicle, status, payment, bookings, valueSum, valueN, distSum, distN, driverSum, driverN, customerSum, customerN */
  main: number[][]
  /** hour, quarter, vehicle, status, bookings */
  hours: number[][]
  /** location, quarter, vehicle, status, bookings */
  pickups: number[][]
  /** reason, quarter, vehicle, bookings */
  reasonCounts: number[][]
}
const data = raw as unknown as Raw

export const { months: MONTHS, quarters: QUARTERS, vehicles: VEHICLES, statuses: STATUSES, payments: PAYMENTS, locations: LOCATIONS } = data
const quarterOfMonth = (m: number) => Math.floor((Number(MONTHS[m].slice(5, 7)) - 1) / 3)

// ---------- filters (the slicers)
export type Filters = { vehicle: string; quarter: string; status: string }
export const options = { vehicle: VEHICLES, quarter: QUARTERS, status: STATUSES }

const pass = (f: Filters, q: number, v: number, s?: number) =>
  (f.quarter === ALL || QUARTERS[q] === f.quarter) && (f.vehicle === ALL || VEHICLES[v] === f.vehicle) && (s == null || f.status === ALL || STATUSES[s] === f.status)

export const mainRows = (f: Filters) => data.main.filter((r) => pass(f, quarterOfMonth(r[0]), r[1], r[2]))

// ---------- measures over the main cube
export type Totals = { bookings: number; completed: number; value: number; valueN: number; dist: number; distN: number; driver: number; driverN: number; customer: number; customerN: number }
export function totals(rows: number[][]): Totals {
  const t: Totals = { bookings: 0, completed: 0, value: 0, valueN: 0, dist: 0, distN: 0, driver: 0, driverN: 0, customer: 0, customerN: 0 }
  for (const r of rows) {
    t.bookings += r[4]
    if (r[2] === 0) t.completed += r[4]
    t.value += r[5]
    t.valueN += r[6]
    t.dist += r[7]
    t.distN += r[8]
    t.driver += r[9]
    t.driverN += r[10]
    t.customer += r[11]
    t.customerN += r[12]
  }
  return t
}

/** Sum a cube column grouped by one of its dimensions. */
export function groupSum(rows: number[][], dim: number, col: number, labels: string[]) {
  const out = labels.map(() => 0)
  for (const r of rows) out[r[dim]] += r[col]
  return labels.map((key, i) => ({ key, value: out[i] }))
}

export const hourCounts = (f: Filters) => {
  const out = Array<number>(24).fill(0)
  for (const r of data.hours) if (pass(f, r[1], r[2], r[3])) out[r[0]] += r[4]
  return out
}

export const pickupCounts = (f: Filters) => {
  const out = LOCATIONS.map(() => 0)
  for (const r of data.pickups) if (pass(f, r[1], r[2], r[3])) out[r[0]] += r[4]
  return LOCATIONS.map((key, i) => ({ key, value: out[i] }))
}

/** Cancellation reasons for one kind ("customer", "driver", "incomplete"). Status filter doesn't apply: each kind is one status. */
export const reasonCounts = (f: Filters, kind: string) => {
  const out = new Map<string, number>()
  for (const [ri, q, v, n] of data.reasonCounts) {
    const [k, label] = data.reasons[ri].split("|")
    if (k === kind && pass(f, q, v)) out.set(label, (out.get(label) ?? 0) + n)
  }
  return [...out].map(([key, value]) => ({ key, value }))
}

const inr = (v: number) => (v >= 1e6 ? `₹${(v / 1e6).toFixed(1)}M` : `₹${(v / 1e3).toFixed(1)}K`)

/** Plain-language findings that update with the filters. */
export function insights(rows: number[][], f: Filters): string[] {
  const t = totals(rows)
  if (!t.bookings) return []
  const out: string[] = []
  const byStatus = groupSum(rows, 2, 4, STATUSES)
  if (f.status === ALL) {
    const lost = t.bookings - t.completed
    out.push(`${Math.round((lost / t.bookings) * 100)}% of bookings never completed; drivers cancelled ${byStatus[1].value.toLocaleString("en-US")} of them.`)
  }
  const byVehicle = groupSum(rows, 1, 5, VEHICLES).sort((a, b) => b.value - a.value)
  if (f.vehicle === ALL) out.push(`${byVehicle[0].key} brings in the most revenue: ${inr(byVehicle[0].value)}, ${Math.round((byVehicle[0].value / t.value) * 100)}% of the total.`)
  const hours = hourCounts(f)
  const peak = hours.indexOf(Math.max(...hours))
  out.push(`Bookings peak at ${peak}:00, with ${hours[peak].toLocaleString("en-US")} requests in that hour.`)
  const pay = groupSum(rows.filter((r) => r[3] !== PAYMENTS.indexOf("Not paid")), 3, 4, PAYMENTS).sort((a, b) => b.value - a.value)[0]
  if (pay?.value) out.push(`${pay.key} is the most used way to pay.`)
  return out
}
