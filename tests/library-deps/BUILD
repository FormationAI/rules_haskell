package(default_testonly = 1)

load(
  "@io_tweag_rules_haskell//haskell:haskell.bzl",
  "haskell_binary",
  "haskell_library",
)

haskell_library(
    name = "sublib",
    srcs = ["One.hs"],
    prebuilt_dependencies = ["base"],
)

haskell_library(
  name = "library-deps",
  srcs = ["TestLib.hs"],
  deps = ["//tests/library-deps/sublib"],
  prebuilt_dependencies = ["base"],
  visibility = ["//visibility:public"],
)

haskell_binary(
    name = "bin",
    srcs = ["Bin.hs"],
    main_file = "Bin.hs",
    deps = [
        ":sublib",
        "//tests/library-deps/sublib",
    ],
    prebuilt_dependencies = ["base"],
)
