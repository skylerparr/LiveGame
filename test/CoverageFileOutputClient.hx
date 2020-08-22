package;

import sys.io.File;
import mcover.coverage.client.PrintClient;
@IgnoreLogging
class CoverageFileOutputClient extends PrintClient {
  private var fileName: String;
  public function new(?fileName: String) {
    if(fileName == null) {
      fileName = "coverage.txt";
    }
    this.fileName = fileName;
    super();
    newline = #if js "<br/>" #else "\n" #end;
    tab = #if js "&nbsp;" #else " " #end;
  }

  override function printReport() {
    super.printReport();
    output += newline;

    File.saveContent(fileName, newline + output);
  }
}