# Radiocarbon calibration curves

Radiocarbon calibration requires a calibration curve: an estimate of the
true calendar age associated with a radiocarbon measurement. The
following curves are included with the c14 package:

- IntCal20:

  IntCal Northern Hemisphere curve, 0–55,000 cal BP (Reimer et al. 2020)
  .

- SHCal20:

  IntCal Southern Hemisphere curve, 0–55,000 cal BP (Hogg et al. 2020) .

- Marine20:

  IntCal marine curve, 0–55,000 cal BP (Heaton et al. 2020) .

- IntCal13, IntCal09, IntCal04, IntCal98:

  Previous IntCal Northern Hemisphere curves (Reimer et al. 2013; Reimer
  et al. 2009; Reimer et al. 2004; Stuiver et al. 1998) . Superseded by
  `IntCal20`.

- SHCal13, SHCal04:

  Previous IntCal Southern Hemisphere curves (Hogg et al. 2013; McCormac
  et al. 2004) . Superseded by `SHCal20`.

- Marine13, Marine09, Marine04, Marine98:

  Previous IntCal marine curves (Reimer et al. 2013; Reimer et al. 2009;
  Hughen et al. 2004; Stuiver et al. 1998) . Superseded by `Marine20`.

Generally, it is recommended to use the latest curve from the IntCal
series: `IntCal20` for samples from the northern hemisphere; `SHCal20`
for samples from the southern hemisphere; or `Marine20` for samples that
obtained their 14C in a marine environment.

## Usage

``` r
IntCal20

SHCal20

Marine20

IntCal13

SHCal13

Marine13

IntCal09

Marine09

IntCal04

SHCal04

Marine04

IntCal98

Marine98
```

## Format

A [c14_curve](https://c14.joeroe.io/reference/c14_curve.md) object with
the following fields.

For standard curves:

- cal_age:

  Calendar ages with associated era
  ([era::yr](https://era.joeroe.io/reference/yr.html) class).

- c14_age:

  Uncalibrated radiocarbon ages.

- c14_error:

  Errors (sigma values) associated with `c14_age`.

- d14c:

  Delta-14C values.

- d14c_error:

  Errors (sigma values) associated with `d14c`.

For post-bomb curves:

- cal_age:

  Calendar ages with their associated era
  ([era::yr](https://era.joeroe.io/reference/yr.html) class).

- f14c:

  Fraction modern (F14C or pMC) values.

- f14c_error:

  Errors (sigma values) associated with `f14c`.

An object of class `c14_curve_14c` (inherits from `c14_curve`,
`data.frame`) with 9501 rows and 5 columns.

An object of class `c14_curve_14c` (inherits from `c14_curve`,
`data.frame`) with 9501 rows and 5 columns.

An object of class `c14_curve_14c` (inherits from `c14_curve`,
`data.frame`) with 5501 rows and 5 columns.

An object of class `c14_curve_14c` (inherits from `c14_curve`,
`data.frame`) with 5141 rows and 5 columns.

An object of class `c14_curve_14c` (inherits from `c14_curve`,
`data.frame`) with 5141 rows and 5 columns.

An object of class `c14_curve_14c` (inherits from `c14_curve`,
`data.frame`) with 4801 rows and 5 columns.

An object of class `c14_curve_14c` (inherits from `c14_curve`,
`data.frame`) with 3522 rows and 5 columns.

An object of class `c14_curve_14c` (inherits from `c14_curve`,
`data.frame`) with 3651 rows and 5 columns.

An object of class `c14_curve_14c` (inherits from `c14_curve`,
`data.frame`) with 3302 rows and 5 columns.

An object of class `c14_curve_14c` (inherits from `c14_curve`,
`data.frame`) with 2482 rows and 5 columns.

An object of class `c14_curve_14c` (inherits from `c14_curve`,
`data.frame`) with 3301 rows and 5 columns.

An object of class `c14_curve_14c` (inherits from `c14_curve`,
`data.frame`) with 1538 rows and 5 columns.

An object of class `c14_curve_14c` (inherits from `c14_curve`,
`data.frame`) with 1569 rows and 5 columns.

## Source

<https://intcal.org/curves.html> and <http://calib.org/CALIBomb/>

## References

Heaton TJ, Köhler P, Butzin M, Bard E, Reimer RW, Austin WEN, Ramsey CB,
Grootes PM, Hughen KA, Kromer B, Reimer PJ, Adkins J, Burke A, Cook MS,
Olsen J, Skinner LC (2020). “Marine20—The Marine Radiocarbon Age
Calibration Curve (0–55,000 cal BP).” *Radiocarbon*, **62**(4), 779–820.
ISSN 0033-8222, 1945-5755.
[doi:10.1017/RDC.2020.68](https://doi.org/10.1017/RDC.2020.68) .  
  
Hogg AG, Heaton TJ, Hua Q, Palmer JG, Turney CSM, Southon J, Bayliss A,
Blackwell PG, Boswijk G, Ramsey CB, Pearson C, Petchey F, Reimer P,
Reimer R, Wacker L (2020). “SHCal20 Southern Hemisphere Calibration,
0–55,000 Years cal BP.” *Radiocarbon*, **62**(4), 759–778. ISSN
0033-8222, 1945-5755.
[doi:10.1017/RDC.2020.59](https://doi.org/10.1017/RDC.2020.59) .  
  
Hogg AG, Hua Q, Blackwell PG, Niu M, Buck CE, Guilderson TP, Heaton TJ,
Palmer JG, Reimer PJ, Reimer RW, Turney CSM, Zimmerman SRH (2013).
“SHCal13 Southern Hemisphere Calibration, 0–50,000 Years cal BP.”
*Radiocarbon*, **55**(4), 1889–1903. ISSN 0033-8222, 1945-5755.
[doi:10.2458/azu_js_rc.55.16783](https://doi.org/10.2458/azu_js_rc.55.16783)
.  
  
Hughen KA, Baillie MGL, Bard E, Warren Beck J, Bertrand CJH, Blackwell
PG, Buck CE, Burr GS, Cutler KB, Damon PE, Edwards RL, Fairbanks RG,
Friedrich M, Guilderson TP, Kromer B, McCormac G, Manning S, Ramsey CB,
Reimer PJ, Reimer RW, Remmele S, Southon JR, Stuiver M, Talamo S, Taylor
FW, VAN der Plicht J, Weyhenmeyer CE (2004). “Marine04 Marine
Radiocarbon Age Calibration, 0–26 Cal Kyr Bp.” *Radiocarbon*, **46**(3),
1059–1086. ISSN 0033-8222, 1945-5755.
[doi:10.1017/S0033822200033002](https://doi.org/10.1017/S0033822200033002)
.  
  
McCormac FG, Hogg AG, Blackwell PG, Buck CE, Higham TFG, Reimer PJ
(2004). “SHCal04 Southern Hemisphere Calibration, 0–11.0 Cal Kyr BP.”
*Radiocarbon*, **46**(3), 1087–1092. ISSN 0033-8222, 1945-5755.
[doi:10.1017/S0033822200033014](https://doi.org/10.1017/S0033822200033014)
.  
  
Reimer PJ, Austin WEN, Bard E, Bayliss A, Blackwell PG, Ramsey CB,
Butzin M, Cheng H, Lawrence Edwards R, Friedrich M, Grootes PM,
Guilderson TP, Hajdas I, Heaton TJ, Hogg AG, Hughen KA, Kromer B,
Manning SW, Muscheler R, Palmer JG, Pearson C, van der Plicht J, Reimer
RW, Richards DA, Marian Scott E, Southon JR, Turney CSM, Wacker L,
Adolphi F, Büntgen U, Capano M, Fahrni SM, Fogtmann-Schulz A, Friedrich
R, Köhler P, Kudsk S, Miyake F, Olsen J, Reinig F, Sakamoto M, Sookdeo
A, Talamo S (2020). “The IntCal20 Northern Hemisphere Radiocarbon Age
Calibration Curve (0–55 cal kBP).” *Radiocarbon*, **62**(4), 725–757.
ISSN 0033-8222, 1945-5755.
[doi:10.1017/RDC.2020.41](https://doi.org/10.1017/RDC.2020.41) .  
  
Reimer PJ, Baillie MGL, Bard E, Bayliss A, Beck JW, Blackwell PG, Bronk
Ramsey C, Buck CE, Burr GS, Edwards RL, Friedrich M, Grootes PM,
Guilderson TP, Hajdas I, Heaton TJ, Hogg AG, Hughen KA, Kaiser KF,
Kromer B, McCormac FG, Manning SW, Reimer RW, Richards DA, Southon JR,
Talamo S, Turney CSM, van der Plicht J, Weyhenmeyer CE (2009). “IntCal09
and Marine09 Radiocarbon Age Calibration Curves, 0-50,000 Years cal BP.”
*Radiocarbon*, **51**(4), 1111–1150. ISSN 0033-8222.  
  
Reimer PJ, Baillie MGL, Bard E, Bayliss A, Warren Beck J, Bertrand CJH,
Blackwell PG, Buck CE, Burr GS, Cutler KB, Damon PE, Lawrence Edwards R,
Fairbanks RG, Friedrich M, Guilderson TP, Hogg AG, Hughen KA, Kromer B,
McCormac G, Manning S, Ramsey CB, Reimer RW, Remmele S, Southon JR,
Stuiver M, Talamo S, Taylor FW, van der Plicht J, Weyhenmeyer CE (2004).
“IntCal04 terrestrial radiocarbon age calibration, 0-26 cal kyr BP.”
*Radiocarbon*, **46**(3), 1029–1058. ISSN 0033-8222.  
  
Reimer PJ, Bard E, Bayliss A, Warren Beck J, Blackwell PG, Ramsey CB,
Buck CE, Cheng H, Lawrence Edwards R, Friedrich M, Grootes PM,
Guilderson TP, Haflidason H, Hajdas I, Hatté C, Heaton TJ, Hoffmann DL,
Hogg AG, Hughen KA, Felix Kaiser K, Kromer B, Manning SW, Niu M, Reimer
RW, Richards DA, Marian Scott E, Southon JR, Richard A Staff, Turney
CSM, van der Plicht J (2013). “IntCal13 and Marine13 Radiocarbon Age
Calibration Curves 0–50,000 Years cal BP.” *Radiocarbon*, **55**(4),
1869–1887. ISSN 0033-8222, 1945-5755.
[doi:10.2458/azu_js_rc.55.16947](https://doi.org/10.2458/azu_js_rc.55.16947)
.  
  
Stuiver M, Reimer PJ, Bard E, Warren Beck J, Burr GS, Hughen KA, Kromer
B, McCormac G, Van Der Plicht J, Spurk M (1998). “INTCAL98 Radiocarbon
Age Calibration, 24,000–0 cal BP.” *Radiocarbon*, **40**(3), 1041–1083.
ISSN 0033-8222, 1945-5755.
[doi:10.1017/S0033822200019123](https://doi.org/10.1017/S0033822200019123)
.
