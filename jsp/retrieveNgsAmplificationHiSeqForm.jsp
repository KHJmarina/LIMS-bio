 <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script src='<c:url value="/resources/js/ngs/common.js"/>'></script>
<script src='<c:url value="/resources/js/cus/common.js"/>'></script>

<script>
var searchMode = '${param.searchMode}'||'ILL';

function fnOnload() {

	// if(searchMode === 'MGI') {
		$('#searchMode').val(searchMode);
	// }

	$('#searchBeginDate').IBMaskEdit('yyyy-MM-dd', {
		//defaultValue: moment().add("-1","month").format('YYYY-MM-DD')
	});
	$('#searchEndDate').IBMaskEdit('yyyy-MM-dd', {
	//	defaultValue: moment().format('YYYY-MM-DD')
	});

	objCmmnCmbCodes = new CommonSheetComboCodes()
	.addGroupCode({"groupCode": "PLTFOM_CD", "includedNotUse" : false ,"atrb2":searchMode})		/* PLTFOM_CD */
	.addGroupCode({"groupCode": "LIB_TYPE_CD", "includedNotUse" : true})	/* 라이브러리 타입 코드 */ //  ,"atrb1":"MGI"
	.execute();

	$("#searchPltfomCd").addCommonSelectOptions({
		  "comboData": objCmmnCmbCodes["PLTFOM_CD"],
		  "required": true ,
		  "defaultValue": ""
	});

	/* MiSeq, (Mybiom)MiSeq 제거 */
	$("#searchPltfomCd option").each(function(){
		if($(this).val() == "MI" || $(this).val() == "MM")
		{
			$(this).remove();
		}
	});

	$('#searchOrdGrdeCd').addCommonSelectOptions({
    	"comboData": objCmmnCmbCodes["ORD_GRDE_CD"],
    	"required": false,
    	"defaultValue": "WORD"
    });

	fnSetEvent();

	//$('#searchPltfomCd')[1].attr('selected', 'selected');
	fnRunScaleCombo();
	createIBSheet2($("#div_amplification").get(0), "ibsAmplification", "100%", "780px");
    IBS_InitSheet(ibsAmplification,
    	{
	    	"Cfg" : {
	            "MergeSheet": msHeaderOnly+msPrevColumnMerge,PrevColumnMergeMode:0, DeferredVScroll : 1
	        },
	        "HeaderMode" : {"Sort": 0},
	    	   "Cols": [
	        	{Header:"",														Type:"CheckBox",	Align:"Center",	SaveName:"ibCheck",				Width:50, ColMerge:"0" 	,Edit:"1"},
	        	{Header:"<spring:message code='word.hd.ord.no'/>",					Type:"Text",   		Align:"Left",   SaveName:"ordNo",      			MinWidth:90, ColMerge:"1" , Edit:"0", FontColor: "#4C84FF", FontUnderline:1, Cursor:"Pointer"}, //ordNo
	        	{Header:"<spring:message code='word.hd.due.date'/>",				Type:"Text",   		Align:"Left",   SaveName:"cmplPrearngeDt",      MinWidth:70, ColMerge:"1" , Edit:"0"}, //고객납기일
	        	{Header:"<spring:message code='word.hd.ngs.cstmr.nm'/>",			Type:"Text",   		Align:"Left", SaveName:"custNm",      		MinWidth:100, ColMerge:"1" , Edit:"0"},//고객명
	    		{Header:"<spring:message code='word.hd.prfm.unus.cntn'/>",			Type:"Html",   		Align:"Left", SaveName:"prfmUnusCntn",     	MinWidth:200, ColMerge:"1" , Edit:"1"},//수행특이사항
	        	{Header:"<spring:message code='word.hd.run.info'/>",				Type:"Text",   		Align:"Left", SaveName:"runTypeNm",     		MinWidth:120, ColMerge:"1" , Edit:"0"},//런정보
	        	{Header:"<spring:message code='word.hd.library.nm'/>",				Type:"Text",   		Align:"Left", SaveName:"libNm",     			MinWidth:110, ColMerge:"0" , Edit:"0"},//라이브러리 명
	        	{Header:"<spring:message code='word.hd.idx'/>",					Type:"Text",   		Align:"Left", SaveName:"idxCd",     			MinWidth:90, ColMerge:"0" , Edit:"0"},//index
	        	{Header:"<spring:message code='word.hd.target.size'/>",			Type:"Text",   		Align:"Right",  SaveName:"targetSize",     		MinWidth:80, ColMerge:"0" , Edit:"1" ,EditLen:"10"},//target size
	        	{Header:"<spring:message code='word.hd.target.size'/>",			Type:"Text",   		Align:"Right",  SaveName:"targetSizeOrigin",     		MinWidth:80, ColMerge:"0" , Edit:"0",Hidden:"1", EditLen:"10"},//target size(수정전 데이터)
	        	{Header:"<spring:message code='word.hd.run.group.no'/>",			Type:"Text",   		Align:"Right", SaveName:"runGropNo",     		MinWidth:100, ColMerge:"0" , Edit:"0"},//RUN_GROP_NO
	        	{Header:"<spring:message code='word.hd.run.scale'/>",				Type:"Text",   		Align:"Left", SaveName:"runScale",     		MinWidth:100, ColMerge:"0" , Edit:"0"},//런스케일
	        	{Header:"<spring:message code='word.hd.accom.pltfom'/>",			Type:"Text",   		Align:"Left", SaveName:"prfmPltfomNm",      	MinWidth:80, ColMerge:"0" , Edit:"0"},//수행 플랫폼
	        	{Header:"<spring:message code='word.hd.exome.work.no'/>",			Type:"Text",   		Align:"Left", SaveName:"libWshId",     		MinWidth:100, ColMerge:"0" , Edit:"0"},//exome작업번호
	        	{Header:"<spring:message code='word.hd.pooling.id'/>",			Type:"Text",   		Align:"Right", SaveName:"libPoolingNm",     		MinWidth:100, ColMerge:"0" , Edit:"0"},	// 200814 LQC 단계 또는 Exome Caption 단계의 Pooling ID
	         	{Header:"<spring:message code='word.hd.phix.pt'/>",	    		Type:"Text",   		Align:"Left", SaveName:"phiPt",     			MinWidth:60, ColMerge:"0" , Edit:"0"},//phix(%)
         		{Header:"<spring:message code='word.hd.sample.status'/>",			Type:"Text",   		Align:"Left", SaveName:"smplStatNm",     		MinWidth:80, ColMerge:"0" , Edit:"0"},//샘플status
         		{Header:"<spring:message code='word.hd.library.kit'/>",			Type:"Text",   		Align:"Left", SaveName:"libKitNm",    		MinWidth:60, ColMerge:"0" , Edit:"0"},//라이브러리 kit
         		{Header:"<spring:message code='word.hd.lib.type'/>",				Type:"Combo",  		Align:"Left", SaveName:"libTypeNm",    		MinWidth:100, ColMerge:"0" , Edit:"0",	"ComboText":objCmmnCmbCodes["LIB_TYPE_CD"].ComboText, "ComboCode":objCmmnCmbCodes["LIB_TYPE_CD"].ComboCode},//라이브러리타입 명
         		{Header:"<spring:message code='word.hd.appl.type'/>",				Type:"Text",   		Align:"Left", SaveName:"applionTypeNm",  		MinWidth:110, ColMerge:"0" , Edit:"0"},//라이브러리 타입 명
	        	{Header:"<spring:message code='word.hd.otd.otd3p'/>",				Type:"Text",   		Align:"Left", SaveName:"otd3P",  		   		MinWidth:100, ColMerge:"0" , Edit:"0"},//OTD3_P
	        	{Header:"<spring:message code='word.hd.otd.otd3m'/>",				Type:"Text",   		Align:"Left", SaveName:"otd3M",     			MinWidth:100, ColMerge:"0" , Edit:"0"},//otd3m
				{Header:"<spring:message code='word.hd.retore.cause'/>",			Type:"Text",   		Align:"Left", SaveName:"libPrgrStatChgRsn",   MinWidth:100, ColMerge:"0" , Edit:"0"},//PostSales 명
				{Header:"<spring:message code='word.hd.priority.yn'/>", 			Type:"Text", 		Align:"Left", SaveName:"ordGrdeNm", 			MinWidth:100, ColMerge:"0" , Edit:"0"},//priority 여부
				{Header:"<spring:message code='word.hd.library.id'/>",				Type:"Text",   		Align:"Left", SaveName:"libId",     			MinWidth:100, ColMerge:"0" , Edit:"0",Hidden:"1", Render : 0},//라이브러리 id
				{Header:"idxSeq7",												Type:"Text",   		Align:"Left", SaveName:"idxSeq7",     		MinWidth:100, Edit:"0",Hidden:"1", Render : 0},//
				{Header:"idxSeq5",												Type:"Text",   		Align:"Left", SaveName:"idxSeq5",     		MinWidth:100, Edit:"0",Hidden:"1", Render : 0},//
				{Header:"readLngt",												Type:"Text",   		Align:"Left", SaveName:"readLngt",     		MinWidth:100, Edit:"0",Hidden:"1", Render : 0},//
				{Header:"runModeCd",											Type:"Text",   		Align:"Left", SaveName:"runModeCd",     		MinWidth:100, Edit:"0",Hidden:"1", Render : 0},//
				{Header:"readTypeCd",											Type:"Text",   		Align:"Left", SaveName:"readTypeCd",     		MinWidth:100, Edit:"0",Hidden:"1", Render : 0},//=
				{Header:"runScaleSn",											Type:"Text",   		Align:"Left", SaveName:"runScaleSn",     		MinWidth:100, ColMerge:"1" , Edit:"0",Hidden:"1", Render : 0},//
				{Header:"<spring:message code='word.hd.run.info'/>",				Type:"Text",   		Align:"Left", SaveName:"runTypeCd",     		MinWidth:100, ColMerge:"1" , Edit:"0",Hidden:"1", Render : 0},//런정보
				{Header:"<spring:message code='word.hd.sttus'/>",					Type:"Status",		Align:"Left", SaveName:"ibStatus", 			MinWidth:50,  Hidden:"1", Render : 0},
				{Header:"adtlRunReqYn",											Type:"Text",   		Align:"Left", SaveName:"adtlRunReqYn",     	MinWidth:100, Edit:"0",Hidden:"1", Render : 0},//추가런 여부
				{Header:"prfmPltfomCd", 										Type:"Text",		Align:"Left", SaveName:"pltfomCd", 			MinWidth:100, Edit:"0",Hidden:"1", Render : 0}, //Platform
		       	]
	    }
    )

	/*
	 * 19.01.29(화) 박용선K
	 *
	 * [변경내역] : 페이지가 load될때 기본 선택옵션에 따라 데이터 바인딩 되지 않도록 처리.
	 *			    만약, 속도이슈가 개선되어 기본선택옵션에 따라서 데이터 바인딩이 되도록 처리 한다면 아래의 UDF함수를 주석해제
	 */
	//fnRetrieve();
}


/**
 * [개발표준]이벤트를 정의함
 */
var _setCheckTimer;
var _setCheckQueue = [];
function fnSetEvent() {

    window["ibsAmplification_OnPopupClick"] = function(Row, Col) {
    	if(ibsAmplification.ColSaveName(Col) == "prfmUnusCntn"){
    		retrievePerformUnusualPopup(ibsAmplification.GetCellValue(Row, "ordNo"), "");
    	}
    };

    window["ibsAmplification_OnChange"] = function(Row, Col, Value) {
    	var chgRunCtCount = 0;
    	var libIdCount  = 0;
    	var len = 0;
		/*선택한 Row에 color 표시 */
    	if(Col==0){
    		if(ibsAmplification.GetCellValue(Row,"ibCheck")){

    			// 201222 : 속도개선 > 렌더링컬럼 축소(6~17)(1047건 기준 1분 30초 빨라짐)
    			_setCheckQueue.push("ibsAmplification.SetCellBackColor("+Row+", 'libNm', '#FAEBD7')");
    		}else{
    			_setCheckQueue.push("ibsAmplification.SetCellBackColor("+Row+", 'libNm', '')");
    		}
    	}

		clearTimeout(_setCheckTimer);
    	_setCheckTimer = setTimeout(fnSetCheckTimer, 100);
    };

	$("#searchPltfomCd").change(function() {
		fnRunScaleCombo();
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

	$("#btnTargetSizeSave").click(function() {
		fnTargetSizeSave();
    });

	$("#btnLibHoldSave").click(function() {
		fnAmplificationHoldSave();
    });
	$("#btnAmpPerson").click(function() {
		$("#workType").val("person");
		fnAmplificationHiSeqPop();
    });
	$("#btnAmpGroup").click(function() {
		$("#workType").val("group");
		fnAmplificationHiSeqPop();
    });

	$("#btnExcel").click(function() {
		fnCommonExcelDown(ibsAmplification)
    });
	$("#btnSearch").click(function() {
		fnRetrieve();
    });

	 $('#btnUpdateOtdDt').click(function() {

     	var count = ibsAmplification.CheckedRows("ibCheck");
     	if(count == 0){
     		alert("<spring:message code='infm.no.select'/>");
     		return false;
     	}

     	fnRetrieveOrdLibOtdPopup("fnOtdCallBack()", "Y", "ibsAmplification","OTD3");
     });
}

function fnRetrieve() {

	if(moment($("#searchBeginDate").val()).isAfter($("#searchEndDate").val())) {
		alert("<spring:message code='infm.bgnde.endde.imprty'/>");  //시작일은 종료일보다 클 수 없습니다.
		$("#searchBeginDate").focus();
		return;
	}

	 new CommonAjax("/ngs/amplification/retrieveNgsAmplificationList.do")
			.addParam(amplificationForm)
	      .callback(function (resultData) {
	    	  resultData.result.forEach(function(v){
	    		v.targetSizeOrigin = v.targetSize;
	    	  });
	    	  ibsAmplification.LoadSearchData({"data": resultData.result});
	      })
	      .execute();
}

function fnSetCheckTimer() {

	var queue = _setCheckQueue.splice(0);

// 	ibsAmplification.RenderSheet(0);
	if(queue.some(function(v){
		try {
			eval(v);
		} catch (e) {
			return true;
		}
	})) {
		alert('<spring:message code="err.com.msg"/>');
		return false;
	}
// 	ibsAmplification.RenderSheet(1);

	var chgRunCtCount = 0;
	var libIdCount  = 0;
	var len = 0
	for(var i=ibsAmplification.GetDataFirstRow(); i<=ibsAmplification.GetDataLastRow(); ++i){

		if(ibsAmplification.GetCellValue(i,"ibCheck")){
			var targetSize = ibsAmplification.GetCellValue(i,"targetSize");
			targetSize = String(targetSize);
			if(targetSize !=""){
				chgRunCtCount  += Number(ibsAmplification.GetCellValue(i,"targetSize"));
    			if(targetSize.indexOf(".")>-1){
					var len01 = targetSize.substring(targetSize.indexOf(".")+1,targetSize.length).length;
    				if(len < len01){ /* 소수점 최대 자리 구함 */
    					len  = len01;
    				}
    			}
			}
			libIdCount++;
		}
	}
	chgRunCtCount  = chgRunCtCount.toFixed(len);

   	$("#divLibIdCount").text(libIdCount+"EA");
 	$("#divChgRunCtCount").text(chgRunCtCount+"GB");
}

function fnRunScaleCombo(){

     var commonUseWordCombo = new CommonSheetComboOthers("/ngs/amplification/retrieveNgsRunScaleCombo.do")
     .addParam({"searchPltfomCd": $('#searchPltfomCd').val()})
	 .addCombo({"resultCombo": {"codeColumn": "runScaleSn", "textColumn": "runScaleCd"}})
	 .execute();
	 $("#searchRunCaleSn").addCommonSelectOptions({
	 	"comboData": commonUseWordCombo["resultCombo"],
	 	"required": true
	 });
}
/*target size 저장*/
function fnTargetSizeSave(){

	for(var i=ibsAmplification.GetDataFirstRow(); i<=ibsAmplification.GetDataLastRow(); ++i){
		if(ibsAmplification.GetCellValue(i,"ibCheck")){
			if(ibsAmplification.GetCellValue(i,"targetSize") ==""){
				alert("<spring:message code='word.target.size.input'/>");//'word.target.size.input
				ibsAmplification.SelectCell(i, 8);
				return false;
			}
			if(isNaN(ibsAmplification.GetCellValue(i,"targetSize")) ){
				alert("<spring:message code='word.targetsize.check'/>");//'word.target.size.input
				ibsAmplification.SelectCell(i, 8);
				return false;
			}
		}
	}

	var count = ibsAmplification.CheckedRows("ibCheck");
	if(count == 0){
		alert("<spring:message code='word.no.select.lib'/>");
		return false;
	}
	new CommonAjax("/ngs/amplification/updateAmplificationTargetSize.do")
	.addParam(ibsAmplification)
	.callback(function (resultData) {
		alert(resultData.message);
		if(resultData.result == "S"){
			fnRetrieve();
		}
	})
	.confirm("<spring:message code='word.select.lib.chg'/>")
	.execute();
}
/* lib 보류 사유 저장*/
function fnAmplificationHoldSave(){


	var count = ibsAmplification.CheckedRows("ibCheck");
	if(count == 0){
		alert("<spring:message code='word.no.select.lib'/>");
		return false;
	}
	if($("#libPrgrStatChgRsn").val() == ""){
		alert("<spring:message code='word.hold.rsn.input'/>");
		$("#libPrgrStatChgRsn").focus();
		return false;
	}

//libPrgrStatChgRsn
	new CommonAjax("/ngs/amplification/updateAmplificationHold.do")
	.addParam(ibsAmplification)
	.addParam(amplificationForm)
	.callback(function (resultData) {
		alert(resultData.message);
		if(resultData.result == "S"){
			$("#libPrgrStatChgRsn").val("");
			fnRetrieve();
		}
	})
	.confirm("<spring:message code='word.hold.rsn.save'/>")
	.execute();
}


/* 업무요청 등록*/
function fnAmplificationHiSeqPop() {
	if($("#searchPltfomCd").val()==""){
		$("#searchPltfomCd").focus();
		alert("<spring:message code='word.accom.pltfom.select'/>");
		return false;
	}
	var count = ibsAmplification.CheckedRows("ibCheck");

	if(count == 0){
		alert("<spring:message code='word.no.select.lib'/>");
		return false;
	}

	if($("#workType").val()== "group"){
		if(!fnInxSeqChk(ibsAmplification,"<spring:message code='word.index.dup.chk'/>")){ /*중복 indx7, inx5 체크*/
			return false;
		}
	}

	// target size 검사 추가(저장 전 데이터 기준)
	var saveData = ibsAmplification.GetSaveJson({"StdCol": "ibCheck"}).data;
	var fails = '';
	saveData.forEach(function(v){
		var targetSize = Number.parseFloat(v.targetSizeOrigin);
		if(targetSize <= 0 || !targetSize) {
			fails += v.ordNo+' > '+v.libNm + ' > ' + targetSize + '\n';
		}
	})
	if(fails) {
		alert('Target Size, <spring:message code="err.com.data"/>\n' + fails);
		return false;
	}

	window.open("", "ampPop","toolbar=no,directories=no,scrollbars=yes,resizable=yes,status=no,menubar=no,width=1250,height=650");
	$("#amplificationForm").attr("target","ampPop")
	.attr("action","/ngs/amplification/retrieveNgsAmplificationHiSeqPopup.do")
	.attr("method","post")
	.submit();
}

/*otd 팝업 콜백함수*/
window.fnOtdCallBack = function (){
	fnRetrieve();
}


/**
 * 2019.01.22(화) 박용선K 추가
 *
 * [변경내역] : IBSheet내 OnClick이벤트 호출
 *
 */
function ibsAmplification_OnClick(row, col, value, cellX, cellY, cellW, cellH, rowtype)
{
	if(rowtype == "DataRow")
	{
		var saveName = ibsAmplification.ColSaveName(col);
		var ordNo = ibsAmplification.GetCellValue(row, "ordNo");

    	if(saveName === "ordNo")
    	{
			//주문조회상세 화면으로 이동
			$('#frmMenu').find("input[name=ordNo]").remove();
	  		$('#frmMenu').append('<input type="hidden" name="ordNo" value="'+ordNo+'">');
	  		// fnMove("/ngs/order/retrieveOrdSearchDetailForm.do", "");
	  		fnMove("/ngs/order/retrieveOrdSearchDetailForm.do", "", "Y");
    	}
	}
}

</script>
<div class="content ampHiqList">
	<!-- 타이틀/위치정보 -->
	<div class="title-info">
		<h2>${activeMenu.menuNm}</h2>
	</div>
	<form class="form-inline form-control-static" action="" id="amplificationForm" name="amplificationForm">
		<input type="hidden" id="workType" name="workType" />
		<input type="hidden" id="amplificationType" name="amplificationType" value="HI" />
		<input type="hidden" id="searchMode" name="searchMode" value="ILL" />
		<!-- 검색영역 -->
		<div class="search_box2">
			<div class="leftBox">
			<table>
				<!-- <colgroup>
					<col width="100" />
					<col width="150" />
					<col width="100" />
					<col width="150" />
					<col width="100" />
					<col width="400" />
				</colgroup> -->
				<tbody>
					<tr>
						<th><spring:message code='word.order.accept.date'/><%-- 기간설정 --%></th>
						<td class="date_search">
							<input type="text" name="searchBeginDate" id="searchBeginDate" class="date_type1" required="<spring:message code='word.regist.start.date'/>"/><button type="button" class="btn_calendar" id="btnStartCal"></button> ~
							<input type="text" name="searchEndDate" id="searchEndDate" class="date_type1" required="<spring:message code='word.regist.end.date'/>"/><button type="button" class="btn_calendar" id="btnEndCal"></button>
						</td>
						<th><spring:message code='word.accom.pltfom'/><%-- 수행플랫폼 --%></th>
						<td>
							<select name="searchPltfomCd" id="searchPltfomCd" style="width:120px;"></select>
						</td>
						<th><spring:message code='word.run.scale'/><%-- 런스케일  --%></th>
						<td>
							<select name="searchRunCaleSn" id="searchRunCaleSn" style="width:120px;">
								<option value=""><spring:message code='word.combo.option.select'/></option>
							</select>
						</td>
						<th></th>
						<td>
							<select name="searchBasiSrchCd" id="searchBasiSrchCd" class="bor2">
								<option value=""><spring:message code='word.base.search'/></option><!-- 기본검색 -->
								<option value="01"><spring:message code='word.ord.no'/></option>
								<option value="02"><spring:message code='word.library.id'/></option>
								<option value="03"><spring:message code='word.ngs.cstmr.id'/></option>
							</select><input type="text" name=searchKeyword id="searchKeyword" maxlength="30" class="w246 bor2 iconKeyboard"/>
						</td>
					</tr>
				</tbody>
			</table>
			</div>
			<div class="rightBox"><button type="button" class="btn_search" id="btnSearch"><spring:message code='word.inquiry'/><%--조회 --%></button></div>
		</div>

		<div class="sh_box">
			<!-- 그리드 레이아웃 추가 -->
			<div class="grid_wrap gridType3">
				<section>
					<div class="w100">
						<div class="w100 titType1">
							<div class="w100 grid_btn pb3">
								<div class="btn-group flex-j-end search-box-btn">
									<div class="leftBox mr10 libSel" style="align-items: center; padding-right: 5px;">
										<span><spring:message code='word.selected.lib.cnt'/></span>: [<strong id="divLibIdCount">0EA</strong>]<br>
										<span><spring:message code='word.selected.target.size'/></span>: [<strong id="divChgRunCtCount">0GB</strong>]
									</div>
									<div>
										<input type="text" name="libPrgrStatChgRsn" id="libPrgrStatChgRsn" class="input input-text input-box-search-btn" maxlength="50">
										<button type="button" class="btn btn-sub size-sm bg-active" id="btnLibHoldSave" title="<spring:message code='word.amp.hold'/>" style="float: right;"><spring:message code='word.amp.hold'/></button>
									</div>
									<div class="vertical-bar-sm"></div>
									<div>
										<button type="button" class="btn btn-sub size-auto bg-secondary-empty" id="btnAmpPerson" title="<spring:message code='word.person.save'/>"><spring:message code='word.person.save'/></button>
										<button type="button" class="btn btn-sub size-auto bg-secondary-empty" id="btnAmpGroup" title="<spring:message code='word.group.save'/>"><spring:message code='word.group.save'/></button>
									</div>
									<div class="vertical-bar-sm"></div>
									<div>
										<button type="button" class="btn btn-sub size-auto bg-secondary-empty" id="btnUpdateOtdDt"><spring:message code='word.update.otd.dt'/></button><!-- OTD일자변경 -->
									</div>
									<div class="vertical-bar-sm"></div>
									<div>
										<button type="button" class="icon-save-white btn btn-icon bg-active" id="btnTargetSizeSave" title="<spring:message code='word.target.size.save'/>"></button>
									</div>
									<div class="vertical-bar-sm"></div>
									<div>
										<button type="button" class="icon-export-white btn btn-sub size-sm btn-icon bg-secondary b-zero" id="btnExcel"></button><!-- Excel Export -->
									</div>
								</div>
								<%-- <div class="rightBox">
									<div class="leftBox mr10 libSel">
										<span><spring:message code='word.selected.lib.cnt'/></span>: [<strong id="divLibIdCount">0EA</strong>]<br>
										<span><spring:message code='word.selected.target.size'/></span>: [<strong id="divChgRunCtCount">0GB</strong>]
									</div>
									<div class="leftBox int_btn">
										<input type="text" id="libPrgrStatChgRsn" name="libPrgrStatChgRsn" value="" maxlength="50" /><button type="button" class="btn_normal" id="btnLibHoldSave" title="<spring:message code='word.amp.hold'/>"><span class=""><spring:message code='word.amp.hold'/></span></button>
									</div>
									<button type="button" class="btn_normal btn_frst" id="btnAmpPerson" title="<spring:message code='word.person.save'/>"><span class=""><spring:message code='word.person.save'/></span></button>
									<button type="button" class="btn_normal btn_last" id="btnAmpGroup" title="<spring:message code='word.group.save'/>"><span class=""><spring:message code='word.group.save'/></span></button>
									<button type="button" class="btn_normal btn_frst" id="btnTargetSizeSave" title="<spring:message code='word.target.size.save'/>"><span class="glyphicon glyphicon-floppy-disk"></span></button>
									<button type="button" class="btn_normal btn_cent" id="btnUpdateOtdDt" ><spring:message code='word.update.otd.dt'/></button><!-- OTD일자변경 -->
									<button type="button" class="btn_excel btn_last" id="btnExcel" title="<spring:message code='word.excel.export'/>"></button>Excel Export
								</div> --%>
							</div>
						</div>
						<div id='div_amplification'></div>
					</div>
				</section>
		<!-- // 그리드 레이아웃 추가 -->
			</div>
		</div>
	</form>
</div>