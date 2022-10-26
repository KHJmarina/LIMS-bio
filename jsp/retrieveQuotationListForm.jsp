<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script src='<c:url value="/resources/js/ngs/common.js"/>'></script>
<script src='<c:url value="/resources/js/cus/common.js"/>'></script>
<!-- ROLE_NGS_ORD_CREAT 권한 -->
<c:set value="${pageRole.hasAnyRole('ROLE_NGS_ORD_CREAT')}" var="isOrdCreat"/>
<!-- ROLE_NGS_PRE_SALES -->
<c:set value="${pageRole.hasAnyRole('ROLE_NGS_PRE_SALES')}" var="isPreSales"/>


<script>
var custCrncUntCdList;
function fnOnload() {
	//공통코드
	var objCmmnCmbCodes = new CommonSheetComboCodes()
    .addGroupCode({"groupCode": "SRVC_DOMN_CD", "required": true, "includedNotUse" : false}) //서비스도메인
    .addGroupCode({"groupCode": "CRNC_UNT_CD", "required": true, "includedNotUse" : false}) //통화
    .addGroupCode({"groupCode": "ESTMT_STAT_CD", "required": true, "includedNotUse" : false}) //견적상태
    .addGroupCode({"groupCode": "SNDNG_STTUS_CD", "required": true, "includedNotUse" : false}) //발송상태
    .execute();

	$("#searchSrvcDomnCd").addCommonSelectOptions({
	    "comboData":objCmmnCmbCodes["SRVC_DOMN_CD"],
	    "required": false
	});
	$("#searchCrncUntCd").addCommonSelectOptions({
	    "comboData":objCmmnCmbCodes["CRNC_UNT_CD"],
	    "required": false
	});
	$("#searchEstmtStatCd").addCommonSelectOptions({
	    "comboData":objCmmnCmbCodes["ESTMT_STAT_CD"],
	    "required": false
	});
	$("#searchSndngSttusCd").addCommonSelectOptions({
	    "comboData":objCmmnCmbCodes["SNDNG_STTUS_CD"],
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

	//검색조건_기간
	$("#searchRgsnFrom").IBMaskEdit("yyyy-MM-dd",{
		align: "left",
		hideGuideCharOnBlur: true,
		defaultValue: moment(moment().format('YYYYMMDD')).add("-1","month").format("YYYYMMDD"),
		onChange: function(value, oldvalue){
			var searchRgsnTo = $("#searchRgsnTo").IBMaskEdit("value");
			//값이 존재할 경우만 비교
			if(value && searchRgsnTo) {
				if(value.length === 8 && searchRgsnTo.length === 8 && !moment(value).isSameOrBefore(searchRgsnTo)) {
					alert("<spring:message code='infm.bgnde.endde.imprty'/>");  //시작일은 종료일보다 클 수 없습니다.
					$("#searchRgsnFrom").IBMaskEdit("value", oldvalue);
				}
			}
		}
	});
	$("#searchRgsnTo").IBMaskEdit("yyyy-MM-dd",{
		align: "left",
		hideGuideCharOnBlur: true,
		defaultValue: moment().format('YYYYMMDD'),
		onChange: function(value, oldvalue){
			var searchRgsnFrom = $("#searchRgsnFrom").IBMaskEdit("value");
			//값이 존재할 경우만 비교
			if(searchRgsnFrom && value) {
				if(value.length === 8 && searchRgsnFrom.length === 8 && !moment(searchRgsnFrom).isSameOrBefore(value)) {
					alert("<spring:message code='infm.bgnde.endde.imprty'/>");  //시작일은 종료일보다 클 수 없습니다.
					$("#searchRgsnTo").IBMaskEdit("value", oldvalue);
				}
			}
		}
	});

	createIBSheet2("quotation-sheet", "quotationSheet", "100%", "780px", "", false, "{AutoSizeColumn:'1', Mode:'1'}");
	IBS_InitSheet(quotationSheet, {
		"Cols": [
        	{Header:"상태", Type:"Status", Align:"Center", SaveName:"ibStatus", Hidden:"1", MinWidth:40},
        	{Header:"", Type:"DummyCheck", Align:"Center", SaveName:"ibCheck", MinWidth:50},//선택
        	{Header:"<spring:message code='word.hd.no'/>", Type:"Seq", Align:"Center", SaveName:"no", MinWidth:50, Edit:"0"},//No
        	{Header:"<spring:message code='word.hd.estmt.no'/>", Type:"Text", Align:"Center", SaveName:"estmtId", MinWidth:110, FontColor: "#4C84FF", FontUnderline:1, Cursor:"Pointer", Edit:"0"},//견적번호
        	{Header:"<spring:message code='word.hd.last.version'/>", Type:"Text", Align:"Center", SaveName:"estmtSn", MinWidth:60, Edit:"0"},//최종버전
        	{Header:"<spring:message code='word.hd.estmt.sj'/>", Type:"Text", Align:"Left", SaveName:"estmtTit", MinWidth:200, Edit:"0"},//견적제목
        	{Header:"<spring:message code='word.hd.estmt.sttus'/>", Type:"Text", Align:"Left", SaveName:"estmtStatNm", MinWidth:120, Edit:"0"},//견적상태
        	{Header:"<spring:message code='word.hd.ord.creat'/>", Type:"Button", Align:"Center", SaveName:"ordCreate", MinWidth:100, DefaultValue:"<spring:message code='word.ord.creat'/>", Edit:"0"},//주문생성
        	{Header:"<spring:message code='word.hd.srvc.domn'/>", Type:"Text", Align:"Left", SaveName:"srvcDomnNm", MinWidth:80, Edit:"0"},//서비스도메인
        	{Header:"<spring:message code='word.hd.ngs.cstmr.id'/>", Type:"Text", Align:"Left", SaveName:"custId", MinWidth:110, FontColor: "#4C84FF", FontUnderline:1, Cursor:"Pointer", Edit:"0"},//고객ID
        	{Header:"<spring:message code='word.hd.ngs.cstmr.nm'/>", Type:"Text", Align:"Left", SaveName:"custNm", MinWidth:110, Edit:"0"},//고객명
        	{Header:"<spring:message code='word.hd.nation'/>", Type:"Text", Align:"Center", SaveName:"natcode", MinWidth:50, Edit:"0"},//국가
        	{Header:"<spring:message code='word.hd.ngs.organization'/>", Type:"Text", Align:"Left", SaveName:"organization", MinWidth:120, Edit:"0"},//기관
        	{Header:"<spring:message code='word.hd.crncy'/>", Type:"Text", Align:"Center", SaveName:"crncUntNm", MinWidth:60, Edit:"0"},//통화
        	{Header:"<spring:message code='word.hd.taxamt.se'/>", Type:"Text", Align:"Center", SaveName:"txamtDivNm", MinWidth:80, Edit:"0"},//세액구분
	        {Header:"<spring:message code='word.hd.estmt.amount'/>", Type:"Float", Align:"Right", SaveName:"estmtAmt", MinWidth:90, "Format":"#,##0.00", Edit:"0"},//견적금액
        	{Header:"<spring:message code='word.hd.estmt.file'/>", Type:"Text", Align:"Left", SaveName:"orginlFileNm", MinWidth:200, FontColor: "#4C84FF", FontUnderline:1, Cursor:"Pointer", Edit:"0"},//견적파일
        	{Header:"<spring:message code='word.hd.sndng.dt'/>", Type:"Text", Align:"Center", SaveName:"sndngDttm", MinWidth:120, Format:"YmdHm", Edit:"0"},//발송일시
        	{Header:"<spring:message code='word.hd.sndng.sttus'/>", Type:"Text", Align:"Left", SaveName:"sndngSttusNm", MinWidth:80, Edit:"0"},//발송상태
        	{Header:"<spring:message code='word.hd.pinv.yn'/>", Type:"Text", Align:"Left", SaveName:"pinvCnt", MinWidth:80, Edit:"0"},//주문연결 여부
        	{Header:"<spring:message code='word.hd.regist.user.nm'/>", Type:"Text", Align:"Left", SaveName:"rgsnUserNm", MinWidth:100, Edit:"0"},//등록사용자명
        	{Header:"<spring:message code='word.hd.com.rgsn.dttm'/>", Type:"Text", Align:"Center", SaveName:"rgsnDttm", MinWidth:150, Format:"YmdHm", Edit:"0"},//등록일시
			{Header:"cmpnyCd", Type:"Text", SaveName:"cmpnyCd", Hidden:"1"}, //법인코드
			{Header:"estmtDivCd", Type:"Text", SaveName:"estmtDivCd", Hidden:"1"}, //견적구분
			{Header:"prenEstmtId", Type:"Text", SaveName:"prenEstmtId", Hidden:"1"}, //부모견적ID
			{Header:"estmtStatCd", Type:"Text", SaveName:"estmtStatCd", Hidden:"1"}, //견적상태
			{Header:"atchmnflNo", Type:"Text", SaveName:"atchmnflNo", Hidden:"1"}, //첨부파일번호
			{Header:"srvcDomnCd", Type:"Text", SaveName:"srvcDomnCd", Hidden:"1"}, //서비스도메인
			{Header:"crncUntCd", Type:"Text", SaveName:"crncUntCd", Hidden:"1"}, //통화
			{Header:"euCorpFlag", Type:"Text", SaveName:"euCorpFlag", Hidden:"1"} //유럽법인 고객 여부
		]
	});

    fnSetEvent();

    fnRetrieveList();
};

function fnSetEvent() {
	//검색조건_기간
	$("#btnRgsnFrom").click(function(){
		IBCalendar.Show($("#searchRgsnFrom").IBMaskEdit("value"), {
			"CallBack": function(date){
				$("#searchRgsnFrom").IBMaskEdit("value", date);
			},
			"Format": "Ymd",
			"Target": $("#searchRgsnFrom")[0],
			"CalButtons": "InputEmpty|Today|Close"
		});
	});
	$("#btnRgsnTo").click(function(){
		IBCalendar.Show($("#searchRgsnTo").IBMaskEdit("value"), {
			"CallBack": function(date){
				$("#searchRgsnTo").IBMaskEdit("value", date);
			},
			"Format": "Ymd",
			"Target": $("#searchRgsnTo")[0],
			"CalButtons": "InputEmpty|Today|Close"
		});
	});

	//검색
	$('#btnSearch').click(function() {
    	fnRetrieveList();
    });
	//견적생성
	$('#btnCreate').click(function() {
		if(${isPreSales}){
			fnMoveQuotationCteate("Q", "", "");
		}else{
			alert("권한이 없습니다.");
			return;
		}
    });
	//삭제
	$('#btnDelete').click(function() {
		if(${isPreSales}){
			cfDeleteRow(smplSheet);
			fnDelete();
		}else{
			alert("권한이 없습니다.");
			return;
		}
    });
	//
	$('#btnExcel').click(function() {
		if(${isPreSales}){
			fnExcel();
		}else{
			alert("권한이 없습니다.");
			return;
		}
	});

	//리사이징
    gridResize();
}

//조회
function fnRetrieveList() {
	new CommonAjax("/ngs/order/retrieveQuotationList.do")
	.addParam(quotationForm)
	.callback(function (resultData) {
		quotationSheet.LoadSearchData({"data": resultData.result});
	})
	.execute();
}

function fnExcel() {
	var param = {FileName:"QuotationList.xlsx", HiddenColumn:"1"};
	quotationSheet.Down2Excel(param);
}

//OnRowSearchEnd
function quotationSheet_OnRowSearchEnd(row) {
	var estmtStatCd =  quotationSheet.GetCellValue(row, "estmtStatCd");
	if (estmtStatCd === "Q10") {
		//견적상태=Q10(고객확정) 이면 버튼 활성화
		quotationSheet.InitCellProperty(row, "ordCreate", {Header:"<spring:message code='word.hd.ord.creat'/>", Type:"Button", Align:"Center", SaveName:"ordCreate", MinWidth:100, DefaultValue:"<spring:message code='word.ord.creat'/>", Edit:"1"});
	}

	var crncUntCd = quotationSheet.GetCellValue(row, "crncUntCd");
	if (crncUntCd === "KRW") {
		//원화:정수
		quotationSheet.InitCellProperty(row, "estmtAmt", {Type:"Float", Align:"Right", MinWidth:120, "Format":"#,##0", Edit:"0"});
	} else {
		//외화:소수 둘째자리
		quotationSheet.InitCellProperty(row, "estmtAmt", {Type:"Float", Align:"Right", MinWidth:120, "Format":"#,##0.00", Edit:"0"});
	}
}

//OnClick
function quotationSheet_OnClick(row, col) {
	if (row > 0) {
		var estmtDivCd = quotationSheet.GetCellValue(row, "estmtDivCd");
		var estmtId = quotationSheet.GetCellValue(row, "estmtId");
		var estmtSn = quotationSheet.GetCellValue(row, "estmtSn");
		var custId = quotationSheet.GetCellValue(row, "custId");
		var custNm = quotationSheet.GetCellValue(row, "custNm");
		var estmtStatCd =  quotationSheet.GetCellValue(row, "estmtStatCd");
		var srvcDomnCd = quotationSheet.GetCellValue(row, "srvcDomnCd");
		var saveName = quotationSheet.ColSaveName(col);
    	if (saveName === "estmtId") {
			//견적수정 화면으로 이동
    		fnMoveQuotationCteate(estmtDivCd, estmtId, estmtSn);
    	} else if (saveName === "ordCreate") {
    		if (estmtStatCd === "Q10") {
    			if(${isOrdCreat}){
    				fnRetrieveCrncUntList(row);
         			//고객 회계그룹통화 코드에 없는 통화 견적인 경우 에러 처리
        			//(2020-03-05 손상길) 회계그룹통화 코드에 없는 통화 처리 X
        			/* if (custCrncUntCdList.indexOf(quotationSheet.GetCellValue(row, "crncUntCd")) == -1) {
        				alert("<spring:message code='infm.estmt.invalid,crnc'/>"); //해당 고객의 회계그룹에 등록되어 있지 않은 통화입니다.
        				return false;
        			} */

        			//유럽법인 고객 주문 Block 처리
        			if (quotationSheet.GetCellValue(row, "euCorpFlag") == "Y") {
        				alert("<spring:message code='infm.eu.user.not.create'/>"); //EU user can not create order.
        				return false;
        			}

        			//견적상태=Q10(고객확정) 이면 주문생성 화면으로 이동
        			$('#frmMenu').find("input[name=estmtDivCd]").remove();
        			$('#frmMenu').find("input[name=estmtId]").remove();
        			$('#frmMenu').find("input[name=estmtSn]").remove();
        			$('#frmMenu').find("input[name=custId]").remove();
        			$('#frmMenu').find("input[name=custNm]").remove();
        			$('#frmMenu').find("input[name=srvcDomnCd]").remove();
            		$('#frmMenu').append('<input type="hidden" name="estmtDivCd" value="P">');				//견적구분(Q=견적서, P=Pre-Invoice)
            		$('#frmMenu').append('<input type="hidden" name="estmtId" value="'+estmtId+'">');		//견적ID
            		$('#frmMenu').append('<input type="hidden" name="estmtSn" value="'+estmtSn+'">');		//견적순번
            		$('#frmMenu').append('<input type="hidden" name="custId" value="'+custId+'">');  		//고객ID
            		$('#frmMenu').append('<input type="hidden" name="custNm" value="'+custNm+'">');  		//고객명
            		$('#frmMenu').append('<input type="hidden" name="srvcDomnCd" value="'+srvcDomnCd+'">'); //서비스도메인
    	   			fnMove("/ngs/order/retrieveNgsOrdRegistForm.do", "", "Y");
    			}else{
    				alert("권한이 없습니다.");
    				return;
    			}
    		}
    	} else if (saveName === "custId") {
   			//고객ID 클릭시 고객정보 팝업
			var custId = quotationSheet.GetCellValue(row, "custId");
   			retrieveUserInfoPopup(custId);
    	} else if (saveName === "orginlFileNm") {
 			var atchmnflNo = quotationSheet.GetCellValue(row, "atchmnflNo");
 			if (atchmnflNo !== "") {
				fnFileDownForm(atchmnflNo);
 			}
    	}
	}
}

//견적생성(수정) 화면으로 이동
function fnMoveQuotationCteate(estmtDivCd, estmtId, estmtSn) {
	$('#frmMenu').children().filter(':not(#menuCd)').remove();
	$('#frmMenu').append('<input type="hidden" name="estmtDivCd" value="'+estmtDivCd+'">'); //견적구분(Q=견적서, P=Pre-Invoice)
	$('#frmMenu').append('<input type="hidden" name="estmtId" value="'+estmtId+'">');		//견적ID
	$('#frmMenu').append('<input type="hidden" name="estmtSn" value="'+estmtSn+'">');   	//견적순번
	fnMove("/ngs/order/retrieveQuotationCteateForm.do", "");
}

//삭제
function fnDelete() {
	if (quotationSheet.CheckedRows("ibCheck") === 0 ) {
		var msgArg1 = "<spring:message code='word.estmt.info'/>";//견적정보
		alert("<spring:message code='infm.item.select' arguments='"+msgArg1+"'/>");//{0}을(를) 선택하여 주십시오.
		return;
	} else {
		new CommonAjax("/ngs/order/saveQuotationList.do")
		.addParam(quotationSheet, undefined, {AllSave:1})
		.callback(function (resultData) {
			alert(resultData.message);
			if (resultData.result === "S") {
				//삭제 후 조회
				fnRetrieveList();
			}

		})
		.confirm("<spring:message code='cnfm.delete'/>")
		.execute();
	}
}


//고객에 해당하는 통화코드 목록 조회
function fnRetrieveCrncUntList(row) {
  var codes = new CommonSheetComboOthers("/ngs/order/retrieveComCmmnCrncUntCdCombo.do")
  .addParam({"custId":quotationSheet.GetCellValue(row, "custId"), "cmmnClCd":"CRNC_UNT_CD"})
  .addCombo({"resultCombo": {"codeColumn": "cmmnCd", "textColumn": "cmmnCdNm"}})
  .execute();

  custCrncUntCdList = codes.resultCombo.ComboCode.split("|");
}

//그리드 resize(문지환D)
function gridResize(){
	$(window).resize(function(){
		var popWinSize = $(window).height();
		var hH = $("header").height();
		var hH2 = $("h2").height();
		var sH = $(".search_box2").height();
		var allH = hH + hH2 + sH + 100;
		//alert(hH + hH2 + sH + sH2);
		$("#quotation-sheet").height(popWinSize - allH);
	});
	var popWinSize = $(window).height();
	var hH = $("header").height();
	var hH2 = $("h2").height();
	var sH = $(".search_box2").height();
	var allH = hH + hH2 + sH + 100;
	//alert(hH + hH2 + sH + sH2);
	$("#quotation-sheet").height(popWinSize - allH);
}

</script>

<div class="content estmtList">
	<form class="form-inline form-control-static" action="" id="quotationForm" name="quotationForm" onsubmit="return false">
		<!-- 타이틀/위치정보 -->
		<div class="title-info">
			<h2>${activeMenu.menuNm}</h2>
		</div>
		<%--검색영역--%>
		<%-- <div class="search_box2">
			<div class="leftBox">
				<div class="searchLine1">
					<select id="searchRgsnCd" name="searchRgsnCd">
						<option value="01"><spring:message code='word.rgsn.dttm'/></option><!-- 등록일자 -->
						<option value="02"><spring:message code='word.product.date'/></option><!-- 제작일자 -->
						<option value="03"><spring:message code='word.send.date'/></option><!-- 발송일자 -->
					</select>
					<input type="text" class="date_type1" id="searchRgsnFrom" name="searchRgsnFrom"/><button type="button" class="btn_calendar" id="btnRgsnFrom"></button><span class="dateCk">~</span>
					<input type="text" class="date_type1" id="searchRgsnTo" name="searchRgsnTo"/><button type="button" class="btn_calendar" id="btnRgsnTo"></button>

					<!-- 서비스도메인 -->
					<span class="sech_tit"><spring:message code='word.srvc.domn'/></span>
					<select id="searchSrvcDomnCd" name="searchSrvcDomnCd" style="width:130px;">
					</select>

					<!--품목그룹-->
					<span class="sech_tit"><spring:message code='word.prdlst.group'/></span>
					<select id="searchEstmtItmGropInfo" name="searchEstmtItmGropInfo" style="width:130px;">
					</select>

					<!-- 검색조건1 -->
					<spring:message code='word.sch.cond1'/>
					<select id="searchBaseCd1" name="searchBaseCd" style="width:130px;">
						<option value=""><spring:message code='word.select'/></option><!-- 선택 -->
						<option value="01"><spring:message code='word.estmt.no'/></option><!-- 견적번호 -->
						<option value="02"><spring:message code='word.estmt.sj'/></option><!-- 견적제목 -->
						<option value="03"><spring:message code='word.ord.no'/></option><!-- 주문번호 -->
						<option value="04"><spring:message code='word.ngs.cstmr.id'/></option><!-- 고객ID -->
						<option value="05"><spring:message code='word.ngs.cstmr.nm'/></option><!-- 고객명 -->
						<option value="06"><spring:message code='word.nation'/></option><!-- 국가 -->
						<option value="07"><spring:message code='word.ngs.organization'/></option><!-- 기관 -->
						<option value="08"><spring:message code='word.regist.user.id'/></option><!-- 등록사용자ID -->
						<option value="09"><spring:message code='word.regist.user.nm'/></option><!-- 등록사용자명 -->
						<option value="10"><spring:message code='word.mnfct.user.id'/></option><!-- 제작사용자ID -->
						<option value="11"><spring:message code='word.mnfct.user.nm'/></option><!-- 제작사용자명 -->
						<option value="12"><spring:message code='word.sndng.user.id'/></option><!-- 발송사용자ID -->
						<option value="13"><spring:message code='word.sndng.user.nm'/></option><!-- 발송사용자명 -->
					</select>
					<input type="text" id="searchBase" name="searchBase" style="width:130px;" />
				</div>
				<div class="searchLine2">
					<!-- 견적상태 -->
					<span class="sech_tit"><spring:message code='word.estmt.sttus'/></span>
					<select id="searchEstmtStatCd" name="searchEstmtStatCd">
					</select>

					<!-- 발송상태 -->
					<span class="sech_tit"><spring:message code='word.sndng.sttus'/></span>
					<select id="searchSndngSttusCd" name="searchSndngSttusCd" style="width:130px;">
					</select>

					<!-- 통화 -->
					<span class="sech_tit"><spring:message code='word.crncy'/></span>
					<select id="searchCrncUntCd" name="searchCrncUntCd" style="width:130px;">
					</select>

					<!-- 검색조건2 -->
					<span class="sech_tit"><spring:message code='word.sch.cond2'/></span>
					<select id="searchBaseCd2" name="searchBaseCd2" style="width:130px;">
						<option value=""><spring:message code='word.select'/></option><!-- 선택 -->
						<option value="01"><spring:message code='word.estmt.no'/></option><!-- 견적번호 -->
						<option value="02"><spring:message code='word.estmt.sj'/></option><!-- 견적제목 -->
						<option value="03"><spring:message code='word.ord.no'/></option><!-- 주문번호 -->
						<option value="04"><spring:message code='word.ngs.cstmr.id'/></option><!-- 고객ID -->
						<option value="05"><spring:message code='word.ngs.cstmr.nm'/></option><!-- 고객명 -->
						<option value="06"><spring:message code='word.nation'/></option><!-- 국가 -->
						<option value="07"><spring:message code='word.ngs.organization'/></option><!-- 기관 -->
						<option value="08"><spring:message code='word.regist.user.id'/></option><!-- 등록사용자ID -->
						<option value="09"><spring:message code='word.regist.user.nm'/></option><!-- 등록사용자명 -->
						<option value="10"><spring:message code='word.mnfct.user.id'/></option><!-- 제작사용자ID -->
						<option value="11"><spring:message code='word.mnfct.user.nm'/></option><!-- 제작사용자명 -->
						<option value="12"><spring:message code='word.sndng.user.id'/></option><!-- 발송사용자ID -->
						<option value="13"><spring:message code='word.sndng.user.nm'/></option><!-- 발송사용자명 -->
					</select>
					<input type="text" id="searchBase2" name="searchBase2" style="width: 130px;" />
				</div>
			</div>
			<div class="leftBox">
				<button type="button" class="btn_search" id="btnSearch"><spring:message code='word.inquiry'/></button><!-- 조회 -->
			</div>
		</div> --%>
		<div class="search_box2">
			<div class="leftBox">
				<table>
					<%-- <colgroup>
						<col width="8%" />
						<col width="28%" />
						<col width="8%" />
						<col width="10%" />
						<col width="8%" />
						<col width="10%" />
						<col width="8%" />
						<col width="20%" />
					</colgroup> --%>
					<tbody>
						<tr>
							<td class="date_search">
								<select id="searchRgsnCd" name="searchRgsnCd">
									<option value="01"><spring:message code='word.rgsn.dttm'/></option><!-- 등록일자 -->
									<option value="02"><spring:message code='word.product.date'/></option><!-- 제작일자 -->
									<option value="03"><spring:message code='word.send.date'/></option><!-- 발송일자 -->
								</select>
								<input type="text" class="date_type1" id="searchRgsnFrom" name="searchRgsnFrom"/><button type="button" class="btn_calendar" id="btnRgsnFrom"></button><span class="dateCk">~</span>
								<input type="text" class="date_type1" id="searchRgsnTo" name="searchRgsnTo"/><button type="button" class="btn_calendar" id="btnRgsnTo"></button>
							</td><!-- 기간조회 -->
							<th><spring:message code='word.srvc.domn'/></th><!-- 서비스 도메인 -->
							<td>
								<select id="searchSrvcDomnCd" name="searchSrvcDomnCd" style="width: 130px;">
								</select>
							</td>
							<th><spring:message code='word.prdlst.group'/></th><!--품목그룹-->
							<td>
								<select id="searchEstmtItmGropInfo" name="searchEstmtItmGropInfo" style="width: 130px;">
								</select>
							</td>
							<th></th><!-- 검색조건1 -->
							<td>
								<select id="searchBaseCd1" name="searchBaseCd" class="bor2">
									<option value=""><spring:message code='word.sch.cond1'/></option><!-- 선택 -->
									<option value="01"><spring:message code='word.estmt.no'/></option><!-- 견적번호 -->
									<option value="02"><spring:message code='word.estmt.sj'/></option><!-- 견적제목 -->
									<option value="03"><spring:message code='word.ord.no'/></option><!-- 주문번호 -->
									<option value="04"><spring:message code='word.ngs.cstmr.id'/></option><!-- 고객ID -->
									<option value="05"><spring:message code='word.ngs.cstmr.nm'/></option><!-- 고객명 -->
									<option value="06"><spring:message code='word.nation'/></option><!-- 국가 -->
									<option value="07"><spring:message code='word.ngs.organization'/></option><!-- 기관 -->
									<option value="08"><spring:message code='word.regist.user.id'/></option><!-- 등록사용자ID -->
									<option value="09"><spring:message code='word.regist.user.nm'/></option><!-- 등록사용자명 -->
									<option value="10"><spring:message code='word.mnfct.user.id'/></option><!-- 제작사용자ID -->
									<option value="11"><spring:message code='word.mnfct.user.nm'/></option><!-- 제작사용자명 -->
									<option value="12"><spring:message code='word.sndng.user.id'/></option><!-- 발송사용자ID -->
									<option value="13"><spring:message code='word.sndng.user.nm'/></option><!-- 발송사용자명 -->
									<option value="14"><spring:message code='word.com.in.ord.no'/></option><!-- 인 주문번호 -->
									<option value="15"><spring:message code='word.com.out.ord.no'/></option><!-- 아웃 주문번호 -->
								</select><input type="text" id="searchBase" name="searchBase" class="w246 bor2 iconKeyboard" />
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			<div class="rightBox"><button type="button" class="btn_search" id="btnSearch"><spring:message code='word.inquiry'/></button></div><!-- 조회 -->
		</div>
		<div class="search_box2">
			<div class="leftBox">
				<table>
					<tbody>
						<tr>
							<th><spring:message code='word.estmt.sttus'/></th><!-- 견적상태 -->
							<td style="padding-right: 44px;">
								<select id="searchEstmtStatCd" name="searchEstmtStatCd" style="width:220px;">
								</select>
							</td>
							<th><spring:message code='word.sndng.sttus'/></th><!-- 발송상태 -->
							<td style="padding-right: 14px;">
								<select id="searchSndngSttusCd" name="searchSndngSttusCd" style="width: 130px;">
								</select>
							</td>
							<th><spring:message code='word.crncy'/></th><!-- 통화 -->
							<td>
								<select id="searchCrncUntCd" name="searchCrncUntCd" style="width: 130px;">
								</select>
							</td>
							<th></th>
							<td>
								<select id="searchBaseCd2" name="searchBaseCd2" class="bor2">
									<option value=""><spring:message code='word.sch.cond2'/></option><!-- 검색조건2 -->
									<option value="01"><spring:message code='word.estmt.no'/></option><!-- 견적번호 -->
									<option value="02"><spring:message code='word.estmt.sj'/></option><!-- 견적제목 -->
									<option value="03"><spring:message code='word.ord.no'/></option><!-- 주문번호 -->
									<option value="04"><spring:message code='word.ngs.cstmr.id'/></option><!-- 고객ID -->
									<option value="05"><spring:message code='word.ngs.cstmr.nm'/></option><!-- 고객명 -->
									<option value="06"><spring:message code='word.nation'/></option><!-- 국가 -->
									<option value="07"><spring:message code='word.ngs.organization'/></option><!-- 기관 -->
									<option value="08"><spring:message code='word.regist.user.id'/></option><!-- 등록사용자ID -->
									<option value="09"><spring:message code='word.regist.user.nm'/></option><!-- 등록사용자명 -->
									<option value="10"><spring:message code='word.mnfct.user.id'/></option><!-- 제작사용자ID -->
									<option value="11"><spring:message code='word.mnfct.user.nm'/></option><!-- 제작사용자명 -->
									<option value="12"><spring:message code='word.sndng.user.id'/></option><!-- 발송사용자ID -->
									<option value="13"><spring:message code='word.sndng.user.nm'/></option><!-- 발송사용자명 -->
									<option value="14"><spring:message code='word.com.in.ord.no'/></option><!-- 인 주문번호 -->
									<option value="15"><spring:message code='word.com.out.ord.no'/></option><!-- 아웃 주문번호 -->
								</select><input type="text" id="searchBase2" name="searchBase2" class="w246 bor2 iconKeyboard" />
							</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
		<%--//검색영역--%>

		<div class="sh_box">
			<div class="grid_wrap">
				<div class="titType1">
					<div class="grid_btn">
						<%-- <button type="button" class="btn_normal btn_frst" id="btnCreate" title="<spring:message code='word.estmt.creat'/>"><spring:message code='word.estmt.creat'/></button>견적생성
						<button type="button" class="btn_normal btn_cent" id="btnDelete" title="<spring:message code='word.delete'/>"><spring:message code='word.delete'/></button>삭제
						<button type="button" class="bt_excel" id="btnExcel"><span class="glyphicon glyphicon-excel"></span></button> --%>
						<div class="btn-group flex-j-end">
							<div class=flex-j-end>
								<button type="button" class="btn btn-sub size-auto bg-blueL" id="btnCreate"><spring:message code='word.estmt.creat'/></button><!-- 견적생성 -->
							</div>
							<div class="vertical-bar-sm"></div>
							<div class=flex-j-end>
								<button type="button" class="icon-delete-white btn btn-sub size-auto bg-active btn-text-icon bt_gray" id="btnDelete"><spring:message code='word.delete'/></button><!-- 삭제 -->
							</div>
							<div class="vertical-bar-sm"></div>
							<div class="flex-j-end">
								<button type="button" class="icon-export-white btn btn-sub size-sm btn-icon bg-secondary b-zero" id="btnExcel"></button>
							</div>
						</div>
					</div>
				</div>
				<div id='quotation-sheet'></div>
			</div>
		</div>
	</form>
</div>
