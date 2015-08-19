load("frege", "frege_library")

frege_library(
  name="billing-api",
  lib="@frege-lib//jar",
  srcs=glob(["frege/api/**/*.fr"]))

frege_library(
  name="frege_test",
  lib="@frege-lib//jar",
  srcs=glob(["frege/main/**/*.fr"]),
  deps=[":billing-api"])

java_binary(
  name="mylib",
  srcs=glob(["java/main/**/*.java"]),
  deps = [
    ":frege_test",
    ":billing-api",
    "@frege-lib//jar"
  ],
  main_class = "com.talios.test.Test")