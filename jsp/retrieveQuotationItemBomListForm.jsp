<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script src='<c:url value="/resources/js/ngs/common.js"/>'></script>
<script src='<c:url value="/resources/js/cus/common.js"/>'></script>
<script>
var bomCodeList;

function fnOnload() {
	//공통코드
	var objCmmnCmbCodes = new CommonSheetComboCodes()
	.addGroupCode({"groupCode":"ESTMT_ITM_STAT_CD", "required":true, "includedNotUse":false}) //픔목상태
	.addGroupCode({"groupCode":"BOM_STDR_CD", "required":true, "includedNotUse":false}) //BOM규격
    .execute();

	//픔목상태
	$("#searchEstmtItmStatCd").addCommonSelectOptions({
	    "comboData":objCmmnCmbCodes["ESTMT_ITM_STAT_CD"],
	    "required": false
	});

	//품목그룹
    var estmtItmGropInfoCodes = new CommonSheetComboOthers("/ngs/order/retrieveEstmtItmGropInfoCombo.do")
    .addCombo({"resultCombo": {"codeColumn": "estmtItmGropCd", "textColumn": "estmtItmGropCdNm"}})
    .execute();
    $("#searchEstmtItmGropInfo").addCommonSelectOptions({
        "comboData":estmtItmGropInfoCodes["resultCombo"],
        "required": false
    });

	createIBSheet2("item-sheet", "itemSheet", "100%", "300px", "", false, "{AutoSizeColumn:'1', Mode:'1'}");
	IBS_InitSheet(itemSheet, {
		"Cols": [
        	{Header:"상태", Type:"Status", Align:"Center", SaveName:"ibStatus", Hidden:"1", MinWidth:40, Hidden:"1"},
        	{Header:"<spring:message code='word.hd.no'/>", Type:"Seq", Align:"Center", SaveName:"no", MinWidth:50, Edit:"0"},//No
        	{Header:"<spring:message code='word.hd.prdlst.group'/>", Type:"Text", Align:"Left", SaveName:"estmtItmGropCdNm", MinWidth:120, Edit:"0"},//품목그룹
        	{Header:"<spring:message code='word.hd.prdlst.cd'/>", Type:"Text", Align:"Left", SaveName:"estmtItmCd", MinWidth:100, Edit:"0"},//품목코드
        	{Header:"<spring:message code='word.hd.prdlst.nm'/>", Type:"Text", Align:"Left", SaveName:"estmtItmCdNm", MinWidth:200, Edit:"0"},//품목명
	        {Header:"<spring:message code='word.hd.stndrd'/>", Type:"Text", Align:"Left", SaveName:"estmtItmStdrNm", MinWidth:100, Edit:"0"},//규격
        	{Header:"<spring:message code='word.hd.prdlst.sttus'/>", Type:"Text", Align:"Left", SaveName:"estmtItmStatNm", MinWidth:120, Edit:"0"},//품목상태
	        {Header:"<spring:message code='word.hd.modi.user'/>", Type:"Text", Align:"Left", SaveName:"modiUserNm", MinWidth:120, Edit:"0"},//수정사용자
	        {Header:"<spring:message code='word.hd.com.modi.dttm'/>", Type:"Date", Align:"Left", SaveName:"modiDttm", MinWidth:120, Edit:"0", Format:"YmdHm"},//수정일시
			{Header:"cmpnyCd", Type:"Text", SaveName:"cmpnyCd", Hidden:"1"}, //법인코드
			{Header:"estmtItmStatCd", Type:"Text", SaveName:"estmtItmStatCd", Hidden:"1"}  //품목상태
		]
	});

    createIBSheet2("bom-sheet", "bomSheet", "100%", "300px", "", false, "{AutoSizeColumn:'1', Mode:'1'}");
	IBS_InitSheet(bomSheet, {
		"Cols": [
        	{Header:"상태", Type:"Status", Align:"Center", SaveName:"ibStatus", Hidden:"1", MinWidth:40},
        	{Header:"", Type:"DummyCheck", Align:"Center", SaveName:"ibCheck", MinWidth:20},//선택
        	{Header:"<spring:message code='word.hd.no'/>", Type:"Seq", Align:"Center", SaveName:"no", MinWidth:50, Edit:"0"},//No
        	{Header:"<spring:message code='word.hd.bom.group.no'/>", Type:"Int", Align:"Right", SaveName:"bomGropNo", MinWidth:100, KeyField:"1", EditLen:3},//BOM그룹번호
        	{Header:"<spring:message code='word.hd.bom.cd'/>", Type:"Text", Align:"Left", SaveName:"bomCd", MinWidth:120, KeyField:"1", EditLen:15},//BOM코드
        	{Header:"<spring:message code='word.hd.bom.nm'/>", Type:"Text", Align:"Left", SaveName:"bomNm", MinWidth:200, Edit:"0"},//BOM명
        	{Header:"<spring:message code='word.hd.stndrd'/>", Type:"Combo", Align:"Left", SaveName:"bomStdrCd", MinWidth:80, KeyField:"1", "ComboText":objCmmnCmbCodes["BOM_STDR_CD"].ComboText, "ComboCode":objCmmnCmbCodes["BOM_STDR_CD"].ComboCode},//규격
        	{Header:"<spring:message code='word.hd.qnt'/>", Type:"Int", Align:"Right", SaveName:"bomQnt", MinWidth:100, KeyField:"1", Format:"Integer", MinimumValue:0, MaximumValue: 9999999999 },//수량
        	{Header:"<spring:message code='word.hd.aply.begin.dt'/>", Type:"Date", Align:"Left", SaveName:"aplyBeginDt", MinWidth:120, KeyField:"1", Format:"Ymd"},//적용시작일자
			{Header:"<spring:message code='word.hd.aply.end.dt'/>", Type:"Date", Align:"Left", SaveName:"aplyEndDt", MinWidth:120, KeyField:"1", Format:"Ymd"},//적용종료일자
	        {Header:"<spring:message code='word.hd.modi.user'/>", Type:"Text", Align:"Left", SaveName:"modiUserNm", MinWidth:120, Edit:"0"},//수정사용자
	        {Header:"<spring:message code='word.hd.com.modi.dttm'/>", Type:"Date", Align:"Left", SaveName:"modiDttm", MinWidth:120, Edit:"0", Format:"YmdHm"},//수정일시
			{Header:"cmpnyCd", Type:"Text", SaveName:"cmpnyCd", Hidden:"1"}, //법인코드
			{Header:"estmtItmCd", Type:"Text", SaveName:"estmtItmCd", Hidden:"1"}, //품목코드
			{Header:"estmtItmBomSn", Type:"Int", SaveName:"estmtItmBomSn", Hidden:"1"}, //품목BOM순번
			{Header:"editYn", Type:"Text", SaveName:"editYn", Hidden:"1"}, //수정가능여부
			{Header:"aplyEndDtEditYn", Type:"Text", SaveName:"aplyEndDtEditYn", Hidden:"1"} //종료일자 수정가능여부
		]
	});

    fnSetEvent();
    fnRetrieveBomCodeList(); //BOM코드 목록 조회
    fnRetrieveList("search")

  	//리사이징
    gridResize();;
};

function fnSetEvent() {
	//검색
	$('#btnSearch').click(function() {
    	fnRetrieveList("search");
    });

	//BOM_행추가
	$('#btnBomAddRow').click(function() {
        var itemRow = $("#selectItemSheetRow").val();
    	var ibStatus = itemSheet.GetCellValue(itemRow, "ibStatus");
		if (ibStatus !== "I") {
	        var row = bomSheet.DataInsert(bomSheet.GetDataLastRow() + 1);
	        bomSheet.SetCellValue(row, "no", row);
	        bomSheet.SetCellValue(row, "ibCheck", "Y");
	        bomSheet.SetCellValue(row, "cmpnyCd", itemSheet.GetCellValue(itemRow, "cmpnyCd"));
	        bomSheet.SetCellValue(row, "estmtItmCd", itemSheet.GetCellValue(itemRow, "estmtItmCd"));
	        bomSheet.SetCellValue(row, "bomStdrCd", "EA");
	        bomSheet.SetCellValue(row, "bomQnt", "1");
	        bomSheet.SetCellValue(row, "aplyBeginDt", moment(moment().format('YYYYMMDD')).add("1","day").format("YYYYMMDD"));
	        bomSheet.SetCellValue(row, "aplyEndDt", "99991231");
		}
    });
	//BOM_행삭제
	$('#btnBomDeleteRow').click(function() {
		cfDeleteRow(bomSheet);
	});
	//BOM_삭제
	$('#btnBomDelete').click(function() {
    	fnBomDelete();
    });
	//BOM_저장
	$('#btnBomSave').click(function() {
    	fnBomSave();
    });
	//BOM_확정
	$('#btnItemUpdate').click(function() {
    	fnItemUpdate();
    });
}

//품목정보_조회
function fnRetrieveList(obj) {
	$("#actionGubun").val(obj);
	new CommonAjax("/ngs/setup/quotation/retrieveQuotationItemList.do")
	.addParam(quotationForm)
	.callback(function (resultData) {
		itemSheet.LoadSearchData({"data": resultData.result});

		if (resultData.result.length === 0) {
			//품목정보 조회 결과가 없으면 품목BOM 그리드 클리어
			bomSheet.RemoveAll();
		}
	})
	.execute();
}

//품목정보_OnSearchEnd
function itemSheet_OnSearchEnd(code, message) {
	if (code === 0) {
		var actionGubun = $("#actionGubun").val();
		if (actionGubun === "save") {
			itemSheet.SetSelectRow($("#selectItemSheetRow").val(), 1);
		} else {
			itemSheet.SetSelectRow(1, 1);
		}
	}
}

//품목정보_OnSelectCell
function itemSheet_OnSelectCell(oldRow, oldCol, newRow, newCol, isDelete) {
	if (newRow !== oldRow) {
		//클릭한 row
		$("#selectItemSheetRow").val(newRow);
		$("#selectCmpnyCd").val(itemSheet.GetCellValue(newRow, "cmpnyCd"));
		$("#selectEstmtItmCd").val(itemSheet.GetCellValue(newRow, "estmtItmCd"));

		fnBomRetrieveList();
    }
}

//BOM_조회
function fnBomRetrieveList() {
	new CommonAjax("/ngs/setup/quotation/retrieveQuotationItemBomList.do")
	.addParam(quotationForm)
	.callback(function (resultData) {
		bomSheet.LoadSearchData({"data": resultData.result});
	})
	.execute();
}

//BOM_삭제
function fnBomDelete() {
	for (var i = 0; i < bomSheet.RowCount(); i++) {
		var ibCheck = bomSheet.GetCellValue(i + 1, "ibCheck");
		var editYn = bomSheet.GetCellValue(i + 1, "editYn");
		if (ibCheck == "1" && editYn == "N") {
			alert("<spring:message code='infm.begin.date.only.future.delete'/>");//적용시작일자가 미래일자의 경우에만 삭제 할 수 있습니다.
			return;
		}
    }

	new CommonAjax("/ngs/setup/quotation/deleteQuotationItemBomList.do")
	.addParam(bomSheet)
	.confirm("<spring:message code='cnfm.delete'/>")
	.callback(function (resultData) {
		alert(resultData.message);
		if (resultData.result === "S") {
			$("#actionGubun").val("save");
			fnRetrieveList("save");
		}
	})
	.execute();
}

//BOM_저장
function fnBomSave() {
	new CommonAjax("/ngs/setup/quotation/saveQuotationItemBomList.do")
	.addParam(bomSheet)
	.confirm("<spring:message code='cnfm.save'/>")
	.callback(function (resultData) {
		alert(resultData.message);
		if (resultData.result === "S") {
			$("#actionGubun").val("save");
			fnRetrieveList("save");
		}
	})
	.execute();
}

//BOM_확정
function fnItemUpdate() {
	new CommonAjax("/ngs/setup/quotation/updateEstmtItmInfoStatCd.do")
	.addParam(quotationForm)
	.confirm("<spring:message code='cnfm.decide'/>")
	.callback(function (resultData) {
		alert(resultData.message);
		if (resultData.result === "S") {
			$("#actionGubun").val("save");
			fnRetrieveList("save");
		}
	})
	.execute();
}

//BOM_OnRowSearchEnd
function bomSheet_OnRowSearchEnd(row) {
	var editYn = bomSheet.GetCellValue(row, "editYn");
	var aplyEndDtEditYn = bomSheet.GetCellValue(row, "aplyEndDtEditYn");
	if (editYn === "N") {
		//수정불가
		bomSheet.SetCellEditable(row, "bomGropNo", 0);
		bomSheet.SetCellEditable(row, "bomCd", 0);
		bomSheet.SetCellEditable(row, "bomQnt", 0);
		bomSheet.SetCellEditable(row, "bomStdrCd", 0);
		bomSheet.SetCellEditable(row, "aplyBeginDt", 0);
		bomSheet.SetCellEditable(row, "aplyEndDt", 0);

		if (aplyEndDtEditYn === "Y") {
			//종료일자 수정가능
			bomSheet.SetCellEditable(row, "aplyEndDt", 1);
		}
	}
}

//BOM_OnSearchEnd
function bomSheet_OnSearchEnd(row) {
	var estmtItmStatCd = itemSheet.GetCellValue($("#selectItemSheetRow").val(), "estmtItmStatCd");
	if (estmtItmStatCd === "00") {
		$("#btnLeftDiv").show();
		$("#btnLeftDiv_line").show();	// line 추가
	} else {
		$("#btnLeftDiv").hide();
		$("#btnLeftDiv_line").hide();		// line 추가
	}
}

//BOM_OnChange
function bomSheet_OnChange(row, col, value) {
	var saveName = bomSheet.ColSaveName(col);
	if (saveName === "bomCd") {
		//bom코드 편집 완료시 bom명 매핑
		var bomCd = bomSheet.GetCellValue(row, "bomCd");
		for (var i = 0; i < bomCodeList.length; i++) {
			var data = bomCodeList[i];
			if (bomCd === data.bomCd) {
				bomSheet.SetCellValue(row, "bomNm", data.bomNm);
				break;
			} else {
				bomSheet.SetCellValue(row, "bomNm", "");
			}
		}
	}
}

//BOM코드 목록 조회
function fnRetrieveBomCodeList() {
	new CommonAjax("/ngs/order/retrieveBomCodeList.do")
	.callback(function (resultData) {
		bomCodeList = resultData.result;
	})
	.execute();

}

/**
 * 2019.05.21(화) 문지환D 추가
 *
 * [변경내역] : 화면에 따른 Ibsheet 리사이징 추가
 *
 */
function gridResize(){
	$(window).resize(function(){
		var popWinSize = $(window).height();
		var hH = $("header").height();
		var hH2 = $(".title-info").height();
		var sH = $(".search_box2").height();
		/* var sH2 = $("#item-sheet").height(); */
		var bH = $(".grid_btn").height();
		var allH = hH + hH2 + sH + /* sH2 + */ bH + 230;
		$("#item-sheet, #bom-sheet").height((popWinSize - allH)/2);
	});
	var popWinSize = $(window).height();
	var hH = $("header").height();
	var hH2 = $(".title-info").height();
	var sH = $(".search_box2").height();
	/* var sH2 = $("#item-sheet").height(); */
	var bH = $(".grid_btn").height();
	var allH = hH + hH2 + sH + /* sH2 + */ bH + 230;
	$("#item-sheet, #bom-sheet").height((popWinSize - allH)/2);
}

</script>

<div class="content qutItemList">
	<form class="form-inline form-control-static" action="" id="quotationForm" name="quotationForm" onsubmit="return false">
		<input type="hidden" id="selectCmpnyCd" name="selectCmpnyCd" />           <%--품목정보 그리드에서 선택한 법인코드--%>
		<input type="hidden" id="selectEstmtItmCd" name="selectEstmtItmCd" />     <%--품목정보 그리드에서 선택한 품목코드--%>
		<input type="hidden" id="selectItemSheetRow" name="selectItemSheetRow" /> <%--선택한 품목정보 row--%>
		<input type="hidden" id="actionGubun" name="actionGubun" />

		<!-- 타이틀/위치정보 -->
		<div class="title-info">
			<h2>${activeMenu.menuNm}</h2>
		</div>
		<%--검색영역--%>
		<div class="search_box2">
			<div class="leftBox">
				<table>
					<!-- <colgroup>
						<col width="8%" />
						<col width="17%" />
						<col width="8%" />
						<col width="17%" />
						<col width="8%" />
						<col width="17%" />
						<col width="8%" />
						<col width="17%" />
					</colgroup> -->
					<tbody>
						<tr>
							<th><spring:message code='word.prdlst.group'/></th><%--품목그룹--%>
							<td>
								<select id="searchEstmtItmGropInfo" name="searchEstmtItmGropInfo">
								</select>
							</td>
							<th><spring:message code='word.prdlst.cd'/></th><%--품목코드--%>
							<td>
								<input type="text" id="searchEstmtItmCd" name="searchEstmtItmCd" class="iconKeyboard bor3" maxlength="15"/>
							</td>
							<th><spring:message code='word.prdlst.nm'/></th><%--품목명--%>
							<td>
								<input type="text" id="searchEstmtItmCdNm" name="searchEstmtItmCdNm" class="iconKeyboard bor3" maxlength="200"/>
							</td>
							<th><spring:message code='word.prdlst.sttus'/></th><%--품목상태--%>
							<td>
								<select id="searchEstmtItmStatCd" name="searchEstmtItmStatCd">
								</select>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			<div class="rightBox"><button type="button" class="btn_search" id="btnSearch"><spring:message code='word.inquiry'/></button><%--조회--%></div>
		</div>
		<%--//검색영역--%>

		<div class="sh_box">
			<%--그리드 레이아웃 추가--%>
			<div class="grid_wrap gridType3">
				<section>
					<div class="w100">
						<div class="titType1">
							<h3><spring:message code='word.prdlst.info'/></h3><%--품목정보--%>
						</div>
						<div id='item-sheet'></div>
					</div>
				</section>
			</div>
		</div>
		<div class="sh_box">
				<section>
					<div class="w100">
						<div class="titType1">
							<%--BOM정보--%>
							<%-- <h3 class="qItemTit"><spring:message code='word.bom.info'/> :
								<span class="pl10 checkStyleCh">
									<input type="radio" id="searchAplyCd_01" name="searchAplyCd" value="01" onchange="javascript:fnBomRetrieveList()"/><label for="searchAplyCd_01"><spring:message code='word.valid'/></label>유효
									<input type="radio" id="searchAplyCd_02" name="searchAplyCd" value="02" onchange="javascript:fnBomRetrieveList()" checked/><label for="searchAplyCd_02"><spring:message code='word.all'/></label>전체
								</span>
							</h3> --%>
							<%--버튼영역--%>
							<%-- <div class="grid_btn">
								<div class="leftBox" id="btnLeftDiv" style="display: none;">
									<button type="button" class="btn_normal btn_frst" id="btnItemUpdate"><spring:message code='word.dcsn'/></button>확정
									<button type="button" class="btn_normal btn_last" id="btnBomDelete"><spring:message code='word.delete'/></button>삭제
									<!-- <span class="btnSpc">|</span> -->
								</div>
								<div class="rightBox">
									<button type="button" class="btn_normal btn_frst" id="btnBomAddRow"><span class="glyphicon glyphicon-plus"></span></button>행추가
									<button type="button" class="btn_normal btn_cent" id="btnBomDeleteRow"><span class="glyphicon glyphicon-minus"></span></button>행삭제
									<button type="button" class="btn_normal btn_last" id="btnBomSave"><span class="glyphicon glyphicon-floppy-disk"></span></button>저장
								</div>
							</div> --%>
							<div class="grid_btn">
								<div class="btn-group flex-j-end">
									<table>
										<tbody>
											<tr>
												<td>
													<ul class="master_check checkStyleCh">
														<li><input type="radio" id="searchAplyCd_01" name="searchAplyCd" value="01" onchange="javascript:fnBomRetrieveList()"/><label for="searchAplyCd_01"><spring:message code='word.valid'/></label><!-- 유효 --></li>
														<li><input type="radio" id="searchAplyCd_02" name="searchAplyCd" value="02" onchange="javascript:fnBomRetrieveList()" checked/><label for="searchAplyCd_02"><spring:message code='word.all'/></label><!-- 전체 --></li>
													</ul>
												</td>
											</tr>
										</tbody>
									</table>
									<div class="vertical-bar-sm" id="btnLeftDiv_line"></div>
									<div class="flex-j-end" id="btnLeftDiv">
										<button type="button" class="btn btn-sub size-auto bg-active btn-text-icon bt_gray" id="btnItemUpdate"><spring:message code='word.dcsn'/></button><!-- 확정 -->
										<button type="button" class="icon-delete-white btn btn-sub bg-active btn-text-icon bt_gray" id="btnBomDelete"><spring:message code='word.delete'/></button><!-- 삭제 -->
									</div>
									<div class="vertical-bar-sm"></div>
									<div class="btn-group-circular">
										<button type="button" class="icon-add btn btn-circular bg-disable" id="btnBomAddRow" title="<spring:message code='word.row.adit'/>"></button>
										<button type="button" class="icon-minus btn btn-circular bg-disable" id="btnBomDeleteRow" title="Delete"></button>
									</div>
									<div class="vertical-bar-sm"></div>
									<div class="flex-j-end">
										<button type="button" class="icon-save-white btn btn-icon bg-active" id="btnBomSave" title="Save"></button>
									</div>
								</div>
							</div>
							<%--// 버튼영역--%>
						</div>
						<div id='bom-sheet'></div>
					</div>
				</section>

			<%--// 그리드 레이아웃 추가--%>
		</div>
	</form>
</div>
