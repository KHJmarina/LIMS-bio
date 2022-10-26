<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<script>
function fnOnload() {
	//공통코드
	var objCmmnCmbCodes = new CommonSheetComboCodes()
	.addGroupCode({"groupCode": "USE_YN", "required": false, "includedNotUse" : false}) //사용여부
    .execute();

	$("#searchUseYn").addCommonSelectOptions({
	    "comboData":objCmmnCmbCodes["USE_YN"],
	    "required": false
	});


	createIBSheet2("group-sheet", "groupSheet", "100%", "350px", "", false, "{AutoSizeColumn:'1', Mode:'1'}");
	IBS_InitSheet(groupSheet, {
		"Cols": [
        	{Header:"상태", Type:"Status", Align:"Center", SaveName:"ibStatus", Hidden:"1", MinWidth:40},
        	{Header:"", Type:"DummyCheck", Align:"Center", SaveName:"ibCheck", MinWidth:20},//선택
        	{Header:"<spring:message code='word.hd.no'/>", Type:"Seq", Align:"Center", SaveName:"no", MinWidth:50, Edit:"0"},//No
        	{Header:"<spring:message code='word.hd.prdlst.group.cd'/>", Type:"Text", Align:"Left", SaveName:"estmtItmGropCd", MinWidth:100, KeyField:"1", EditLen:15, InputCaseSensitive:1},//품목그룹코드
        	{Header:"<spring:message code='word.hd.prdlst.group.nm'/>", Type:"Text", Align:"Left", SaveName:"estmtItmGropCdNm", MinWidth:250, KeyField:"1", EditLen:200},//품목그룹명
        	{Header:"<spring:message code='word.hd.regist.prdlst.ct'/>", Type:"Int", Align:"Right", SaveName:"itemCnt", MinWidth:80, Edit:"0"},//등록품목수
	        {Header:"<spring:message code='word.hd.use.yn'/>", Type:"Combo", Align:"Left", SaveName:"useYn", MinWidth:80, KeyField:"1", "ComboText":objCmmnCmbCodes["USE_YN"].ComboText, "ComboCode":objCmmnCmbCodes["USE_YN"].ComboCode},//사용여부
	        {Header:"<spring:message code='word.hd.modi.user'/>", Type:"Text", Align:"Left", SaveName:"modiUserNm", MinWidth:120, Edit:"0"},//수정사용자
	        {Header:"<spring:message code='word.hd.com.modi.dttm'/>", Type:"Date", Align:"Left", SaveName:"modiDttm", MinWidth:120, Edit:"0", Format:"YmdHm"},//수정일시
			{Header:"cmpnyCd", Type:"Text", SaveName:"cmpnyCd", Hidden:"1"}, //법인코드
			{Header:"srvcDivCd", Type:"Text", SaveName:"srvcDivCd", Hidden:"1"} //서비스구분
		]
	});

    fnSetEvent();
    fnRetrieveList();

  	//리사이징
    gridResize();
};

function fnSetEvent() {
    //엔터키 입력 시 검색함
    $('form input').keypress(function(event) {
        var keycode = (event.keyCode ? event.keyCode : event.which);
        if (keycode == '13') {
        	fnRetrieveList();
        }
    });

	//검색
	$('#btnSearch').click(function() {
    	fnRetrieveList();
    });
	//행추가
	$('#btnAddRow').click(function() {
        var row = groupSheet.DataInsert(groupSheet.GetDataLastRow() + 1);
        groupSheet.SetCellValue(row, "no", row);
        groupSheet.SetCellValue(row, "ibCheck", "Y");
        groupSheet.SetCellValue(row, "cmpnyCd", $("#cmpnyCd").val());
        groupSheet.SetCellValue(row, "srvcDivCd", $("#srvcDivCd").val());
        groupSheet.SetCellValue(row, "useYn", "Y");
        groupSheet.SetCellEditable(row, "useYn", 0);
    });
	//행삭제
	$('#btnDeleteRow').click(function() {
		cfDeleteRow(groupSheet);
	});
	//삭제
	$('#btnDelete').click(function() {
    	fnDelete();
    });
	//저장
	$('#btnSave').click(function() {
    	fnSave();
    });

}

//조회
function fnRetrieveList() {
	new CommonAjax("/ngs/setup/quotation/retrieveQuotationItemGroupList.do")
	.addParam(groupForm)
	.callback(function (resultData) {
		groupSheet.LoadSearchData({"data": resultData.result});
	})
	.execute();
}

//삭제
function fnDelete() {
	new CommonAjax("/ngs/setup/quotation/deleteQuotationItemGroupList.do")
	.addParam(groupSheet)
	.confirm("<spring:message code='cnfm.delete'/>")
	.callback(function (resultData) {
		alert(resultData.message);
		if (resultData.result === "S") {
			fnRetrieveList();

			//부모화면 리로딩
			opener.callBackItemGroupPopup();
		}
	})
	.execute();
}

//저장
function fnSave() {
    var dup = groupSheet.ColValueDup('estmtItmGropCd', {'IncludeDelRow': 0, 'IncludeEmpty': 0});
    if (dup > 0) {
		alert("<spring:message code='infm.samenss.prdlst.group.imprty'/>");//동일한 품목그룹코드는 사용 할 수 없습니다.
        return;
    }

	new CommonAjax("/ngs/setup/quotation/saveQuotationItemGroupList.do")
	.addParam(groupSheet)
	.confirm("<spring:message code='cnfm.save'/>")
	.callback(function (resultData) {
		alert(resultData.message);
		if (resultData.result === "S") {
			fnRetrieveList();

			//부모화면 리로딩
			opener.callBackItemGroupPopup();
		}
	})
	.execute();
}

//OnRowSearchEnd
function groupSheet_OnRowSearchEnd(row) {
	var itemCnt = groupSheet.GetCellValue(row, "itemCnt");
	if (itemCnt > 0) {
		/*해당 견적품목그룹코드에 견적품목코드가 등록되어 있지 않은 경우 견적품목그룹코드, 견적품목그룹명, 사용여부, 견적품목코드가 등록된 경우 사용여부만 변경 가능
		  ===> 등록품목수 존재시 사용여부만 수정 가능*/
		groupSheet.SetCellEditable(row, "estmtItmGropCd", 0);
		groupSheet.SetCellEditable(row, "estmtItmGropCdNm", 0);
	}
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
		var hH = $(".pop_header").height();
		var sH = $(".pop_search").height();
		var allH = hH + sH + 100;
		$("#group-sheet").height(popWinSize - allH);
	});
	var popWinSize = $(window).height();
	var hH = $(".pop_header").height();
	var sH = $(".pop_search").height();
	var allH = hH + sH + 100;
	$("#group-sheet").height(popWinSize - allH);
}

</script>

<div class="pop_wrap">
	<form class="form-inline form-control-static" action="" id="groupForm" name="groupForm" onsubmit="return false">
		<input type="hidden" id="cmpnyCd" name="cmpnyCd" value="<sec:authentication property='principal.egovUserVO.cmpnyCd' />"/>
		<input type="hidden" id="srvcDivCd" name="srvcDivCd" value="NGS"/>

		<div class="pop_cont">
			<div class="pop_search">
				<div class="leftBox">
					<strong><spring:message code='word.prdlst.group'/></strong><!-- 품목그룹코드 -->
					<input type="text" id="searchEstmtItmGropCd" name="searchEstmtItmGropCd" style="text-transform:uppercase;" maxlength="15"/>
					<strong><spring:message code='word.prdlst.group.nm'/></strong><!-- 품목그룹명 -->
					<input type="text" id="searchEstmtItmGropCdNm" name="searchEstmtItmGropCdNm" style="maxlength="200"/>
					<strong><spring:message code='word.use.yn'/></strong><!-- 사용여부 -->
					<select id="searchUseYn" name="searchUseYn">
					</select>
				</div>
				<div class="rightBox">
					<%-- <button type="button" class="btn_search btn_inqPop" id="btnSearch"><spring:message code='word.inquiry'/></button>조회 --%>
					<button type="button" class="btn_search" id="btnSearch"><spring:message code='word.inquiry'/></button><!-- 조회 -->
				</div>
			</div>
			<div class="pop_item_cont">
				<!-- <div class="rightBox"> -->
					<%-- <button type="button" class="btn_normal btn_one" id="btnDelete"><spring:message code='word.delete'/></button>삭제
					<button type="button" class="btn_normal btn_frst" id="btnAddRow"><span class="glyphicon glyphicon-plus"></span></button>행추가
					<button type="button" class="btn_normal btn_cent" id="btnDeleteRow"><span class="glyphicon glyphicon-minus"></span></button>행삭제
					<button type="button" class="btn_normal btn_last" id="btnSave"><span class="glyphicon glyphicon-floppy-disk"></span></button>저장 --%>
					<div class="grid_btn">
						<div class="btn-group flex-j-end">
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
					<!-- </div> -->
				</div>
				<div id='group-sheet'></div>
			</div>
		</div>
	</form>
</div>
