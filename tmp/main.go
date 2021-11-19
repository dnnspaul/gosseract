package main

import (
	"gosseract"
)

func main() {
	gosseract.PdfOutput("testjpg.jpg", "testjpg")
}
