<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<script>
var saveRow = 0;
var objCmmnCmbCodes2;
var cmmnClCd;
var preDupRow = {};
function fnOnload() {
	var objCmmnCmbCodes = new CommonSheetComboCodes()
	.addGroupCode({"groupCode": "USE_YN", "required": false, "includedNotUse" : false})
	.addGroupCode({"groupCode": "WORK_DTL_CD", "required": false, "includedNotUse" : false})
    .execute();
	fnSetEvent();

	createIBSheet2(document.getElementById('divIbsPerformCode'), "ibsPerformCode", "100%", "300px", "", true);
    IBS_InitSheet(ibsPerformCode,
    	{
	        "Cols": [
	        	{Header:"<spring:message code='word.hd.no'/>",				Type:"Seq",		Align:"Center",	SaveName:"seq",			MinWidth:30},//순번
				{Header:"<spring:message code='word.hd.group.code.nm'/>",	Type:"Text",	Align:"Left",	SaveName:"cmmnClCdNm",	MinWidth:80, 	Edit:"0"},//그룹코드명
				{Header:"<spring:message code='word.hd.group.code.id'/>",	Type:"Text",	Align:"Left",	SaveName:"cmmnClCd",	MinWidth:80, 	Edit:"0"},//그룹코드ID
				{Header:"<spring:message code='word.hd.code.cnt'/>",		Type:"Text",	Align:"Left",	SaveName:"lowerCodeCnt",MinWidth:80, 	Hidden:"1"},//소속코드갯수
				{Header:"<spring:message code='word.hd.modi.user'/>",		Type:"Text",	Align:"Left",	SaveName:"modiUserNm",	MinWidth:80, 	Edit:"0"},//수정사용자
				{Header:"<spring:message code='word.hd.modi.dttm'/>",		Type:"Date",	Align:"Center",	SaveName:"modiDttm",	MinWidth:80, 	Edit:"0", 	Format:"Ymd"},//수정일자
				{Header:"<spring:message code='word.hd.rgsn.user.id'/>",	Type:"Text",	Align:"Left",	SaveName:"rgsnUserNm",	MinWidth:80, 	Edit:"0"},//등록사용자
				{Header:"<spring:message code='word.hd.rgsn.dttm'/>",		Type:"Date",	Align:"Center",	SaveName:"rgsnDttm",	MinWidth:80, 	Edit:"0", 	Format:"Ymd"},//등록일자
				{Header:"업무구분코드",	Type:"Text",	Align:"Left",	SaveName:"jobRelmCd",	MinWidth:80, 	Hidden:"1"},
				{Header:"비고1",		Type:"Text",	Align:"Left",	SaveName:"atrb1",		MinWidth:80,	Hidden:"1"},
				{Header:"비고2",		Type:"Text",	Align:"Left",	SaveName:"atrb2",		MinWidth:80,	Hidden:"1"},
				{Header:"비고3",		Type:"Text",	Align:"Left",	SaveName:"atrb3",		MinWidth:80,	Hidden:"1"},
				{Header:"비고4",		Type:"Text",	Align:"Left",	SaveName:"atrb4",		MinWidth:80,	Hidden:"1"},
				{Header:"비고5",		Type:"Text",	Align:"Left",	SaveName:"atrb5",		MinWidth:80,	Hidden:"1"},
				{Header:"회사코드",		Type:"Text",	Align:"Left",	SaveName:"cmpnyCd",		MinWidth:80,	Hidden:"1"}
	        ]
	    }
    );
    ibsPerformCode.FitColWidth();

    createIBSheet2(document.getElementById('divIbsPerformCodeDetail'), "ibsPerformCodeDetail", "100%", "300px", "", false);
    IBS_InitSheet(ibsPerformCodeDetail,
    	{
			"Cfg" : {
	            "MergeSheet": msHeaderOnly
	        },
	        "HeaderMode" : {},
	        "Cols": [
	        	{Header:"<spring:message code='word.hd.no'/>",				Type:"Seq",			Align:"Center",		SaveName:"seq",			MinWidth:30},//순번
	        	{Header:"<spring:message code='word.hd.sttus'/>",			Type:"Status",		Align:"Left",		SaveName:"ibStatus",	MinWidth:50},//상태
	        	{Header:"<spring:message code='word.hd.code'/>",			Type:"Text",		Align:"Left",		SaveName:"cmmnCd2",		MinWidth:50, 	Edit:"0"},//코드명
	        	{Header:"<spring:message code='word.hd.code.nm'/>",		Type:"Combo",		Align:"Left",		SaveName:"cmmnCd",		MinWidth:200, 	KeyField:"1"},//코드명
	        	{Header:"<spring:message code='word.hd.dna.yn'/>",			Type:"Combo",		Align:"Left",		SaveName:"dnaYn",		MinWidth:60, 	ComboText:objCmmnCmbCodes["USE_YN"].ComboText, ComboCode:objCmmnCmbCodes["USE_YN"].ComboCode},//DNA여부
	        	{Header:"<spring:message code='word.hd.rna.yn'/>",			Type:"Combo",		Align:"Left",		SaveName:"rnaYn",		MinWidth:60, 	ComboText:objCmmnCmbCodes["USE_YN"].ComboText, ComboCode:objCmmnCmbCodes["USE_YN"].ComboCode},//RNA여부
	        	{Header:"<spring:message code='word.hd.tissue.yn'/>",		Type:"Combo",		Align:"Left",		SaveName:"tisueYn",		MinWidth:60, 	ComboText:objCmmnCmbCodes["USE_YN"].ComboText, ComboCode:objCmmnCmbCodes["USE_YN"].ComboCode},//Tissue 여부
	        	{Header:"<spring:message code='word.hd.library.yn'/>",		Type:"Combo",		Align:"Left",		SaveName:"libYn",		MinWidth:60, 	ComboText:objCmmnCmbCodes["USE_YN"].ComboText, ComboCode:objCmmnCmbCodes["USE_YN"].ComboCode},//Library 여부
	        	{Header:"<spring:message code='word.hd.first.pcr.yn'/>",	Type:"Combo",		Align:"Left",		SaveName:"fistPcrYn",	MinWidth:60, 	ComboText:objCmmnCmbCodes["USE_YN"].ComboText, ComboCode:objCmmnCmbCodes["USE_YN"].ComboCode},//First PCR 여부
	        	{Header:"<spring:message code='word.hd.expo.sqnc'/>",		Type:"Int",			Align:"Right",		SaveName:"expoSqnc",	MinWidth:60, 	MaximumValue : 99},//노출순서
	        	{Header:"<spring:message code='work.work.detail'/>",	Type:"Combo",		Align:"Left",		SaveName:"workDtlCd",	MinWidth:80, 	ComboText:objCmmnCmbCodes["WORK_DTL_CD"].ComboText, ComboCode:objCmmnCmbCodes["WORK_DTL_CD"].ComboCode},//작업 내역
	        	{Header:"<spring:message code='word.hd.aply.begin.dt'/>",	Type:"Date",		Align:"Left",		SaveName:"aplyBeginDt",	MinWidth:80, 	Format:"Ymd", 	KeyField:"1"},//적용시작일자
				{Header:"<spring:message code='word.hd.aply.end.dt'/>",	Type:"Date",		Align:"Left",		SaveName:"aplyEndDt",	MinWidth:80, 	Format:"Ymd", 	KeyField:"1"},//적용종료일자
				{Header:"<spring:message code='word.hd.modi.user'/>",		Type:"Text",		Align:"Left",		SaveName:"modiUserNm",	MinWidth:80, 	Edit:"0"},//수정사용자
				{Header:"<spring:message code='word.hd.modi.dttm'/>",		Type:"Date",		Align:"Left",		SaveName:"modiDttm",	MinWidth:80, 	Edit:"0", 	Format:"Ymd"},//수정일자
				{Header:"<spring:message code='word.hd.rgsn.user.id'/>",	Type:"Text",		Align:"Left",		SaveName:"rgsnUserNm",	MinWidth:80, 	Edit:"0"},//등록사용자
				{Header:"<spring:message code='word.hd.rgsn.dttm'/>",		Type:"Date",		Align:"Left",		SaveName:"rgsnDttm",	MinWidth:80, 	Edit:"0", 	Format:"Ymd"},//등록일자
				{Header:"수행 관리 코드 순번",	Type:"Text",		SaveName:"prfmMngtCdSn",	Hidden:"1"},
				{Header:"회사코드",				Type:"Text",		SaveName:"cmpnyCd",			Hidden:"1"},
				{Header:"선택",					Type:"DummyCheck",	SaveName:"ibCheck",			Hidden: "1"},
				{Header:"editYn",				Type:"Text",		SaveName:"editYn",			Hidden: "1"},
				{Header:"분류코드",				Type:"Text",		SaveName:"cmmnClCd",		Hidden:"1"}
	        ]
	    }
    );

    fnRetrievePerformCodes();

  	//리사이징
    gridResize();

};

/**
 * [개발표준]이벤트를 정의함
 */
function fnSetEvent() {
 	// 수행코드 상세 행추가 버튼
    $("#btnGroupDetailAddRow").click(function() {
    	if(ibsPerformCodeDetail.FindStatusRow("I")){
    		alert("<spring:message code='infm.new.row.one'/>");//신규건은 한건만 등록이 가능합니다.
    		return false;
    	}

    	if( ibsPerformCode.GetSelectRow() === -1 ) {
    		return;
    	}

    	if( ibsPerformCode.GetCellValue(ibsPerformCode.GetSelectRow(), "ibStatus") === "I" ) {
    		return;
    	}

        var row = ibsPerformCodeDetail.DataInsert(0);
        ibsPerformCodeDetail.SetCellValue(row, "cmmnClCd",  ibsPerformCode.GetCellValue(ibsPerformCode.GetSelectRow(), "cmmnClCd"));
        ibsPerformCodeDetail.SetCellValue(row, "cmpnyCd",  ibsPerformCode.GetCellValue(ibsPerformCode.GetSelectRow(), "cmpnyCd"));

        ibsPerformCodeDetail.CellComboItem(row, "cmmnCd", {
            "ComboCode": objCmmnCmbCodes2[cmmnClCd].ComboCode,
            "ComboText": objCmmnCmbCodes2[cmmnClCd].ComboText
        });
    });

    // 수행코드 상세 행삭제 버튼
    $("#btnGroupDetailDelRow").click(function() {
    	cfDeleteCurrentRow(ibsPerformCodeDetail);
    });

    // 수행코드 상세 저장 버튼
    $("#btnGroupDetailSave").click(function() {
    	fnSavePerformCodeDetail();
    });

 	// 수행코드 상세 조회 버튼
    $("#btnSearchPerformCodeDetails").click(function() {
    	fnRetrievePerformCodeDetails();
    });

    $('input:radio[name="usedYn"]').change(function() {
    	fnRetrievePerformCodeDetails();
    });

  	//수행코드 선택시, 수행코드상세 목록 조회.
    window["ibsPerformCode_OnSelectCell"] = function(oldRow, oldCol, newRow, newCol, isDelete) {
	    if( newRow == 0 || (oldRow == newRow) ) {
	    	return;
	    }
	    if( ibsPerformCode.GetCellValue(newRow, "ibStatus") === "I" ) {
	    	ibsPerformCodeDetail.RemoveAll();
	    	return;
	    }
	    $("#gridTitle").text(ibsPerformCode.GetCellValue(newRow, "cmmnClCdNm"));
	    fnRetrievePerformCodeDetails();		// 수행코드상세 조회
    };

    window["ibsPerformCode_OnSearchEnd"] = function(Code, Msg, StCode, StMsg) {
    	ibsPerformCode.SetSelectRow(saveRow);
    	saveRow=0;
    };

    window["ibsPerformCodeDetail_OnChange"] = function(row, col, value, oldValue, raiseFlag) {
    	if(ibsPerformCodeDetail.ColSaveName(col) == "aplyBeginDt") {//적용시작일 변경시 이벤트
    		if(value <= moment().format('YYYYMMDD')){
    			alert("<spring:message code='infm.start.dt.check'/>");//시작일자는 내일 날짜 이후로 설정 가능합니다.
    			ibsPerformCodeDetail.SetCellValue(row, "aplyBeginDt", oldValue, false);
    		}
    		var dupRow=0;
    		var dupCnt=0;
    		for(var i=ibsPerformCodeDetail.GetDataFirstRow(); i<=ibsPerformCodeDetail.GetDataLastRow(); ++i){// 중복된 row가 있는지 체크
    			var status = ibsPerformCodeDetail.GetCellValue(i, "ibStatus");

    			if(ibsPerformCodeDetail.GetCellValue(i, "cmmnCd") == ibsPerformCodeDetail.GetCellValue(row, "cmmnCd")){
   					if(status != "I" && i != row){
   						if(dupCnt == 0){
   							dupRow = i;
   						} else {
   							if(parseInt(ibsPerformCodeDetail.GetCellValue(dupRow, "prfmMngtCdSn"), 10) < parseInt(ibsPerformCodeDetail.GetCellValue(i, "prfmMngtCdSn"), 10)){
   	   							dupRow = i;
   	   						}
   						}
   						dupCnt++;
  					}
   				}
    		}
    		if(dupRow != 0){//중복된 row의 적용종료일 값 셋팅
    			ibsPerformCodeDetail.SetCellValue(dupRow, "aplyEndDt", moment(ibsPerformCodeDetail.GetCellValue(row, "aplyBeginDt")).add(-1, "day").format('YYYYMMDD'));
    		}
    	} else if(ibsPerformCodeDetail.ColSaveName(col) == "aplyEndDt") {// 종료일자 변경시 이벤트
    		if(value < ibsPerformCodeDetail.GetCellValue(row, "aplyBeginDt")){
    			alert("<spring:message code='infm.end.dt.check'/>");//종료일자는 시작일자 이후로 설정 가능합니다.
    			ibsPerformCodeDetail.SetCellValue(row, "aplyEndDt", oldValue, false);
    		}
    	} else if(ibsPerformCodeDetail.ColSaveName(col) == "cmmnCd"){// 수행코드값 변경시 이벤트ow, "ibsPerforpRow=0;
    		// Code콤보 변경시 코드 표시
    		ibsPerformCodeDetail.SetCellValue(row, "cmmnCd2", ibsPerformCodeDetail.GetCellValue(row, "cmmnCd"));

    		var dupCnt=0;
    		for(var i=ibsPerformCodeDetail.GetDataFirstRow(); i<=ibsPerformCodeDetail.GetDataLastRow(); ++i){//중복 코드가 있는지 체크
    			var tarVal = ibsPerformCodeDetail.GetCellValue(i, "cmmnCd");
    			var status = ibsPerformCodeDetail.GetCellValue(i, "ibStatus");

   				if(tarVal == value){
   					if(status == "I"){
   						if(i != row ){
   							alert("<spring:message code='infm.dub.code.check'/>");//중복된 코드를 신규로 1건이상 등록할수 없습니다.
   	   						ibsPerformCodeDetail.SetCellValue(row, "cmmnCd", oldValue, false);
   	   						return false;
   						}
   					} else {
   						if(ibsPerformCodeDetail.GetCellValue(i, "aplyBeginDt") > moment().format('YYYYMMDD')){
   							alert("<spring:message code='infm.not.used.code'/>");//아직 사용하지 않은 등록된 코드가 있습니다.
   	   						ibsPerformCodeDetail.SetCellValue(row, "cmmnCd", oldValue, false);
   	   						return false;
   	   					}
   						if(dupCnt == 0){
   							dupRow = i;
   						} else {
   							if(parseInt(ibsPerformCodeDetail.GetCellValue(dupRow, "prfmMngtCdSn"), 10) < parseInt(ibsPerformCodeDetail.GetCellValue(i, "prfmMngtCdSn"), 10)){
   	   							dupRow = i;
   	   						}
   						}
   						dupCnt++;
   					}
   				}
    		}

    		if(preDupRow[row]){
    			ibsPerformCodeDetail.ReturnCellData(preDupRow[row], "aplyEndDt");
    			ibsPerformCodeDetail.SetCellEditable(preDupRow[row], "aplyEndDt", true);
    		}

    		if(dupRow != 0){
    			ibsPerformCodeDetail.SetCellValue(dupRow, "aplyEndDt", moment().format('YYYYMMDD'));
        		ibsPerformCodeDetail.SetCellEditable(dupRow, "aplyEndDt", false);
        		ibsPerformCodeDetail.SetCellValue(row, "aplyBeginDt", moment().add(1, "day").format('YYYYMMDD'));
        		ibsPerformCodeDetail.SetCellValue(row, "aplyEndDt", "99991231");
        		ibsPerformCodeDetail.SetCellEditable(row, "aplyEndDt", false);
        		preDupRow[row] = dupRow;
    		} else {
    			ibsPerformCodeDetail.SetCellValue(row, "aplyEndDt", "", false);
    			ibsPerformCodeDetail.SetCellEditable(row, "aplyEndDt", true);
    		}
    	}
    };

    window["ibsPerformCodeDetail_OnColInitConfirm"] = function() {
		if(ibsPerformCodeDetail.IsDataModified()){
			if(!confirm("변경된 데이터가 있습니다. 계속진행하시겠습니까?")){
				return false;
			}
		}
		return true;
    };

    window["ibsPerformCodeDetail_OnColInit"] = function() {
    	fnRetrievePerformCodeDetails();
    };
}

/**
 * 수행코드 조회
 */
function fnRetrievePerformCodes() {
    new CommonAjax("/ngs/setup/retrievePerformCodes.do")
    .addParam(performCodeForm)
    .callback(function (resultData) {
    	ibsPerformCode.LoadSearchData({"data": resultData.performCodes});
    })
    .execute();
}

/**
 * 수행코드상세 조회
 */
function fnRetrievePerformCodeDetails() {
	var nRow = ibsPerformCode.GetSelectRow();
	cmmnClCd = ibsPerformCode.GetCellValue(nRow, "cmmnClCd");
	var usedYn = $(":input:radio[name=usedYn]:checked").val();

	if(cmmnClCd != "PRE_WORK_TYPE_CD" && cmmnClCd != "SQC_WORK_TYPE_CD" && cmmnClCd != "FRA_WORK_TYPE_CD" && cmmnClCd != "LQC_WORK_TYPE_CD" && cmmnClCd != "ECA_WORK_TYPE_CD"){
		ibsPerformCodeDetail.SetColEditable("workDtlCd", "0");
	} else {
		ibsPerformCodeDetail.SetColEditable("workDtlCd", "1");
	}

	objCmmnCmbCodes2 = new CommonSheetComboCodes()
	.addGroupCode({"groupCode": cmmnClCd, "required": false, "includedNotUse" : false})
    .execute();

  	new CommonAjax("/ngs/setup/retrievePerformCodeDetails.do")
  	.addParam({"cmmnClCd":cmmnClCd, "cmpnyCd":ibsPerformCode.GetCellValue(nRow, "cmpnyCd"), "usedYn":usedYn})
  	.callback(function (resultData) {
  		resultData.performCodeDetails.forEach(function(data) {
  			data["cmmnCd#ComboText"] = objCmmnCmbCodes2[cmmnClCd].ComboText;
  			data["cmmnCd#ComboCode"] = objCmmnCmbCodes2[cmmnClCd].ComboCode;
			if(data.editYn=="01"){//종료일만 수정
				data["cmmnCd#Edit"] = 0;
				data["dnaYn#Edit"] = 0;
				data["rnaYn#Edit"] = 0;
				data["tisueYn#Edit"] = 0;
				data["libYn#Edit"] = 0;
				data["fistPcrYn#Edit"] = 0;
				data["workDtlCd#Edit"] = 0;
				data["expoSqnc#Edit"] = 0;
				data["aplyBeginDt#Edit"] = 0;
				if(data.aplyEndDtEditYn=="Y"){//종료일만 수정
					data["aplyEndDt#Edit"] = 1;
				} else {
					data["aplyEndDt#Edit"] = 0;
				}
			} else if(data.editYn=="02") {//모두 수정 가능
				data["cmmnCd#Edit"] = 0;
				data["dnaYn#Edit"] = 1;
				data["rnaYn#Edit"] = 1;
				data["tisueYn#Edit"] = 1;
				data["libYn#Edit"] = 1;
				data["fistPcrYn#Edit"] = 1;
				data["workDtlCd#Edit"] = 1;
				data["expoSqnc#Edit"] = 1;
				data["aplyBeginDt#Edit"] = 1;
				data["aplyEndDt#Edit"] = 1;
			} else {//모두 수정 불가
				data["cmmnCd#Edit"] = 0;
				data["dnaYn#Edit"] = 0;
				data["rnaYn#Edit"] = 0;
				data["tisueYn#Edit"] = 0;
				data["libYn#Edit"] = 0;
				data["fistPcrYn#Edit"] = 0;
				data["workDtlCd#Edit"] = 0;
				data["expoSqnc#Edit"] = 0;
				data["aplyBeginDt#Edit"] = 0;
				data["aplyEndDt#Edit"] = 0;
			}
		});
  		ibsPerformCodeDetail.LoadSearchData({"data": resultData.performCodeDetails});
	})
	.execute();
}

/**
 * 수행코드상세 저장
 */
function fnSavePerformCodeDetail() {
	saveRow = ibsPerformCode.GetSelectRow();
	new CommonAjax("/ngs/setup/savePerformCodeDetails.do")
	.addParam(ibsPerformCodeDetail)
	.confirm("<spring:message code='cnfm.save'/>")
	.callback(function (resultData) {
		alert(resultData.message);
		if(resultData.result == "S"){
			fnRetrievePerformCodes();
		}
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
		/* var sH2 = $("#divIbsPerformCode").height(); */
		var bH = $(".grid_btn").height();;	// 그리드 버튼
		var allH = hH + hH2 + /* sH2 + */ bH + 215;
		$("#divIbsPerformCode, #divIbsPerformCodeDetail").height((popWinSize - allH)/2);
	});
	var popWinSize = $(window).height();
	var hH = $("header").height();
	var hH2 = $(".title-info").height();
	/* var sH2 = $("#divIbsPerformCode").height(); */
	var bH = $(".grid_btn").height();
	var allH = hH + hH2 + /* sH2 + */ bH + 215;
	$("#divIbsPerformCode, #divIbsPerformCodeDetail").height((popWinSize - allH)/2);
}

</script>
<div class="content labMngt">
	<!-- 타이틀/위치정보 -->
	<div class="title-info">
		<h2>${activeMenu.menuNm}</h2>
	</div>
	<!-- //타이틀/위치정보 -->
	<form class="form-inline form-control-static" action="" id="performCodeForm" name="performCodeForm" onsubmit="return false">
		<input type="hidden" id="menuCd" name="menuCd" />
		<div class="sh_box">
			<!-- 그리드 레이아웃 추가 -->
			<div class="grid_wrap gridType2">
				<h3 class="nonType"><spring:message code='word.perform.code'/></h3><!-- 수행코드 -->
				<div id='divIbsPerformCode'></div>
			</div>
		</div>
		<!-- 검색영역 -->
		<%-- <div class="search_box2">
			<div class="leftBox">
				<table>
					<tbody>
						<tr>
							<th><spring:message code='word.use.yn'/></th><!-- 사용여부 -->
							<td>
								<ul class="master_check checkStyleCh">
									<li><input type="radio" id="i1" name="usedYn" value="Y" checked/> <label class="" for="i1"><spring:message code='word.used'/></label><!-- 사용중 --></li>
									<li><input type="radio" id="i2" name="usedYn" value="N"/> <label for="i2"><spring:message code='word.all'/></label><!-- 전체 --></li>
								</ul>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			<div class="leftBox"><button type="button" class="btn_search" id="btnSearchPerformCodeDetails"><spring:message code='word.inquiry'/></button><!-- 조회 --></div>
		</div> --%>
		<div class="sh_box">
			<div class="grid_wrap gridType2 titType1">
				<h3><span id="gridTitle"></span></h3>
				<!-- 버튼영역 -->
				<div class="grid_btn">
					<%-- <div class="rightBox">
						<button type="button" class="btn_normal btn_frst" id="btnGroupDetailAddRow" title="<spring:message code='word.row.adit'/>"><span class="glyphicon glyphicon-plus"></span></button>
						<button type="button" class="btn_normal btn_cent" id="btnGroupDetailDelRow" title="Delete"><span class="glyphicon glyphicon-minus"></span></button>
						<button type="button" class="btn_normal btn_last" id="btnGroupDetailSave" title="Save"><span class="glyphicon glyphicon-floppy-disk"></span></button>
						<div class="vertical-bar-sm btn-group"></div>
					</div> --%>
					<div class="btn-group flex-j-end">
						<table>
							<tbody>
								<tr>
									<td>
										<ul class="master_check checkStyleCh">
											<li><input type="radio" id="i1" name="usedYn" value="Y" checked/> <label class="" for="i1"><spring:message code='word.used'/></label><!-- 사용중 --></li>
											<li><input type="radio" id="i2" name="usedYn" value="N"/> <label for="i2"><spring:message code='word.all'/></label><!-- 전체 --></li>
										</ul>
									</td>
								</tr>
							</tbody>
						</table>
						<div class="vertical-bar-sm"></div>
						<div class="btn-group-circular">
							<button type="button" class="icon-add btn btn-circular bg-disable" id="btnGroupDetailAddRow" title="<spring:message code='word.row.adit'/>"></button>
							<button type="button" class="icon-minus btn btn-circular bg-disable" id="btnGroupDetailDelRow" title="Delete"></button>
						</div>
						<div class="vertical-bar-sm"></div>
						<div class="flex-j-end">
							<button type="button" class="icon-save-white btn btn-icon bg-active" id="btnGroupDetailSave" title="Save"></button>
						</div>
						<div class="vertical-bar-sm"></div>
						<div class="rightBox flex-j-end"></div>
					</div>
				</div>
				<div id='divIbsPerformCodeDetail'></div>
			</div>
		</div>
	</form>
</div>