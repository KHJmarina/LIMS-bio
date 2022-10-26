<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script src='<c:url value="/resources/js/ngs/common.js"/>'></script>
<script src='<c:url value="/resources/js/cus/common.js"/>'></script>
<!-- PreSalse 권한 -->
<c:set value="${pageRole.hasAnyRole('ROLE_NGS_PRE_SALES')}" var="isPreSales"/>

<script>
function fnOnload() {
	//공통코드
	var objCmmnCmbCodes = new CommonSheetComboCodes()
    .addGroupCode({"groupCode": "CMPNY_CD", "required": true, "includedNotUse" : false}) //CMPNY_CD
    .addGroupCode({"groupCode": "PLTFOM_CD", "required": true, "includedNotUse" : false}) //PLTFOM_CD
    .addGroupCode({"groupCode": "APPLION_TYPE_CD", "required": true, "includedNotUse" : false}) //APPLION_TYPE_CD
    .addGroupCode({"groupCode": "LIB_TYPE_CD", "required": true, "includedNotUse" : false}) //LIB_TYPE_CD
    .execute();

	//법인구분
	$("#searchCmpnyCd").addCommonSelectOptions({
	    "comboData":objCmmnCmbCodes["CMPNY_CD"],
	    "required": false
	});
	//Platform
	$("#searchPltfomCd").addCommonSelectOptions({
	    "comboData":objCmmnCmbCodes["PLTFOM_CD"],
	    "required": false
	});
	//APPLION_TYPE_CD
	$("#searchApplionTypeCd").addCommonSelectOptions({
	    "comboData":objCmmnCmbCodes["APPLION_TYPE_CD"],
	    "required": false
	});
	//Library Type
	$("#searchLibTypeCd").addCommonSelectOptions({
	    "comboData":objCmmnCmbCodes["LIB_TYPE_CD"],
	    "required": false
	});

	//Library Kit
	fnRetrieveLibKitList();

	//KINGDOM
    var kgdmCodes = new CommonSheetComboOthers("/ngs/order/retrieveComCmmnCombo.do")
    .addParam({cmmnClCd:"KGDM_CD"})
    .addCombo({"resultCombo": {"codeColumn": "cmmnCd", "textColumn": "cmmnCdNm", "required": true}})
    .execute();

    $("#searchKgdmCd").addCommonSelectOptions({
        "comboData":kgdmCodes["resultCombo"],
        "required": false
    });

	//SOURCE
	fnRetrieveComCmmnList("SRC_CD");

	//검색조건_기간
	$("#searchRgsnFrom").IBMaskEdit("yyyy-MM-dd",{
		align: "left",
		hideGuideCharOnBlur: true,
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

	createIBSheet2("ordRqst-sheet", "ordRqstSheet", "100%", "800px", "", false, "{AutoSizeColumn:'1', Mode:'1'}");
	IBS_InitSheet(ordRqstSheet, {
		"Cols": [
        	{Header:"상태", Type:"Status", Align:"Center", SaveName:"ibStatus", Hidden:"1", MinWidth:40, BackColor:"#ffffff"},
        	{Header:"<spring:message code='word.hd.no'/>", Type:"Seq", Align:"Left", SaveName:"no", MinWidth:60, BackColor:"#ffffff"},//No
        	{Header:"<spring:message code='word.hd.com.cmpny.se'/>", Type:"Text", Align:"Left", SaveName:"cmpnyNm", MinWidth:100, BackColor:"#ffffff"},//법인구분
        	{Header:"<spring:message code='word.hd.rqstdoc.no'/>", Type:"Text", Align:"Left", SaveName:"rqstNo", MinWidth:120, FontColor: "#4C84FF", FontUnderline:1, Cursor:"Pointer", BackColor:"#ffffff"},//의뢰서번호
        	{Header:"<spring:message code='word.hd.rqstdoc.nm'/>", Type:"Text", Align:"Left", SaveName:"rqstNm", MinWidth:150, BackColor:"#ffffff"},//의뢰서명
        	{Header:"<spring:message code='word.hd.ord.no'/>", Type:"Text", Align:"Left", SaveName:"ordNo", MinWidth:100, FontColor: "#4C84FF", FontUnderline:1, Cursor:"Pointer", BackColor:"#ffffff"},//주문번호
        	{Header:"<spring:message code='word.hd.ngs.cstmr.id'/>", Type:"Text", Align:"Left", SaveName:"custId", MinWidth:100, FontColor: "#4C84FF", FontUnderline:1, Cursor:"Pointer", BackColor:"#ffffff"},//고객ID
        	{Header:"<spring:message code='word.hd.ngs.cstmr.nm'/>", Type:"Text", Align:"Left", SaveName:"custNm", MinWidth:150, BackColor:"#ffffff"},//고객명
        	{Header:"<spring:message code='word.hd.platform'/>", Type:"Text", Align:"Left", SaveName:"pltfomNm", MinWidth:110, iconCode: "pltfomCd", iconGroupCode:"PLTFOM_CD", BackColor:"#ffffff"},//platform
        	{Header:"<spring:message code='word.hd.smpl.kingdom'/>", Type:"Text", Align:"Left", SaveName:"smplKgdmNm", MinWidth:100, BackColor:"#ffffff"},//kingdom
        	{Header:"<spring:message code='word.hd.smpl.source'/>", Type:"Text", Align:"Left", SaveName:"smplSrcNm", MinWidth:100, BackColor:"#ffffff"},//source
        	{Header:"<spring:message code='word.hd.lib.type'/>", Type:"Text", Align:"Left", SaveName:"libTypeNm", MinWidth:150, BackColor:"#ffffff"},//Library type
        	{Header:"<spring:message code='word.hd.lib.kit'/>", Type:"Text", Align:"Left", SaveName:"libKitNm", MinWidth:200, BackColor:"#ffffff"},//Library Kit
        	{Header:"<spring:message code='word.hd.application.type'/>", Type:"Text", Align:"Left", SaveName:"applionTypeNm", MinWidth:250, BackColor:"#ffffff"},//Application type
        	{Header:"<spring:message code='word.hd.smpl.ct'/>", Type:"Int", Align:"Right", SaveName:"smplCt", MinWidth:60, BackColor:"#ffffff"},//샘플수
        	{Header:"<spring:message code='word.hd.prsa.user'/>", Type:"Text", Align:"Left", SaveName:"prsaUserNm", MinWidth:100, BackColor:"#ffffff"},//Pre-sales
        	{Header:"<spring:message code='word.hd.rgsn.user.id'/>", Type:"Text", Align:"Left", SaveName:"rgsnUserNm", MinWidth:100, BackColor:"#ffffff"},//등록자
        	{Header:"<spring:message code='word.hd.com.rgsn.dttm'/>", Type:"Date", Align:"Left", SaveName:"rgsnDttm", MinWidth:130, Format:"YmdHm", BackColor:"#ffffff"},//등록일시
        	{Header:"<spring:message code='word.ord.slop.cd'/>", Type:"Text", Align:"Left", SaveName:"ordSlopNm", MinWidth:100, BackColor:"#ffffff"},//주문 영업 코드
        	{Header:"pltfomCd", Type:"Text", SaveName:"pltfomCd", Hidden:"1", BackColor:"#ffffff"}, //Platform
        	{Header:"cmpnyCd", Type:"Text", SaveName:"cmpnyCd", Hidden:"1", BackColor:"#ffffff"} //법인코드
		]
	});
	ordRqstSheet.SetEditable(0);

    fnSetEvent();
	fnRetrieveList();
	btnLength();

	//리사이징
	gridResize();

	//Execl 다운로드 onclick 값 변경
	$('.icon-export-white.bt_excel.btn_one').attr("onclick", "btnExcel();");
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

	//등록
	$('#btnRegist').click(function() {
		if(${isPreSales}){
			fnRegist();
		}
		else{
			alert("권한이 없습니다.");
			return;
		}
    });

}

//공통코드 목록 조회
function fnRetrieveComCmmnList(objCd) {
	if (objCd === "SRC_CD") {
		//kingdom에 해당하는 source 리스트 조회
	    var searchKgdmCd = $('#searchKgdmCd').val();
		if (searchKgdmCd !== "") {
		    var srcCodes = new CommonSheetComboOthers("/ngs/order/retrieveComCmmnCombo.do")
		    .addParam({"atrb1":searchKgdmCd, "cmmnClCd":objCd})
		    .addCombo({"resultCombo": {"codeColumn": "cmmnCd", "textColumn": "cmmnCdNm", "required": true}})
		    .execute();

		    $("#searchSrcCd").addCommonSelectOptions({
		        "comboData":srcCodes["resultCombo"],
		        "required": false
		    });
		} else {
			$("#searchSrcCd").addCommonSelectOptions({
		        "comboData": {ComboCode:"", ComboText:"", ComboUseYn:""},
		        "required": false
		    });
		}
	}
}

//library kit 목록 조회
function fnRetrieveLibKitList() {
	//library type에 해당하는 library kit 리스트 조회
    var searchLibTypeCd = $('#searchLibTypeCd').val();
	if (searchLibTypeCd !== "") {
	    var libKitCodes = new CommonSheetComboOthers("/ngs/order/retrieveLibKitCombo.do")
	    .addParam({"atrb1":searchLibTypeCd, "cmmnClCd":"LIB_KIT_CD"})
	    .addCombo({"resultCombo": {"codeColumn": "cmmnCd", "textColumn": "cmmnCdNm", "required": true}})
	    .execute();

	    $("#searchLibKitCd").addCommonSelectOptions({
	        "comboData":libKitCodes["resultCombo"],
	        "required": false
	    });
	} else {
		$("#searchLibKitCd").addCommonSelectOptions({
	        "comboData": {ComboCode:"", ComboText:"", ComboUseYn:""},
	        "required": false
	    });
	}
}

//validation
function fnValidation() {

	return true;
}

//조회
function fnRetrieveList() {
	if (fnValidation()) {
		new CommonAjax("/ngs/order/retrieveOrdRqstList.do")
		.addParam(ordRqstForm)
		.callback(function (resultData) {
			ordRqstSheet.LoadSearchData({"data": resultData.result});
		})
		.execute();
	}
}

//등록
function fnRegist() {
	//주문의뢰서등록
	fnMove("/ngs/order/retrieveNgsOrdRqstRegistForm.do", "");
}

//엑셀 다운로드 버튼
function btnExcel(){
	if(${isPreSales}){
		fnCommonExcelDown(ordRqstSheet,{});
	}else{
		alert("권한이 없습니다.");
		return;
	}
}

//OnClick
function ordRqstSheet_OnClick(row, col, value, cellX, cellY, cellW, cellH, rowtype) {
	if (rowtype == "DataRow") {
		var saveName = ordRqstSheet.ColSaveName(col);
    	if (saveName === "rqstNo") {
   			//주문의뢰서등록(수정) 화면으로 이동
   			var cmpnyCd = ordRqstSheet.GetCellValue(row, "cmpnyCd");
   			var rqstNo = ordRqstSheet.GetCellValue(row, "rqstNo");
   			$('#frmMenu').append('<input type="hidden" name="cmpnyCd" value="'+cmpnyCd+'">').append('<input type="hidden" name="rqstNo" value="'+rqstNo+'">');
   			fnMove("/ngs/order/retrieveNgsOrdRqstRegistForm.do", "");
    	} else if (saveName === "ordNo") {
   			var ordNo = ordRqstSheet.GetCellValue(row, "ordNo");
   			if ("" !== ordNo) {
				//주문조회상세 화면으로 이동
				$('#frmMenu').find("input[name=ordNo]").remove();
				$('#frmMenu').append('<input type="hidden" name="ordNo" value="'+ordNo+'">');
				fnMove("/ngs/order/retrieveOrdSearchDetailForm.do", "", "Y");
   			}
    	} else if (saveName === "custId") {
   			//고객ID 클릭시 고객정보 팝업
			var custId = ordRqstSheet.GetCellValue(row, "custId");
   			retrieveUserInfoPopup(custId);
    	}

	}
}

//엑셀 버튼 혼자 있을 경우
function btnLength(){
	var btnChk = $(".grid_btn .rightBox").children().length;
	var btnAttr = $(".grid_btn .rightBox").children().hasClass("btn_excel");
	if(btnChk == 1 && btnChk == true){
		$(".grid_btn .rightBox").children().addClass("btn_one");
	};
}

//그리드 resize(문지환D)
function gridResize(){
	$(window).resize(function(){
		var popWinSize = $(window).height();
		var hH = $("header").height();
		var hH2 = $("h2").height();
		var sH = $(".search_box2").height();
		var allH = hH + hH2 + sH + 115;
		$("#ordRqst-sheet").height(popWinSize - allH);
	});
	var popWinSize = $(window).height();
	var hH = $("header").height();
	var hH2 = $("h2").height();
	var sH = $(".search_box2").height();
	var allH = hH + hH2 + sH + 115;
	$("#ordRqst-sheet").height(popWinSize - allH);
}

</script>

<div class="content rqstList rightNone">
	<form class="form-inline form-control-static" action="" id="ordRqstForm" name="ordRqstForm" onsubmit="return false">
		<input type="hidden" id="selectCmpnyCd" name="selectCmpnyCd" /><!-- 선택한 법인구분 -->
		<input type="hidden" id="selectRqstNo" name="selectRqstNo" /><!-- 선택한 의뢰서번호 -->

		<!-- 타이틀/위치정보 -->
		<div class="title-info">
			<h2>${activeMenu.menuNm}</h2>
		</div>
		<!-- 검색영역 -->
		<div class="search_box2">
			<div class="leftBox">
				<table>
					<tbody>
						<tr>
							<th><spring:message code='word.com.rgsn.dttm'/></th><!-- 등록일시 -->
							<td class="date_search">
								<input type="text" class="date_type1" id="searchRgsnFrom" name="searchRgsnFrom"/><button type="button" class="btn_calendar" id="btnRgsnFrom"></button><span class="dateCk">~</span>
								<input type="text" class="date_type1" id="searchRgsnTo" name="searchRgsnTo"/><button type="button" class="btn_calendar" id="btnRgsnTo"></button>
							</td>
							<th><spring:message code='word.smpl.info'/></th><!-- 샘플정보 -->
							<td>
								<select id="searchKgdmCd" name="searchKgdmCd" onchange="fnRetrieveComCmmnList('SRC_CD')" class="mr5">
								</select>
								<select id="searchSrcCd" name="searchSrcCd">
								</select>
							</td>
							<th><spring:message code='word.lib.info'/></th><!-- Library 정보 -->
							<td>
								<select id="searchLibTypeCd" name="searchLibTypeCd" onchange="fnRetrieveLibKitList();" style="width:170px;" class="mr5">
								</select>
								<select id="searchLibKitCd" name="searchLibKitCd" style="width:260px;">
								</select>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			<div class="rightBox"><button type="button" class="btn_search" id="btnSearch"><spring:message code='word.inquiry'/></button><!-- 조회 --></div>
		</div>
		<div class="search_box2">
			<div class="leftBox">
				<table>
					<tbody>
						<tr>
							<th><spring:message code='word.platform'/></th><!-- PlatForm -->
							<td>
								<select id="searchPltfomCd" name="searchPltfomCd" style="width:135px;">
								</select>
							</td>
							<th><spring:message code='word.com.cmpny.se'/></th><!-- 법인구분 -->
							<td>
								<select id="searchCmpnyCd" name="searchCmpnyCd" style="width:165px;">
								</select>
							</td>
							<th><spring:message code='word.application.type'/></th><!-- Application -->
							<td>
								<select id="searchApplionTypeCd" name="searchApplionTypeCd" style="width:290px;">
								</select>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
		<div class="search_box2">
			<div class="search-box">
				<select id="searchBaseCd" name="searchBaseCd" class="dropdown dropdown-rg">
					<option value=""><spring:message code='word.sch.cond1'/></option><!-- 기본검색1 -->
					<option value="01"><spring:message code='word.rqstdoc.no'/></option><!-- 의뢰서번호 -->
					<option value="02"><spring:message code='word.ord.no'/></option><!-- 주문번호 -->
					<option value="03"><spring:message code='word.ngs.cstmr.id'/></option><!-- 고객ID -->
					<option value="04"><spring:message code='word.ngs.cstmr.nm'/></option><!-- 고객명 -->
					<option value="05"><spring:message code='word.presales.id'/></option><!-- PreSales ID -->
					<option value="06"><spring:message code='word.presales.nm'/></option><!-- PreSales 명 -->
				</select>
				<input type="text" id="searchBase" name="searchBase" class="input input-text input-text-search" />

				<select id="searchBaseCd2" name="searchBaseCd2" class="dropdown dropdown-rg ml-10">
					<option value=""><spring:message code='word.sch.cond2'/></option><!-- 기본검색2 -->
					<option value="01"><spring:message code='word.rqstdoc.no'/></option><!-- 의뢰서번호 -->
					<option value="02"><spring:message code='word.ord.no'/></option><!-- 주문번호 -->
					<option value="03"><spring:message code='word.ngs.cstmr.id'/></option><!-- 고객ID -->
					<option value="04"><spring:message code='word.ngs.cstmr.nm'/></option><!-- 고객명 -->
					<option value="05"><spring:message code='word.presales.id'/></option><!-- PreSales ID -->
					<option value="06"><spring:message code='word.presales.nm'/></option><!-- PreSales 명 -->
				</select>
				<input type="text" id="searchBase2" name="searchBase2" class="input input-text input-text-search" />
			</div>
		</div>
		<!-- //검색영역 -->

		<div class="sh_box">
			<!-- 그리드 레이아웃 추가 -->
			<div class="grid_wrap gridType3">
						<%-- <h3><spring:message code='word.rqstdoc.list'/></h3><!-- 의뢰서 목록 --> --%>
						<!-- 버튼영역 -->
						<div class="grid_btn">
							<%-- <div class="leftBox">
								<button type="button" class="btn_normal2" id="btnRegist"><spring:message code='word.com.regi'/></button><!-- 등록 -->
							</div>
							<div class="rightBox">
								<!-- <span class="btnSpc">|</span> -->
							</div> --%>
							<div class="btn-group flex-j-end">
								<button type="button" class="btn btn-sub size-auto bg-blueL" id="btnRegist"><spring:message code='word.com.regi'/></button><!-- 등록 -->
								<div class="vertical-bar-sm"></div>
								<div class="rightBox flex-j-end"></div>
							</div>
						</div>
						<!-- // 버튼영역 -->
						<div id='ordRqst-sheet'></div>
			</div>
			<!-- // 그리드 레이아웃 추가 -->
		</div>
	</form>
</div>
