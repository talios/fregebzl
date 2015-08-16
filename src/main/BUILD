load("frege", "frege_library")

frege_library(
  name="frege_test",
  lib="@frege-lib//jar",
  srcs=glob(["frege/**/*.fr"]))

java_binary(
  name="mylib",
  srcs = glob(["java/com/talios/test/*.java"]),
#  runtime_deps = [
#    ":frege_test"
#  ],
  main_class = "com.talios.test.Test",
)