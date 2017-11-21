#populate an nml, copy over driver file, save nml for reuse
#speed up mass model runs by not populating the base nml/downloading driver data repeatedly
library(mda.lakes)
library(glmtools)
nhd_id <- 'nhd_13293262'
nml <- populate_base_lake_nml(site_id = nhd_id)
meteo_file_path <- get_nml_value(nml, 'meteo_fl')
new_meteo_path <- file.path("meteo", paste(nhd_id, 'driver.csv', sep = "_"))
file.copy(from =meteo_file_path, to = new_meteo_path)
nml <- set_nml(glm_nml = nml, arg_name = "meteo_fl", arg_val = file.path('../..', new_meteo_path))
#be smart about setting max layers, to reduce amount of output
min_thick <- get_nml_value(nml, arg_name = "min_layer_thick")
max_depth <- get_nml_value(nml, arg_name = "lake_depth")
max_layers <- ceiling(max_depth/min_thick * 1.1)
nml <- set_nml(glm_nml = nml, arg_name = "max_layers", arg_val = max_layers)
write_nml(glm_nml = nml, file = "nml/glm2_mendota.nml")