# Bazel rule for compiling frege files.

def frege_impl(ctx):
  """Compile a .jar file form Frege source files."""
  class_jar = ctx.outputs.class_jar
  build_output = class_jar.path + ".build_output"

  # Gather transitive deps
  all_deps = set(ctx.files.deps)
  for this_dep in ctx.attr.deps:
    if hasattr(this_dep, "java"):
      all_deps += this_dep.java.transitive_runtime_deps

  frege_dep_path = ""
  if all_deps:
    frege_dep_path = "-fp " + ":".join([dep.path for dep in ctx.files.deps])

  cmd = "rm -rf %s && mkdir -p %s && " % (build_output, build_output)
  cmd += "%s -Xss2m -jar %s -make %s -inline -d %s %s && " % (
    ctx.file._java.path,
    ctx.file.lib.path,
    frege_dep_path,
    build_output,
    " ".join([src.path for src in ctx.files.srcs]))

  cmd += "%s cvf %s -C %s . &>build.log\n" % (ctx.file._jar.path, class_jar.path , build_output )

  ctx.action(
    inputs=ctx.files.srcs + ctx.files.deps,
    outputs=[class_jar],
    mnemonic = "Fregec",
    progress_message="Building frege library %s (%d files)" % (
      class_jar.basename, len(ctx.files.srcs)),
    command=cmd,
    use_default_shell_env = True
  )

_frege_library_jar = rule(
  implementation = frege_impl,
  attrs={
    "_java": attr.label(default=Label("@bazel_tools//tools/jdk:java"), single_file=True),
    "_jar": attr.label(default=Label("@bazel_tools//tools/jdk:jar"), single_file=True),
    "lib": attr.label(mandatory=True, single_file=True),
    "srcs": attr.label_list(mandatory=False, allow_files=FileType([".fr"])),
    "deps": attr.label_list(mandatory=False, allow_files=FileType([".jar"]))
    },
  outputs={"class_jar": "lib%{name}.jar"},
)

def frege_library(name, lib, srcs=[], deps=[], **kwargs):
  """Compile Frege source files into a jar library"""
  _frege_library_jar(name = name + "-impl", lib = lib, srcs = srcs, deps = deps)
  native.java_import(name = name, jars = [name + "-impl"], **kwargs)

def frege_repositories():
  # Released Version of Frege
  native.http_jar(
    name = "frege_lib",
    url = "https://github.com/Frege/frege/releases/download/3.24alpha/frege3.24.100.jar",
    sha256 = "6ad1c4535d61b1f0cd9edbbe46bdad110cfac15d413bcc28dcbb78cd8800e6e9",
  )
