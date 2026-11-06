import NumberFlow from "@number-flow/react"
import { AnimatePresence, motion } from "motion/react"
import { parseAsString, useQueryStates } from "nuqs"
import { useMemo } from "react"
import { OrderedColumns, Panel, RankBars, TrendLine } from "@/components/charts"
import { Figures } from "@/components/figures"
import { ALL, FilterBar, type Field } from "@/components/filter-bar"
import { PageHeader } from "@/components/page-header"
import { MONTHS, PAYMENTS, STATUSES, VEHICLES, groupSum, hourCounts, insights, mainRows, options, pickupCounts, reasonCounts, totals, type Filters } from "@/data/rides"

// Every slicer lives in the URL, so a filtered view can be shared as a link
const params = {
  vehicle: parseAsString.withDefault(ALL),
  quarter: parseAsString.withDefault(ALL),
  status: parseAsString.withDefault(ALL),
}

const FIELDS: Field[] = [
  { key: "vehicle", label: "Vehicle type", all: "All vehicles", options: options.vehicle },
  { key: "quarter", label: "Quarter (2024)", all: "Whole year", options: options.quarter },
  { key: "status", label: "Booking status", all: "All statuses", options: options.status },
]

const monthLabel = (m: string) => new Date(`${m}-01T00:00:00`).toLocaleDateString("en-US", { month: "short" })

export default function App() {
  const [q, setQ] = useQueryStates(params)
  const filters: Filters = { vehicle: q.vehicle, quarter: q.quarter, status: q.status }
  const rows = useMemo(() => mainRows(filters), [q.vehicle, q.quarter, q.status]) // eslint-disable-line react-hooks/exhaustive-deps
  const t = totals(rows)

  const monthly = groupSum(rows, 0, 5, MONTHS)
  const monthlyBookings = groupSum(rows, 0, 4, MONTHS)
  const trend = MONTHS.map((m, i) => ({ key: monthLabel(m), value: monthly[i].value, bookings: monthlyBookings[i].value })).filter((d) => d.bookings > 0)
  const hours = hourCounts(filters)
  const paid = rows.filter((r) => r[3] !== PAYMENTS.indexOf("Not paid"))

  return (
    <div className="mx-auto max-w-7xl px-4 pb-24 sm:px-8">
      <PageHeader
        title="Ride sharing bookings"
        dataset="Delhi NCR ride bookings, 2024, 150,000 bookings."
        repo="https://github.com/Ananya3283/indian-ride-sharing-analytics"
        linkText="Notebook, SQL and Power BI on GitHub"
      />

      <div className="sticky top-0 z-20 -mx-4 mt-6 border-b bg-background/90 px-4 py-4 backdrop-blur sm:-mx-8 sm:px-8">
        <FilterBar fields={FIELDS} value={filters} onChange={(k, v) => setQ({ [k]: v === ALL ? null : v })} />
      </div>

      <main className="mt-10">
        {t.bookings === 0 ? (
          <p className="py-24 text-center text-muted-foreground">No bookings match these filters. Clear one to see results.</p>
        ) : (
          <div className="space-y-12">
            <section className="grid items-start gap-8 lg:grid-cols-[minmax(0,5fr)_minmax(0,7fr)]">
              <div>
                <h1 className="text-4xl leading-[1.05] font-extrabold tracking-tight text-balance sm:text-5xl">
                  <NumberFlow value={t.bookings} /> bookings.{" "}
                  <span className="text-kept">
                    <NumberFlow value={t.completed / t.bookings} format={{ style: "percent", maximumFractionDigits: 1 }} /> completed.
                  </span>
                </h1>
                <h2 className="mt-8 text-base font-semibold">What stands out</h2>
                <ul className="mt-2 space-y-2.5">
                  <AnimatePresence mode="popLayout" initial={false}>
                    {insights(rows, filters).map((s) => (
                      <motion.li
                        key={s}
                        layout
                        initial={{ opacity: 0, y: 4, filter: "blur(2px)" }}
                        animate={{ opacity: 1, y: 0, filter: "blur(0px)" }}
                        exit={{ opacity: 0, filter: "blur(2px)", transition: { duration: 0.15 } }}
                        transition={{ duration: 0.15, ease: [0.22, 1, 0.36, 1] }}
                        className="border-l-2 border-kept pl-3 leading-snug"
                      >
                        {s}
                      </motion.li>
                    ))}
                  </AnimatePresence>
                </ul>
              </div>
              <Panel title="Booking value by month" note="Hover the line to read a month.">
                <TrendLine data={trend} series={[{ key: "value", label: "Booking value", color: "var(--kept)" }]} format="inr" height={300} />
              </Panel>
            </section>

            <Figures
              items={[
                { label: "Bookings", value: t.bookings, format: "int" },
                { label: "Completed", value: t.completed / t.bookings, format: "pct", tone: "kept" },
                { label: "Booking value", value: t.value, format: "inr" },
                { label: "Avg booking value", value: t.valueN ? t.value / t.valueN : null, format: "int", prefix: "₹" },
                { label: "Avg ride distance", value: t.distN ? t.dist / t.distN : null, format: "dec2", suffix: " km" },
                { label: "Avg driver rating", value: t.driverN ? t.driver / t.driverN : null, format: "dec" },
              ]}
            />

            <div className="grid gap-x-12 gap-y-10 lg:grid-cols-2">
              <Panel title="Bookings by status" note="Completed and incomplete rides are paid; cancellations and no-driver bookings are lost demand.">
                <RankBars data={groupSum(rows, 2, 4, STATUSES)} format="int" labelWidth={160} />
              </Panel>
              <Panel title="Booking value by vehicle type">
                <RankBars data={groupSum(rows, 1, 5, VEHICLES)} format="inr" labelWidth={110} color="var(--kept)" />
              </Panel>
              <Panel title="Bookings by hour of the day" note="24-hour clock.">
                <OrderedColumns data={hours.map((v, h) => ({ key: String(h), value: v }))} format="int" labels={false} />
              </Panel>
              <Panel title="How rides were paid" note="Completed and incomplete rides.">
                {paid.length ? <RankBars data={groupSum(paid, 3, 4, PAYMENTS).filter((d) => d.key !== "Not paid")} format="int" labelWidth={110} color="var(--kept)" /> : <p className="py-8 text-sm text-muted-foreground">Cancelled bookings have no payment. Pick another status.</p>}
              </Panel>
              <Panel title="Why drivers cancelled" note="Bookings cancelled by the driver, by reason.">
                <RankBars data={reasonCounts(filters, "driver")} format="int" labelWidth={230} />
              </Panel>
              <Panel title="Why customers cancelled" note="Bookings cancelled by the customer, by reason.">
                <RankBars data={reasonCounts(filters, "customer")} format="int" labelWidth={230} />
              </Panel>
              <Panel title="Top 10 pickup locations" className="lg:col-span-2">
                <RankBars data={pickupCounts(filters).sort((a, b) => b.value - a.value).slice(0, 10)} format="int" labelWidth={170} color="var(--kept)" />
              </Panel>
            </div>
          </div>
        )}
      </main>
    </div>
  )
}
