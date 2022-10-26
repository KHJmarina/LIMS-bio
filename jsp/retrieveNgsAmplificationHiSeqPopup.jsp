<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<script>
var paramWorkType = '${param.workType}';
function fnOnload() {
	if(!['person','group'].includes(paramWorkType)) {
		alert('<spring:message code="err.com.data"/>'); // 데이터가 잘못되었습니다.
		self.close();
	}

	createIBSheet2("div_amplification", "ibsAmplification", "100%", "430px");
    IBS_InitSheet(ibsAmplification,
    	{
	    	"Cfg" : {
	            "MergeSheet": msHeaderOnly+msPrevColumnMerge,PrevColumnMergeMode:0,SearchMode:0
	        },
	        "HeaderMode" : {"Sort": 0},
	        "Cols": [
			  	{Header:"<spring:message code='word.hd.ord.no'/>",								Type:"Text",   		Align:"Left",   SaveName:"ordNo",				MinWidth:100, ColMerge:"1" , Edit:"0"},//주문번호
	        	{Header:"<spring:message code='word.hd.ngs.cstmr.nm'/>",						Type:"Text",   		Align:"Left", SaveName:"custNm",      		MinWidth:80,  ColMerge:"1" , Edit:"0"},//고객명
	        	{Header:"<spring:message code='word.hd.accom.pltfom'/>",						Type:"Text",   		Align:"Left", SaveName:"prfmPltfomNm",      	MinWidth:100, ColMerge:"1" , Edit:"0"},//수행 플랫폼
	        	{Header:"<spring:message code='word.hd.library.id'/>",							Type:"Text",   		Align:"Left", SaveName:"libId",     			MinWidth:100, ColMerge:"0" , Edit:"0"},//라이브러리 id
	        	{Header:"<spring:message code='word.hd.library.nm'/>",							Type:"Text",   		Align:"Left", SaveName:"libNm",     			MinWidth:120, ColMerge:"0" , Edit:"0"},//라이브러리 명
	           	{Header:"<spring:message code='word.hd.run.group.no'/>",						Type:"Text",   		Align:"Left", SaveName:"runGropNo",     		MinWidth:100, ColMerge:"0" , Edit:"0"},//RUN_GROP_NO
	        	{Header:"<spring:message code='word.hd.idx'/>",								Type:"Text",   		Align:"Left", SaveName:"idxCd",     			MinWidth:80, ColMerge:"0" , Edit:"0"},//index
	        	{Header:"<spring:message code='word.hd.idx.seq.7'/>",							Type:"Text",   		Align:"Left", SaveName:"idxSeq7",   			MinWidth:120, ColMerge:"0"  ,Edit:"0"},//idxSeq7그룹명
				{Header:"<spring:message code='word.hd.idx.seq.5'/>",							Type:"Text",   		Align:"Left", SaveName:"idxSeq5",   			MinWidth:120, ColMerge:"0" ,Edit:"0"},//idxSeq5그룹명
	        	{Header:"<spring:message code='word.hd.target.size'/>",						Type:"Text",   		Align:"Left", SaveName:"targetSize",     		MinWidth:80, ColMerge:"0" , Edit:"0"},//target size
	        	<c:if test = "${param.workType =='person'}">
	        	{Header:"<spring:message code='word.hd.phix.pt'/>",	    					Type:"Text",   		Align:"Left", SaveName:"phiPt",     			MinWidth:80, ColMerge:"0" , Edit:"0"},//phix(%)
				{Header:"<spring:message code='word.hd.run.info'/>",							Type:"Text",   		Align:"Left", SaveName:"runTypeNm",     		MinWidth:80, ColMerge:"0" , Edit:"0"},//런정보
				{Header:"<spring:message code='word.hd.run.scale'/>",							Type:"Text",   		Align:"Left", SaveName:"runScale",     		MinWidth:80, ColMerge:"0" , Edit:"0"},//런스케일
				{Header:"<spring:message code='word.hd.exome.work.no'/>",						Type:"Text",   		Align:"Left", SaveName:"libWshId",     		MinWidth:0, ColMerge:"1" , Edit:"0" ,Hidden:"1"},//exome작업번호
				{Header:"<spring:message code='word.hd.group.create.count'/>",					Type:"Text",   		Align:"Left", SaveName:"groupSeq",   			MinWidth:100, ColMerge:"0", Edit:"1"},//그룹생성개수
				{Header:"<spring:message code='word.hd.amplification.group.nm'/>",				Type:"Text",   		Align:"Left", SaveName:"workNm",   			MinWidth:100, ColMerge:"0", Edit:"1"},//Amplification그룹명
	        	</c:if>
	        	<c:if test = "${param.workType =='group'}">
	        	{Header:"<spring:message code='word.hd.phix.pt'/>",	    					Type:"Text",   		Align:"Left", SaveName:"phiPt",     			MinWidth:80, ColMerge:"1" , Edit:"0"},//phix(%)
				{Header:"<spring:message code='word.hd.run.info'/>",							Type:"Text",   		Align:"Left", SaveName:"runTypeNm",      		MinWidth:80, ColMerge:"1" , Edit:"0"},//런정보
				{Header:"<spring:message code='word.hd.run.scale'/>",							Type:"Text",   		Align:"Left", SaveName:"runScale",     		MinWidth:80, ColMerge:"1" , Edit:"0"},//런스케일
				{Header:"<spring:message code='word.hd.exome.work.no'/>",						Type:"Text",   		Align:"Left", SaveName:"libWshId",     		MinWidth:120, ColMerge:"0" , Edit:"0"},//exome작업번호
				{Header:"<spring:message code='word.hd.group.create.count'/>",					Type:"Text",   		Align:"Left", SaveName:"groupSeq",   			MinWidth:100, ColMerge:"0" , Edit:"1"},//그룹생성개수
				{Header:"<spring:message code='word.hd.amplification.group.nm'/>",				Type:"Text",   		Align:"Left", SaveName:"workNm",   			MinWidth:120, ColMerge:"0" , Edit:"1"},//Amplification그룹명
				</c:if>

				{Header:"lastLibWshId",														Type:"Text",		Align:"Left", SaveName:"lastLibWshId", 		MinWidth:50,  Hidden:"1"},
				{Header:"runModeCd",														Type:"Text",		Align:"Left", SaveName:"runModeCd", 			MinWidth:50,  Hidden:"1"},
				{Header:"readLngt",															Type:"Text",		Align:"Left", SaveName:"readLngt", 			MinWidth:50,  Hidden:"1"},
				{Header:"readTypeCd",														Type:"Text",		Align:"Left", SaveName:"readTypeCd", 			MinWidth:50,  Hidden:"1"},
				{Header:"prfmPltfomCd",														Type:"Text",		Align:"Left", SaveName:"prfmPltfomCd", 		MinWidth:50,  Hidden:"1"},
				{Header:"pltfomCd",															Type:"Text",		Align:"Left", SaveName:"pltfomCd", 			MinWidth:50,  ColMerge:"0",Hidden:"1" },
				{Header:"index7",															Type:"Text",		Align:"Left", SaveName:"idxSeq7", 			MinWidth:50,  Hidden:"1"},
				{Header:"index5",															Type:"Text",		Align:"Left", SaveName:"idxSeq5", 			MinWidth:50,  Hidden:"1"},
				{Header:"idxColorFlag",														Type:"Text",		Align:"Left", SaveName:"idxColorFlag", 		MinWidth:50,  Hidden:"1"},
				{Header:"idxColor",															Type:"Text",		Align:"Left", SaveName:"idxColor", 			MinWidth:50,  Hidden:"1"},
				{Header:"adtlRunReqYn",														Type:"Text",		Align:"Left", SaveName:"adtlRunReqYn", 		MinWidth:50,  ColMerge:"0", Hidden:"1"},
				{Header:"adtlRunRsnCd",														Type:"Text",		Align:"Left", SaveName:"adtlRunRsnCd", 		MinWidth:50,  ColMerge:"0", Hidden:"1"},
				{Header:"runTypeCd",														Type:"Text",   		Align:"Left", SaveName:"runTypeCd",     		MinWidth:80, ColMerge:"1" , Edit:"0", Hidden:"1"},//런정보
				{Header:"<spring:message code='word.hd.sttus'/>",								Type:"Status",		Align:"Left", SaveName:"ibStatus", 			MinWidth:50,  Hidden:"1"}
	       	]
	    }
    );

	fnRetrieve();
	fnSetEvent();

}

/**
 * [개발표준]이벤트를 정의함
 */
function fnSetEvent() {

	$("#btnSave").click(function(){
		fnSaveList();
	});
	$("#btnSequence").click(function(){
		fnSequencePop();
	});

	window["ibsAmplification_OnSearchEnd"] = function(code, msg, stCode, stMsg, responseText) {
		if(paramWorkType === 'group') {
			ibsAmplification.SetMergeCell([
			   [1, ibsAmplification.SaveNameCol('libWshId'), ibsAmplification.RowCount(), 1],
			   [1, ibsAmplification.SaveNameCol('groupSeq'), ibsAmplification.RowCount(), 1]
			]);
			ibsAmplification.RenderSheet(2);
		}
    };
}

function fnRetrieve() {
	new CommonAjax("/ngs/amplification/retrieveNgsAmplificationHiSeqRegi.do")
	.addParam(opener.ibsAmplification)
	.callback(function (resultData) {

	 	var libIdCount = resultData.result.length;

		var readLngt = 0; // 최대 readLngt
		var chgRunCtCount = 0;

		resultData.result.forEach(function(v, i){
			if(Number(v.readLngt) && Number(v.readLngt) > readLngt) {
				readLngt = Number(v.readLngt);
			}
		});

		resultData.result.forEach(function(v, i){
			var workNm = '';
			var runScale = '';

			chgRunCtCount += Number.parseFloat(v.targetSize);

			if(paramWorkType === 'group') {
				workNm  = readLngt + v.readTypeCd;
			} else if (paramWorkType === 'person') {
				workNm  = (i+1) + "_" + v.readLngt + v.readTypeCd;
			}

			runScale = '(' + v.runModeCd.substring(0,1) + ') ' + readLngt + ' ' + v.readTypeCd;

			v.workNm = workNm;
			v.runScale = runScale;

		});

		$('.pop_search').find('tr:eq(0) th:eq(1)').text(libIdCount + 'EA');
	 	$('.pop_search').find('tr:eq(1) th:eq(1)').text(chgRunCtCount + 'GB');

		ibsAmplification.LoadSearchData({"data": resultData.result});
	})
	.execute();
}
/*저장*/
function fnSaveList(){

	for(var i=ibsAmplification.GetDataFirstRow(); i<=ibsAmplification.GetDataLastRow(); ++i){
		//if(ibsAmplification.GetCellValue(i,"ibCheck")){

			if(ibsAmplification.GetCellValue(i,"groupSeq") ==""){
				alert("<spring:message code='word.group.seq.input'/>");//'word.target.size.input
				<c:if test = "${param.workType =='person'}">
				ibsAmplification.SelectCell(i, 11);
				</c:if>
				<c:if test = "${param.workType =='group'}">
				ibsAmplification.SelectCell(i, 11);
				</c:if>
				return false;
			}

			if(ibsAmplification.GetCellValue(i,"workNm") ==""){
				alert("<spring:message code='word.amplification.nm.input'/>");//'word.target.size.input
				<c:if test = "${param.workType =='person'}">
				ibsAmplification.SelectCell(i, 12);
				</c:if>
				<c:if test = "${param.workType =='group'}">
				ibsAmplification.SelectCell(i, 12);
				</c:if>
				return false;
			}
	}


	new CommonAjax("/ngs/amplification/saveNgsAmplificationHiSeq.do")
	.addParam(ibsAmplification, "", {"AllSave": 1})
	.addParam(amplificationForm)
	.callback(function (resultData) {
		alert(resultData.message);
		if(resultData.result == "S"){
			opener.fnRetrieve();
			self.close();
		}
	})
	.confirm("<spring:message code='word.group.create.save'/>")
	.execute();
}
/*배열 최대값 호출*/
function getArrayMax(array){
	var max  = array.reduce(function(pre, cur){
		return pre>cur ? pre:cur;
	});
	return max;
}
/* Sequence color balance 및 ACTG 비율확인*/
function fnSequencePop(){
	window.open("", "ratePop","toolbar=no,directories=no,scrollbars=yes,resizable=yes,status=no,menubar=no,width=1250,height=650");
	$("#amplificationForm").attr("target","ratePop")
	.attr("action","/ngs/amplification/retrieveNgsAmplificationRatePopup.do")
	.attr("method","post")
	.submit();
}

</script>
<div class="content ampWorkPop" style="margin: 0;">
	<!-- 타이틀/위치정보 -->

	<form class="form-inline form-control-static" action="" id="amplificationForm" name="amplificationForm">
		<input type="hidden" name="workType" id="workType" value="<c:out value="${param.workType}"/>"/>
		<!-- 검색영역 -->
		<div class="pop_search">
			<table>
				<tbody>
					<tr>
						<th><spring:message code='word.selected.lib.cnt'/><%-- 기간설정 --%></th>
						<th><%-- 기간설정 --%></th>
					</tr>
					<tr>
						<th><spring:message code='word.selected.target.size'/><%-- 기간설정 --%></th>
						<th><%-- 수행플랫폼 --%></th>
					</tr>
				</tbody>
			</table>
		</div>

		<div class="pop_item_cont" style="padding-top: 0;">
			<!-- 그리드 레이아웃 추가 -->
			<div class="grid_wrap gridType3">
				<section>
					<div class="">
						<div class="titType1">
							<div class="w100 grid_btn pb3">
								<div class="rightBox">
									<c:if test = "${param.workType =='group'}">
										<button type="button" class="btn btn-sub size-auto bg-secondary-empty" id="btnSequence" title="<spring:message code='word.seq.color.balance.actg'/>">
											<span class=""><spring:message code='word.seq.color.balance.actg'/></span>
										</button>
									</c:if>
								</div>
							</div>
						</div>

						<div id='div_amplification'></div>
					</div>

					<div class="btn_box">
						<button type="button" class="btn btn-main size-md bg-primary" id="btnSave" title="<spring:message code='word.save'/>">
							<span class=""><spring:message code='word.save'/></span>
						</button>
					</div>
				</section>
			</div>
		<!-- // 그리드 레이아웃 추가 -->
		</div>
	</form>
</div>