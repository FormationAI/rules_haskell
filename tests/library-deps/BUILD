package(default_testonly = 1)

load(
  "@io_tweag_rules_haskell//haskell:haskell.bzl",
  "haskell_library",
  "haskell_test",
)

haskell_library(
  name = "library-deps",
  srcs = ["TestLib.hs"],
  deps = ["//tests/library-deps/sublib"],
  prebuilt_dependencies = ["base"],
  visibility = ["//visibility:public"],
)

haskell_test(
  name = "bin-deps",
  srcs = ["Bin.hs"],
  main_file = "Bin.hs",
  deps = ["//tests/library-deps/sublib"],
  prebuilt_dependencies = ["base"],
  visibility = ["//visibility:public"],
  size = "small",
)
