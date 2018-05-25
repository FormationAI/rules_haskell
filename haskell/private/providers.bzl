DefaultCompileInfo = provider(
  doc = "Default compilation files and configuration.",
  fields = {
    "args": "Default argument list.",
    "haddock_args": "Default Haddock argument list.",
    "inputs": "Default inputs.",
    "outputs": "Default outputs.",
    "objects_dir": "Object files directory.",
    "interfaces_dir": "Interface files directory.",
    "object_files": "Object files.",
    "object_dyn_files": "Dynamic object files.",
    "interface_files": "Interface files.",
    "modules": "Set of all module names.",
    "source_files": "Set of files that contain Haskell modules.",
    "header_files": "Set of header files.",
    "import_dirs": "Import hierarchy roots.",
    "env": "Default env vars."
  },
)

HaskellBuildInfo = provider(
  doc = "Common information about build process: dependencies, etc.",
  fields = {
    "package_ids": "Set of all package ids of transitive dependencies.",
    "package_confs": "Set of package .conf files.",
    "package_caches": "Set of package cache files.",
    "static_libraries": "Ordered collection of compiled library archives.",
    "dynamic_libraries": "Set of dynamic libraries.",
    "interface_files": "Set of interface files belonging to the packages.",
    "prebuilt_dependencies": "Transitive collection of names of wired-in Haskell dependencies.",
    "external_libraries": "Set of dynamic shared libraries needed for linking.",
  },
)

HaskellLibraryInfo = provider(
  doc = "Library-specific information.",
  fields = {
    "package_id": "Package id, usually of the form name-version.",
    "import_dirs": "Import hierarchy roots.",
    "exposed_modules": "Set of exposed module names.",
    "other_modules": "Set of non-public module names.",
    "haddock_args": "Arguments that were used to compile the package suitable for Haddock.",
    "source_files": "Set of files that contain Haskell modules.",
    "header_files": "Set of header files.",
  },
)

HaskellBinaryInfo = provider(
  doc = "Binary-specific information.",
  fields = {
    "source_files": "Set of source files.",
    "modules": "Set of module names.",
    "binary": "File, compiled binary.",
  },
)

HaddockInfo = provider(
  doc = "Haddock information.",
  fields = {
    "package_id": "Package id, usually of the form name-version.",
    "transitive_html": "Dictionary from package id to html dirs.",
    "transitive_haddocks": "Dictionary from package id to Haddock files.",
  }
)

HaskellLintInfo = provider(
  doc = "Provider that collects files produced by linters",
  fields = {
    "outputs": "Set of linter log files."
  }
)

HaskellProtobufInfo = provider(
  doc = "Provider that wraps providers of auto-generated Haskell libraries",
  fields = {
    "files": "files",
  }
)
