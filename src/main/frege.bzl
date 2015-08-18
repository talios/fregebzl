# Bazel rule for compiling frege files.

def _impl(ctx):
  """Compile a .jar file form Frege saource files."""
  class_jar = ctx.outputs.class_jar
  build_output = class_jar.path + ".build_output"

  # Gather transitive deps
  all_deps = set(ctx.files.deps)
  for this_dep in ctx.attr.deps:
    if hasattr(this_dep, "java"):
      all_deps += this_dep.java.transitive_runtime_deps

  cmd = "rm -rf %s && mkdir -p %s && " % (build_output, build_output)
  cmd += "java -Xss2m -jar %s -v -hints -d %s %s && " % (
    ctx.file.lib.path,
    build_output,
    " ".join([src.path for src in ctx.files.srcs]))

  cmd += "jar cvf %s -C %s .\n" % (class_jar.path , build_output )

  ctx.action(
    inputs=ctx.files.srcs + ctx.files.deps,
    outputs=[class_jar],
    mnemonic = "Fregec",
    progress_message="Building frege library %s" % class_jar.basename,
    command=cmd,
    use_default_shell_env = True
  )

_frege_library_jar = rule(
  implementation = _impl,
  attrs={
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
