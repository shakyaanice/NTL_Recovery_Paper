/*
Purpose:
Estimate main effects and race interactions for NFIP and IHP in
nighttime-light-based recovery following Hurricane Harvey.

Model order:
1. NFIP main effects
2. IHP main effects
3. NFIP interactions with race
4. IHP interactions with race

All models absorb GEOID fixed effects and use heteroskedasticity-robust
standard errors. NFIP and IHP are estimated in separate models.
Reference categories: nfip = 0, IHP = 0, race_code = 1 (White).

Requirements: Stata, outreg, and estout (which provides esttab).
Input: raceprd_dataset.dta
The input dataset consists of public and restricted information.
*/

* ---------------------------------------------------------------------------
* 1. Set directory and prepare analysis dataset
* ---------------------------------------------------------------------------

* Change this path to match your project directory.
cd "E:\04_RaceProfile\STATA"

use "raceprd_dataset.dta", clear

* ---------------------------------------------------------------------------
* 2. Dependencies and model setup
* ---------------------------------------------------------------------------

global ivar1 Fl_depth wb_dist_km co_dist_km sfha slope val_sqm bquality_n
global ivar2 Fl_depth wb_dist_km co_dist_km sfha slope val_sqm bquality_n

* Race labels for regression and marginal-effects tables.
label define racelab 1 "White" 2 "Black" 3 "Asian" 4 "Hispanic" 5 "Other", replace
label values race_code racelab

* rec_1q, rec_2q, and rec_3q denote months 1-4, 5-8, and 9-12, respectively.
* Each loop exports results in that order.

* ---------------------------------------------------------------------------
* 3. NFIP main effects
* ---------------------------------------------------------------------------

local rhs "ib0.nfip ib1.race_code $ivar1"
local export_mode replace

foreach outcome in rec_1q rec_2q rec_3q {

    areg `outcome' `rhs', absorb(GEOID) vce(robust)

    outreg using "NFIP_race_main", ///
        starloc(1) bdec(6) starlevels(10 5 1) ///
        summstat(r2\r2_a\N\rmse) ///
        summtitle("R2"\"Adjusted R2"\"N"\"RMSE") ///
        se `export_mode'

    local export_mode merge
}

* ---------------------------------------------------------------------------
* 4. IHP main effects
* ---------------------------------------------------------------------------

local rhs "ib0.IHP ib1.race_code $ivar2"
local export_mode replace

foreach outcome in rec_1q rec_2q rec_3q {

    areg `outcome' `rhs', absorb(GEOID) vce(robust)

    outreg using "IHP_race_main", ///
        starloc(1) bdec(6) starlevels(10 5 1) ///
        summstat(r2\r2_a\N\rmse) ///
        summtitle("R2"\"Adjusted R2"\"N"\"RMSE") ///
        se `export_mode'

    local export_mode merge
}

* ---------------------------------------------------------------------------
* 5. NFIP interactions with race
* ---------------------------------------------------------------------------

local rhs "ib0.nfip##ib1.race_code $ivar1"
local export_mode replace
local period 0

foreach outcome in rec_1q rec_2q rec_3q {

    local period = `period' + 1

    areg `outcome' `rhs', absorb(GEOID) vce(robust)

    outreg using "NFIP_race_int", ///
        starloc(1) bdec(6) starlevels(10 5 1) ///
        summstat(r2\r2_a\N\rmse) ///
        summtitle("R2"\"Adjusted R2"\"N"\"RMSE") ///
        se `export_mode'

    local export_mode merge

    * Discrete change from nfip = 0 to 1 within each race.
    margins race_code, dydx(nfip) post
    estimates store nfip_me_q`period'
}

esttab nfip_me_q1 nfip_me_q2 nfip_me_q3 ///
    using "NFIP_margins_by_race.rtf", replace ///
    title("NFIP discrete marginal effects by race") ///
    mtitles("Months 1-4" "Months 5-8" "Months 9-12") ///
    b(3) se(3) ///
    star(* 0.10 ** 0.05 *** 0.01) ///
    label

* ---------------------------------------------------------------------------
* 6. IHP interactions with race
* ---------------------------------------------------------------------------

local rhs "ib0.IHP##ib1.race_code $ivar2"
local export_mode replace
local period 0

foreach outcome in rec_1q rec_2q rec_3q {

    local period = `period' + 1

    areg `outcome' `rhs', absorb(GEOID) vce(robust)

    outreg using "IHP_race_int", ///
        starloc(1) bdec(6) starlevels(10 5 1) ///
        summstat(r2\r2_a\N\rmse) ///
        summtitle("R2"\"Adjusted R2"\"N"\"RMSE") ///
        se `export_mode'

    local export_mode merge

    * Discrete change from IHP = 0 to 1 within each race.
    margins race_code, dydx(IHP) post
    estimates store ihp_me_q`period'
}

esttab ihp_me_q1 ihp_me_q2 ihp_me_q3 ///
    using "IHP_margins_by_race.rtf", replace ///
    title("IHP discrete marginal effects by race") ///
    mtitles("Months 1-4" "Months 5-8" "Months 9-12") ///
    b(3) se(3) ///
    star(* 0.10 ** 0.05 *** 0.01) ///
    label

