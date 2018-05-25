"""Interop with cc_* rules

These rules are temporary and will be deprecated in the future.
"""

load(":private/providers.bzl",
     "HaskellBuildInfo",
     "HaskellLibraryInfo",
     "HaskellBinaryInfo",
)

load(":private/set.bzl", "set")
load("@bazel_skylib//:lib.bzl", "paths")
load(":private/tools.bzl", "tools")

CcInteropInfo = provider(
  doc = "Information needed for interop with cc rules.",
  fields = {
    "hdrs": "CC headers",
    "cpp_flags": "Preprocessor flags",
    "include_args": "Extra include dirs",
  }
)

def cc_headers(ctx):
  """Bring in scope the header files of dependencies, if any.

  *Internal function - do not use.*
  """
  hdrs = depset()

  # XXX There's gotta be a better way to test the presence of
  # CcSkylarkApiProvider.
  ccs = [dep.cc for dep in ctx.attr.deps if hasattr(dep, "cc")]

  hdrs = depset(transitive = [cc.transitive_headers for cc in ccs])

  include_directories = set.to_list(set.from_list(
      [f for cc in ccs for f in cc.include_directories]))
  quote_include_directories = set.to_list(set.from_list(
      [f for cc in ccs for f in cc.quote_include_directories]))
  system_include_directories = set.to_list(set.from_list(
      [f for cc in ccs for f in cc.system_include_directories]))

  cpp_flags = (
      ["-D" + define for cc in ccs for define in cc.defines]
      + [f for include in quote_include_directories
         for f in ["-iquote", include]]
      + [f for include in system_include_directories
         for f in ["-isystem", include]])

  include_args = ["-I" + include for include in include_directories]

  return CcInteropInfo(
    hdrs = hdrs.to_list(),
    cpp_flags = cpp_flags,
    include_args = include_args,
  )

def haskell_cc_import(name, shared_library, hdrs=[], strip_include_prefix="",testonly=None,visibility=None):
  native.cc_import(name = name + ".import",
            shared_library = shared_library,
            testonly=testonly)
  native.cc_library(name = name,
             hdrs = hdrs,
             strip_include_prefix=strip_include_prefix,
             deps = [name + ".import"],
             testonly=testonly,
             visibility=visibility)

def _cc_haskell_import(ctx):

  dyn_libs = set.empty()

  if HaskellBuildInfo in ctx.attr.dep:
    set.mutable_union(dyn_libs, ctx.attr.dep[HaskellBuildInfo].dynamic_libraries)
  else:
    fail("{0} has to provide `HaskellBuildInfo`".format(ctx.attr.dep.label.name))

  if HaskellBinaryInfo in ctx.attr.dep:
    bin = ctx.attr.dep[HaskellBinaryInfo].binary
    dyn_lib = ctx.actions.declare_file("lib{0}.so".format(bin.basename))
    relative_bin = paths.relativize(bin.path, dyn_lib.dirname)
    ctx.actions.run(
      inputs = [bin],
      outputs = [dyn_lib],
      executable = tools(ctx).ln,
      arguments = ["-s", relative_bin, dyn_lib.path],
    )
    set.mutable_insert(dyn_libs, dyn_lib)

  return [
    DefaultInfo(
      files = set.to_depset(dyn_libs)
    )
  ]

  if HaskellBinaryInfo in ctx.attr.dep:
    dbin = ctx.attr.dep[HaskellBinaryInfo].dynamic_bin
    if dbin != None:
      set.mutable_insert(dyn_libs, dbin)

  return [
    DefaultInfo(
      files = set.to_depset(dyn_libs)
    )
  ]

  if HaskellBinaryInfo in ctx.attr.dep:
    dbin = ctx.attr.dep[HaskellBinaryInfo].dynamic_bin
    if dbin != None:
      set.mutable_insert(dyn_libs, dbin)

  return [
    DefaultInfo(
      files = set.to_depset(dyn_libs)
    )
  ]

cc_haskell_import = rule(
  _cc_haskell_import,
  attrs = {
    "dep": attr.label(
      doc = """
Target providing a `HaskellLibraryInfo` or `HaskellBinaryInfo`, such as
`haskell_library` or `haskell_binary`.
"""
    ),
  },
  toolchains = ["@io_tweag_rules_haskell//haskell:toolchain"],
)
"""Exports a Haskell library as a CC library.

Given a [haskell_library](#haskell_library) or
[haskell_binary](#haskell_binary) input, outputs the shared object files
produced as well as the object files it depends on directly and
transitively. This is very useful if you want to link in a Haskell shared
library from `cc_library`.

There is a caveat: this will not provide any shared libraries that
aren't explicitly given to it. This means that if you're using
`prebuilt_dependencies` and relying on GHC to provide those objects,
they will not be present here. You will have to provide those
separately to your `cc_library`. If you're getting
`prebuilt_dependencies` from your toolchain, you will likely want to
extract those and pass them in as well.

*This rule is temporary and only needed until the Bazel C/C++
"sandwich" (see [bazelbuild/bazel#2163][bazel-cpp-sandwich]) is
implemented. This rule will be deprecated in the future.*

Example:
  ```bzl
  haskell_library(
    name = "my-lib",
    ...
  )

  cc_haskell_import(
    name = "my-lib-objects",
    dep = ":my-lib",
  )

  cc_library(
    name = "my-cc",
    srcs = ["main.c", ":my-lib-objects"],
  )
  ```

[bazel-cpp-sandwich]: https://github.com/bazelbuild/bazel/issues/2163
"""
