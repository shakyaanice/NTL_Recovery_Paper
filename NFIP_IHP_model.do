/*
Purpose:
Estimate associations between NFIP/IHP indicators and nighttime-light-based
recovery following Hurricane Harvey.

Method:
OLS with geographic fixed effects absorbed using GEOID and
heteroskedasticity-robust standard errors.

Input:
par_m_prop_fldepth_merged7.dta

Outputs:
nfip_t1 and ihp_t1 regression tables, saved in the outputs directory.

Requirements:
Stata 

Data availability:
The analysis requires the merged input dataset. 
The input dataset consists of public and restricted information.
*/

*Set project directory and load data
*edit path as necessary

cd "E:\01\Project1"
use "par_m_prop_fldepth_merged7", clear 

/*
Dependent variables:
rec_1q: NTL-based recovery during months 1-4 after Hurricane Harvey
rec_2q: NTL-based recovery during months 5-8 after Hurricane Harvey
rec_3q: NTL-based recovery during months 9-12 after Hurricane Harvey

Reported outcome units: nW cm^-2 sr^-1.

Explanatory variables:
nfip:        Binary NFIP payment indicator (0 = no; 1 = yes)
IHP:         Binary Individuals and Households Program indicator (0 = no; 1 = yes)
Fl_depth:    Hurricane Harvey flood depth (m)
wb_dist_km:  Distance to water bodies (km)
co_dist_km:  Distance to the coast (km)
sfha:        Binary Special Flood Hazard Area indicator (0 = outside; 1 = inside)
slope:       Terrain Slope (degrees)
val_sqm:     Assessed property value per unit area ($/km^2)
bquality_n:  Binary Building-quality variable (codes Average, Above Average, Good, Excellent and Luxury assigned 1;
             codes None, Type Unknown, Bypass, Below Average, Below Average, Economical, Fair, Low, Poor assigned 0)

Fixed-effects variable:
GEOID:       Geographic identifier for block groups
*/

*Define explanatory and control variables
global ivar1  nfip  Fl_depth  wb_dist_km co_dist_km   sfha slope val_sqm bquality_n
global ivar2  IHP Fl_depth  wb_dist_km co_dist_km   sfha slope val_sqm bquality_n

*********************************************************************************************************************************************************************
**# NFIP models
areg rec_1q $ivar1 absorb(GEOID) robust
outreg using "nfip_t1", starloc(1) bdec(6) starlevels(10 5 1) summstat(r2\r2_a\N\rmse) summtitle("R2"\"Adjusted R2"\"N"\"root mean square error") se replace

areg rec_2q $ivar1, absorb(GEOID) robust
outreg using "nfip_t1", starloc(1) bdec(6) starlevels(10 5 1) summstat(r2\r2_a\N\rmse) summtitle("R2"\"Adjusted R2"\"N"\"root mean square error") se merge

areg rec_3q $ivar1, absorb(GEOID) robust
outreg using "nfip_t1", starloc(1) bdec(6) starlevels(10 5 1) summstat(r2\r2_a\N\rmse) summtitle("R2"\"Adjusted R2"\"N"\"root mean square error") se merge
***********************************************************************************************************************************************************************
*********************************************************************************************************************************************************************
**# IHP models
areg rec_1q $ivar2 absorb(GEOID) robust
outreg using "ihp_t1", starloc(1) bdec(6) starlevels(10 5 1) summstat(r2\r2_a\N\rmse) summtitle("R2"\"Adjusted R2"\"N"\"root mean square error") se replace

areg rec_2q $ivar2, absorb(GEOID) robust
outreg using "ihp_t1", starloc(1) bdec(6) starlevels(10 5 1) summstat(r2\r2_a\N\rmse) summtitle("R2"\"Adjusted R2"\"N"\"root mean square error") se merge

areg rec_3q $ivar2, absorb(GEOID) robust
outreg using "ihp_t1", starloc(1) bdec(6) starlevels(10 5 1) summstat(r2\r2_a\N\rmse) summtitle("R2"\"Adjusted R2"\"N"\"root mean square error") se merge
***********************************************************************************************************************************************************************