package(default_testonly = 1)

load("@io_tweag_rules_haskell//haskell:haskell.bzl",
     "haskell_binary",
)

haskell_binary(
  name = "encoding",
  srcs = [
    "TH.hs",
    "Main.hs",
  ],
  extra_srcs = [
    "unicode.txt",
  ],
  prebuilt_dependencies = [
    "base",
    "template-haskell",
  ],
)
