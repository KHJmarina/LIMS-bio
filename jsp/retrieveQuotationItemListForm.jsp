<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script src='<c:url value="/resources/js/ngs/common.js"/>'></script>
<script src='<c:url value="/resources/js/cus/common.js"/>'></script>
<script>
function fnOnload() {
	//공통코드
	var objCmmnCmbCodes = new CommonSheetComboCodes()
	.addGroupCode({"groupCode":"ESTMT_ITM_STAT_CD", "required":true, "includedNotUse":false}) //픔목상태
	.addGroupCode({"groupCode":"ESTMT_ITM_STDR_CD", "required":true, "includedNotUse":false}) //규격
	.addGroupCode({"groupCode":"CRNC_UNT_CD", "required":true, "includedNotUse":false}) //통화
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

    //품목그룹
    var estmtItmGropInfoList;
   	new CommonAjax("/ngs/order/retrieveEstmtItmGropInfoList.do")
    //.addParam({"useYn":"Y"})
	.callback(function (resultData) {
		if (resultData.result.length === 0) {
			estmtItmGropInfoList = [];
			estmtItmGropInfoList["estmtItmGropCdNm"] = "";
			estmtItmGropInfoList["estmtItmGropCd"] = "";
		} else {
			estmtItmGropInfoList = cfArrayToSheetCombo(resultData.result);
		}
	})
	.async(false)
	.execute();

    //sheet 초기화
    if (typeof itemSheet != "undefined") {
        DisposeSheet(itemSheet, "item-sheet");
    }
    if (typeof priceSheet != "undefined") {
        DisposeSheet(priceSheet, "price-sheet");
    }

	createIBSheet2("item-sheet", "itemSheet", "100%", "300px", "", false, "{AutoSizeColumn:'1', Mode:'1'}");
	IBS_InitSheet(itemSheet, {
		"Cols": [
        	{Header:"상태", Type:"Status", Align:"Center", SaveName:"ibStatus", Hidden:"1", MinWidth:40},
        	{Header:"", Type:"DummyCheck", Align:"Center", SaveName:"ibCheck", MinWidth:20},//선택
        	{Header:"<spring:message code='word.hd.no'/>", Type:"Seq", Align:"Center", SaveName:"no", MinWidth:50, Edit:"0"},//No
        	{Header:"<spring:message code='word.hd.prdlst.cd'/>", Type:"Text", Align:"Left", SaveName:"estmtItmCd", MinWidth:100, Edit:"0"},//품목코드
        	{Header:"<spring:message code='word.hd.prdlst.group'/>", Type:"Combo", Align:"Left", SaveName:"estmtItmGropCd", MinWidth:150, KeyField:"1", "ComboText":estmtItmGropInfoList.estmtItmGropCdNm, "ComboCode":estmtItmGropInfoList.estmtItmGropCd},//품목그룹
        	{Header:"<spring:message code='word.hd.prdlst.nm'/>", Type:"Text", Align:"Left", SaveName:"estmtItmCdNm", MinWidth:200, KeyField:"1", EditLen:200},//품목명
	        {Header:"<spring:message code='word.hd.stndrd'/>", Type:"Combo", Align:"Left", SaveName:"estmtItmStdrCd", MinWidth:80, KeyField:"1", "ComboText":objCmmnCmbCodes["ESTMT_ITM_STDR_CD"].ComboText, "ComboCode":objCmmnCmbCodes["ESTMT_ITM_STDR_CD"].ComboCode},//규격
        	{Header:"<spring:message code='word.hd.prdlst.sttus'/>", Type:"Combo", Align:"Left", SaveName:"estmtItmStatCd", MinWidth:120, Edit:"0", "ComboText":objCmmnCmbCodes["ESTMT_ITM_STAT_CD"].ComboText, "ComboCode":objCmmnCmbCodes["ESTMT_ITM_STAT_CD"].ComboCode},//품목상태
	        {Header:"<spring:message code='word.hd.modi.user'/>", Type:"Text", Align:"Left", SaveName:"modiUserNm", MinWidth:120, Edit:"0"},//수정사용자
	        {Header:"<spring:message code='word.hd.com.modi.dttm'/>", Type:"Date", Align:"Left", SaveName:"modiDttm", MinWidth:120, Edit:"0", Format:"YmdHm"},//수정일시
			{Header:"cmpnyCd", Type:"Text", SaveName:"cmpnyCd", Hidden:"1"}, //법인코드
			{Header:"unprCnt", Type:"Int", SaveName:"unprCnt", Hidden:"1"}   //등록단가수
		]
	});

    createIBSheet2("price-sheet", "priceSheet", "100%", "300px", "", false, "{AutoSizeColumn:'1', Mode:'1'}");
	IBS_InitSheet(priceSheet, {
		"Cols": [
        	{Header:"상태", Type:"Status", Align:"Center", SaveName:"ibStatus", Hidden:"1", MinWidth:40},
        	{Header:"", Type:"DummyCheck", Align:"Center", SaveName:"ibCheck", MinWidth:20},//선택
        	{Header:"<spring:message code='word.hd.no'/>", Type:"Seq", Align:"Center", SaveName:"no", MinWidth:50, Edit:"0"},//No
	        {Header:"<spring:message code='word.hd.crncy'/>", Type:"Combo", Align:"Left", SaveName:"crncUntCd", MinWidth:120, KeyField:"1", "ComboText":objCmmnCmbCodes["CRNC_UNT_CD"].ComboText, "ComboCode":objCmmnCmbCodes["CRNC_UNT_CD"].ComboCode},//통화
        	{Header:"<spring:message code='word.hd.aply.begin.dt'/>", Type:"Date", Align:"Left", SaveName:"aplyBeginDt", MinWidth:120, KeyField:"1", Format:"Ymd"},//적용시작일자
			{Header:"<spring:message code='word.hd.aply.end.dt'/>", Type:"Date", Align:"Left", SaveName:"aplyEndDt", MinWidth:120, KeyField:"1", Format:"Ymd"},//적용종료일자
			{Header:"<spring:message code='word.hd.prc'/>", Type:"Float", Align:"Right", SaveName:"unpr", MinWidth:120, KeyField:"1", "Format":"#,##0.00", "EditPointCount":2, "MaximumValue":999999999999999.99},//단가
	        {Header:"<spring:message code='word.hd.modi.user'/>", Type:"Text", Align:"Left", SaveName:"modiUserNm", MinWidth:120, Edit:"0"},//수정사용자
	        {Header:"<spring:message code='word.hd.com.modi.dttm'/>", Type:"Date", Align:"Left", SaveName:"modiDttm", MinWidth:120, Edit:"0", Format:"YmdHm"},//수정일시
			{Header:"cmpnyCd", Type:"Text", SaveName:"cmpnyCd", Hidden:"1"}, //법인코드
			{Header:"estmtItmCd", Type:"Text", SaveName:"estmtItmCd", Hidden:"1"}, //품목코드
			{Header:"estmtItmUnprSn", Type:"Text", SaveName:"estmtItmUnprSn", Hidden:"1"}, //품목단가순번
			{Header:"editYn", Type:"Text", SaveName:"editYn", Hidden:"1"}, //수정가능여부
			{Header:"aplyEndDtEditYn", Type:"Text", SaveName:"aplyEndDtEditYn", Hidden:"1"}  //종료일자 수정가능여부
		]
	});

    fnSetEvent();
    fnRetrieveList("search");

  	//리사이징
    gridResize();
};

function fnSetEvent() {
	//검색
	$('#btnSearch').click(function() {
    	fnRetrieveList("search");
    });
	//품목그룹
	$('#btnItemGroupPopup').click(function() {
		fnItemGroupPopup();
    });
	//품목정보_행추가
	$('#btnAddRow').click(function() {
		//판매단가 그리드 클리어
		priceSheet.RemoveAll();

        var row = itemSheet.DataInsert(itemSheet.GetDataLastRow() + 1);
		$("#selectItemSheetRow").val(row); //클릭한 row
        itemSheet.SetCellValue(row, "no", row);
        itemSheet.SetCellValue(row, "ibCheck", "Y");
        itemSheet.SetCellValue(row, "estmtItmStatCd", "00"); //생성
    });
	//품목정보_행삭제
	$('#btnDeleteRow').click(function() {
		cfDeleteRow(itemSheet);
	});
	//품목정보_삭제
	$('#btnDelete').click(function() {
    	fnDelete();
    });
	//품목정보_저장
	$('#btnSave').click(function() {
    	fnSave();
    });

	//판매단가_행추가
	$('#btnPriceAddRow').click(function() {
        var itemRow = $("#selectItemSheetRow").val();
    	var ibStatus = itemSheet.GetCellValue(itemRow, "ibStatus");
		if (ibStatus !== "I") {
	        var row = priceSheet.DataInsert(priceSheet.GetDataLastRow() + 1);
	        priceSheet.SetCellValue(row, "no", row);
	        priceSheet.SetCellValue(row, "ibCheck", "Y");
	        priceSheet.SetCellValue(row, "cmpnyCd", itemSheet.GetCellValue(itemRow, "cmpnyCd"));
	        priceSheet.SetCellValue(row, "estmtItmCd", itemSheet.GetCellValue(itemRow, "estmtItmCd"));
	        priceSheet.SetCellValue(row, "aplyBeginDt", moment(moment().format('YYYYMMDD')).add("1","day").format("YYYYMMDD"));
	        priceSheet.SetCellValue(row, "aplyEndDt", "99991231");
		}
    });
	//판매단가_행삭제
	$('#btnPriceDeleteRow').click(function() {
		cfDeleteRow(priceSheet);
	});
	//판매단가_삭제
	$('#btnPriceDelete').click(function() {
    	fnPriceDelete();
    });
	//판매단가_저장
	$('#btnPriceSave').click(function() {
    	fnPriceSave();
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
			//품목정보 조회 결과가 없으면 판매단가 그리드 클리어
			priceSheet.RemoveAll();
		}
	})
	.execute();
}

//품목정보_삭제
function fnDelete() {
	if (itemSheet.CheckedRows("ibCheck") === 0 ) {
		alert("<spring:message code='infm.delete.trgter.choise'/>");
		return;
	} else {
		new CommonAjax("/ngs/setup/quotation/deleteQuotationItemList.do")
		.addParam(itemSheet)
		.confirm("<spring:message code='cnfm.delete'/>")
		.callback(function (resultData) {
			alert(resultData.message);
			if (resultData.result === "S") {
				fnRetrieveList("search");
			}
		})
		.execute();
	}
}

//품목정보_저장
function fnSave() {
	new CommonAjax("/ngs/setup/quotation/saveQuotationItemList.do")
	.addParam(itemSheet)
	.confirm("<spring:message code='cnfm.save'/>")
	.callback(function (resultData) {
		alert(resultData.message);
		if (resultData.result === "S") {
			fnRetrieveList("save");
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

//품목정보_OnRowSearchEnd
function itemSheet_OnRowSearchEnd(row) {
	var estmtItmStatCd = itemSheet.GetCellValue(row, "estmtItmStatCd");
	var unprCnt = itemSheet.GetCellValue(row, "unprCnt");
	if (estmtItmStatCd !== "00" || unprCnt !== 0) {
		/*품목상태=생성(00) 이고 판매단가 등록되어 있지 않으면 수정 가능
		  그외는 수정 불가*/
		itemSheet.SetCellEditable(row, "estmtItmGropCd", 0);
		itemSheet.SetCellEditable(row, "estmtItmCdNm", 0);
		itemSheet.SetCellEditable(row, "estmtItmStdrCd", 0);
	}
}

//품목정보_OnSelectCell
function itemSheet_OnSelectCell(oldRow, oldCol, newRow, newCol, isDelete) {
	if (newRow !== oldRow) {
    	var ibStatus = itemSheet.GetCellValue(newRow, "ibStatus");
		if (ibStatus === "I") {
			//판매단가 그리드 클리어
			priceSheet.RemoveAll();
		} else if (ibStatus === "R") {
			//클릭한 row
			$("#selectItemSheetRow").val(newRow);
			$("#selectCmpnyCd").val(itemSheet.GetCellValue(newRow, "cmpnyCd"));
			$("#selectEstmtItmCd").val(itemSheet.GetCellValue(newRow, "estmtItmCd"));

			fnPriceRetrieveList();
		}
    }
}

//판매단가_조회
function fnPriceRetrieveList() {
	new CommonAjax("/ngs/setup/quotation/retrieveQuotationItemPriceList.do")
	.addParam(quotationForm)
	.callback(function (resultData) {
		priceSheet.LoadSearchData({"data": resultData.result});
	})
	.execute();
}

//판매단가_삭제
function fnPriceDelete() {
	for (var i = 0; i < priceSheet.RowCount(); i++) {
		var ibCheck = priceSheet.GetCellValue(i + 1, "ibCheck");
		var editYn = priceSheet.GetCellValue(i + 1, "editYn");
		if (ibCheck == "1" && editYn == "N") {
			alert("<spring:message code='infm.begin.date.only.future.delete'/>");//적용시작일자가 미래일자의 경우에만 삭제 할 수 있습니다.
			return;
		}
    }

	new CommonAjax("/ngs/setup/quotation/deleteQuotationItemPriceList.do")
	.addParam(priceSheet)
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

//판매단가_저장
function fnPriceSave() {
	new CommonAjax("/ngs/setup/quotation/saveQuotationItemPriceList.do")
	.addParam(priceSheet)
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

//판매단가_onchange
function priceSheet_OnChange(row, col, value, oldValue, raiseFlag) {
	var saveName = priceSheet.ColSaveName(col);
	if (saveName === "crncUntCd") {
		var crncUntCd = priceSheet.GetCellValue(row, "crncUntCd");
		if (crncUntCd === "KRW") {
			//원화:정수
			priceSheet.InitCellProperty(row, "unpr", {Type:"Float", Align:"Right", KeyField:"1", "Format":"#,##0", "EditPointCount":0, "MaximumValue":999999999999999});//단가
		} else {
			//외화:소수 둘째자리
			priceSheet.InitCellProperty(row, "unpr", {Type:"Float", Align:"Right", KeyField:"1", "Format":"#,##0.00", "EditPointCount":2, "MaximumValue":999999999999999.99});//단가
		}
	}
}

//판매단가_OnRowSearchEnd
function priceSheet_OnRowSearchEnd(row) {
	var editYn = priceSheet.GetCellValue(row, "editYn");
	var aplyEndDtEditYn = priceSheet.GetCellValue(row, "aplyEndDtEditYn");
	if (editYn === "N") {
		//수정불가
		priceSheet.SetCellEditable(row, "crncUntCd", 0);
		priceSheet.SetCellEditable(row, "aplyBeginDt", 0);
		priceSheet.SetCellEditable(row, "aplyEndDt", 0);
		priceSheet.SetCellEditable(row, "unpr", 0);

		if (aplyEndDtEditYn === "Y") {
			//종료일자 수정가능
			priceSheet.SetCellEditable(row, "aplyEndDt", 1);
		}
	}

	var crncUntCd = priceSheet.GetCellValue(row, "crncUntCd");
	if (crncUntCd === "KRW") {
		//원화:정수
		priceSheet.InitCellProperty(row, "unpr", {Type:"Float", Align:"Right", MinWidth:120, KeyField:"1", "Format":"#,##0", "EditPointCount":0, "MaximumValue":999999999999999});//단가
	} else {
		//외화:소수 둘째자리
		priceSheet.InitCellProperty(row, "unpr", {Type:"Float", Align:"Right", MinWidth:120, KeyField:"1", "Format":"#,##0.00", "EditPointCount":2, "MaximumValue":999999999999999.99});//단가
	}
}

//품목그룹정보 팝업
function fnItemGroupPopup() {
	var left = (screen.width / 2) - 500;
	var top= (screen.height /2) - 250;
	var frm = document.quotationForm;
	window.open("", "itemGroupPopup","toolbar=no,directories=no,scrollbars=yes,resizable=yes,status=no,menubar=no,width=1000,height=500, left=" + left + ", top=" + top);
	frm.target = "itemGroupPopup";
	frm.action = "/ngs/setup/quotation/retrieveQuotationItemGroupListPopup.do";
	frm.method = "post";
	frm.submit();
}

function callBackItemGroupPopup() {
	//품목그룹
    var estmtItmGropInfoCodes = new CommonSheetComboOthers("/ngs/order/retrieveEstmtItmGropInfoCombo.do")
    .addCombo({"resultCombo": {"codeColumn": "estmtItmGropCd", "textColumn": "estmtItmGropCdNm"}})
    .execute();
    $("#searchEstmtItmGropInfo").addCommonSelectOptions({
        "comboData":estmtItmGropInfoCodes["resultCombo"],
        "required": false
    });

    //품목그룹
    var estmtItmGropInfoList;
   	new CommonAjax("/ngs/order/retrieveEstmtItmGropInfoList.do")
    //.addParam({"useYn":"Y"})
	.callback(function (resultData) {
		if (resultData.result.length === 0) {
			estmtItmGropInfoList = [];
			estmtItmGropInfoList["estmtItmGropCdNm"] = "";
			estmtItmGropInfoList["estmtItmGropCd"] = "";
		} else {
			estmtItmGropInfoList = cfArrayToSheetCombo(resultData.result);
		}
		itemSheet.SetColProperty(0, "estmtItmGropCd", {ComboText:estmtItmGropInfoList.estmtItmGropCdNm,ComboCode:estmtItmGropInfoList.estmtItmGropCd});
	})
	.async(false)
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
		var allH = hH + hH2 + sH + /* sH2 + */ (bH*2) + 215;
		$("#item-sheet, #price-sheet").height((popWinSize - allH)/2);
	});
	var popWinSize = $(window).height();
	var hH = $("header").height();
	var hH2 = $(".title-info").height();
	var sH = $(".search_box2").height();
	/* var sH2 = $("#item-sheet").height(); */
	var bH = $(".grid_btn").height();
	var allH = hH + hH2 + sH + /* sH2 + */ (bH*2) + 215;
	$("#item-sheet, #price-sheet").height((popWinSize - allH)/2);
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
							<%--버튼영역--%>
							<div class="grid_btn">
								<%-- <div class="leftBox">
									<button type="button" class="btn_normal btn_frst" id="btnItemGroupPopup"><spring:message code='word.prdlst.group'/></button>품목그룹
									<button type="button" class="btn_normal btn_last" id="btnDelete"><spring:message code='word.delete'/></button>삭제
								</div>
								<div class="rightBox">
									<!-- <span class="btnSpc">|</span> -->
									<button type="button" class="btn_normal btn_frst" id="btnAddRow"><span class="glyphicon glyphicon-plus"></span></button>행추가
									<button type="button" class="btn_normal btn_cent" id="btnDeleteRow"><span class="glyphicon glyphicon-minus"></span></button>행삭제
									<button type="button" class="btn_normal btn_last" id="btnSave"><span class="glyphicon glyphicon-floppy-disk"></span></button>저장
								</div> --%>
								<div class="btn-group flex-j-end">
									<div class="flex-j-end">
										<%-- <button type="button" class="btn btn-sub size-auto bg-secondary fl-left" id="btnItemGroupPopup"><spring:message code='word.prdlst.group'/></button><!-- 팝업 --> --%>
										<button type="button" class="btn btn-sub size-auto bg-secondary-empty" id="btnItemGroupPopup"><spring:message code='word.prdlst.group'/></button><!-- 팝업 -->
									</div>
									<div class="vertical-bar-sm"></div>
									<div class="flex-j-end">
										<button type="button" class="icon-delete-white btn btn-sub size-auto bg-active btn-text-icon bt_gray" id="btnDelete"><spring:message code='word.delete'/></button><!-- 삭제 -->
									</div>
									<div class="vertical-bar-sm"></div>
									<div class="btn-group-circular">
										<button type="button" class="icon-add btn btn-circular bg-disable" id="btnAddRow" title="<spring:message code='word.row.adit'/>"></button>
										<button type="button" class="icon-minus btn btn-circular bg-disable" id="btnDeleteRow" title="Delete"></button>
									</div>
									<div class="vertical-bar-sm"></div>
									<div class="flex-j-end">
										<button type="button" class="icon-save-white btn btn-icon bg-active" id="btnSave" title="Save"></button>
									</div>
								</div>
							</div>
							<%--// 버튼영역--%>
						</div>
						<div id='item-sheet'></div>
					</div>
				</section>
			</div>
		</div>
		<div class="sh_box">
				<section>
					<div class="w100">
						<%-- <div class="titType1">
							<h3 class="qItemTit"><spring:message code='word.sle.prc'/> :
								<span class="pl10 checkStyleCh">
									<input type="radio" id="searchAplyCd_01" name="searchAplyCd" value="01" onchange="javascript:fnPriceRetrieveList()"/><label for="searchAplyCd_01"><spring:message code='word.valid'/></label>유효
									<input type="radio" id="searchAplyCd_02" name="searchAplyCd" value="02" onchange="javascript:fnPriceRetrieveList()" checked/><label for="searchAplyCd_02"><spring:message code='word.all'/></label>전체
								</span>
							</h3>판매단가
							버튼영역
							<div class="grid_btn">
								<div class="leftBox">
									<button type="button" class="btn_normal btn_one" id="btnPriceDelete"><spring:message code='word.delete'/></button>삭제
								</div>
								<div class="rightBox">
									<button type="button" class="btn_normal btn_frst" id="btnPriceAddRow"><span class="glyphicon glyphicon-plus"></span></button>행추가
									<button type="button" class="btn_normal btn_cent" id="btnPriceDeleteRow"><span class="glyphicon glyphicon-minus"></span></button>행삭제
									<button type="button" class="btn_normal btn_last" id="btnPriceSave"><span class="glyphicon glyphicon-floppy-disk"></span></button>저장
								</div>
							</div>
						</div> --%>
						<div class="grid_btn">
							<div class="btn-group flex-j-end">
								<table>
									<tbody>
										<tr>
											<td>
												<ul class="master_check checkStyleCh">
													<li><input type="radio" id="searchAplyCd_01" name="searchAplyCd" value="01" onchange="javascript:fnPriceRetrieveList()"/><label for="searchAplyCd_01"><spring:message code='word.valid'/></label><!-- 유효 --></li>
													<li><input type="radio" id="searchAplyCd_02" name="searchAplyCd" value="02" onchange="javascript:fnPriceRetrieveList()" checked/><label for="searchAplyCd_02"><spring:message code='word.all'/></label><!-- 전체 --></li>
												</ul>
											</td>
										</tr>
									</tbody>
								</table>
								<div class="vertical-bar-sm"></div>
								<div class=flex-j-end>
									<button type="button" class="icon-delete-white btn btn-sub size-auto bg-active btn-text-icon bt_gray" id="btnPriceDelete"><spring:message code='word.delete'/></button><!-- 삭제 -->
								</div>
								<div class="vertical-bar-sm"></div>
								<div class="btn-group-circular">
									<button type="button" class="icon-add btn btn-circular bg-disable" id="btnPriceAddRow" title="<spring:message code='word.row.adit'/>"></button>
									<button type="button" class="icon-minus btn btn-circular bg-disable" id="btnPriceDeleteRow" title="Delete"></button>
								</div>
								<div class="vertical-bar-sm"></div>
								<div class="flex-j-end">
									<button type="button" class="icon-save-white btn btn-icon bg-active" id="btnPriceSave" title="Save"></button>
								</div>
							</div>
						</div>
						<div id='price-sheet'></div>
						<div style="padding:5px 0; text-align:left; font-size: 12px;"><spring:message code='word.krw.vat.include'/></div><%--※KRW의 경우 VAT 포함금액--%>
					</div>
				</section>

			<%--// 그리드 레이아웃 추가--%>
		</div>
	</form>
</div>
