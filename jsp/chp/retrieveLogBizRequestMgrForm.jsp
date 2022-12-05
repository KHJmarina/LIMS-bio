<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<sec:authentication var="userDetails" property="principal.egovUserVO" />

<script>
function fnOnload() {
	$('#searchBeginDate').IBMaskEdit('yyyy-MM-dd', {
		defaultValue: moment().add("-3","month").format('YYYY-MM-DD')
	});
	$('#searchEndDate').IBMaskEdit('yyyy-MM-dd', {
		defaultValue: moment().format('YYYY-MM-DD')
	});

	var objCmmnCmbCodes = new CommonSheetComboCodes()
    .addGroupCode({"groupCode": "SRVC_DOMN_CD", "required": true, "includedNotUse" : false}) /*서비스 도메인*/
	.addGroupCode({"groupCode": "USE_YN", "includedNotUse" : false}) /*긴급여부*/
    .addGroupCode({"groupCode": "CHP_APPLION_TYPE_CD", "required": true, "includedNotUse" : false, "includedAtrb" : true, "atrb9" : "Y"}) /*Application 타입*/
    .addGroupCode({"groupCode": "LOG_PRGR_STAT_CD", "required": true, "includedNotUse" : false}) /*진행상태*/
	.execute();

	/*조회필드 setting*/
	/*서비스 도메인*/
	$("#searchSrvcDomnCd").addCommonSelectOptions({
		  "comboData": objCmmnCmbCodes["SRVC_DOMN_CD"],
		  "required": false
	});

	/*긴급여부*/
	$("#searchUrgentYn").addCommonSelectOptions({
		  "comboData": objCmmnCmbCodes["USE_YN"],
		  "required": false
	});

	/*Application 타입*/
	$("#searchApplionTypeCd").addCommonSelectOptions({
		  "comboData": objCmmnCmbCodes["CHP_APPLION_TYPE_CD"],
		  "required": false
	});


	//set checkbox
	/*진행상태*/
    $("#logForm #ulPrgrStatCd").addCommonCheckboxs({
        "checkName": "searchLogPrgrStatCd", /* [필수]Name 속성 값 */
		"defaultValue": objCmmnCmbCodes["LOG_PRGR_STAT_CD"].ComboCode,
        "checkData": objCmmnCmbCodes["LOG_PRGR_STAT_CD"] /* [필수]데이터 */
    });

	$("#searchLogPrgrStatCd_50").prop("checked", false);

	fnSetEvent();
    createIBSheet2(document.getElementById('divLogBizReq'), "ibsLogBiz", "100%", "635px");
    IBS_InitSheet(ibsLogBiz,
    	{    	"Cfg" : {
            "MergeSheet": msHeaderOnly+msPrevColumnMerge,PrevColumnMergeMode:0
        },

        "HeaderMode" : {"Sort": 1},
	        "Cols": [
	        	{Header:"<spring:message code='word.hd.no'/>",						Type:"Text",   		Align:"Center", 	SaveName:"logGropNo1",     		MinWidth:100, 	ColMerge:"1",	Edit:"0",	Hidden:"1"},//로그 id
	        	{Header:"",															Type:"CheckBox",	Align:"Center",		SaveName:"ibCheck",				MinWidth:20,	ColMerge:"1"},
	        	{Header:"<spring:message code='word.hd.no'/>",						Type:"Text",   		Align:"Left", 		SaveName:"logGropNo",     		MinWidth:100, 	ColMerge:"1",	Edit:"0",	FontColor:"#4C84FF",	FontUnderline:1,	Cursor:"Pointer"},//로그 id
	        	{Header:"<spring:message code='word.hd.req.cntn'/>",				Type:"Text",   		Align:"Left",   	SaveName:"cntn",      			MinWidth:300, 	ColMerge:"1",	Edit:"0"},//요청 내용
	        	{Header:"<spring:message code='word.hd.urgent.yn'/>",				Type:"Text",   		Align:"Left", 		SaveName:"urgnYn",      		MinWidth:100, 	ColMerge:"1",	Edit:"0"},//긴급 여부
	        	{Header:"<spring:message code='word.hd.req.dept'/>",				Type:"Text",   		Align:"Left",   	SaveName:"reqstDeptNm",     	MinWidth:100, 	ColMerge:"1",	Edit:"0"},//요청 부서
	        	{Header:"<spring:message code='word.hd.req.emp'/>",					Type:"Text",   		Align:"Left",		SaveName:"rgsnUserNm",     		MinWidth:100, 	ColMerge:"1",	Edit:"0"},//요청 담당자
	        	{Header:"<spring:message code='word.hd.req.date'/>",				Type:"Text",   		Align:"Left", 		SaveName:"rgsnDttm",     		MinWidth:120, 	ColMerge:"1",	Edit:"0",	Format:"YmdHm"},//요청일시
	        	{Header:"<spring:message code='word.hd.prog.dept'/>",				Type:"Text",   		Align:"Left",   	SaveName:"deptName",     		MinWidth:150, 	ColMerge:"1",	Edit:"0"},//처리부서
	        	{Header:"<spring:message code='word.hd.target.id'/>",				Type:"Text",   		Align:"Left", 		SaveName:"logProcessTrgtId",    MinWidth:100, 	ColMerge:"1",	Edit:"0",	FontColor: "#4C84FF",	FontUnderline:1,	Cursor:"Pointer"},//주문번호
	        	{Header:"<spring:message code='word.chp.hd.application.type'/>",	Type:"Text",   		Align:"Left",   	SaveName:"applionTypeNm",   	MinWidth:130, 	ColMerge:"1",	Edit:"0"},//Application
	        	{Header:"<spring:message code='word.chp.hd.platform'/>",			Type:"Text",   		Align:"Left",   	SaveName:"pltfomNm",     		MinWidth:130, 	ColMerge:"1",	Edit:"0"},//Platform
	        	{Header:"<spring:message code='word.hd.cmpl.pnttm'/>",				Type:"Text",   		Align:"Left",   	SaveName:"cmplPnttmCd",     	MinWidth:100, 	ColMerge:"1",	Edit:"0"},// Final Process(
				{Header:"<spring:message code='word.hd.ord.prgr.stat'/>",			Type:"Text",   		Align:"Left",   	SaveName:"ordPrgrStatNm",     	MinWidth:100, 	ColMerge:"1",	Edit:"0"},//Order Status
				{Header:"<spring:message code='word.hd.smpl.ct'/>",					Type:"Text",   		Align:"Left",   	SaveName:"smplCnt",     		MinWidth:100, 	ColMerge:"1",	Edit:"0"},// # SPL(샘플 수)
	        	{Header:"<spring:message code='word.hd.progrs.sttus.log'/>",		Type:"Combo",   	Align:"Left", 		SaveName:"logPrgrStatCd",     	MinWidth:100, 	ColMerge:"0",	Edit:"0",	ComboText:objCmmnCmbCodes["LOG_PRGR_STAT_CD"].ComboText, ComboCode:objCmmnCmbCodes["LOG_PRGR_STAT_CD"].ComboCode},//진행상태
	        	{Header:"<spring:message code='word.hd.ngs.cstmr.nm'/>",			Type:"Text",   		Align:"Left",   	SaveName:"custNm",     			MinWidth:100, 	ColMerge:"0",  	Edit:"0"},//고객명
				{Header:"<spring:message code='word.hd.nation'/>",					Type:"Text",   		Align:"Left", 		SaveName:"natcode",     		MinWidth:100, 	ColMerge:"0",	Edit:"0"},//국가
				{Header:"<spring:message code='word.hd.presales.nm'/>",				Type:"Text",   		Align:"Left",   	SaveName:"prsaUserNm",     		MinWidth:100, 	ColMerge:"0",  	Edit:"0"},//PreSales 명
				{Header:"<spring:message code='word.hd.postsales.nm'/>",			Type:"Text",   		Align:"Left",   	SaveName:"posaUserNm",     		MinWidth:100, 	ColMerge:"0",  	Edit:"0"},//PostSales 명
				{Header:"<spring:message code='word.hd.fina.prog.date'/>",			Type:"Text",   		Align:"Left", 		SaveName:"modiDttm",     		MinWidth:100, 	ColMerge:"0",  	Edit:"0",	Format:"YmdHm"}, //최종진행일시
	        	{Header:"<spring:message code='word.ces.stat'/>",					Type:"Status",		Align:"Left", 		SaveName:"ibStatus", 			MinWidth:50,	Hidden:"1"},
	        	{Header:"logId",											Type:"Text",   		Align:"Left", 		SaveName:"logId",   		 	MinWidth:50 ,   Hidden:"1" },  //LOGID
	        	{Header:"rgsnUserId",										Type:"Text",   		Align:"Left", 		SaveName:"rgsnUserId",   		MinWidth:50 ,   Hidden:"1" },  //rgsnUserId
	        ]
	    }
    );


    window["ibsLogBiz_OnClick"] = function(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) {
		if(Row == 0 || Col == 0){
			return false;
		}
		var saveName = ibsLogBiz.ColSaveName(Col);
    	if (saveName == "logGropNo") {
	    	fnLogBizDetail(ibsLogBiz.GetCellValue(Row, "logId"),ibsLogBiz.GetCellValue(Row, "logGropNo"),ibsLogBiz.GetCellValue(Row, "deptId"));
		}
    	if (saveName == "logProcessTrgtId") {
    		var targetType = ibsLogBiz.GetCellValue(Row, "logProcessTrgtId");
    		var ordNo = ibsLogBiz.GetCellValue(Row, "logProcessTrgtId");
    		fnLogBizMenuMove(ordNo, targetType);
		}
	};


	fnDeptCombo();

	//리사이징
	gridResize();


};

/**
 * [개발표준]이벤트를 정의함
 */
function fnSetEvent() {
	// 검색버튼
    $('#btnSearch').click(function() {
    	fnRetrieve();
    });
 	// 저장버튼
    $('#btnRegi').click(function() {
    	fnLogBizReqReqPop();
    });
 	//삭제버튼
    $('#btnDelete').click(function() {
    	fnDeleteList();
    });


	$("#btnStartCal").click(function() {
        IBCalendar.Show($(this).val(), {
            "CallBack": function(date) {
                $("#searchBeginDate").val(date);
            },
            "Format": "Ymd",
            "Target": $("#searchBeginDate")[0],
            "CalButtons": "InputEmpty|Today|Close"
        });
    });

	$("#btnEndCal").click(function() {
        IBCalendar.Show($(this).val(), {
            "CallBack": function(date) {
                $("#searchEndDate").val(date);
            },
            "Format": "Ymd",
            "Target": $("#searchEndDate")[0],
            "CalButtons": "InputEmpty|Today|Close"
        });
    });

	$("#btnComplete").click(function() {
		var loginUserId =  "<c:out value="${userDetails.userId}" />";
		var msgArg1 = "<spring:message code='word.com.complete'/>";
		var msgArg2 = "<spring:message code='word.req.user.nm'/>";

		for(var i=ibsLogBiz.GetDataFirstRow(); i<=ibsLogBiz.GetDataLastRow(); i++){
			if(ibsLogBiz.GetCellValue(i, "ibCheck")){
				if(ibsLogBiz.GetCellValue(i, "logPrgrStatCd") == "50"){
					alert("<spring:message code='word.log.exists.complete'/>");
					return false;
				}

				var rgsnUserId =  ibsLogBiz.GetCellValue(i, "rgsnUserId");

				if (rgsnUserId != loginUserId) {
					alert("<spring:message code='infm.process.imprty.progrs.sttus.cnfirm' arguments='"+msgArg1+","+msgArg2+"'/>");//{0}을(를) 처리 할 수 없습니다. {1}을(를) 확인하시기 바랍니다.
					ibsLogBiz.SelectCell(i, "rgsnUserNm");
					return false;
				}

			}

		}

		new CommonAjax("/chp/log/saveChpLogBizCmComplete.do")
		.addParam(ibsLogBiz)
		.callback(function (resultData) {
			alert(resultData.message);
			if(resultData.result == "S"){
				fnRetrieve();
			}
		})
		.confirm("<spring:message code='cnfm.save'/>")
		.execute();
	});

}

/**
 * 업무메모관리 조회
 */
function fnRetrieve() {
	if( !FormQueryString(logForm, true) ) {
		return;
	}

	if(!$("#searchBeginDate").IBMaskEdit('isComplete')) {
		var msgArg = "<spring:message code='word.regist.start.date'/>"; //등록시작일
        alert("<spring:message code='infm.date.fom.invalid' arguments='"+msgArg+",YYYY-MM-DD'/>");
		$("searchBeginDate").focus();
		return;
	}

	if(!$("#searchEndDate").IBMaskEdit('isComplete')) {
		var msgArg = "<spring:message code='word.regist.end.date'/>"; //플레이팅일자
		alert("<spring:message code='infm.date.fom.invalid' arguments='"+msgArg+",YYYY-MM-DD'/>");
		$("searchEndDate").focus();
		return;
	}

	if(moment($("#searchBeginDate").val()).isAfter($("#searchEndDate").val())) {
		alert("<spring:message code='infm.bgnde.endde.imprty'/>");  //시작일은 종료일보다 클 수 없습니다.
		$("searchBeginDate").focus();
		return;
	}
	var str  = "";
	$("input[name=searchLogPrgrStatCd]").each(function(){
		if($(this).is(":checked")){
			str += $(this).val()+",";
		}

	});

	$("#searchLogPrgrStatCds").val(str);

    new CommonAjax("/chp/log/retrieveLogBizRequestMgr.do")
	    .addParam(logForm)
	    .callback(function (resultData) {
	    	ibsLogBiz.LoadSearchData({"data": resultData.result});
	    })
   		.execute();

}

/* 업무요청 등록*/
function fnLogBizReqReqPop() {
	$("#logForm").attr("target","_self")
	.attr("method","POST")
	.attr("action","/chp/log/retrieveLogBizRequestRegForm.do")
	.submit();

	// 업무요청등록 팝업
	/* $('#isPopup').val('Y');
	var frm = document.logForm;
	ordPop = window.open("", "ordPop","toolbar=no,directories=no,scrollbars=yes,resizable=yes,status=no,menubar=no,width=1400,height=700");
	frm.target = "ordPop";
	frm.action = "/chp/log/retrieveLogBizRequestRegPopup.do";
	frm.method = "post";
	frm.submit(); */
}

function fnLogBizDetail(id,gropId,deptId){
	$('#frmMenu .hidden').remove();
	$('#frmMenu').append('<input type="hidden" name="logGropNo" class="hidden" value="'+gropId+'">');
	$('#frmMenu').append('<input type="hidden" name="deptId" class="hidden" value="'+deptId+'">');
	$('#frmMenu').append('<input type="hidden" name="logId" class="hidden" value="'+id+'">');

	fnMove("/chp/log/retrieveLogBizRequestDetailForm.do", "", "Y");
}

function fnLogBizMenuMove(targetId, targetType){
	$('#frmMenu').find("input[name=ordNo]").remove();
	$('#frmMenu').append('<input type="hidden" name="ordNo" value="'+targetId+'">');
	fnMove("/chp/order/retrieveChpOrdSearchDetailForm.do", "", "Y");		//주문 상세정보 페이지 이동
}

/*삭제*/
function fnDeleteList(){
	var loginUserId =  "<c:out value="${userDetails.userId}" />";
	var msgArg1 = "<spring:message code='word.delete'/>";
	var msgArg2 = "<spring:message code='word.req.user.nm'/>";

	for(var i=ibsLogBiz.GetDataFirstRow(); i<=ibsLogBiz.GetDataLastRow(); i++){
		if(ibsLogBiz.GetCellValue(i, "ibCheck")){
			if(ibsLogBiz.GetCellValue(i, "logPrgrStatCd") != "00"){
				alert("<spring:message code='word.reqst.input'/>");
				ibsLogBiz.SelectCell(i, "logPrgrStatNm");
				return false;
			}

			var rgsnUserId =  ibsLogBiz.GetCellValue(i, "rgsnUserId");

			if (rgsnUserId != loginUserId) {
				alert("<spring:message code='infm.process.imprty.progrs.sttus.cnfirm' arguments='"+msgArg1+","+msgArg2+"'/>");//{0}을(를) 처리 할 수 없습니다. {1}을(를) 확인하시기 바랍니다.
				ibsLogBiz.SelectCell(i, "rgsnUserNm");
				return false;
			}

		}

	}

	new CommonAjax("/chp/log/updateChpLogBiz.do")
	.addParam(ibsLogBiz)
	.callback(function (resultData) {
		alert(resultData.message);
		if(resultData.result == "S"){
			fnRetrieve();
		}
	})
	.confirm("<spring:message code='cnfm.delete'/>")
	.execute();
}

function fnDeptCombo() {
	// 호기
    var commonCombo = new CommonSheetComboOthers("/chp/log/retrieveLogBizDeptList.do")
    .addParam({"useYn": "Y"})
    .addCombo({"resultCombo": {"codeColumn": "gwDeptId", "textColumn": "deptName", "required": false}})
    .execute();

    $("#searchDeptId").addCommonSelectOptions({
    	"comboData": commonCombo["resultCombo"],
    	"required": true
    });

    $("#searchReqstDeptId").addCommonSelectOptions({
    	"comboData": commonCombo["resultCombo"],
    	"required": true
    });
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
		var hH2 = $("h2").height();
		var sH = $(".search_box2").height();
		var sH2 = $(".main_search").height();
		var allH = hH + hH2 + sH + sH2 + 130;
		$("#divLogBizReq").height(popWinSize - allH);
	});
	var popWinSize = $(window).height();
	var hH = $("header").height();
	var hH2 = $("h2").height();
	var sH = $(".search_box2").height();
	var sH2 = $(".main_search").height();
	var allH = hH + hH2 + sH + sH2 + 130;
	$("#divLogBizReq").height(popWinSize - allH);
}
</script>
<div class="content bizRgsnMngt">
	<!-- 타이틀/위치정보 -->
	<div class="title-info">
		<h2>${activeMenu.menuNm}</h2>
	</div>

	<form class="form-inline form-control-static" action="" id="logForm" name="logForm">

	<input type="hidden" id="ordNo" name="ordNo" value="" />
	<input type="hidden" id="logGropNo" name="logGropNo" value="" />
	<input type="hidden" id="deptId" name="deptId" value="" />
	<input type="hidden" id="logId" name="logId" value="" />
	<input type="hidden" id="searchLogPrgrStatCds" name="searchLogPrgrStatCds" value="" />
	<input type="hidden" id="isPopup" name="isPopup" value="N" />

		<!-- 검색영역 -->
		<div class="search_box2">
			<div class="leftBox">
				<table>
					<tbody>
						<tr>
							<th><spring:message code='word.period.set'/><%-- 기간설정 --%></th>
							<td class="date_search">
								<input type="text" name="searchBeginDate" id="searchBeginDate" class="date_type1" style="width: 80px; text-align:center;" required="<spring:message code='word.regist.start.date'/>"/><button type="button" class="btn_calendar" id="btnStartCal"></button> ~
								<input type="text" name="searchEndDate" id="searchEndDate" class="date_type1" style="width: 80px; text-align:center;" required="<spring:message code='word.regist.end.date'/>"/><button type="button" class="btn_calendar" id="btnEndCal"></button>
							</td>

							<th><spring:message code='word.srvc.domn'/><%-- 서비스도메인 --%></th>
							<td>
								<select name="searchSrvcDomnCd" id="searchSrvcDomnCd"></select>
							</td>

							<th><spring:message code='word.urgent.yn'/><%-- 긴급여부  --%></th>
							<td>
								<select name="searchUrgentYn" id="searchUrgentYn" style="width:90px;"></select>
							</td>

							<th><spring:message code='word.appl.type'/><%-- application type  --%></th>
							<td>
								<select name="searchApplionTypeCd" id="searchApplionTypeCd" style="width:260px;"></select>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			<div class="rightBox"><button type="button" class="btn_search" id="btnSearch"><spring:message code='word.inquiry'/><%--조회 --%></button></div>
		</div>
		<div class="search_box2">
			<div class="leftBox">
				<table>
					<tbody>
						<tr>
							<th><spring:message code='word.ces.req.dept'/><%-- 요청부서  --%></th>
							<td>
								<select name="searchReqstDeptId" id="searchReqstDeptId" style="width: 300px; margin-right:0px;"></select>
							</td>

							<th><spring:message code='word.ces.proc.dept'/><%-- 처리부서 --%></th>
							<td colspan="3">
								<select name="searchDeptId" id="searchDeptId" style="width: 300px; margin-right:0px;"></select>
							</td>

							<th><spring:message code='word.ces.log.stat'/><%-- 진행상태 --%></th>
							<td colspan="3">
								<ul id="ulPrgrStatCd" class="checkStyleCh"></ul>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
		<div class="search_box2">
			<div class="search-box">
				<select name="searchBasiSrchCd1" id="searchBasiSrchCd1" class="dropdown dropdown-rg">
					<option value=""><spring:message code='word.sch.cond'/>1</option><!-- 검색조건 -->
					<option value="01"><spring:message code='word.ces.ord.no'/></option><!-- 주문번호 -->
					<option value="02"><spring:message code='word.ces.cstmr.nm'/></option><!-- 고객명 -->
					<option value="03"><spring:message code='word.req'/></option><!-- 요청내용 -->
					<option value="04"><spring:message code='word.req.user.nm'/></option><!-- 요청사용자명 -->
					<option value="05"><spring:message code='word.req.user.id'/></option><!-- 요청사용자ID -->
					<option value="06"><spring:message code='word.prog.dept'/></option><!-- 처리부서 -->
					<option value="07"><spring:message code='word.prog.user.id'/></option><!-- 처리사용자ID -->
				</select>
				<input type="text" name=searchKeyword1 id="searchKeyword1" maxlength="30" class="w246 bor2 iconKeyboard"/>
				<select name="searchBasiSrchCd2" id="searchBasiSrchCd2" class="dropdown dropdown-rg ml-10">
					<option value=""><spring:message code='word.sch.cond'/>2</option><!-- 검색조건 -->
					<option value="01"><spring:message code='word.ces.ord.no'/></option><!-- 주문번호 -->
					<option value="02"><spring:message code='word.ces.cstmr.nm'/></option><!-- 고객명 -->
					<option value="03"><spring:message code='word.req'/></option><!-- 요청내용 -->
					<option value="04"><spring:message code='word.req.user.nm'/></option><!-- 요청사용자명 -->
					<option value="05"><spring:message code='word.req.user.id'/></option><!-- 요청사용자ID -->
					<option value="06"><spring:message code='word.prog.dept'/></option><!-- 처리부서 -->
					<option value="07"><spring:message code='word.prog.user.id'/></option><!-- 처리사용자ID -->
				</select>
				<input type="text" name=searchKeyword2 id="searchKeyword2" maxlength="30" class="w246 bor2 iconKeyboard"/>
			</div>
		</div>
	</form>
	<div class="sh_box">
		<!-- 그리드 레이아웃 추가 -->
		<div class="grid_wrap gridType2">
			<section>
				<h3></h3>
				<div class="titType1">
					<div class="grid_btn">
						<div class="btn-group flex-j-end">
							<div class="flex-j-end">
								<button type="button" class="btn btn-sub size-auto bg-blueL" id="btnRegi"><spring:message code='word.com.regi'/></button><!-- 등록 -->
							</div>
							<div class="vertical-bar-sm"></div>
							<div class="flex-j-end">
								<button type="button" class="icon-delete-white btn btn-sub bg-active btn-text-icon bt_gray" id="btnDelete"><spring:message code='word.delete'/></button><!-- 삭제 -->
								<button type="button" class="btn btn-sub size-auto bg-active btn-text-icon bt_gray" id="btnComplete"><spring:message code='word.com.complete'/></button>
							</div>
						</div>
<%--						<div class="rightBox">
 							<button type="button" class="btn_normal btn_frst" id="btnRegi"><spring:message code='word.com.regi'/></button>
 							<button type="button" class="btn_normal btn_cent" id="btnDelete"><spring:message code='word.delete'/></button>
 							<button type="button" class="btn_normal btn_last3" id="btnComplete"><spring:message code='word.com.complete'/></button>
						</div> --%>
					</div>
				</div>
				<div id='divLogBizReq'></div>
			</section>
		</div>
	</div>

		<div class="sh_box">
		<!-- 그리드 레이아웃 추가 -->
		<div class="grid_wrap gridType2" id= "divLogTemp">

		</div>
	</div>
</div>

<!-- 공지사항팝업 -->
<!-- <div class="notiPop" id="popNoti">
	<div class="notiHeader">
		<p>Notice</p>
		<a href="javascript:void(0);">X</a>
	</div>
	<div class="notiCont">
		<strong>※ 안내</strong> <br>
		- 외부접속 오류 해결방법 <br>
		외부접속 오류시 브라우저에 저장된 <strong class="red">캐시 삭제(계정,비밀번호)</strong> <br>
		잘못된 비밀번호 저장으로 인하여, 해당 값을 가져오고 있는 문제로 위와 같은 방법을 통해 해결 가능합니다.<br>
		위와 같은 방법으로 처리 후 해결이 안되실 때는 정보관리부에 문의<br>
		해주세요.(information@macrogen.com)<br><br>
		감사합니다. <br>
		---------------------------------------------------------------------------------------------------------<br>
		※ Solution for external network access to LIMS 3.0<br>
		Delete all the cache on your web browser. <br> Wrong account ID/PW saved in cache can cause a problem.<br>
		If the access is still blocked after that, please contact us at  <span style="text-decoration:underline;">information@macrogen.com</span>
		<br><br>
		Thank you

	</div>
	<div class="notiFoot">
		 <form method="post" action="" name="pop_form">
            <span id="check"><input type="checkbox" value="checkbox" name="chkbox" id="chkday"/><label for="chkday">오늘 하루동안 보지 않기</label></span>
            <a href="javascript:void(0);" id="close">Close</a>
        </form>
	</div>
</div> -->

<!-- 오늘하루안보기 스크립트 -->
<script>
function getCookie(cname) {
    var name = cname + "=";
    var ca = document.cookie.split(';');
    for(var i=0; i<ca.length; i++) {
        var c = ca[i];
        while (c.charAt(0)==' ') c = c.substring(1);
        if (c.indexOf(name) != -1) return c.substring(name.length,c.length);
    }
    return "";
}
function setCookie(cname, cvalue, exdays) {
    var d = new Date();
    d.setTime(d.getTime() + (exdays*24*60*60*1000));
    var expires = "expires="+d.toUTCString();
    document.cookie = cname + "=" + cvalue + "; " + expires;
}

function couponClose(){
    if($("input[name='chkbox']").is(":checked") ==true){
        setCookie("close","Y",1);
    }
    $("#popNoti").hide();
};

$(document).ready(function(){
    cookiedata = document.cookie;
    if(cookiedata.indexOf("close=Y")<0){
        $("#popNoti").show();
    }else{
        $("#popNoti").hide();
    }
    $("#close").click(function(){
        couponClose();
    });
    $(".notiHeader a").click(function(){
		$("#popNoti").hide();
	});
});
</script>