load("frege", "frege_library")

frege_library(
  name="frege_test",
  lib="@frege-lib//jar",
  srcs=glob(["frege/main/**/*.fr"]),
)

java_binary(
  name="mylib",
  srcs=glob(["java/main/**/*.java"]),
  deps = [
    ":frege_test",
	"@frege-lib//jar"
  ],
  main_class = "com.talios.test.Test",
)