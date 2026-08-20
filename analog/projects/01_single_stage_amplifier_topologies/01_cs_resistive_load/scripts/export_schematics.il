printf("CDF schematic vector export start\n")

procedure(cdfPlotSchematic(libName cellName outputFile)
  let((ok)
    schPlotOptions = list(
      nil
      'library libName
      'cell cellName
      'view "schematic"
      'version "0.0"
      'multisheet nil
      'indexsheet nil
      'hierarchy nil
      'copy 1
      'outputfile outputFile
      'plotter "EPS"
      'plotToFile t
      'plotterType "epsfC"
      'papersize "Unlimited"
      'plotsize list(8.0 6.5)
      'offset list(0.0 0.0)
      'unit "inches"
      'orientation "Automatic"
      'display "display"
      'tmpdir getShellEnvVar("CDF_SCHEMATIC_EPS_DIR")
      'mail nil
    )

    printf("CDF_VECTOR_EXPORT %s/%s/schematic -> %s\n"
      libName cellName outputFile)
    ok = schPlot()
    printf("CDF_VECTOR_RESULT %s/%s ok=%L\n" libName cellName ok)
    ok
  )
)

let((epsDir results)
  epsDir = getShellEnvVar("CDF_SCHEMATIC_EPS_DIR")

  if(epsDir && epsDir != "" then
    results = list(
      cdfPlotSchematic(
        "cdf_analog_sandbox"
        "cs_resistive_load"
        strcat(epsDir "/01_dut_cs_resistive_load.eps")
      )
      cdfPlotSchematic(
        "cdf_analog_tb"
        "tb_p01_cs_basic"
        strcat(epsDir "/02_tb_dc_bias.eps")
      )
      cdfPlotSchematic(
        "cdf_analog_tb"
        "tb_p01_cs_ac"
        strcat(epsDir "/03_tb_ac_response.eps")
      )
      cdfPlotSchematic(
        "cdf_analog_tb"
        "tb_p01_cs_transient"
        strcat(epsDir "/04_tb_transient.eps")
      )
    )

    if(member(nil results) then
      printf("CDF_VECTOR_EXPORT_FAILED one_or_more_plots_failed\n")
    else
      printf("CDF_VECTOR_EXPORT_COMPLETE count=4 output=%s\n" epsDir)
    )
  else
    printf("CDF_VECTOR_EXPORT_FAILED CDF_SCHEMATIC_EPS_DIR_is_not_set\n")
  )
)

exit()
