package(default_testonly = 1, default_visibility = ["//visibility:public"])

load("@io_tweag_rules_haskell//haskell:haskell.bzl",
     "haskell_library",
     "haskell_test",
)

genrule(
    name = "generate-genmodule",
    outs = ["src/GenModule.hs"],
    cmd = "printf 'module GenModule where\na = 1 :: Int' > $@",
)

haskell_library(
    name = "GenModule",
    srcs = [":generate-genmodule"],
    src_strip_prefix = "src",
    prebuilt_dependencies = ["base"],
)

genrule(
    name = "generate-binmodule",
    outs = ["src/BinModule.hs"],
    cmd = "printf 'module BinModule where\nb = 2 :: Int' > $@",
    output_to_bindir = 1,
)

haskell_library(
    name = "BinModule",
    srcs = [":generate-binmodule"],
    src_strip_prefix = "src",
    prebuilt_dependencies = ["base"],
)

genrule(
    name = "generate-main",
    outs = ["src/Main.hs"],
    cmd = "printf 'module Main where\nimport GenModule\nimport BinModule\n"
          + "main = print (a+b) :: IO ()' > $@",
)

haskell_test(
    name = "generated-modules",
    srcs = [":generate-main"],
    src_strip_prefix = "src",
    prebuilt_dependencies = ["base"],
    deps = [":GenModule", ":BinModule"],
    size = "small",
)
