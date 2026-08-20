printf("CDF schematic export start\n")

procedure(cdfExportSchematic(libName cellName fileName)
  let((win ok)
    printf("CDF_EXPORT_OPEN %s/%s/schematic\n" libName cellName)
    win = deOpenCellView(
      libName
      cellName
      "schematic"
      "schematic"
      list(list(0 0) list(1600 1000))
      "r"
    )

    if(win then
      ok = hiExportImage(
        ?fileName fileName
        ?window win
        ?exportRegion 'entireDesign
        ?width 2400
        ?transparentBG nil
        ?colorType 'fullColor
        ?windowProps list(list("drawGridOn" nil) list("drawAxesOn" nil))
        ?verbose t
      )
      printf("CDF_EXPORT_RESULT %s/%s ok=%L file=%s\n"
        libName cellName ok fileName)
      hiCloseWindow(win)
      ok
    else
      printf("CDF_EXPORT_ERROR failed_to_open %s/%s/schematic\n"
        libName cellName)
      nil
    )
  )
)

let((outDir results)
  outDir = getShellEnvVar("CDF_SCHEMATIC_OUTPUT_DIR")
  if(outDir && outDir != "" then
    results = list(
      cdfExportSchematic(
        "cdf_analog_sandbox"
        "cs_resistive_load"
        strcat(outDir "/01_dut_cs_resistive_load.png")
      )
      cdfExportSchematic(
        "cdf_analog_tb"
        "tb_p01_cs_basic"
        strcat(outDir "/02_tb_dc_bias.png")
      )
      cdfExportSchematic(
        "cdf_analog_tb"
        "tb_p01_cs_ac"
        strcat(outDir "/03_tb_ac_response.png")
      )
      cdfExportSchematic(
        "cdf_analog_tb"
        "tb_p01_cs_transient"
        strcat(outDir "/04_tb_transient.png")
      )
    )

    if(member(nil results) then
      printf("CDF_EXPORT_FAILED one_or_more_exports_failed\n")
    else
      printf("CDF_EXPORT_COMPLETE count=4 output=%s\n" outDir)
    )
  else
    printf("CDF_EXPORT_FAILED CDF_SCHEMATIC_OUTPUT_DIR_is_not_set\n")
  )
)

exit()
