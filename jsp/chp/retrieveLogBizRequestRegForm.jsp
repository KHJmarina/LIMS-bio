<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>


<script type="text/javascript">
//<![CDATA[
	$(document).ready(function(){

		/*상용구 콤보*/
		fnCommonUseWordCombo();
		fnUserDeptCombo();
		fnDeptCombo();

		/*상용구 요청내용에 setting*/
		$( "#commonUseWord" ).change(function() {
			fnCommonUseWordCommboSet($(this));
		});
		/*상용구 팝업*/
		$( "#btnCommonUseWordPop" ).click(function() {
			fnCommonUseWordPop();
		});
		/*저장*/
		$( "#btnSave" ).click(function() {
			fnSaveList();
		});
		/*행추가하기 위한 팝업*/
		$( "#btnAdd" ).click(function() {
			fnChpOrdPop();
		});
		/*행삭제 */
		$( "#btnDelete" ).click(function() {
			fnDelete();
		});

		var uploadInit = {
				"viewType": "icon",
				"iconMode": "detail",
	    }
	    $("#fileDtlData").addIbUpload(uploadInit, fileDataCallBack, false, document.logForm.name);

	    $("#btnFileAdd").click(function() {
	    	$("#fileDtlData").IBUpload("add");
	    });
	  	// 파일삭제
	    $("#btnFileDel").click(function() {
	    	$("#fileDtlData").IBUpload("delete");
	    });
	 	//파일다운로드
	    $("#btnFileDown").click(function() {
	        $("#fileDtlData").IBUpload("download");
	    });



		$("#btnClose").click(function() {
		    window.close();
		});


	    fnIbSheetSet();
	    fnRetrieve();
	});



	function fnIbSheetSet(){

		var init = {
		    	"Cfg": {
		            "SearchMode": 2,"MouseHoverMode": 0,"SelectionRowsMode": 1,
		        },
		        "HeaderMode" : {"Sort": 0,},
		        "Cols": [
		        	{Header:"", 													Type:"DummyCheck", 	Align:"Center", SaveName:"ibCheck", 		MinWidth:40,	Edit:"1"},//선택
		        	{Header:"상태", 													Type:"Status", 		Align:"Center", SaveName:"ibStatus",		MinWidth:40,	Hidden:"1"},
		        	{Header:"<spring:message code='word.hd.regist.ord.no'/>", 		Type:"Text",		Align:"Left",	SaveName:"ordNo",			MinWidth:150,	Edit:"0"},//ORDER #
		        	{Header:"<spring:message code='word.hd.chp.cstmr.nm'/>",		Type:"Text",		Align:"Left",	SaveName:"custNm",			MinWidth:150,	Edit:"0"},//CUSTOMER
		        	{Header:"<spring:message code='word.hd.ngs.cstmr.id'/>", 		Type:"Text",		Align:"Left",	SaveName:"custId",			MinWidth:150,	Edit:"0"},//CUSTOMER ID
		        	{Header:"<spring:message code='word.hd.ngs.organization.nm'/>", Type:"Text",		Align:"Left",	SaveName:"inttNm",			MinWidth:150,	Edit:"0"},//INSTITUTE
		        	{Header:"<spring:message code='word.hd.appl.type'/>", 			Type:"Text",		Align:"Left",	SaveName:"applionTypeNm",	MinWidth:100,	Edit:"0"},//APPLICATION
		        	{Header:"<spring:message code='word.chp.hd.platform'/>", 		Type:"Text",		Align:"Left",	SaveName:"pltfomNm",		MinWidth:200,	Edit:"0"},//PLATFORM
		        	{Header:"<spring:message code='word.hd.cmpl.pnttm'/>", 			Type:"Text",		Align:"Left",	SaveName:"cmplPnttmCd",		MinWidth:200,	Edit:"0"},//FINAL PROCESS
		        	{Header:"APPLICATION", 											Type:"Text",		Align:"Left",	SaveName:"applionTypeCd",	Hidden:"1"},//APPLICATION
		        	{Header:"PLATFORM", 											Type:"Text",		Align:"Left",	SaveName:"pltfomCd",		Hidden:"1"},//PLATFORM
		        	{Header:"FINAL PROCESS", 										Type:"Text",		Align:"Left",	SaveName:"cmplPnttmNm",		Hidden:"1"},//FINAL PROCESS
		        ]
		    }

		var sheet = $("#divLogBizReqOrd")[0];

		createIBSheet2(sheet, "ibsLogBizReqOrd", "100%", "200px");
		IBS_InitSheet(ibsLogBizReqOrd, init);
		ibsLogBizReqOrd.FitColWidth();

		window["ibsLogBizReqOrd_OnSearchEnd"] = function(code, msg, stCode, stMsg, responseText) {

			for(var i=ibsLogBizReqOrd.GetDataFirstRow(); i<=ibsLogBizReqOrd.GetDataLastRow(); ++i){
				ibsLogBizReqOrd.SetCellValue(i,"ibCheck",1);
				ibsLogBizReqOrd.SetCellValue(i,"ibStatus","U");
			}

	    };
	}

	function fnCommonUseWordCombo() {
		// 호기
	    var commonUseWordCombo = new CommonSheetComboOthers("/chp/log/retrieveChpCommonUseWordCombo.do")

	    .addCombo({"resultCombo": {"codeColumn": "cuwNo", "textColumn": "cuwCntn", "required": false}})
	    .execute();

	    $("#commonUseWord").addCommonSelectOptions({
	    	"comboData": commonUseWordCombo["resultCombo"],
	    	"required": true
	    });
	}

	function fnCommonUseWordCommboSet(obj) {

		var str = $("#cntn").val();

		if(str != ""){
			str = str + "\n";
		}

		if(obj.find("option:selected").val()==""){
			return false;
		}


		str = str + obj.find("option:selected").text();
		$("#cntn").val(str);
	}

	/*상용문구 팝업 임시*/
	function fnCommonUseWordPop() {
		  $("#cuwDivCd").val("10");
		  var frm = document.logForm;
		  window.open("", "commonUseWordPop","toolbar=no,directories=no,scrollbars=yes,resizable=yes,status=no,menubar=no,width=760,height=650");
		  frm.target = "commonUseWordPop";
		  frm.action = "/chp/log/retrieveCommonUseWordPopup.do";
		  frm.method = "post";
		  frm.submit();
	}

	function fnCommonUseWordSet(obj) {
		var len = obj.length;
		var str = $("#cntn").val();

		if(str != ""){
			str = str + "\n";
		}

		for(var i = 0 ;i < len;i++){
			str += obj[i].cuwCntn +"\n";
		}

		$("#cntn").val(str);

	}

	function fnRetrieve() {
		 var ordNo = "<c:out value="${param.logProcessTrgtId}"/>";

		 if(ordNo != '') {
			 new CommonAjax("/chp/log/retrieveLogBizRequestOrdList.do")
				.addParam({ordNo:"<c:out value='${param.logProcessTrgtId}'/>"})
				.callback(function (resultData) {
					ibsLogBizReqOrd.LoadSearchData({"data": resultData.result});
			    })
			    .execute();
		 }
	}


	function fnSaveList(){

		var ibSheet;

		$("#sheetName").val("ibsLogBizReqOrd");

		if( !FormQueryString(logForm, true) ) {
			return;
		}
		var chkcnt = 0;
		var str = "";
		$("input[name=chkDeptIds]").each(function(){
			if($(this).is(":checked")){
				str += $(this).val()+",";
				chkcnt++;
			}
		});


		if(chkcnt == 0){
			alert("<spring:message code='word.prog.dept.select'/>");
			return false;
		}

		$("#deptIds").val(str);

		new CommonAjax("/chp/log/saveChpLogBizRequest.do")
		.addParam(ibsLogBizReqOrd)
		.addParam(logForm)
		.confirm('<spring:message code="cnfm.save"/>')
		.callback(function (resultData) {
			alert(resultData.message);

			if(resultData.result == "S"){

				<c:if test="${param.isPopup == 'Y'}">
					//opener.fnRetrieve();
				$("#jobRequest",opener.document).addJobRequst({logProcessTrgtId:"<c:out value="${param.logProcessTrgtId}"/>"
					,logProcessTrgtDivCd:"<c:out value="${param.logProcessTrgtDivCd}"/>",isPopup:"Y"
					,deptId:"<c:out value="${param.searchDeptId}"/>"
					,srvcDivCd:"<c:out value="${param.srvcDivCd}"/>"});
					self.close();
				</c:if>

				<c:if test="${param.isPopup=='N'}">

					for(var i=ibsLogBizReqOrd.GetDataFirstRow(); i<=ibsLogBizReqOrd.GetDataLastRow(); ++i){

						ibsLogBizReqOrd.SetCellValue(i,"ibStatus","R");
					}

					fnMove("/chp/log/retrieveLogBizRequestMgrForm.do", "","N");

				</c:if>
			}
		})
		.execute();
	}


	function fileDataCallBack(data) {
		$("#atchmnflNo").val(data.atchmnflNo);
		// 첨부파일 재조회
		CommonRetrieveAtchmnFile("fileDtlData", {"atchmnflNo": data.atchmnflNo}, document.logForm.name);
	}

	/* 주문조회 팝업*/
	var ordPop;

	function fnChpOrdPop() {
		 $("#callback").val("fnCallBackOrdPopup");

		  var frm = document.pramForm;
		  fnCommonPopOpen("ordPop", 1600, 830);
		  frm.target = "ordPop";
		  //frm.action = "/chp/log/retrieveChpOrdPopup.do";
		  frm.action = "/chp/com/retrieveChpOrdPopup.do";
		  frm.method = "post";
		  frm.submit();
	}

	/*callback*/
	function fnCallBackOrdPopup(obj){

		for(var i = obj.length-1 ; i  >=0 ; i--){

			var flag = false;

			for(var j = ibsLogBizReqOrd.GetDataFirstRow(); j <= ibsLogBizReqOrd.GetDataLastRow(); ++j){
				if(ibsLogBizReqOrd.GetCellValue(j, "ordNo") == obj[i].ordNo){
					flag = true;
				}
			}

			if(!flag){
				var row = ibsLogBizReqOrd.DataInsert(0);
				var data = { ibCheck : 1
		    				, ordNo:obj[i].ordNo
		    				, custNm:obj[i].custNm
		    				, custId:obj[i].custId
		    				, inttNm:obj[i].inttNm
		    				, applionTypeCd:obj[i].applionTypeCd
		    				, applionTypeNm:obj[i].applionTypeNm
		    				, pltfomCd:obj[i].pltfomCd
		    				, pltfomNm:obj[i].pltfomNm
		    				, cmplPnttmCd:obj[i].cmplPnttmCd
		    				, cmplPnttmNm:obj[i].cmplPnttmNm
				};
				ibsLogBizReqOrd.SetRowData(row, data);
			}

		}
		ordPop.close();
	}

	/*삭제*/
	function fnDelete(){
		for(var i = ibsLogBizReqOrd.GetDataLastRow(); i >= ibsLogBizReqOrd.GetDataFirstRow(); i--){
			if(ibsLogBizReqOrd.GetCellValue(i, "ibCheck") == "1"){
				ibsLogBizReqOrd.RowDelete(i)
			}
		}
	}

	function fnUserDeptCombo() {
		// 호기
	    var commonCombo = new CommonSheetComboOthers("/chp/log/retrieveLogBizUserDeptList.do")
	    .addCombo({"resultCombo": {"codeColumn": "gwDeptId", "textColumn": "deptName", "required": false}})
	    .execute();

	    $("#reqstDeptId").addCommonSelectOptions({
	    	"comboData": commonCombo["resultCombo"],
	    	"required": true
	    });

	    // 기본선택
	    if ($("#reqstDeptId").length > 0) {
	    	$("#reqstDeptId option:eq(1)").prop("selected", true);
	    }
	}

	function fnDeptCombo() {
		// 호기
	    var commonCombo = new CommonSheetComboOthers("/chp/log/retrieveLogBizDeptList.do")
	    .addParam({"useYn": "Y"})
	    .addCombo({"resultCombo": {"codeColumn": "gwDeptId", "textColumn": "deptName", "required": false}})
	    .execute();
	    $("#logForm #deptIdUl").addCommonCheckboxs({

	    	  "checkName": "chkDeptIds", /* [필수]Name 속성 값 */
	          "checkData": commonCombo["resultCombo"] /* [필수]데이터 */

	    });
	}

//]]>
</script>
<c:if test="${param.isPopup=='Y'}">
	<div class="content" style="padding: 10px 10px 10px 10px;">
	<!-- 타이틀/위치정보 -->
</c:if>
<c:if test="${param.isPopup=='N'}">
<div class="content">
	<!-- 타이틀/위치정보 -->
	<div class="title-info">
		<h2>${activeMenu.menuNm}</h2>
	</div>

</c:if>
<!-- contents -->


	<form action="" id="pramForm" name="pramForm" onsubmit="return false">
		<input type="hidden" id="callback" name="callback"  value="" />
		<input type="hidden" id="multiYn" name="multiYn"  value="Y" />
	</form>
	<form class="form-inline form-control-static" action="" id="logForm" name="logForm" onsubmit="return false">
		<input type="hidden" id="atchmnflNo" 		name="atchmnflNo"  		value="" />
		<input type="hidden" id="sheetName" 		name="sheetName"  		value="" />
		<input type="hidden" id="ordNo" 			name="ordNo"			value="<c:out value="${param.logProcessTrgtId}"/>" />


		<input type="hidden" id="isPopup" 			name="isPopup"  		value="<c:out value="${param.isPopup}"/>" />
		<input type="hidden" id="deptIds" 			name="deptIds"  		value="<c:out value="${param.deptIds}"/>" />
		<input type="hidden" id="searchDeptId" 		name="searchDeptId"  	value="<c:out value="${param.searchDeptId}"/>" />
		<input type="hidden" id="deptId" 			name="deptId"  			value="<c:out value="${param.deptId}"/>" />
		<input type="hidden" id="cuwDivCd" 			name="cuwDivCd"  		value="" />

		<input type="hidden" id="srvcDivCd"			name="srvcDivCd" 		value="CHP"/><!-- 업무구분코드 -->
		<!-- 검색영역 End-->
		<div class="sh_box">
			<!-- 그리드 레이아웃 추가 -->
			<div>
				<section class="bizReg">
					<div>
						<div class="w100">
							<table class="tbl_col">
								<colgroup>
									<col width="10%" />
									<col width="90%" />
								</colgroup>
								<tbody>
									<tr>
										<th>
											<spring:message code='word.target.info'/><span>*</span><%--대상구분 --%>
										</th>
										<td>
											<c:if test="${param.isPopup!='Y'}">
												<div style="float: right; padding-top: 5px;" id="divBtnCtrl">
													<button type="button" class="btn btn-sub size-auto bg-secondary-empty" id="btnAdd"><spring:message code='word.add'/></button>
													<button type="button" class="icon-delete-white btn btn-sub size-auto bg-active btn-text-icon bt_gray" id="btnDelete"><spring:message code='word.delete'/></button>
<%-- 													<button type="button" class="btn_normal2" id="btnAdd"><spring:message code='word.add'/></button> --%>
<%-- 													<button type="button" class="btn_normal2" id="btnDelete"><spring:message code='word.delete'/></button> --%>
												</div>
											</c:if>
											<div style="padding-top: 30px;display: none" id="divLogBizReqOrd"></div>
										</td>
									</tr>
									<tr>
										<th>
											<spring:message code='word.req.dept'/><span>*</span><%--처리부서 --%>
										</th>
										<td>
											<select id="reqstDeptId" name="reqstDeptId"  required="<spring:message code='word.req.dept'/>"></select>
										</td>
									</tr>
									<tr>
										<th>
											<spring:message code='word.prog.dept'/><span>*</span><%--처리부서 --%>
										</th>
										<td><ul class="ul4 checkStyleCh2" id="deptIdUl"></ul>

										</td>
									</tr>
									<tr>
										<th>
											<spring:message code='word.request'/> <spring:message code='word.cn'/><span>*</span><%--요청내용 --%>
										</th>
										<td class="reg_comt">
											<div class="leftBox">
												<ul class="listType1 radioStyleCh">
													<li><input type="radio" id="urgnYn01" checked="checked" name="urgnYn" value = "N"> <label for="urgnYn01"><spring:message code='word.com.normal'/></label></li>
													<li><input type="radio" id="urgnYn02" name="urgnYn" value = "Y"> <label for="urgnYn02"><spring:message code='word.com.urgent'/></label></li>
												</ul>
											</div>
											<div class="rightBox">
												<select id="commonUseWord" name="commonUseWord" >
												</select><button type="button" class="icon_seach2" id="btnCommonUseWordPop"></button>
											</div>
											<div class="clear">
												<textarea  id="cntn" name="cntn" class="w100" cols=""  required="<spring:message code='RequestEmplInfo.reqstResnCn.input'/>"></textarea>
											</div>
										</td>
									</tr>
									<tr>
										<th>
											<spring:message code='word.atchmnfl.no'/><%--첨부파일 --%>
										</th>
										<td>
										<div class="sh_btn_box" style="text-align: right;">
											<div class="grid_btn">
												<div class="btn-group flex-j-end">
													<button type="button" class="icon-add btn btn-sub size-sm bg-blueL btn-text-icon sizeM" id="btnFileAdd" title="파일 추가">
														<spring:message code='word.file.adit'/>
													</button>
													<button type="button" class="icon-minus btn btn-sub size-sm bg-blueL btn-text-icon sizeM" id="btnFileDel" title="파일 삭제">
														<spring:message code='word.file.delete'/>
													</button>
													<div class="vertical-bar-sm"></div>
													<div class="flex-j-end">
														<button type="button" class="icon-download-white btn btn-sub size-sm btn-icon bg-secondary b-zero" id="btnFileDown" title="다운로드"></button>
													</div>
												</div>
											</div>
<%-- 											<button type="button" class="btn_normal2" id="btnFileAdd"><spring:message code='word.file.adit'/></button><!-- 파일추가 --> --%>
<%-- 											<button class="btn_normal2" type="button" id="btnFileDel"><spring:message code='word.file.delete'/></button><!-- 파일삭제 --> --%>
<!-- 											<button class="btn_down2" type="button" id="btnFileDown"><img src="/resources/images/common/download_w_ico.png"></button>다운로드 -->
										</div>
										<div style="width: 100%;padding-top: 5px;">
											<div id="fileDtlData" style="height: 100px;"></div>

										</div>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
						<div class="btn_box txtRight">
							<button type="button" class="btn btn-main size-md bg-primary" id="btnSave"><spring:message code='word.save'/></button>
<%-- 						<button type="button" id="btnSave" class="btn_bg_b btn_mid" ><spring:message code='word.save'/></button> --%>
							<c:if test="${param.isPopup=='Y'}">
								<button type="button" class="btn btn-main size-md bg-active-empty" id="btnClose" onclick="self.close()"><spring:message code='word.close'/></button>
<%-- 							<button type="button" id="btnClose" onclick="self.close();" class="btn_normal btn_mid"  ><spring:message code='word.close'/></button> --%>
							</c:if>
						</div>
					</div>
				</section>
			</div>
		</div>

	</form>
</div>