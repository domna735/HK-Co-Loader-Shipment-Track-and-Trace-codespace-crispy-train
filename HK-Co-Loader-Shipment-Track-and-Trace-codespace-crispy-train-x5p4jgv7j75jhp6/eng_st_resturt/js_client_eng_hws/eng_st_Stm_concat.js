// 外部化自 eng_st_Stm.jsp 的 concat(f) function
function concat(f, noawb) {
  if (!CheckStmInfo(f.elements["aname"], f.elements["cname"], f.elements["cphone"], f.elements["emailaddr"]))
    return false;

  f.noawb.value = noawb;
  f.awblist.value = "";
  f.rmkslist.value = "";
  var rmk_found = false;

  for (let j = 0; j < noawb; j++) {
    f.awblist.value = f.awblist.value + f["awb" + j].value + "|";
    rmk_found = false;
    for (let k = 0; k < 10; k++) {
      f.rmkslist.value = f.rmkslist.value + f["rmks" + j + "_" + k].value + "^~";
      if (!isWhitespace(f["rmks" + j + "_" + k].value)) {
        rmk_found = true;
      }
    }
    f.rmkslist.value = f.rmkslist.value + "|";
    if (rmk_found == false) {
      f["rmks" + j + "_0"].focus();
      f["rmks" + j + "_0"].select();
      dhl_alert("Remark is missing.", "Please enter remark for each selected waybill.", 180);
      return false;
    }
  }
  // 若有 Terms & Conditions 檢查需求，請於此補上
  return true;
}
