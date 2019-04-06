This is documentation for a replication data file for the Op-Ed: Gary
King and Samir Soneji "Statistical Security: It's Worse Than You
Think" (New York Times, January 6, 2013), and also for the page of
text and graphics accompanying our article by Bill Marsh of the New
York Times.  See http://j.mp/1042oYz

The basis of the forecasts used in the New York Times is the following
scholarly work.  The forecasting methods are originally from Girosi,
Federico, and King, Gary. 2008. Demographic Forecasting. Princeton:
Princeton University Press, http://j.mp/pqms4U.  These are adapted and
applied to forecasting US mortality rates in King, Gary, and Soneji,
Samir. 2011. The Future of Death in America. Demographic Research 25,
no. 1: 1--38, http://j.mp/iXUpBv; and this approach to forecasting
mortality rates is used in Soneji, Samir, and King,
Gary. 2012. Statistical Security for Social Security. Demography 49,
no. 3: 1037-1060, http://j.mp/Qvla7N.  The replication data sets for
the two articles is Gary King; Samir Soneji, 2011, "Replication data
for: The Future of Death in America",
http://hdl.handle.net/1902.1/16178 IQSS Dataverse Network
[Distributor] V8 [Version].  The replication dataset for the book is
Frederico Girosi; Gary King, 2006, "Cause of Death Data",
http://hdl.handle.net/1902.1/UOVMCPSWOL UNF:3:9JU+SmVyHgwRhAKclQ85Cg==
IQSS Dataverse Network [Distributor] V3 [Version].  The software that
implements all of our work is an open-source R package: Federico
Girosi and Gary King "YourCast: Time Series Cross-Sectional
Forecasting with Your Assumptions," http://gking.harvard.edu/yourcast.
We have also recently added a way to automate some of YourCast via the
software by Jonathan Bischof, Gary King, and Samir Soneji, AutoCast:
Automated Bayesian Forecasting with YourCast,
http://gking.harvard.edu/autocast.

We document here the input files, statistical code, SSASIM run
specification files, and output files for each panel. Novel to the New
York Times piece is the presentation and updates of the input data.
All else remains the same as our scholarly work.

In what follows, we use the these abbreviations: 
SSA = Social Security Administration
OACT = Office of the Chief Actuary
R = R is the R Foundation for Statistical Computing, an open-source
statistical programming language
OASI = Old-Age Survivors Insurance Trust Fund
SSDI = Social Security Disability Insurance Trust Fund
OASDI = Old-Age Survivors and Disability Insurance (the combined Trust
Funds)
SSASIM = Social Security simulator (see http://www.polsim.com/SSASIM.html)
rsf = SSASIM run specificiation file
HMD = Human Mortality Database, http://www.mortality.org/

Panel 1. "How the Program Works" 
We input historial life tables from  HMD and our forecast life tables.
We calculate  the old-age dependency ratio  as ratio  of the number of
20-64 year olds to 65+ year olds).

Panel 2. "Ignoring the Obvious"
For full details of the data sources of historical smoking and
obesity, see King, Gary and Samir Soneji. (2011) ``The Future of Death
in America.'' Demographic Research, Vol. 25, pp 1-38.  The graph in
this panel appears with more details of the data in our article.

Panel 3.  "Warping the All-Important Life Span Forecasts" This panel
plots "observed stroke and other vascular disease" mortality rates
(deaths per 100,000 people). The data are taken directly from SSA OACT
and consists of historical mortality from 1979 to 2002, which is the
mortality data used to project life expectancy according the 2006 SSA
Trustees Report.  We did not process these data. This is one of many
important examples of SSA forecasts with age groups that inexplicably
cross over (so that the older age group dies at lower rates), widely
diverge, or dramatically contradict historical trends; some are
considerably worse than this one.

The R code, panel3.R, inputs SSA-provided mortality rates, and
outputs a graph of male vascular disease mortality, ages 60-64 and
65-69 years, intermediate cost projection.  The R code also outputs a
.csv file with the numeric values plotted in the graph.

Panel 4.  "Crazy Death Rates (and How They Should Look)"
In the left figure, we plot male mortality rates by year and age
group derived from a linear model that includes as covariates smoking
and obesity, lagged 25 years in age and 25 years in time.  In the
right figure, we also plot male mortality rates by year and age group
derived from our forecasting model.

Panel 5. "So: People Will Live Longer"
We input our life expectancy forecasts and SSA life expectancy
projections derived from SSA OACT mortality rates [1979,2008].  See
Soneji, Samir and Gary King (2012). ``Statistical Security for Social
Security.'' Demography, Vol. 49, No. 3, pp 1037-1060 for full details
of difference in 2031 OASDI Trust Funds amount. 

Panel 6.  "Finding That Extra $801 Billion"
In this panel, we consider two proposals that would result in an
additional $801 billion dollars in the combined OASDI Trust Funds by
2031.  

To reproduce this analyses, install the version of SSASIM we used
(10/5/12 edition, included with this replication data set in the
SSASIM subdirectory).  Users should execute the CBA mode benchmark run
from the RSF Toolkit's execute menu (see polsim.com/download.html).

"Raise Payroll Tax Rates".  In "SS-671-higher-taxes.rsf", we hold all
other assumptions at the 2012 Trustees Report, we raise SSDI payroll
tax rates gradually from 1.8% to 2.2% over 20 years and OASI payroll
tax rates gradually from 10.6% to 11.16% over 20 years.  These
specific values were chosen because they represent one of many
possible combinations of payroll tax increases that yields an
additional $801 billion dollars" in the 2031 OASDI Trust Funds.

Using SSASIM, "Open" this .rsf file. "Create ssasim run same as run 12
except:" indicates the same assumptions as the 2012 SSA Trustees
Report.  The provision we specify in this RSF is raising the OASDI
payroll taxes beginning in 2013.  Each RSF is denoted by a RUN.id, in
this case run 671.  Once users have selected "Use", they will see a
new window stating "All input parameters for RUN.id 671 found to be
valid.  Insert run 671 into the SSASIM QUEUE table?".  Selecting "Yes"
will add run.id 671 to the queue. Then users will select "Execute" and
then "Runs after QUEUE view".  A new window will appear with Run.id
671 in the queue.  Users wil select "SSASIM Start and "Yes" when asked
to "Show SSASIM screen output in window".  Users will see a "DOS"
window appear and the message "run queue is empty at [DATE & TIME]."
Users should note the directory, which will likely be C:\SSASIM\db.
Finally, users will navigate to the directory noted on the SSASIM run
(C:\SSASIM\db).  Open the file "run00671.dfc".  The number 00671 is
based on the RUN.id.  The file extension ".dfc" shows solvency values
of the simulation for the combined OASDI trust funds (the "c" stands
for combined).  Similarly ".dfr" shows OASI Trust Fund values and
".dcd" shows SSDI Trust Fund values.  See SSASIM documentation for
specific details on each output file and output variable (In SSASIM
Toolkit, "Help", "View PSG Documentation", then view "SSASIM ...output
statistics".  Descriptions of the .dfc, .dfd, and .dfr shown in the
.DF?" file, which has the same variables for all three output files
(dfc = combined OASDI trust funds, dfr = OASI trust fund, and dfd =
SSDI trust fund).  In "run00671.dfc", users will see the variable
"bal_t", which shows the end-of-year OASDI Trust Funds balance in
trillion dollars (nominal).

"Reduce Benefits".  In "SS-672-lower-benefits.rsf", we hold all other
assumptions at the 2012 Trustees Report, we gradually reduce initial
OASI benefit amounts by 1 - 85.7% = 14.3% over 20 years.  These
specific values were chosen because they represent one of many
possible combinations of benefit reductions that yields an additional
$801 billion dollars" in the 2031 OASDI Trust Funds.

