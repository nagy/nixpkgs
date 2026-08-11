{
  # Overrides for CHICKEN 6 eggs that need patched builds.
  #
  # The overrides for CHICKEN 5 (see ../5/overrides.nix) do not apply here:
  # CHICKEN 6 has its own egg index (eggs-6-latest) with different versions,
  # dependency graphs and a different runtime ABI.  Add entries here as
  # breakage in specific eggs is discovered, following the pattern in
  # ../5/overrides.nix.
}:
{ }
