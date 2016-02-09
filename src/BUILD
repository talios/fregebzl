load("frege", "frege_library")

frege_library(
  name="billing_api",
  lib="@frege_lib//jar",
  deps=[
    "@junit//jar"
  ],
  srcs=glob(["frege/api/**/*.fr"]))

frege_library(
  name="frege_test",
  lib="@frege_lib//jar",
  srcs=glob(["frege/main/**/*.fr"]),
  deps=[":billing_api"])

java_binary(
  name="mylib",
  srcs=glob(["java/main/**/*.java"]),
  deps = [
    ":frege_test",
    ":billing_api",
    "@frege_lib//jar"
  ],
  main_class = "com.talios.test.Test")
