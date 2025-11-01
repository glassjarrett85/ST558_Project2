# Full exoplanet data set, using only the defined Numeric and Character variables below.
fullData <- read.csv("exoplanetsdata.csv", header=TRUE) |>
  mutate(across(c(pl_name, hostname, disc_facility), factor)) |>
  select(all_of(char_vars), all_of(numeric_vars))

numeric_vars <- c(
  "facility_type",    # 
  "pl_controv_flag",  # lag indicating whether the confirmation status of a planet has been questioned in the published literature (1=yes, 0=no)
  "pl_orbper",        # Time the planet takes to make a complete orbit around the host star or system
  "pl_orbsmax",       # The longest radius of an elliptic orbit, or, for exoplanets detected via gravitational microlensing or direct imaging, the projected separation in the plane of the sky
  "pl_rade",          # Length of a line segment from the center of the planet to its surface, measured in units of radius of the Earth
  "pl_radj",          # Length of a line segment from the center of the planet to its surface, measured in units of radius of Jupiter
  "pl_bmasse",        # Best planet mass estimate available, in order of preference: Mass, M*sin(i)/sin(i), or M*sin(i), depending on availability, and measured in Earth masses
  "pl_bmassj",        # Best planet mass estimate available, in order of preference: Mass, M*sin(i)/sin(i), or M*sin(i), depending on availability, and measured in Jupiter masses
  "pl_orbeccen",      # Amount by which the orbit of the planet deviates from a perfect circle
  "pl_insol",         # Insolation flux is another way to give the equilibrium temperature. It's given in units relative to those measured for the Earth from the Sun.
  "pl_eqt",           # The equilibrium temperature of the planet as modeled by a black body heated only by its host star, or for directly imaged planets, the effective temperature of the planet required to match the measured luminosity if the planet were a black body
  "ttv_flag",         # Flag indicating if the planet orbit exhibits transit timing variations from another planet in the system (1=yes, 0=no).
  "st_teff",          # Temperature of the star as modeled by a black body emitting the same total amount of electromagnetic radiation
  "st_rad",           # Length of a line segment from the center of the star to its surface, measured in units of radius of the Sun
  "st_mass",          # Amount of matter contained in the star, measured in units of masses of the Sun
  "st_met",           # Measurement of the metal content of the photosphere of the star as compared to the hydrogen content
  "st_logg",          # Gravitational acceleration experienced at the stellar surface
  "ra",               # Right Ascension of the planetary system in decimal degrees
  "dec",              # Declination of the planetary system in decimal degrees
  "sy_dist",          # Distance to the planetary system in units of parsecs
  "sy_vmag",          # Brightness of the host star as measured using the V (Johnson) band in units of magnitudes
  "sy_kmag",          # Brightness of the host star as measured using the K (2MASS) band in units of magnitudes
  "sy_gaiamag"        # Brightness of the host star as measuring using the Gaia band in units of magnitudes. Objects matched to Gaia using the Hipparcos or 2MASS IDs provided in Gaia DR2.
)
char_vars <- c(
  "pl_name",          # Planet name most commonly used in the literature
  "hostname",         # Stellar name most commonly used in the literature
  "sy_snum",          # Number of gravitationally bound stars in the planetary system
  "discoverymethod",  # Method by which the planet was first identified
  "disc_year",        # Year the planet was discovered
  "disc_facility",    # Name of facility of planet discovery observations
  "pl_bmassprov",     # Provenance of the measurement of the best mass. Options are: Mass, M*sin(i)/sin(i), and M*sini
  "st_spectype",      # Classification of the star based on their spectral characteristics following the Morgan-Keenan system
  "st_metratio",      # Ratio for the Metallicity Value ([Fe/H] denotes iron abundance, [M/H] refers to a general metal content)
  "rastr",            # Right Ascension of the planetary system in sexagesimal format
  "decstr"            # Declination of the planetary system in sexagesimal notation
)