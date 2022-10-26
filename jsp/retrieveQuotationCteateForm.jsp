<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<sec:authentication property='principal' var="principal"/>
<script src='<c:url value="/resources/js/ngs/common.js"/>'></script>
<script src='<c:url value="/resources/js/cus/common.js"/>'></script>

<script>
var objCmmnCmbCodes;
var custCrncUntCdList;
var preEstmtRm = "";		// 201028 Pre 견적 Remark
function fnOnload() {
    //공통코드
	objCmmnCmbCodes = new CommonSheetComboCodes()
    .addGroupCode({"groupCode": "SRVC_DOMN_CD", "required": false, "includedNotUse" : false, "includedAtrb" : true}) //서비스도메인
    .addGroupCode({"groupCode": "CRNC_UNT_CD", "required": false, "includedNotUse" : false}) //통화구분코드
    .addGroupCode({"groupCode": "TXAMT_DIV_CD", "required": false, "includedNotUse" : false}) //세액구분
    .execute();

	$("#srvcDomnCd").addCommonSelectOptions({
	    "comboData":objCmmnCmbCodes["SRVC_DOMN_CD"],
	    "required": true
	});

	$("#crncUntCd").addCommonSelectOptions({
	    "comboData":objCmmnCmbCodes["CRNC_UNT_CD"],
	    "required": true
	});

    //set radio
	//세액구분
    $("#txamtDivCdUl").addCommonRadioOptions({
        "radioName": "txamtDivCd", /* [필수]라디오버튼 Name 속성 값 */
        "radioData": objCmmnCmbCodes["TXAMT_DIV_CD"], /* [필수]데이터 */
    	"defaultValue": "E" /* [선택]기본 선택 값 */
    });

	createIBSheet2("quotation-sheet", "quotationSheet", "100%", "530px", "", false, "{AutoSizeColumn:'1', Mode:'1'}");
	IBS_InitSheet(quotationSheet, {
        "Cfg": {"PrevColumnMergeMode": 0},
		"Cols": [
        	{Header:"Stat", Type:"Status", Align:"Center", SaveName:"ibStatus", MinWidth:40, ColMerge:"0"},
        	{Header:"<spring:message code='word.hd.no'/>", Type:"Text", Align:"Center", SaveName:"rnum", MinWidth:50, Edit:"0", ColMerge:"1"},//No
            {Header:"<spring:message code='word.hd.indict.prdlst'/>", Type:"Text", Align:"Left", SaveName:"itmGropNm", MinWidth:150, KeyField:"1", Edit:"1", ColMerge:"1"},//표시 품명
            {Header:"<spring:message code='word.hd.qy'/>", Type:"Int", Align:"Right", SaveName:"qnt", MinWidth:80, KeyField:"1", Edit:"1", ColMerge:"1"},//수량
        	{Header:"", Type:"Button", Align:"Center", SaveName:"itemPopup", MinWidth:80, DefaultValue:"Add", Edit:"1", ColMerge:"1"},//add버튼
        	{Header:"", Type:"DummyCheck", Align:"Center", SaveName:"ibCheck", Width:50, ColMerge:"0", HeaderCheck:"0"},//선택
            {Header:"<spring:message code='word.hd.prdlst.group'/>", Type:"Text", Align:"Left", SaveName:"estmtItmGropCdNm", MinWidth:120, Edit:"0", ColMerge:"0"},//품목그룹
        	{Header:"<spring:message code='word.hd.prdlst.nm'/>", Type:"Text", Align:"Left", SaveName:"estmtItmCdNm", MinWidth:200, Edit:"0", ColMerge:"0"},//품목명
        	{Header:"<spring:message code='word.hd.prdlst.cd'/>", Type:"Text", Align:"Center", SaveName:"estmtItmCd", MinWidth:100, Edit:"0", KeyField:"1", ColMerge:"0"},//품목코드
        	{Header:"<spring:message code='word.hd.stndrd'/>", Type:"Text", Align:"Center", SaveName:"estmtItmStdrNm", MinWidth:100, Edit:"0", ColMerge:"0"},//규격
            {Header:"<spring:message code='word.hd.itm.qy'/>", Type:"Int", Al1ign:"Right", SaveName:"itmQnt", MinWidth:80, KeyField:"1", Edit:"1", ColMerge:"0"},//품목 수량
            {Header:"<spring:message code='word.hd.input.prc.vat.exclude'/>", Type:"AutoSum", Align:"Right", SaveName:"unpr", MinWidth:120, KeyField:"1", Format:"#,##0.00", EditPointCount:2, MaximumValue:999999999999999.99, ColMerge:"0"},//입력단가(VAT포함)
            {Header:"<spring:message code='word.hd.input.grop.prc'/>", Type:"Text", Align:"Right", SaveName:"gropUnpr", MinWidth:120, MinWidth:120, Edit:"0", ColMerge:"0"},//그룹입력단가
            {Header:"<spring:message code='word.hd.splpc.vat.exclude'/>", Type:"Text", Align:"Right", SaveName:"supplyPrice", MinWidth:120,  Edit:"0", ColMerge:"0"},//공급가액(VAT별도)
            {Header:"<spring:message code='word.hd.taxamt'/>", Type:"Text", Align:"Right", SaveName:"taxAmount", MinWidth:120,  Edit:"0", ColMerge:"0"},//세액
            {Header:"<spring:message code='word.hd.tot.amount'/>", Type:"Text", Align:"Right", SaveName:"totalAmount", MinWidth:120,  Edit:"0", ColMerge:"0"},//총금액
			{Header:"cmpnyCd", Type:"Text", SaveName:"cmpnyCd", Hidden:"1"}, //법인코드
			{Header:"estmtDivCd", Type:"Text", SaveName:"estmtDivCd", Hidden:"1"}, //견적구분
			{Header:"estmtId", Type:"Text", SaveName:"estmtId", Hidden:"1"}, //견적ID
			{Header:"estmtSn", Type:"Int", SaveName:"estmtSn", Hidden:"1"}, //견적순번
			{Header:"estmtItmGropNo", Type:"Int", SaveName:"estmtItmGropNo", Hidden:"1"}, //견적품목그룹번호
			{Header:"crncUntCd", Type:"Text", SaveName:"crncUntCd", Hidden:"1"}, //통화
			{Header:"estmtItmUnprSn", Type:"Int", SaveName:"estmtItmUnprSn", Hidden:"1"}, //견적품목단가순번
			{Header:"rnumGroup", Type:"Text", SaveName:"rnumGroup", Hidden:"1"} //소계그룹핑용
		]
	});
	quotationSheet.SetMergeSheet(msBaseColumnMerge);
	quotationSheet.SetHeaderMode({"ColMove":0, "Sort":0});	// sort 사용 안함, 201221 컬럼 이동 미사용

    var uploadInit = {
			"viewType": "icon",
			"iconMode": "detail",
			"useDragDrop": false
    }
    $("#fileDtlData").addIbUpload(uploadInit, null, false, "ibsDetail", null, false);
    $('#fileDtlData').IBUpload('dropTarget', "ibsDetail");

	//set event
    fnSetEvent();

	//견적구분/견적ID/견적순번 존재시 기등록 정보 조회
	if ($("#estmtDivCd").val() !== "" && $("#estmtId").val() !== "" && $("#estmtSn").val() !== "") {
	    //견적정보 조회
		retrieveQuotationBaseInfo();
	} else {
		//최초등록
		fnAuth("");
	}
};

//견적상태별 버튼 및 항목 제어
function fnAuth(obj) {
	/*obj
	Q00 : 생성
	Q10 : 고객확정
	Q98 : 폐기*/
	if (obj === "save") { //저장
		//radio disabled 항목 해제
		$("input:radio[name='txamtDivCd']").prop("disabled",false); //세액구분

		//select disabled 항목 해제
		$("#srvcDomnCd").prop("disabled",false); //서비스도메인
		$("#crncUntCd").prop("disabled",false); //통화
	} else if (obj === "") { //최초등록
		//default set
		$("#estmtSnTd").text("1"); //버전
		$("#estmtStatNm").val("<spring:message code='word.create'/>"); //상태
		$("#rgsnUserNm").val('<c:out value="${principal.egovUserVO.userNm}"/>' + "(" + '<c:out value="${principal.egovUserVO.userId}"/>' + ")"); //등록사용자
		$("#rgsnDttmView").val(moment().format("YYYY-MM-DD HH:mm")); //등록일시

		//하단 버튼바 뜨면 comment 높이 변경
		document.getElementById("cmtCm").style.margin = "5px 0 20px 0";

		//button
		$("#btnSave").show();
		$("#btnCustPopup").show();
		$("#btnAddRow").show();
		$("#btnDeleteRow").show();
		$("#btnCopy").show();
		$("#btnLeftDiv").show();
		$("#btnLeftDiv_line").show();
		$("#btnExcel").show();
		$("#btnExcel_line").show();
	} else {
		var userId = '<c:out value="${principal.egovUserVO.userId}"/>';
		var rgsnUserId = $("#rgsnUserId").val();
		var atchmnflNo = $("#emailAtchmnflNo").val();
		var crncUntCd = $("#crncUntCd").val(); //통화
		var txamtDivCd = $("input:radio[name='txamtDivCd']:checked").val(); //세액구분

		if (atchmnflNo !== "") {
			$("#fileDataTd").show();
		}

		if (rgsnUserId === userId) { //본인이 등록한 견적만 수정 가능
			if (obj === "Q98") { //폐기
				//그리드 수정불가
				quotationSheet.SetEditable(0);

				//button hidden
				fnItemPopupButtonHidden("1");

				//select disabled
				$("#crncUntCd").prop("disabled",true); //통화
				$("#srvcDomnCd").prop("disabled",true); //서비스도메인

				//radio disabled
				//$("input:radio[name='txamtDivCd']").prop("disabled",true); //세액구분
				$("#txamtDivCdTd").hide();
				$("#txamtDivCdTdView").show();

				//input readonly
				$("#estmtTit").prop("readonly",true); //제목
				$("#adtlSndgEmail").prop("readonly",true); //추가 발송 E-Mail
				$("#cm").prop("readonly",true); //comment
			} else {
				if (crncUntCd !== "KRW") {
					//외화 세액구분 세액별도로 fix
					$("input:radio[name='txamtDivCd']:input[value='E']").prop("checked",true); //세액구분
					//$("input:radio[name='txamtDivCd']").prop("disabled",true); //세액구분
					$("#txamtDivCdTd").hide();
					$("#txamtDivCdTdView").show();
				} else {
					$("#txamtDivCdTd").show();
					$("#txamtDivCdTdView").hide();
					$("input:radio[name='txamtDivCd']").prop("disabled",false); //세액구분
				}

				//select disabled
				$("#srvcDomnCd").prop("disabled",true); //서비스도메인

				//최종견적여부
				var lastEstmtYn = $("#lastEstmtYn").val();
				if (lastEstmtYn === "Y") {
					//그리드 수정가능
					quotationSheet.SetEditable(1);

					//button hidden
					fnItemPopupButtonHidden("0");

					//select disabled 항목 해제
					$("#crncUntCd").prop("disabled",false); //통화

					//input readonly 항목 해제
					$("#estmtTit").prop("readonly",false); //제목
					$("#adtlSndgEmail").prop("readonly",false); //추가 발송 E-Mail
					$("#cm").prop("readonly",false); //comment

					$("#rgsnUserTitle").hide();
					$("#rgsnUserValue").hide();
					$("#rgsnDttmTitle").hide();
					$("#rgsnDttmValue").hide();
					$("#modiUserTitle").show();
					$("#modiUserValue").show();
					$("#modiDttmTitle").show();
					$("#modiDttmValue").show();

					//button
					$("#btnSave").show(); //저장
					$("#btnDisposal").show(); //폐기
					$("#btnAddRow").show(); //행추가
					$("#btnDeleteRow").show(); //행삭제
					$("#btnCopy").show(); //견적복사
					$("#btnLeftDiv").show(); //견적복사
					$("#btnLeftDiv_line").show();
					$("#btnExcel").show(); //엑셀
					$("#btnExcel_line").show();

					$("#btnPdfCreate").show();

					if (atchmnflNo !== "") {
						var emailSndngYn = objCmmnCmbCodes["SRVC_DOMN_CD"].data[$("#srvcDomnCd").val()].atrb4;
						if ("Y" === emailSndngYn) {
							$("#btnMailSend").show();
						} else {
							$("#btnMailSend").hide();
						}
					}

					if (obj === "Q00") { //생성
						//button
						$("#btnCustConfirm").show(); //고객확정
					} else if (obj === "Q10") { //고객확정
						//button
						$("#btnOrdCreat").show(); //주문생성
					}
				} else {
					//그리드 수정불가
					quotationSheet.SetEditable(0);

					//button hidden
					fnItemPopupButtonHidden("1");

					//select disabled
					$("#crncUntCd").prop("disabled",true); //통화
					$("#srvcDomnCd").prop("disabled",true); //서비스도메인

					//radio disabled 항목 해제
					//$("input:radio[name='txamtDivCd']").prop("disabled",true); //세액구분
					$("#txamtDivCdTd").hide();
					$("#txamtDivCdTdView").show();

					//input readonly
					$("#estmtTit").prop("readonly",true); //제목
					$("#adtlSndgEmail").prop("readonly",true); //추가 발송 E-Mail
					$("#cm").prop("readonly",true); //comment

					//button
					//$("#btnPdfCreate").show();
					//$("#btnMailSend").show();
					$("#btnExcel").show();
					$("#btnExcel_line").show();
				}
			}
		} else {
			//그리드 수정불가
			quotationSheet.SetEditable(0);

			//button hidden
			fnItemPopupButtonHidden("1");

			//select disabled
			$("#crncUntCd").prop("disabled",true); //통화
			$("#srvcDomnCd").prop("disabled",true); //서비스도메인

			//radio disabled 항목 해제
			//$("input:radio[name='txamtDivCd']").prop("disabled",true); //세액구분
			$("#txamtDivCdTd").hide();
			$("#txamtDivCdTdView").show();

			//input readonly
			$("#estmtTit").prop("readonly",true); //제목
			$("#adtlSndgEmail").prop("readonly",true); //추가 발송 E-Mail
			$("#cm").prop("readonly",true); //comment
		}
	}
}

//button hidden
function fnItemPopupButtonHidden(obj) {
	for (var i = 0; i < quotationSheet.RowCount(); i++) {
		//col hidden
		quotationSheet.SetColHidden("itemPopup", obj);
	}
}

//event
function fnSetEvent() {
	$('#cm').keyup(function(){
		fnTextAreaLineLimit(this, 30);
    });

	//통화
	$("#crncUntCd").change(function() {
		var crncUntCd = this.value;
		var preCrncUntCd = $("#preCrncUntCd").val();
		var priceYn = "N";
	    var clearYn = "N";
		if (quotationSheet.RowCount() > 0) {
			if (crncUntCd !== "" && crncUntCd !== preCrncUntCd) {
				//통화에 해당하는 그리드 품목 단가가 등록되어 있는지 조회
				new CommonAjax("/ngs/order/retrieveQuotationItemGroupPriceCheck.do")
				.addParam({searchCrncUntCd: crncUntCd})
				.addParam(quotationSheet, undefined, {AllSave:1})
				.callback(function (resultData) {
					if (resultData.result === "S") {
						priceYn = "Y";
					}
				})
				.async(false)
				.execute();
			}

			if (priceYn === "Y") { //통화에 해당하는 품목 단가 존재
				if (confirm("<spring:message code='infm.change.crncy.amount.init'/>")) {//통화 변경시 금액정보가 초기화 됩니다. 진행하시겠습니까?
					clearYn = "Y";
				}
			} else { //통화에 해당하는 품목 단가 미존재
				//변경전 값으로 셋팅
				$("#crncUntCd").val($("#preCrncUntCd").val());
				return;
			}
		} else {
			clearYn = "Y";
		}

		if (clearYn === "Y") {
			var txamtDivCd = $("input:radio[name='txamtDivCd']:checked").val(); //세액구분

			$("#deleteYn").val("N");
			$("#copyYn").val("N");
			$("#preCrncUntCd").val(crncUntCd);


			//그리드 col set
			if (crncUntCd === "KRW") { //원화
				quotationSheet.SetColHidden("taxAmount", 0); //세액

				if (txamtDivCd === "E") { //세액별도
					//title 변경
					quotationSheet.SetCellValue(0, "unpr", "<spring:message code='word.input.prc.vat.exclude'/>", 0); //입력단가(VAT별도)
				} else { //세액포함
					//title 변경
					quotationSheet.SetCellValue(0, "unpr", "<spring:message code='word.input.prc.vat.include'/>", 0); //입력단가(VAT포함)
				}

				$("#txamtDivCdTd").show();
				$("#txamtDivCdTdView").hide();

				$("input:radio[name='txamtDivCd']").prop("disabled",false); //세액구분

				//원화:정수
				quotationSheet.SetColProperty(0, "unpr", {Type:"AutoSum", Align:"Right", MinWidth:120, KeyField:"1", Format:"#,##0", EditPointCount:0, MaximumValue:999999999999999, ColMerge:"0"});
			} else { //외화
				//col hidden
				quotationSheet.SetColHidden("taxAmount", 1); //세액



				//title 변경
				quotationSheet.SetCellValue(0, "unpr", "<spring:message code='word.input.prc.vat.exclude'/>", 0); //입력단가\n(VAT별도)

				//외화:소수 둘째자리
				quotationSheet.SetColProperty(0, "unpr", {Type:"AutoSum", Align:"Right", MinWidth:120, KeyField:"1", Format:"#,##0.00", EditPointCount:2, MaximumValue:999999999999999.99, ColMerge:"0"});

				//외화 세액구분 세액별도로 fix
				$("#txamtDivCdTd").hide();
				$("#txamtDivCdTdView").show();

				$("input:radio[name='txamtDivCd']:input[value='E']").prop("checked",true); //세액구분
				$("#txamtDivCdTdView").text("<spring:message code='word.tax.amount.exclude'/>"); //세액별도


				$("input:radio[name='txamtDivCd']").prop("disabled",true); //세액구분
			}

			//금액정보 초기화
			fnClearUnpr(crncUntCd);
		} else {
			//변경전 값으로 셋팅
			$("#crncUntCd").val($("#preCrncUntCd").val());
		}
	});

	//세액구분
	$("#txamtDivCdUl").change(function() {
		var crncUntCd = $("#crncUntCd").val(); //통화
		var txamtDivCd = $("input:radio[name='txamtDivCd']:checked").val(); //세액구분

		$("#deleteYn").val("N");
		$("#copyYn").val("N");
		$("#preTxamtDivCd").val(txamtDivCd);

		//그리드 col set
		if (crncUntCd === "KRW") { //원화
			quotationSheet.SetColHidden("taxAmount", 0); //세액

			if (txamtDivCd === "E") { //세액별도
				$("#txamtDivCdTdView").text("<spring:message code='word.tax.amount.exclude'/>"); //세액별도

				//title 변경
				quotationSheet.SetCellValue(0, "unpr", "<spring:message code='word.input.prc.vat.exclude'/>", 0); //입력단가(VAT별도)
			} else { //세액포함
				$("#txamtDivCdTdView").text("<spring:message code='word.tax.amount.include'/>"); //세액포함

				//title 변경
				quotationSheet.SetCellValue(0, "unpr", "<spring:message code='word.input.prc.vat.include'/>", 0); //입력단가(VAT포함)
			}
		} else { //외화
			$("#txamtDivCdTdView").text("<spring:message code='word.tax.amount.exclude'/>"); //세액별도

			//col hidden
			quotationSheet.SetColHidden("taxAmount", 1); //세액

			//title 변경
			quotationSheet.SetCellValue(0, "unpr", "<spring:message code='word.input.prc.vat.exclude'/>", 0); //입력단가\n(VAT별도)
		}

		for (var row = quotationSheet.GetDataFirstRow(); row <= quotationSheet.GetDataLastRow(); row++) {
			fnCalRowAmount(row);
		}

		//금액정보 초기화
		fnCalAmount();
	});

	//button
	//고객검색팝업 호출
	$("#btnCustPopup").click(function() {
		fnRetrieveCstmrPopup({
			callback : 'fnCallBackCustPopup',
			optionCheckCnt : '1',
			setCustStatCd : '10',
		});
    });

	//고객확정
	$("#btnCustConfirm").click(function() {
		fnUpdate("C");
    });
	//폐기
	$("#btnDisposal").click(function() {
		fnUpdate("D");
    });
	//주문생성
	$("#btnOrdCreat").click(function() {
    	fnOrdCreat();
    });
	//PDF제작
	$("#btnPdfCreate").click(function() {
		fnPdfCreate();
    });
	//메일발송
	$("#btnMailSend").click(function() {
		fnMailSend();
    });
	//저장
	$("#btnSave").click(function() {
		fnSave();
    });

	//견적복사
	$("#btnCopy").click(function() {
		var custId = $("#custId").val();
		if (custId === null || custId === "") {
			var msgArg1 = "<spring:message code='word.ngs.cstmr.nm'/>";//고객
	        alert("<spring:message code='infm.item.select' arguments='"+msgArg1+"'/>");//{0}을(를) 선택하여 주십시오.
			return;
		}
		var crncUntCd = $("#crncUntCd").val();
		if (crncUntCd === null || crncUntCd === "") {
			var msgArg1 = "<spring:message code='word.crncy'/>";//통화
	        alert("<spring:message code='infm.item.select' arguments='"+msgArg1+"'/>");//{0}을(를) 선택하여 주십시오.
			return;
		}

		var copyYn = "N";
		if (quotationSheet.GetDataRows() > 0) {
			if (confirm("<spring:message code='infm.quotation.copy.info.init.process'/>")) {//견적복사 진행시 입력한 품목정보가 초기화 됩니다. 진행하시겠습니까?
				copyYn = "Y";
			}
		} else {
			copyYn = "Y";
		}

		if (copyYn === "Y") {
	  		//견적조회 팝업
	  		fnRetrieveQuotationListPopup("fnCallBackQuotationListPopup", "N", "", "", crncUntCd, "Q10"); //견적상태=Q10(고객확정)
		}
    });

	//행추가
	$('#btnAddRow').click(function() {
		var custId = $("#custId").val();
		if (custId === null || custId === "") {
			var msgArg1 = "<spring:message code='word.ngs.cstmr.nm'/>";//고객
	        alert("<spring:message code='infm.item.select' arguments='"+msgArg1+"'/>");//{0}을(를) 선택하여 주십시오.
	        $("#btnCustPopup").focus(); //2019-05-13[문지환D] 포커스이동추가
			return;
		}
		var crncUntCd = $("#crncUntCd").val();
		if (crncUntCd === null || crncUntCd === "") {
			var msgArg1 = "<spring:message code='word.crncy'/>";//통화
	        alert("<spring:message code='infm.item.select' arguments='"+msgArg1+"'/>");//{0}을(를) 선택하여 주십시오.
	        $("#crncUntCd").focus();
			return;
		}

		//No + 1
		/*
		var no = 0;
		for (var i = 0; i < quotationSheet.RowCount(); i++) {
			var rnum = quotationSheet.GetCellValue(i + 1, "rnum");
			if (no < rnum) {
				no = rnum;
			}
		}
		no = parseInt(no, 10) + 1;
		*/
		var no = 0;
	   	var row = quotationSheet.GetDataLastRow();
	   	if (row < 0) {
	   		no = 1;
	   	} else {
	   		no = parseInt(quotationSheet.GetCellValue(row-1, "rnum"), 10) + 1;
	   	}

		var data = [];
		data.push({"ibStatus":"I"
			      ,"ibCheck":1
			      ,"rnum":no
			      ,"rnumGroup":no
			      ,"qnt":1
			      ,"itmQnt":1
			      ,"crncUntCd":crncUntCd});

		quotationSheet.ShowSubSum([{"StdCol":"rnum"
								   //,"SumCols":"10"
								   ,"SumCols":quotationSheet.SaveNameCol("unpr")
						           ,"Sort":0
						           ,"CaptionCol":2
						           ,"CaptionText":"%s"}]);
		quotationSheet.LoadSearchData({"data": data}, {"Append":"1", Sync:1});
    });

	//행삭제
	$("#btnDeleteRow").click(function() {
		var deleteRow = "";
		var rnumGroupList = [];
		for (var i = 0; i < quotationSheet.RowCount(); i++) {
			var cnt = 0;
			var row = i + 1;
			var ibCheck = quotationSheet.GetCellValue(row, "ibCheck");
			var rnumGroup = quotationSheet.GetCellValue(row, "rnumGroup");
			if (ibCheck === 1) {
				if (deleteRow === "") {
					deleteRow = row;
				} else {
					deleteRow = deleteRow + "|" + row;
				}

				if ($.inArray(rnumGroup, rnumGroupList) === -1) {
					rnumGroupList.push(rnumGroup);
			    }
			}
		}
		quotationSheet.RowDelete(deleteRow);

		var deleteSubRow = "";
		var deleteRnumGroup = [];
		for (var i = 0; i < rnumGroupList.length; i++) {
			var cnt = 0;
			for (var k = 0; k < quotationSheet.RowCount(); k++) {
				if (quotationSheet.GetCellValue(k + 1, "rnumGroup") == rnumGroupList[i]) {
					cnt++;
				}
			}

			if (cnt === 1) {
				for (var k = 0; k < quotationSheet.RowCount(); k++) {
					var row = k + 1;
					if (quotationSheet.GetCellValue(k + 1, "rnumGroup") == rnumGroupList[i]) {
						if (deleteSubRow === "") {
							deleteSubRow = row;
						} else {
							deleteSubRow = deleteSubRow + "|" + row;
						}
					}
				}
			}
		}
		quotationSheet.RowDelete(deleteSubRow);

		if (deleteRow !== "") {
			$("#deleteYn").val("Y");
		}

		// 200731 견적 품목 행삭제 시, Quoted Price / 견적명세 Total Amount 불일치 오류 수정
		fnCalAmount();
	});
	//엑셀다운
	$("#btnExcel").click(function() {
		var param = {FileName:"<spring:message code='word.estmt.dtls'/>.xlsx", "AutoSizeColumn":"1", "HiddenColumn":"1"};
		quotationSheet.Down2Excel(param);
    });

	//버전
	$("#selectEstmtSn").change(function() {
		//all button hide
		fnAllButtonHide();

		//선택한 버전으로 재조회
		$("#estmtSn").val(this.value);
		retrieveQuotationBaseInfo();
	});
}

//고객명 팝업 콜백
function fnCallBackCustPopup(result, sSheetId, nRow) {
	$("#custId").val(result[0].custId);
	$("#custView").val(result[0].custNm + "(" + result[0].custId + ")");
	$("#email1").val(result[0].custReprsntEmil);
	$("#natcodeNm").val(result[0].inttCntyNm);
	$("#organization").val(result[0].inttNm);

	//고객에 해당하는 통화코드 목록 조회
	fnRetrieveCrncUntList();
}

//견적정보_고객상세조회 팝업
function fnCustPopup() {
	var custId = $("#custId").val();
	if (custId !== "") {
		retrieveUserInfoPopup(custId);
	}
}

//all button hide
function fnAllButtonHide() {
	$("#btnCustConfirm").hide();
	$("#btnDisposal").hide();
	$("#btnOrdCreat").hide();
	$("#btnPdfCreate").hide();
	$("#btnMailSend").hide();
	$("#btnSave").hide();
	$("#btnAddRow").hide();
	$("#btnDeleteRow").hide();
	$("#btnCopy").hide();
	$("#btnLeftDiv").hide();
	$("#btnLeftDiv_line").hide();
	$("#btnExcel").hide();
	$("#btnExcel_line").hide();
}

//견적정보_조회
function retrieveQuotationBaseInfo() {
	new CommonAjax("/ngs/order/retrieveQuotationBaseInfo.do")
	.addParam({"estmtDivCd":$("#quotationForm #estmtDivCd").val(), "estmtId":$("#quotationForm #estmtId").val(), "estmtSn":$("#quotationForm #estmtSn").val()})
	.callback(function (resultData) {
		fnSetData(resultData.result);
	})
	.execute();
}

//견적정보_조회 후 셋팅
function fnSetData(result) {
	//폼 전체 셋팅
	IBS_CopyJson2Form({"quotationForm" : result}, "quotationForm");
	$("#preEstmtTit").val(result.estmtTit);
	$("#preCrncUntCd").val(result.crncUntCd);
	$("#preTxamtDivCd").val(result.txamtDivCd);
	$("#preAdtlSndgEmail").val(result.adtlSndgEmail);
	$("#cm").val(result.cm);
	$("#preCm").val(result.cm);
	preEstmtRm = nullString(result.estmtRm);	// 201028 원 견적 Remark
	$("#selectEstmtSn").val(result.estmtSn);
	$("#emailSrvcDomnCd").val(result.srvcDomnCd);
	$("#emailAtchmnflNo").val(result.atchmnflNo);

	$("#crncUntCdHidden").val(result.crncUntCd);
	$("#txamtDivCdHidden").val(result.txamtDivCd);
	var mainTitle = "<spring:message code='word.estmt.creat'/>" + " - " + result.estmtId;
	$("#mainTitle").text(mainTitle);

	$("#rgsnUserNm").val(result.rgsnUserNm + "(" + result.rgsnUserId + ")");
	$("#modiUserNm").val(result.modiUserNm + "(" + result.modiUserId + ")");

	//radio
	$("input:radio[name='txamtDivCd']:input[value='"+result.txamtDivCd+"']").prop("checked",true); //세액구분

	if (result.txamtDivCd === "E") {
		$("#txamtDivCdTdView").text("<spring:message code='word.tax.amount.exclude'/>"); //세액별도
	} else {
		$("#txamtDivCdTdView").text("<spring:message code='word.tax.amount.include'/>"); //세액포함
	}

	//고객에 해당하는 통화코드 목록 조회
	fnRetrieveCrncUntList();

	//select
	$("select[name=crncUntCd]").val(result.crncUntCd).prop("selected", true);
	$("select[name=crncUntCd]").trigger("change");

	//버전 목록 조회
	fnRetrieveEstmtSnList();

	//파일 셋팅
	CommonRetrieveAtchmnFile("fileDtlData", {"atchmnflNo": result.atchmnflNo});

    //견적품목상세 목록 조회
	fnRetrieveList();
}

//고객에 해당하는 통화코드 목록 조회
function fnRetrieveCrncUntList() {
    var codes = new CommonSheetComboOthers("/ngs/order/retrieveComCmmnCrncUntCdCombo.do")
    .addParam({"custId":$("#custId").val(), "cmmnClCd":"CRNC_UNT_CD"})
    .addCombo({"resultCombo": {"codeColumn": "cmmnCd", "textColumn": "cmmnCdNm"}})
    .execute();

    custCrncUntCdList = codes.resultCombo.ComboCode.split("|");
//    $("input:radio[name='txamtDivCd']").prop("disabled",false); //세액구분
}

//버전 목록 조회
function fnRetrieveEstmtSnList() {
	$("#selectEstmtSn").empty();
    var codes = new CommonSheetComboOthers("/ngs/order/retrieveEstmtSnCombo.do")
    .addParam({"estmtDivCd":$("#estmtDivCd").val(), "estmtId":$("#estmtId").val()})
    .addCombo({"resultCombo": {"codeColumn": "estmtSn", "textColumn": "estmtSn"}})
    .execute();
    $("#selectEstmtSn").addCommonSelectOptions({
        "comboData":codes["resultCombo"],
        "defaultValue": $("#estmtSn").val(),
    });
}

//견적품목상세 목록 조회
function fnRetrieveList() {
	new CommonAjax("/ngs/order/retrieveQuotationDetailList.do")
	.addParam({"estmtDivCd":$("#estmtDivCd").val(), "estmtId":$("#estmtId").val(), "estmtSn":$("#estmtSn").val()})
	.callback(function (resultData) {
		quotationSheet.ShowSubSum([{"StdCol":"rnum"
								   //,"SumCols":"10"
								   ,"SumCols":quotationSheet.SaveNameCol("unpr")
						           ,"Sort":0
						           ,"CaptionCol":2
						           ,"CaptionText":"%s"}]);
		quotationSheet.LoadSearchData({"data": resultData.result});
	})
	.execute();
}

//금액정보 초기화
function fnClearUnpr(crncUntCd) {
	for (var row = quotationSheet.GetDataFirstRow(); row <= quotationSheet.GetDataLastRow(); row++) {
		if (crncUntCd === "KRW") { //원화
			quotationSheet.SetCellValue(row, "unpr", 0);
			quotationSheet.SetCellValue(row, "supplyPrice", "0");
			quotationSheet.SetCellValue(row, "taxAmount", "0");
			quotationSheet.SetCellValue(row, "totalAmount", "0");
		} else { //외화
			quotationSheet.SetCellValue(row, "unpr", 0.00);
			quotationSheet.SetCellValue(row, "supplyPrice", "0.00");
			quotationSheet.SetCellValue(row, "taxAmount", "0.00");
			quotationSheet.SetCellValue(row, "totalAmount", "0.00");
		}
	}

	fnCalAmount();
}

//입력단가 수정시 공급가액/세액/총금액 계산
function fnCalRowAmount(row) {
	if (row > 0) {
		var crncUntCd = $("#crncUntCd").val(); //통화
		var txamtDivCd = $("input:radio[name='txamtDivCd']:checked").val() //세액구분

		var itmQnt = quotationSheet.GetCellValue(row, "itmQnt"); //품목수량
		var unpr = quotationSheet.GetCellValue(row, "unpr"); //입력단가
		//var rnumGroup = quotationSheet.GetCellValue(row - 1, "rnumGroup");

		var supplyPrice = 0; //공급가액(공급대가)
		var taxAmount = 0; //세액
		var totalAmount = 0; //총액

		if (crncUntCd === "KRW") { //원화
			if (txamtDivCd === "E") { //세액별도
				//공급가액 = 입력단가 * 수량
				supplyPrice = Math.round(unpr * itmQnt);

				//세액 = 공급가액 * 0.1
				taxAmount = Math.round(supplyPrice * 0.1);

				//총액 = 공급가액 + 세액
				totalAmount = supplyPrice + taxAmount;
			} else { //세액포함
				//총액 = 단가 * 수량
				totalAmount = unpr * itmQnt;

				//공급가액 = 총액 / 11 * 10
				supplyPrice = Math.round(totalAmount / 11.0 * 10.0);

				//세액 = 총액- 공급가액
				taxAmount = Math.round(totalAmount - supplyPrice);

			}
			quotationSheet.SetCellValue(row, "supplyPrice", numberWithCommas(supplyPrice), 0);
			quotationSheet.SetCellValue(row, "taxAmount", numberWithCommas(taxAmount), 0);
			quotationSheet.SetCellValue(row, "totalAmount", numberWithCommas(totalAmount), 0);
			//quotationSheet.SetCellValue(row, "ibStatus", "R", 0);
		} else { //외화
			//공급대가 = 입력단가 * 수량
			supplyPrice = (parseFloat(unpr) * itmQnt).toFixed(2);

			//총액 = 공급대가
			totalAmount = supplyPrice;

			quotationSheet.SetCellValue(row, "supplyPrice", numberWithCommas(supplyPrice), 0);
			quotationSheet.SetCellValue(row, "taxAmount", 0, 0);
			quotationSheet.SetCellValue(row, "totalAmount", numberWithCommas(totalAmount), 0);
		}
	}
}

//입력단가 수정시 소계/합계 재계산
function fnCalAmount() {
	var crncUntCd = $("#crncUntCd").val(); //통화
	var txamtDivCd = $("input:radio[name='txamtDivCd']:checked").val() //세액구분

	var sumGropUnpr = 0;
	var sumSupplyPrice = 0;
	var sumTaxAmount = 0;
	var sumTotalAmount = 0;

	var subSumRowStr = quotationSheet.FindSubSumRow();

	if (subSumRowStr !== "") {
		var rowList = subSumRowStr.split("|");

		var subSumStartRow = 0;
		var subSumGropUnpr = 0; //그룹단가
		var subSumSupplyPrice = 0; //공급가액
		var subSumTaxAmount = 0; //세액
		var subSumTotalAmount = 0; //총금액

		for (var i = 0; i < rowList.length; i++) {
			var row = rowList[i];

			if (i === 0) {
				subSumStartRow = quotationSheet.GetDataFirstRow();
			} else {
				subSumStartRow = parseInt(rowList[i-1], 10) + 1;
			}

			var qnt = quotationSheet.GetCellValue(row - 1, "qnt"); //수량
			var rnumGroup = quotationSheet.GetCellValue(row - 1, "rnum");

			var gropUnpr = 0; //그룹단가
			var supplyPrice = 0; //공급가액
			var taxAmount = 0; //세액
			var totalAmount = 0; //총금액

			for (var dataRow = subSumStartRow; dataRow < row; dataRow++) {
				var strSupplyPrice = quotationSheet.GetCellValue(dataRow, "supplyPrice").replace(/,/g, ''); //공급가액
				var strTaxAmount = quotationSheet.GetCellValue(dataRow, "taxAmount").replace(/,/g, ''); //세액
				var strTotalAmount = quotationSheet.GetCellValue(dataRow, "totalAmount").replace(/,/g, ''); //총금액

				if ("KRW" === crncUntCd) {
					gropUnpr += parseInt(strSupplyPrice, 10); //그룹단가
					supplyPrice += parseInt(strSupplyPrice, 10); //공급가액
					taxAmount += parseInt(strTaxAmount, 10); //세액
					totalAmount += parseInt(strTotalAmount, 10); //총금액
				} else {
					gropUnpr += parseFloat(strSupplyPrice); //그룹단가
					supplyPrice += parseFloat(strSupplyPrice); //공급가액
					taxAmount += parseFloat(strTaxAmount); //세액
					totalAmount += parseFloat(strTotalAmount); //총금액
				}
			}

			subSumGropUnpr = gropUnpr;
			subSumSupplyPrice = supplyPrice * qnt;
			subSumTaxAmount = taxAmount * qnt;
			subSumTotalAmount = totalAmount * qnt;

			if (crncUntCd === "KRW") { //원화
				sumGropUnpr += parseFloat(subSumGropUnpr);
				sumSupplyPrice += parseFloat(subSumSupplyPrice);
				sumTaxAmount += parseFloat(subSumTaxAmount);
				sumTotalAmount += parseFloat(subSumTotalAmount);
			} else {
				subSumGropUnpr = subSumGropUnpr.toFixed(2);
				subSumSupplyPrice = subSumSupplyPrice.toFixed(2);
				subSumTaxAmount = subSumTaxAmount.toFixed(2);
				subSumTotalAmount = subSumTotalAmount.toFixed(2);

				sumGropUnpr = (parseFloat(sumGropUnpr) + parseFloat(subSumGropUnpr)).toFixed(2);
				sumSupplyPrice = (parseFloat(sumSupplyPrice) + parseFloat(subSumSupplyPrice)).toFixed(2);
				sumTaxAmount = (parseFloat(sumTaxAmount) + parseFloat(subSumTaxAmount)).toFixed(2);
				sumTotalAmount = (parseFloat(sumTotalAmount) + parseFloat(subSumTotalAmount)).toFixed(2);
			}

			//소계 set
			quotationSheet.SetCellValue(row, "rnumGroup", rnumGroup);

			quotationSheet.SetCellValue(row, "gropUnpr", numberWithCommas(subSumGropUnpr));
			quotationSheet.SetCellValue(row, "supplyPrice", numberWithCommas(subSumSupplyPrice));
			quotationSheet.SetCellValue(row, "taxAmount", numberWithCommas(subSumTaxAmount));
			quotationSheet.SetCellValue(row, "totalAmount", numberWithCommas(subSumTotalAmount));
		}
	}

	//합계
	var sumRow = quotationSheet.FindSumRow();
	quotationSheet.SetCellValue(sumRow, "gropUnpr", numberWithCommas(sumGropUnpr));
	quotationSheet.SetCellValue(sumRow, "supplyPrice", numberWithCommas(sumSupplyPrice));
	quotationSheet.SetCellValue(sumRow, "taxAmount", numberWithCommas(sumTaxAmount));
	quotationSheet.SetCellValue(sumRow, "totalAmount", numberWithCommas(sumTotalAmount));

	//견적금액
	$("#estmtAmt").val(sumTotalAmount);
}

//숫자콤마
function numberWithCommas(x) {
	var parts = x.toString().split(".");
	if (parts[0].length > 3) {
		return parts[0].replace(/\B(?=(\d{3})+(?!\d))/g, ",") + (parts[1] ? "." + parts[1] : "");
	} else {
		return x;
	}
}

//OnRowSearchEnd
function quotationSheet_OnRowSearchEnd(row) {
	var crncUntCd = quotationSheet.GetCellValue(row, "crncUntCd");
	if (crncUntCd === "KRW") {
		//원화:정수
		quotationSheet.InitCellProperty(row, "unpr", {Type:"AutoSum", Align:"Right", MinWidth:120, KeyField:"1", Format:"#,##0", EditPointCount:0, MaximumValue:999999999999999, ColMerge:"0"});
	} else {
		//외화:소수 둘째자리
		quotationSheet.InitCellProperty(row, "unpr", {Type:"AutoSum", Align:"Right", MinWidth:120, KeyField:"1", Format:"#,##0.00", EditPointCount:2, MaximumValue:999999999999999.99, ColMerge:"0"});
	}

	fnCalRowAmount(row);
}

//OnSearchEnd
function quotationSheet_OnSearchEnd(code, msg, stCode, stMsg, responseText) {
	if (code === 0) {
		var crncUntCd = $("#crncUntCd").val(); //통화
		var txamtDivCd = $("input:radio[name='txamtDivCd']:checked").val(); //세액구분
		if (crncUntCd === "KRW") { //원화
			if (txamtDivCd === "E") { //세액별도
				//title 변경
				quotationSheet.SetCellValue(0, "unpr", "<spring:message code='word.input.prc.vat.exclude'/>", 0); //입력단가(VAT별도)
			} else { //세액포함
				//title 변경
				quotationSheet.SetCellValue(0, "unpr", "<spring:message code='word.input.prc.vat.include'/>", 0); //입력단가(VAT포함)
			}
		} else { //외화
			//col hidden
			quotationSheet.SetColHidden("taxAmount", 1); //세액

			//title 변경
			quotationSheet.SetCellValue(0, "unpr", "<spring:message code='word.input.prc.vat.exclude'/>", 0); //입력단가\n(VAT별도)
		}

		//견적상태별 버튼 및 항목 제어
		fnAuth($("#estmtStatCd").val());
		fnCalAmount();
	}
}

//OnAfterEdit
function quotationSheet_OnAfterEdit(row, col) {
	var saveName = quotationSheet.ColSaveName(col);

	if (saveName === "itmQnt" || saveName === "unpr") {
		fnCalRowAmount(row);
	}

	if (saveName === "qnt" || saveName === "itmQnt" || saveName === "unpr") {
		fnCalAmount();
	}
}

//OnAfterPaste
function quotationSheet_OnAfterPaste() {
	var saveName = "";
	var selRow = quotationSheet.GetSelectRow();
	var selCol = quotationSheet.GetSelectCol();
	if (selCol > 0) {
		saveName = quotationSheet.ColSaveName(selCol);
	}

	var filterNumArr = [];
	var saveData = quotationSheet.GetSaveJson({
		"StdCol":"ibCheck",
		"StdColValue" : "1",
		"ValidKeyField" : 0
	});
	saveData.data.filter(function(v){
		filterNumArr.push(v.rnum);
	});
	let filterNum = Array.from(new Set(filterNumArr));

	for (var row = 1; row <= filterNum.length; row++) {
		var rnumValue = '';
		var groupRirstRow = '';
		for(var i = quotationSheet.GetDataFirstRow(); i <= quotationSheet.GetDataLastRow(); i++){
			if(filterNum[row-1] == quotationSheet.GetCellValue(i,"rnum")){
				rnumValue = quotationSheet.GetCellValue(i,"qnt");
				groupRirstRow = i;
				break;
			};
		}
		mergeStartRow = parseInt(quotationSheet.GetMergedStartCell(groupRirstRow, "qnt").split(",")[0]);
		mergeEndRow = parseInt(quotationSheet.GetMergedEndCell(groupRirstRow, "qnt").split(",")[0]);
		for (var j=mergeStartRow; j<=mergeEndRow; j++) {
			quotationSheet.SetCellValue(j, "qnt", rnumValue);
		}
	}

		for (var row = selRow; row <= quotationSheet.GetDataLastRow(); row++) {
			fnCalRowAmount(row);
		}

		fnCalAmount();
}

function quotationSheet_OnFillData() {
	var saveName = "";
	var selRow = quotationSheet.GetSelectRow();
	var selCol = quotationSheet.GetSelectCol();
	if (selCol > 0) {
		saveName = quotationSheet.ColSaveName(selCol);
	}

	//if (saveName === "itmQnt" || saveName === "unpr") {
		for (var row = selRow; row <= quotationSheet.GetDataLastRow(); row++) {
			fnCalRowAmount(row);
		}
	//}

	//if (saveName === "qnt" || saveName === "itmQnt" || saveName === "unpr") {
		fnCalAmount();
	//}
}

//OnClick
function quotationSheet_OnClick(row, col) {
	if (row > 0) {
		var saveName = quotationSheet.ColSaveName(col);
	  	if (saveName === "itemPopup") {
	  		//소계행 팝업 호출 제외
	  		var callYn = "Y";
	  		var rowList = quotationSheet.FindSubSumRow();
	  		if (rowList !== "") {
	  			for (var i = 0; i < rowList.split("|").length; i++) {
	  				var clickRow = rowList.split("|")[i];
					if (clickRow == row) {
						callYn = "N";
					}
	  			}
	  		}

	  		if (callYn === "Y") {
		  		//견적품목정보조회 팝업
		  		fnRetrieveQuotationItemListPopup("fnCallBackQuotationItemListPopup", "Y", "", row, $("#crncUntCd").val());
	  		}
	  	} else if(saveName === "ibCheck"){
			  fnCalRowAmount(row);
			  fnCalAmount();
		}
	}
}

//견적품목정보조회 팝업 콜백
function fnCallBackQuotationItemListPopup(result, sSheetId, nRow) {
	var rnum = quotationSheet.GetCellValue(nRow, "rnum");
	var qnt = quotationSheet.GetCellValue(nRow, "qnt"); //수량
	var itmGropNm = quotationSheet.GetCellValue(nRow, "itmGropNm"); //표시품명
	var estmtItmCd = quotationSheet.GetCellValue(nRow, "estmtItmCd"); //품명코드
	var estmtItmGropNo = quotationSheet.GetCellValue(nRow, "estmtItmGropNo"); //견적품목그룹번호
	for (var i = 0; i < result.length; i++) {
		//이미 선택한 품목 제외
		var dupYn = "N";
		for (var k = 0; k < quotationSheet.RowCount(); k++) {
			var gridRnum = quotationSheet.GetCellValue(k + 1, "rnum");
			var gridEstmtItmCd = quotationSheet.GetCellValue(k + 1, "estmtItmCd");
			var gridEstmtItmGropNo = quotationSheet.GetCellValue(k + 1, "estmtItmGropNo");
			if (rnum === gridRnum && gridEstmtItmCd === result[i].estmtItmCd) {
				dupYn = "Y";
				break;
			}
		}

		if (dupYn === "N") {
			/*단건 선택시 표시*/
			if (result.length === 1 && itmGropNm === "") {
				itmGropNm = result[i].estmtItmCdNm;
			}

			var row;
			if (estmtItmGropNo === "" && estmtItmCd === "" && i === 0) {
				//그룹별 최초 등록 row 이면 수정
				row = nRow;
			} else {
				//입력
		        row = quotationSheet.DataInsert(parseInt(nRow, 10) + i);
			}
			quotationSheet.SetCellValue(row, "rnum", rnum);
			quotationSheet.SetCellValue(row, "ibCheck", 1);
			quotationSheet.SetCellValue(row, "estmtItmGropNo", estmtItmGropNo);
			quotationSheet.SetCellValue(row, "itmGropNm", itmGropNm);
			quotationSheet.SetCellValue(row, "qnt", qnt);
			quotationSheet.SetCellValue(row, "estmtItmGropCdNm", result[i].estmtItmGropCdNm);
			quotationSheet.SetCellValue(row, "estmtItmCdNm", result[i].estmtItmCdNm);
			quotationSheet.SetCellValue(row, "estmtItmCd", result[i].estmtItmCd);
			quotationSheet.SetCellValue(row, "estmtItmStdrNm", result[i].estmtItmStdrNm);
			quotationSheet.SetCellValue(row, "itmQnt", 1);
			quotationSheet.SetCellValue(row, "unpr", result[i].unpr);
			quotationSheet.SetCellValue(row, "crncUntCd", result[i].crncUntCd);
			quotationSheet.SetCellValue(row, "estmtItmUnprSn", result[i].estmtItmUnprSn);

			quotationSheet_OnAfterEdit(row, quotationSheet.SaveNameCol("itmQnt"));
		}
	}
	quotationSheet.SetDataMerge(1); //셀 병합 처리
	fnCalAmount();
}

//견적품목정보조회 팝업 콜백
function fnCallBackQuotationListPopup(result, sSheetId, nRow) {
	$("#copyYn").val("Y");

	$("input:radio[name='txamtDivCd']:input[value='"+result[0].txamtDivCd+"']").prop("checked",true); //세액구분

	quotationSheet.RemoveAll();

	new CommonAjax("/ngs/order/retrieveQuotationDetailList.do")
	.addParam({"estmtDivCd":result[0].estmtDivCd, "estmtId":result[0].estmtId, "estmtSn":result[0].estmtSn})
	.callback(function (resultData) {
		quotationSheet.ShowSubSum([{"StdCol":"rnum"
								   //,"SumCols":"10"
								   ,"SumCols":quotationSheet.SaveNameCol("unpr")
						           ,"Sort":0
						           ,"CaptionCol":2
						           ,"CaptionText":"%s"}]);
		quotationSheet.LoadSearchData({"data": resultData.result});
	})
	.execute();
}

function fnUpdate(obj) {
	/*obj=C : 고객확정
	  obj=D : 폐기*/
	$("#actionGubun").val(obj);
	var btnAction = "";
	if (obj === "C") {
		//변경내역 없으면 주문등록 화면으로 이동
		if (fnDataChangeYn()) {
			alert("<spring:message code='infm.data.save.after.process'/>"); //저장되지 않은 정보가 있습니다. 저장 후 진행하시기 바랍니다.
			return false;
		} else {
			btnAction = $("#btnCustConfirm").text();
		}
	} else if (obj === "D") {
		btnAction = $("#btnDisposal").text();
	}
	var confirmMsg = btnAction + "<spring:message code='cnfm.confirm'/>";
	new CommonAjax("/ngs/order/updateQuotationStatus.do")
	.addParam(quotationForm)
	.confirm(confirmMsg)
	.callback(function (resultData) {
		alert(resultData.message);
		if (resultData.result === "S") {
			//all button hide
			fnAllButtonHide();

			//조회
			$("#estmtDivCd").val(resultData.resultParam.estmtDivCd);
			$("#estmtId").val(resultData.resultParam.estmtId);
			$("#estmtSn").val(resultData.resultParam.estmtSn);
			retrieveQuotationBaseInfo();
		}
	})
	.execute();
}

//주문생성
function fnOrdCreat() {
	//고객 회계그룹통화 코드에 없는 통화 견적인 경우 에러 처리
	// (2020-03-05 손상길) 고객 회계그룹통화 코드에 없는 통화 처리 무시
	/*if (custCrncUntCdList.indexOf($("#crncUntCd").val()) == -1) {
		alert("<spring:message code='infm.estmt.invalid,crnc'/>"); //해당 고객의 회계그룹에 등록되어 있지 않은 통화입니다.
		return false;
	}*/

	//유럽법인 고객 주문 Block 처리
	if ($("#euCorpFlag").val() == "Y") {
		alert("<spring:message code='infm.eu.user.not.create'/>"); //EU user can not create order.
		return false;
	}

	//변경내역 없으면 주문등록 화면으로 이동
	if (fnDataChangeYn()) {
		alert("<spring:message code='infm.data.save.after.process'/>"); //저장되지 않은 정보가 있습니다. 저장 후 진행하시기 바랍니다.
		return false;
	} else {
		var estmtId = $("#estmtId").val();
		var estmtSn = $("#estmtSn").val();
		var custId = $("#custId").val();
		var custNm = $("#custNm").val();
		var srvcDomnCd = $("#srvcDomnCd").val();
		$('#frmMenu').append('<input type="hidden" name="estmtDivCd" value="P">'); 		        //견적구분(Q=견적서, P=Pre-Invoice)
		$('#frmMenu').append('<input type="hidden" name="estmtId" value="'+estmtId+'">');       //견적ID
		$('#frmMenu').append('<input type="hidden" name="estmtSn" value="'+estmtSn+'">');       //견적순번
		$('#frmMenu').append('<input type="hidden" name="custId" value="'+custId+'">');  		//고객ID
		$('#frmMenu').append('<input type="hidden" name="custNm" value="'+custNm+'">');  		//고객명
		$('#frmMenu').append('<input type="hidden" name="srvcDomnCd" value="'+srvcDomnCd+'">'); //서비스도메인
		$('#frmMenu').append('<input type="hidden" name="ordNo" value="">');
		fnMove("/ngs/order/retrieveNgsOrdRegistForm.do", "");
	}
}

//PDF제작
function fnPdfCreate() {
	/*
	if(quotationSheet.IsDataModified()){
		alert("<spring:message code='infm.not.saved.work.report'/>");//저장 되지 않은 정보가 있습니다. 저장 후 리포트 제작 하시기 바랍니다.
		var updateRows = quotationSheet.FindStatusRow("U").split(";");
		quotationSheet.SetSelectRow(updateRows[0]);
		return false;
	}*/
	if (fnDataChangeYn()) {
		alert("<spring:message code='infm.data.save.after.process'/>"); //저장되지 않은 정보가 있습니다. 저장 후 진행하시기 바랍니다.
		return false;
	} else {
		var sumData = quotationSheet.GetRowData(quotationSheet.FindSumRow());

		var subSumList = quotationSheet.FindSubSumRow().split("|");
		var subSumData = new Array();
		subSumList.forEach(function(data) {
			var rowData = quotationSheet.GetRowData(data);
			rowData.itmGropNm= quotationSheet.GetCellValue(data-1, "itmGropNm");
			rowData.qnt= quotationSheet.GetCellValue(data-1, "qnt");
			rowData.estmtItmStdrNm= quotationSheet.GetCellValue(data-1, "estmtItmStdrNm");
			subSumData.push(rowData);
		});

		$("#supplyPriceSum").val(sumData.supplyPrice);
		$("#totalSum").val(sumData.totalAmount);
		$("#vatSum").val(sumData.taxAmount);

		var confirmMsg = $("#btnPdfCreate").text() + "<spring:message code='cnfm.confirm'/>";
		new CommonAjax("/ngs/order/saveQuotationPdfCteate.do")
		.addParam(quotationForm)
		.addParam({"quotationSheet":{"data" : subSumData}})
		.addParam(sumData)
		.confirm(confirmMsg)
		.callback(function (resultData) {
			alert($("#btnPdfCreate").text() + "<spring:message code='infm.set'/>");

			if (resultData.result === "S") {
				//all button hide
				fnAllButtonHide();

				//조회
				retrieveQuotationBaseInfo();
			}
		})
		.execute();
	}
}

//메일발송
function fnMailSend() {
	if (fnDataChangeYn()) {
		alert("<spring:message code='infm.data.save.after.process'/>"); //저장되지 않은 정보가 있습니다. 저장 후 진행하시기 바랍니다.
		return false;
	} else {
    	$("#checkCnt").text("<spring:message code='cnfm.send.mail'/>");

		new CommonAjax("/ngs/order/saveQuotationMailSend.do")
		.addParam(quotationForm)
		.confirmDialog("divCreateDialog", {})
		.callback(function (resultData) {
			alert(resultData.message);
		})
		.execute();
	}
}

//저장
function fnSave() {
	if (fnValidation()) {
		fnAuth("save");
		var ajaxData = new CommonAjax("/ngs/order/saveQuotationCteate.do")
		.addParam(quotationForm)
		.confirm("<spring:message code='cnfm.save'/>")
		.callback(function (resultData) {
			alert(resultData.message);
			if (resultData.result === "S") {
				$('#frmMenu').append('<input type="hidden" name="estmtDivCd" value="'+resultData.resultParam.estmtDivCd+'">');
				$('#frmMenu').append('<input type="hidden" name="estmtId" value="'+resultData.resultParam.estmtId+'">');
				$('#frmMenu').append('<input type="hidden" name="estmtSn" value="'+resultData.resultParam.estmtSn+'">');
				fnMove("/ngs/order/retrieveQuotationCteateForm.do", "", "", "Y");
			}
		});

		if (quotationSheet.RowCount() > 0) {
			ajaxData.addParam(quotationSheet, undefined, {AllSave:1});
		}

		ajaxData.execute();
	}
}

//validation
function fnValidation() {
	var estmtTit = $("#estmtTit").val();
	if (estmtTit === "") {
		var msgArg = "<spring:message code='word.com.sj'/>";//제목
        alert("<spring:message code='infm.essntl.input' arguments='"+msgArg+"'/>");//{0}(은)는 필수 입력 항목 입니다.
		$("#estmtTit").focus();
        return false;
	}
	var srvcDomnCd = $("#srvcDomnCd").val();
	if (srvcDomnCd === "") {
		var msgArg = "<spring:message code='word.srvc.domn'/>";//서비스도메인
        alert("<spring:message code='infm.essntl.input' arguments='"+msgArg+"'/>");//{0}(은)는 필수 입력 항목 입니다.
		$("#srvcDomnCd").focus();
        return false;
	}
	var custId = $("#custId").val();
	if (custId === "") {
		var msgArg = "<spring:message code='word.ngs.cstmr.nm'/>";//고객
        alert("<spring:message code='infm.essntl.input' arguments='"+msgArg+"'/>");//{0}(은)는 필수 입력 항목 입니다.
		$("#custNm").focus();
        return false;
	}
	var crncUntCd = $("#crncUntCd").val();
	if (crncUntCd === "") {
		var msgArg = "<spring:message code='word.crncy'/>";//통화
        alert("<spring:message code='infm.essntl.input' arguments='"+msgArg+"'/>");//{0}(은)는 필수 입력 항목 입니다.
		$("#crncUntCd").focus();
        return false;
	}

	//추가 발송 E-Mail 체크
	var adtlSndgEmail = $("#adtlSndgEmail").val();
	if (adtlSndgEmail && !fnMultiEmailChecked(adtlSndgEmail)) {
		var msgArg = "<spring:message code='word.add.sndng.email'/>";//추가 발송 E-Mail
        alert("<spring:message code='infm.email.address.not.valid' arguments='"+msgArg+"'/>");//{0} 주소가 유효하지 않습니다.
		$("#adtlSndgEmail").focus();
		return false;
	}

	if (quotationSheet.RowCount() === 0) {
		alert("<spring:message code='infm.add.quotation.after.save'/>");//견적명세 추가 후 저장하시기 바랍니다.
        return false;
	}

	//수정모드에서 변경내역 있는지 체크
	var estmtId = $("#estmtId").val();
	if (estmtId !== "") {
		if (!fnDataChangeYn()) {
    		alert("<spring:message code='infm.no.change.data'/>");
			return false;
		}
	}

	return true;
}

//이메일 오류체크
function fnMultiEmailChecked(value) {
	if (value !== "") {
		for (var i = 0; i < value.split(",").length; i++) {
			if (!fnEmailChecked(value.split(",")[i])) {
				return false;
			}
		}
	}
	return true;
}
function fnEmailChecked(value) {
	var regex = /^([a-zA-Z0-9_\.\-\+])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
	return regex.test(value);
}

//변경내역 존재여부
function fnDataChangeYn() {
	//제목, 추가발송Email, 통화, 세액구분, comment 변경여부 체크
	var changeYn = "N";
	// 201028 견적 Remark 변경여부 체크 추가
	if ($("#estmtTit").val() !== $("#preEstmtTit").val()
			|| $("#crncUntCd").val() !== $("#crncUntCdHidden").val()
			|| $("input:radio[name='txamtDivCd']:checked").val() !== $("#txamtDivCdHidden").val()
			|| $("#adtlSndgEmail").val() !== $("#preAdtlSndgEmail").val()
			|| $("#cm").val() !== $("#preCm").val()
			|| $("#estmtRm").val() !== preEstmtRm) {
		changeYn = "Y";
	}

	//기본정보만 변경시 수정, 견적명세 수정시 입력(버전업)
    var retJson = quotationSheet.GetSaveJson({ValidKeyField:0});
	var deleteYn = $("#deleteYn").val();
	var copyYn = $("#copyYn").val();
	var actionGubun = "U";
	if (copyYn === "Y") {
		//그리드 견적복사 데이터 존재
		actionGubun = "I";
	} else {
		if (deleteYn === "Y") {
			//그리드 삭제 데이터 존재
			actionGubun = "I";
		} else {
		    if (retJson.data.length > 0) {
		    	//그리드 입력, 수정 데이터 존재
		    	actionGubun = "I";
		    } else {
		    	if (changeYn === "Y") {
		    		if ($("#crncUntCd").val() !== $("#crncUntCdHidden").val()
		    				|| $("input:radio[name='txamtDivCd']:checked").val() !== $("#txamtDivCdHidden").val()) {
			    		actionGubun = "I";
		    		} else {
			    		//기본정보만 변경
			    		actionGubun = "U";
		    		}
		    	} else {
		    		//변경 내용 없음
		            return false;
		    	}
		    }
		}
	}
	$("#actionGubun").val(actionGubun);

	return true;
}

</script>

<style>
	.ui-widget-content {width:500px !important;}
	#divCreateDialog {height:150px !important;}
</style>

<div class="content mb40 estmtCrtn">
	<form class="form-inline form-control-static" action="" id="quotationForm" name="quotationForm" onsubmit="return false">
		<input type="hidden" id="cmpnyCd" name="cmpnyCd" value="<sec:authentication property='principal.egovUserVO.cmpnyCd' />"/>
		<input type="hidden" id="srvcDivCd" name="srvcDivCd" value="NGS"/><%--서비스구분코드--%>
		<input type="hidden" id="estmtDivCd" name="estmtDivCd" value="<c:out value='${param.estmtDivCd}'/>" /><%--견적구분(Q=견적서, P=Pre-Invoice)--%>
		<input type="hidden" id="estmtId" name="estmtId" value="<c:out value='${param.estmtId}'/>" /><%--견적ID--%>
		<input type="hidden" id="estmtSn" name="estmtSn" value="<c:out value='${param.estmtSn}'/>" /><%--견적순번--%>
		<input type="hidden" id="lastEstmtYn" name="lastEstmtYn" /><%--최종견적여부--%>
		<input type="hidden" id="estmtStatCd" name="estmtStatCd" /><%--견적상태--%>
		<input type="hidden" id="emailAtchmnflNo" name="emailAtchmnflNo" /><%--첨부파일번호--%>
		<input type="hidden" id="rgsnUserId" name="rgsnUserId" /><%--등록자--%>
		<input type="hidden" id="estmtAmt" name="estmtAmt" /><%--견적금액--%>
		<input type="hidden" id="deleteYn" name="deleteYn" value="N" />
		<input type="hidden" id="copyYn" name="copyYn" value="N" />
		<input type="hidden" id="actionGubun" name="actionGubun" />
		<input type="hidden" id="wnmpyTelno" name="wnmpyTelno" />
		<input type="hidden" id="mainClph" name="mainClph" />
		<input type="hidden" id="gwEmil" name="gwEmil" />
		<input type="hidden" id="emailSrvcDomnCd" name="emailSrvcDomnCd" /><%--서비스도메인-메일발송시 사용--%>
		<input type="hidden" id="supplyPriceSum" name="supplyPriceSum" />
		<input type="hidden" id="totalSum" name="totalSum" />
		<input type="hidden" id="vatSum" name="vatSum" />
		<input type="hidden" id="crncUntCdHidden" name="crncUntCdHidden" />
		<input type="hidden" id="txamtDivCdHidden" name="txamtDivCdHidden" />
		<input type="hidden" id="natcodeNmEn" name="natcodeNmEn" />
		<input type="hidden" id="reportrNm" name="reportrNm" />
		<input type="hidden" id="euCorpFlag" name="euCorpFlag" />

		<!-- 타이틀/위치정보 -->
		<div class="title-info">
			<h2 id="mainTitle"><spring:message code='word.estmt.creat'/></h2>
		</div>
		<%--견적정보--%>
		<div class="cont">
			<table class="tbl_col">
				<colgroup>
					<col width="10%" />
					<col width="15%" />
					<col width="10%" />
					<col width="15%" />
					<col width="10%" />
					<col width="15%" />
					<col width="10%" />
					<col width="15%" />
				</colgroup>
				<tbody>
					<tr>
						<th><spring:message code='word.com.sj'/> <span>*</span></th><%--제목--%>
						<td colspan="7">
							<input type="text" id="estmtTit" name="estmtTit" class="w100" maxlength="100"/>
							<input type="hidden" id="preEstmtTit" name="preEstmtTit" />
						</td>
					</tr>
					<tr>
						<th><spring:message code='word.srvc.domn'/> <span>*</span></th><%--서비스도메인--%>
						<td>
							<select id="srvcDomnCd" name="srvcDomnCd" class="w100">
							</select>
						</td>
						<th><spring:message code='word.ngs.cstmr.nm'/>(<spring:message code='word.ngs.cstmr.id'/>) <span>*</span></th><%--고객(고객ID)--%>
						<td>
							<input type="text" class="w80" id="custView" name="custView" onclick="fnCustPopup()" onfocus="this.blur()" style="width: 91%; border:none; border-right:0px; border-top:0px; boder-left:0px; boder-bottom:0px; color:#118eff; text-decoration:underline; cursor: pointer;" readonly />
							<button class="icon_seach1 rightBox" type="button" id="btnCustPopup" style="display:none;"><spring:message code='word.inquiry'/></button>
							<input type="hidden" id="custId" name="custId" />
							<input type="hidden" id="custNm" name="custNm" />
						</td>
						<th><spring:message code='word.nation'/></th><%--국가--%>
						<td>
							<input type="text" id="natcodeNm" name="natcodeNm" class="w100" readonly="readonly"/>
						</td>
						<th><spring:message code='word.ngs.organization'/></th><%--기관--%>
						<td>
							<input type="text" id="organization" name="organization" class="w100" readonly="readonly"/>
						</td>
					</tr>
					<tr>
						<th><spring:message code='word.crncy'/> <span>*</span></th><%--통화--%>
						<td>
							<select id="crncUntCd" name="crncUntCd" class="w100">
							</select>
							<input type="hidden" id="preCrncUntCd" name="preCrncUntCd" />
						</td>
						<th><spring:message code='word.taxamt.se'/> <span>*</span></th><%--세액구분--%>
						<td id="txamtDivCdTd">
							<dl class="leftBox w100">
								<dd class="clearfix">
									<ul class="listType1 radioStyleCh" id="txamtDivCdUl"></ul>
						        </dd>
							</dl>
							<input type="hidden" id="preTxamtDivCd" name="preTxamtDivCd" />
						</td>
						<td id="txamtDivCdTdView" style="display:none;">
						</td>
						<th><spring:message code='word.version'/></th><%--버전--%>
						<td id="estmtSnTd">
							<select id="selectEstmtSn" name="selectEstmtSn" class="w100">
							</select>
						</td>
						<th><spring:message code='word.sttus'/></th><%--상태--%>
						<td>
							<input type="text" id="estmtStatNm" name="estmtStatNm" class="w100" readonly="readonly"/>
						</td>
					</tr>
					<tr>
						<th><spring:message code='word.sndng.de'/></th><%--발송일자--%>
						<td>
							<input type="text" id="sndngDttm" name="sndngDttm" class="w100" readonly="readonly"/>
						</td>
						<th><spring:message code='word.sndng.sttus'/></th><%--발송상태--%>
						<td>
							<input type="text" id="sndngSttusNm" name="sndngSttusNm" class="w100" readonly="readonly"/>
						</td>
						<%--등록사용자/등록일시--%>
						<th id="rgsnUserTitle"><spring:message code='word.rgsn.user.id'/></th><%--등록사용자--%>
						<td id="rgsnUserValue">
							<input type="text" id="rgsnUserNm" name="rgsnUserNm" class="w100" readonly="readonly"/>
						</td>
						<th id="rgsnDttmTitle"><spring:message code='word.com.rgsn.dttm'/></th><%--등록일시--%>
						<td id="rgsnDttmValue">
							<input type="text" id="rgsnDttmView" name="rgsnDttmView" class="w100" readonly="readonly"/>
						</td>
						<%--수정사용자/수정일시--%>
						<th id="modiUserTitle" style="display:none;"><spring:message code='word.modi.user'/></th><%--수정사용자--%>
						<td id="modiUserValue" style="display:none;">
							<input type="text" id="modiUserNm" name="modiUserNm" class="w100" readonly="readonly"/>
						</td>
						<th id="modiDttmTitle" style="display:none;"><spring:message code='word.com.modi.dttm'/></th><%--수정일시--%>
						<td id="modiDttmValue" style="display:none;">
							<input type="text" id="modiDttmView" name="modiDttmView" class="w100" readonly="readonly"/>
						</td>
					</tr>
					<tr>
						<th><spring:message code='word.reprsnt.email'/></th><%--대표 E-Mail--%>
						<td colspan="3">
							<input type="text" id="email1" name="email1" class="w100" readonly="readonly"/>
						</td>
						<th><spring:message code='word.add.sndng.email'/></th><%--추가 발송 E-Mail--%>
						<td colspan="3">
							<input type="text" id="adtlSndgEmail" name="adtlSndgEmail" class="w100" maxlength="400"/>
							<input type="hidden" id="preAdtlSndgEmail" name="preAdtlSndgEmail" />
						</td>
					</tr>
					<!-- 201028 견적 Remark START -->
					<tr>
						<th><spring:message code='word.ngs.rm'/></th><%-- Remark --%>
						<td colspan="7">
							<input type="text" id="estmtRm" name="estmtRm" class="w100" maxlength="50"/>
						</td>
					</tr>
					<!-- 201028 견적 Remark 추가 END -->
					<tr>
						<td colspan="8" style="display:none;" id="fileDataTd">
							<div id="fileDtlData" style="height:100px;"></div>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
		<div class="btn_box ordBox active">
			<button type="button" class="btn_normal btn_mid" id="btnDisposal" style="display:none;"><spring:message code='word.dsuse'/></button><%--폐기--%>
			<button type="button" class="btn_normal btn_mid" id="btnPdfCreate" style="display:none;"><spring:message code='word.pdf.mnfct'/></button><%--PDF제작--%>
			<button type="button" class="btn_normal btn_mid" id="btnMailSend" style="display:none;"><spring:message code='word.email.sndng'/></button><%--메일발송--%>
			<button type="button" class="btn_blue btn_mid" id="btnSave" style="display:none;"><spring:message code='word.save'/></button><%--저장--%>
			<button type="button" class="btn_bg_b btn_mid" id="btnOrdCreat" style="display:none;"><spring:message code='word.ord.creat'/></button><%--주문생성--%>
			<button type="button" class="btn_bg_b btn_mid" id="btnCustConfirm" style="display:none;"><spring:message code='word.cstmr.dcsn'/></button><%--고객확정--%>
		</div>
		<%--//견적정보--%>

		<section class="sh_box">
			<div class="w100">
				<div class="titType1">
					<h3><spring:message code='word.estmt.dtls'/></h3><%--견적명세--%>
					<div class="grid_btn" style="text-align:right;">
						<div class="btn-group flex-j-end">
							<div class="flex-j-end" id="btnLeftDiv" style="display:none;">
								<button type="button" class="btn btn-sub size-auto bg-active btn-text-icon bt_gray" id="btnCopy"><spring:message code='word.estmt.copy'/></button><!-- 견적복사 -->
							</div>
							<div class="vertical-bar-sm" id="btnLeftDiv_line" style="display:none;"></div>
							<div class="btn-group-circular">
								<button type="button" class="icon-add btn btn-circular bg-disable" id="btnAddRow" style="display:none;"></button>
								<button type="button" class="icon-minus btn btn-circular bg-disable" id="btnDeleteRow" style="display:none;"></button>
							</div>
							<div class="vertical-bar-sm" id="btnExcel_line" style="display:none;"></div>
							<div class="rightBox">
								<button type="button" class="icon-export-white bt_excel" id="btnExcel" style="display:none;"></span></button>
							</div>
						</div>
						<%-- <div class="leftBox" id="btnLeftDiv" style="display:none;">
							<button type="button" class="btn_normal btn_one" id="btnCopy"><spring:message code='word.estmt.copy'/></button>견적복사
							<!-- <span class="btnSpc">|</span> -->
						</div>
						<div class="rightBox">
							<button type="button" class="btn_normal btn_frst" id="btnAddRow" style="display:none;"><span class="glyphicon glyphicon-plus"></span></button>행추가
							<button type="button" class="btn_normal btn_cent" id="btnDeleteRow" style="display:none;"><span class="glyphicon glyphicon-minus"></span></button>행삭제
							<button type="button" class="btn_excel" id="btnExcel" style="display:none;"></button>Export
						</div> --%>
					</div>
				</div>
				<div id='quotation-sheet'></div>

				<%--comment--%>
				<table class="tbl_col mt20" id="cmtCm">
					<colgroup>
						<col width="10%" />
						<col width="*%" />
					</colgroup>
					<tbody>
						<tr>
							<th><spring:message code='word.comment'/></th><%--Comment--%>
							<td><textarea class="w100-10" id="cm" name="cm" maxlength="4000"></textarea>
							<textarea class="w100-10" id="preCm" name="preCm" style="display:none;"></textarea></td>
						</tr>
					</tbody>
				</table>
				<%--//comment--%>
			</div>
		</section>

	</form>

	<div id="divCreateDialog" title="<spring:message code='word.email.sndng'/>" style="display:none" class="dialogWrap">
		<form id="frmCreateDialog" onsubmit="return false">
			<p class="dialogTit"><span id="checkCnt"></span></p>
			<dl>
				<dt><spring:message code='word.comment'/></dt>
				<dd><textarea name="emailComment" id="emailComment" class="mailSentComt" /></textarea></dd>
			</dl>
		</form>
	</div>
</div>