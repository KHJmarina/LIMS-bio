<%--
  Created by IntelliJ IDEA.
  User: kimjaesu
  Date: 2017. 5. 15.
  Time: 17:54
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script src='<c:url value="/resources/js/ngs/common.js"/>'></script>
<script src='<c:url value="/resources/js/cus/common.js"/>'></script>
<script>
	var sheet;
    function fnOnload() {
    	$('#searchBeginDe').IBMaskEdit('yyyy-MM-dd');
    	$('#searchEndDe').IBMaskEdit('yyyy-MM-dd');

    	/**
         * 그리드용 콤보조회(공통코드)
         */
        var objCmmnCmbCodes = new CommonSheetComboCodes()
        .addGroupCode({"groupCode": "CUST_GRDE_CD", "required": false, "includedNotUse" : false})
        .execute();

        $('#searchUseYn').addCommonSelectOptions({
        	"comboData": objCmmnCmbCodes["USE_YN"],
        	"required": false,
        	"defaultValue": "WORD"
        });

        fnSetEvent();

		var initCol= {
				"Cfg" : {
		            "MergeSheet": msHeaderOnly + msPrevColumnMerge,
		            "FilterRow": "1",
		            "PrevColumnMergeMode" : 0
		        },
		        "HeaderMode" : {},
                "Cols" : [
                	{"Header" : "",		"Type" : "DummyCheck",	"Align" : "Center",		"SaveName" : "ibCheck",		"MinWidth" : 30, 	"ColMerge": 0, 	"Sort": 0},
                    {"Header" : "<spring:message code='word.hd.sttus'/>",				"Type" : "Status",		"Align" : "Center",	"SaveName" : "ibStatus",			"MinWidth" : 40, 	"Hidden" : 1},//상태
                    {"Header" : "<spring:message code='word.hd.ord.no'/>",				"Type" : "Text",		"Align" : "Left",	"SaveName" : "ordNo",				"MinWidth" : 100, 	"ColMerge":1, 	"Edit": 0,	"FontUnderline":"1",	"Cursor":"Pointer"},//주문번호
                    {"Header" : "<spring:message code='word.hd.ord.grad'/>",			"Type" : "Image",		"Align" : "Left",	"SaveName" : "ordGrdeNm",			"MinWidth" : 100, 	"ColMerge":1, 	"Edit": 0},//주문등급
                    {"Header" : "<spring:message code='word.hd.pilot.yn'/>",			"Type" : "Text",		"Align" : "Left",	"SaveName" : "pilotYnNm",				"MinWidth" : 100, 	"ColMerge":1, 	"Edit": 0},//pilot 여부
                    {"Header" : "<spring:message code='word.hd.pltfom'/>",				"Type" : "Text",		"Align" : "Left",	"SaveName" : "pltfomNm",			"MinWidth" : 100, 	"ColMerge":1, 	"Edit": 0, "iconCode" : "pltfomCd", "iconGroupCode" : "PLTFOM_CD"},//플랫폼
                    {"Header" : "<spring:message code='word.hd.cmpl.pnttm'/>",			"Type" : "Text",		"Align" : "Left",	"SaveName" : "cmplPnttmNm",			"MinWidth" : 100, 	"ColMerge":1, 	"Edit": 0, "iconCode" : "cmplPnttmCd", "iconGroupCode" : "CMPL_PNTTM_CD"},//완료시점
                    {"Header" : "<spring:message code='word.hd.ngs.cstmr.id'/>",		"Type" : "Text",		"Align" : "Left",	"SaveName" : "custId",				"MinWidth" : 100, 	"ColMerge":1, 	"Edit": 0, "FontUnderline":"1",	"Cursor":"Pointer"},//고객ID
                    {"Header" : "<spring:message code='word.hd.ngs.cstmr.nm'/>",		"Type" : "Text",		"Align" : "Left",	"SaveName" : "userName",			"MinWidth" : 100, 	"ColMerge":1, 	"Edit": 0},//고객명
                    {"Header" : "<spring:message code='word.hd.ngs.cstmr.grade'/>",	"Type" : "Combo",		"Align" : "Left",	"SaveName" : "custGrade",			"MinWidth" : 100, 	"ColMerge":1, 	"Edit": 0,	"ComboText":objCmmnCmbCodes["CUST_GRDE_CD"].ComboText, "ComboCode":objCmmnCmbCodes["CUST_GRDE_CD"].ComboCode},//고객등급
                    {"Header" : "<spring:message code='word.hd.smpl.ct'/>",			"Type" : "Text",		"Align" : "Right",	"SaveName" : "smplCnt",				"MinWidth" : 100, 	"ColMerge":1, 	"Edit": 0},//주문샘플수
                    {"Header" : "<spring:message code='word.hd.no'/>",					"Type" : "Text",		"Align" : "Left",	"SaveName" : "smplSn",				"MinWidth" : 100, 	"ColMerge":0, 	"Edit": 0},
                    {"Header" : "<spring:message code='word.hd.smpl.id'/>",			"Type" : "Text",		"Align" : "Left",	"SaveName" : "smplId",				"MinWidth" : 100, 	"ColMerge":0, 	"Edit": 0},//Sample ID
                    {"Header" : "<spring:message code='word.hd.sample.name'/>",		"Type" : "Text",		"Align" : "Left",	"SaveName" : "ordSmplNm",			"MinWidth" : 100, 	"ColMerge":0, 	"Edit": 0},//Sample명
                    {"Header" : "<spring:message code='word.hd.tube.id'/>",			"Type" : "Text",		"Align" : "Left",	"SaveName" : "tubId",				"MinWidth" : 100, 	"ColMerge":0, 	"Edit": 0},//Tube ID
                    {"Header" : "<spring:message code='word.hd.status'/>",				"Type" : "Text",		"Align" : "Left",	"SaveName" : "smplStatNm",			"MinWidth" : 100, 	"ColMerge":0, 	"Edit": 0},//Status
                    {"Header" : "<spring:message code='word.hd.smpl.type'/>",			"Type" : "Text",		"Align" : "Left",	"SaveName" : "smplTypeNm",			"MinWidth" : 100, 	"ColMerge":0, 	"Edit": 0},//Type
                    {"Header" : "<spring:message code='word.hd.kingdom'/>",			"Type" : "Text",		"Align" : "Left",	"SaveName" : "smplKgdmNm",			"MinWidth" : 100, 	"ColMerge":0, 	"Edit": 0},//Kingdom
                    {"Header" : "<spring:message code='word.hd.smpl.species'/>",		"Type" : "Text",		"Align" : "Left",	"SaveName" : "smplSpeNm",			"MinWidth" : 200, 	"ColMerge":0, 	"Edit": 0},//Species
                    {"Header" : "<spring:message code='word.hd.smpl.source'/>",		"Type" : "Text",		"Align" : "Left",	"SaveName" : "smplSrcNm",			"MinWidth" : 100, 	"ColMerge":0, 	"Edit": 0},//source
                    {"Header" : "<spring:message code='word.hd.smpl.organ'/>",			"Type" : "Text",		"Align" : "Left",	"SaveName" : "smplOrgnNm",			"MinWidth" : 100, 	"ColMerge":0, 	"Edit": 0},//organ
                    {"Header" : "<spring:message code='word.hd.smpl.buffer'/>",		"Type" : "Text",		"Align" : "Left",	"SaveName" : "smplBufferNm",		"MinWidth" : 100, 	"ColMerge":0, 	"Edit": 0},//Buffer
                    {"Header" : "<spring:message code='word.hd.smpl.prep'/>",			"Type" : "Text",		"Align" : "Left",	"SaveName" : "smplPreNm",			"MinWidth" : 100, 	"ColMerge":0, 	"Edit": 0},//Prep
                    {"Header" : "<spring:message code='word.hd.lib.kit'/>",			"Type" : "Text",		"Align" : "Left",	"SaveName" : "libKitNm",			"MinWidth" : 100, 	"ColMerge":0, 	"Edit": 0},//Library Kit
                    {"Header" : "<spring:message code='word.hd.otd1.plan'/>",			"Type" : "Text",		"Align" : "Left",	"SaveName" : "otd1P",				"MinWidth" : 100, 	"ColMerge":0, 	"Edit": 0, "Format" : "Ymd"},//OTD1_계획
                    {"Header" : "<spring:message code='word.hd.otd1.adj'/>",			"Type" : "Text",		"Align" : "Left",	"SaveName" : "otd1M",				"MinWidth" : 100, 	"ColMerge":0, 	"Edit": 0, "Format" : "Ymd"},//OTD1_조정
                    {"Header" : "<spring:message code='word.hd.progrs.sttus'/>",		"Type" : "Text",		"Align" : "Left",	"SaveName" : "smplPrgrStatNm",		"MinWidth" : 100, 	"ColMerge":0, 	"Edit": 0},//진행상태
                    {"Header" : "<spring:message code='word.progrs.sttus'/>\n<spring:message code='word.hd.ngs.chg.rsn'/>",	"Type" : "Text",		"Align" : "Left",	"SaveName" : "smplPrgrStatChgRsn",	"MinWidth" : 100, 	"ColMerge":0, 	"Edit": 0},//진행상태\n변경사유
                    {"Header" : "<spring:message code='word.hd.prfm.unus.cntn'/>",		"Type" : "Html",		"Align" : "Left",	"SaveName" : "prfmUnusCntn",		"MinWidth" : 200, 	"ColMerge":1, 	"Edit": 0},//수행특이사항
                    {"Header" : "<spring:message code='word.hd.prfm.unus.cntn'/>",		"Type" : "Popup",		"Align" : "Left",	"SaveName" : "prfmUnusCntnBtn",		"MinWidth" : 30,	"Width" : 30,	"ColMerge":1, 	"Edit": 1},//수행특이사항
                    {"Header" : "<spring:message code='word.hd.cstdy.pd'/>",			"Type" : "Text",		"Align" : "Left",	"SaveName" : "smplKpngPerdNm",		"MinWidth" : 100, 	"ColMerge":0, 	"Edit": 0},//보관기간
                    {"Header" : "<spring:message code='word.hd.work.cnt'/>",			"Type" : "Text",		"Align" : "Right",	"SaveName" : "swsiCnt",				"MinWidth" : 100, 	"ColMerge":0, 	"Edit": 0},//작업횟수
                    {"Header" : "<spring:message code='word.hd.pren.ord.no'/>",		"Type" : "Text",		"Align" : "Left",	"SaveName" : "prenOrdNo",			"MinWidth" : 100, 	"ColMerge":0, 	"Edit": 0, 	"FontUnderline":"1",	"Cursor":"Pointer"},//부모주문번호
                    {"Header" : "완료시점코드", 		"Type" : "Text", 	"SaveName" : "cmplPnttmCd", 	"Hidden" : 1}, //완료시점
                    {"Header" : "주문등급코드",		"Type" : "Text",	"SaveName" : "ordGrdeCd", 		"Hidden" : 1},
                    {"Header" : "플랫폼코드",		"Type" : "Text",	"SaveName" : "pltfomCd", 		"Hidden" : 1},
                    {"Header" : "status코드",		"Type" : "Text",	"SaveName" : "smplStatCd", 		"Hidden" : 1},
                    {"Header" : "type 코드",		"Type" : "Text",	"SaveName" : "smplTypeCd", 		"Hidden" : 1},
                    {"Header" : "kingdom 코드",		"Type" : "Text",	"SaveName" : "smplKgdmCd", 		"Hidden" : 1},
                    {"Header" : "species 코드",		"Type" : "Text",	"SaveName" : "smplSpeCd", 		"Hidden" : 1},
                    {"Header" : "buffer 코드",		"Type" : "Text",	"SaveName" : "smplBufferCd", 	"Hidden" : 1},
                    {"Header" : "prep 코드",		"Type" : "Text",	"SaveName" : "smplPreCd", 		"Hidden" : 1},
                    {"Header" : "Library Kit 코드",	"Type" : "Text",	"SaveName" : "libKitCd", 		"Hidden" : 1},
                    {"Header" : "진행상태코드",		"Type" : "Text",	"SaveName" : "smplPrgrStatCd", 	"Hidden" : 1},
                    {"Header" : "보관기간코드",		"Type" : "Text",	"SaveName" : "smplKpngPerdCd", 	"Hidden" : 1},
                    {"Header" : "유전자 타입 코드",	"Type" : "Text",	"SaveName" : "geneTypeCd", 		"Hidden" : 1},
                    {"Header" : "order1",	"Type" : "Text",	"SaveName" : "order1", 		"Hidden" : 1},
                    {"Header" : "order2",	"Type" : "Text",	"SaveName" : "order2", 		"Hidden" : 1},
                    {"Header" : "order3",	"Type" : "Text",	"SaveName" : "order3", 		"Hidden" : 1},
                    {"Header" : "order4",	"Type" : "Text",	"SaveName" : "order4", 		"Hidden" : 1}
                ]
            };

		createIBSheet2(document.getElementById('divIbsWaitDna'), "ibsWaitDna", "100%", "750px", "", true);
        IBS_InitSheet(ibsWaitDna, initCol);

		createIBSheet2(document.getElementById('divIbsWaitRna'), "ibsWaitRna", "100%", "750px", "", true);
	    IBS_InitSheet(ibsWaitRna, initCol);

	    createIBSheet2(document.getElementById('divIbsWaitDnaPrep'), "ibsWaitDnaPrep", "100%", "750px", "", true);
	    IBS_InitSheet(ibsWaitDnaPrep, initCol);

	    createIBSheet2(document.getElementById('divIbsWaitRnaPrep'), "ibsWaitRnaPrep", "100%", "750px", "", true);
	    IBS_InitSheet(ibsWaitRnaPrep, initCol);

	    fnExcelStyle();

		//리사이징
	    gridResize();

    };

    /**
     * [개발표준]이벤트를 정의함
     */
    function fnSetEvent() {
    	$("#btnStartCal").click(function() {
            IBCalendar.Show($(this).val(), {
                "CallBack": function(date) {
                    $("#searchBeginDe").val(date);
                },
                "Format": "Ymd",
                "Target": $("#searchBeginDe")[0],
                "CalButtons": "InputEmpty|Today|Close"
            });
        });

    	$("#btnEndCal").click(function() {
            IBCalendar.Show($(this).val(), {
                "CallBack": function(date) {
                    $("#searchEndDe").val(date);
                },
                "Format": "Ymd",
                "Target": $("#searchEndDe")[0],
                "CalButtons": "InputEmpty|Today|Close"
            });
        });

      	//sheet의 첨부파일 클릭시 팝업 오픈
        window["ibsWaitDna_OnPopupClick"] = function(Row, Col) {
        	if(ibsWaitDna.ColSaveName(Col) == "prfmUnusCntnBtn"){
        		retrievePerformUnusualPopup(sheet.GetCellValue(Row, "ordNo"), "100,110");
        	}
        };
      	//sheet의 첨부파일 클릭시 팝업 오픈
        window["ibsWaitRna_OnPopupClick"] = function(Row, Col) {
        	if(ibsWaitRna.ColSaveName(Col) == "prfmUnusCntnBtn"){
        		retrievePerformUnusualPopup(sheet.GetCellValue(Row, "ordNo"), "100,110");
        	}
        };
      	//sheet의 첨부파일 클릭시 팝업 오픈
        window["ibsWaitDnaPrep_OnPopupClick"] = function(Row, Col) {
        	if(ibsWaitDnaPrep.ColSaveName(Col) == "prfmUnusCntnBtn"){
        		retrievePerformUnusualPopup(sheet.GetCellValue(Row, "ordNo"), "100,110");
        	}
        };
      	//sheet의 첨부파일 클릭시 팝업 오픈
        window["ibsWaitRnaPrep_OnPopupClick"] = function(Row, Col) {
        	if(ibsWaitRnaPrep.ColSaveName(Col) == "prfmUnusCntnBtn"){
        		retrievePerformUnusualPopup(sheet.GetCellValue(Row, "ordNo"), "100,110");
        	}
        };

     	//sheet 클릭시 이벤트
        window["ibsWaitDna_OnClick"] = function(row, col, value, cellX, cellY, cellW, cellH, rowtype) {
        	if(rowtype == "DataRow"){
        		if(ibsWaitDna.ColSaveName(col) == "custId"){
        			retrieveUserInfoPopup(ibsWaitDna.GetCellValue(row, "custId"));
        		} else if(ibsWaitDna.ColSaveName(col) == "ordNo") {
					//주문조회상세 화면으로 이동
           			var ordNo = ibsWaitDna.GetCellValue(row, "ordNo");
					$('#frmMenu').find("input[name=ordNo]").remove();
		   			$('#frmMenu').append('<input type="hidden" name="ordNo" value="'+ordNo+'">');
		   			fnMove("/ngs/order/retrieveOrdSearchDetailForm.do", "", "Y");
        		} else if(ibsWaitDna.ColSaveName(col) == "prenOrdNo") {
					//주문조회상세 화면으로 이동
           			var prenOrdNo = ibsWaitDna.GetCellValue(row, "prenOrdNo");
           			if(prenOrdNo != ""){
						$('#frmMenu').find("input[name=ordNo]").remove();
			   			$('#frmMenu').append('<input type="hidden" name="ordNo" value="'+prenOrdNo+'">');
			   			fnMove("/ngs/order/retrieveOrdSearchDetailForm.do", "", "Y");
           			}
        		} else if(ibsWaitDna.ColSaveName(col) == "ibCheck") {
        			$("#checkedRow1").text(ibsWaitDna.CheckedRows("ibCheck"));
        		}
        	}
        };
		//sheet 클릭시 이벤트
        window["ibsWaitRna_OnClick"] = function(row, col, value, cellX, cellY, cellW, cellH, rowtype) {
        	if(rowtype == "DataRow"){
        		if(ibsWaitRna.ColSaveName(col) == "custId"){
        			retrieveUserInfoPopup(ibsWaitRna.GetCellValue(row, "custId"));
        		} else if(ibsWaitRna.ColSaveName(col) == "ordNo") {
        			//주문상세 팝업
           			var ordNo = ibsWaitRna.GetCellValue(row, "ordNo");
					$('#frmMenu').find("input[name=ordNo]").remove();
		   			$('#frmMenu').append('<input type="hidden" name="ordNo" value="'+ordNo+'">');
		   			fnMove("/ngs/order/retrieveOrdSearchDetailForm.do", "", "Y");
        		} else if(ibsWaitRna.ColSaveName(col) == "prenOrdNo") {
					//주문조회상세 화면으로 이동
           			var prenOrdNo = ibsWaitRna.GetCellValue(row, "prenOrdNo");
           			if(prenOrdNo != ""){
						$('#frmMenu').find("input[name=ordNo]").remove();
			   			$('#frmMenu').append('<input type="hidden" name="ordNo" value="'+prenOrdNo+'">');
			   			fnMove("/ngs/order/retrieveOrdSearchDetailForm.do", "", "Y");
           			}
        		} else if(ibsWaitRna.ColSaveName(col) == "ibCheck") {
        			$("#checkedRow2").text(ibsWaitRna.CheckedRows("ibCheck"));
        		}
        	}
        };
		//sheet 클릭시 이벤트
        window["ibsWaitDnaPrep_OnClick"] = function(row, col, value, cellX, cellY, cellW, cellH, rowtype) {
        	if(rowtype == "DataRow"){
        		if(ibsWaitDnaPrep.ColSaveName(col) == "custId"){
        			retrieveUserInfoPopup(ibsWaitDnaPrep.GetCellValue(row, "custId"));
        		} else if(ibsWaitDnaPrep.ColSaveName(col) == "ordNo") {
        			//주문상세 팝업
           			var ordNo = ibsWaitDnaPrep.GetCellValue(row, "ordNo");
					$('#frmMenu').find("input[name=ordNo]").remove();
		   			$('#frmMenu').append('<input type="hidden" name="ordNo" value="'+ordNo+'">');
		   			fnMove("/ngs/order/retrieveOrdSearchDetailForm.do", "", "Y");
        		} else if(ibsWaitDnaPrep.ColSaveName(col) == "prenOrdNo") {
					//주문조회상세 화면으로 이동
           			var prenOrdNo = ibsWaitDnaPrep.GetCellValue(row, "prenOrdNo");
					if(prenOrdNo != ""){
						$('#frmMenu').find("input[name=ordNo]").remove();
			   			$('#frmMenu').append('<input type="hidden" name="ordNo" value="'+prenOrdNo+'">');
			   			fnMove("/ngs/order/retrieveOrdSearchDetailForm.do", "", "Y");
					}
        		} else if(ibsWaitDnaPrep.ColSaveName(col) == "ibCheck") {
        			$("#checkedRow3").text(ibsWaitDnaPrep.CheckedRows("ibCheck"));
        		}
        	}
        };
		//sheet 클릭시 이벤트
        window["ibsWaitRnaPrep_OnClick"] = function(row, col, value, cellX, cellY, cellW, cellH, rowtype) {
        	if(rowtype == "DataRow"){
        		if(ibsWaitRnaPrep.ColSaveName(col) == "custId"){
        			retrieveUserInfoPopup(ibsWaitRnaPrep.GetCellValue(row, "custId"));
        		} else if(ibsWaitRnaPrep.ColSaveName(col) == "ordNo") {
        			//주문상세 팝업
           			var ordNo = ibsWaitRnaPrep.GetCellValue(row, "ordNo");
					$('#frmMenu').find("input[name=ordNo]").remove();
		   			$('#frmMenu').append('<input type="hidden" name="ordNo" value="'+ordNo+'">');
		   			fnMove("/ngs/order/retrieveOrdSearchDetailForm.do", "", "Y");
        		} else if(ibsWaitRnaPrep.ColSaveName(col) == "prenOrdNo") {
					//주문조회상세 화면으로 이동
           			var prenOrdNo = ibsWaitRnaPrep.GetCellValue(row, "prenOrdNo");
           			if(prenOrdNo != ""){
						$('#frmMenu').find("input[name=ordNo]").remove();
			   			$('#frmMenu').append('<input type="hidden" name="ordNo" value="'+prenOrdNo+'">');
			   			fnMove("/ngs/order/retrieveOrdSearchDetailForm.do", "", "Y");
           			}
        		} else if(ibsWaitRnaPrep.ColSaveName(col) == "ibCheck") {
        			$("#checkedRow4").text(ibsWaitRnaPrep.CheckedRows("ibCheck"));
        		}
        	}
        };

        window["ibsWaitDna_OnRowSearchEnd"] = function (row) {
        	var ordGrdeCd = ibsWaitDna.GetCellValue(row, "ordGrdeCd");//주문등급
        	var cmplPnttmCd = ibsWaitDna.GetCellValue(row, "cmplPnttmCd");//완료시점에 따른 폰트 컬러
        	if (ordGrdeCd === "10") {
        		ibsWaitDna.SetCellFontColor(row , "ordGrdeNm" ,"#FF0000");
        	}
        	if(cmplPnttmCd === "SQC"){
        		ibsWaitDna.SetCellFontColor(row , "cmplPnttmNm" ,"#989EB3");
        	}else if(cmplPnttmCd === "LQC"){
        		ibsWaitDna.SetCellFontColor(row , "cmplPnttmNm" ,"#636775");
        	}else if(cmplPnttmCd === "RUN"){
        		ibsWaitDna.SetCellFontColor(row , "cmplPnttmNm" ,"#4C84FF");
        	}

        };
        window["ibsWaitRna_OnRowSearchEnd"] = function (row) {
        	var ordGrdeCd = ibsWaitRna.GetCellValue(row, "ordGrdeCd");//주문등급
        	var cmplPnttmCd = ibsWaitRna.GetCellValue(row, "cmplPnttmCd");//완료시점에 따른 폰트 컬러
        	if (ordGrdeCd === "10") {
        		ibsWaitRna.SetCellFontColor(row , "ordGrdeNm" ,"#FF0000");
        	}
        	if(cmplPnttmCd === "SQC"){
        		ibsWaitRna.SetCellFontColor(row , "cmplPnttmNm" ,"#989EB3");
        	}else if(cmplPnttmCd === "LQC"){
        		ibsWaitRna.SetCellFontColor(row , "cmplPnttmNm" ,"#636775");
        	}else if(cmplPnttmCd === "RUN"){
        		ibsWaitRna.SetCellFontColor(row , "cmplPnttmNm" ,"#4C84FF");
        	}
        };
        window["ibsWaitDnaPrep_OnRowSearchEnd"] = function (row) {
        	var ordGrdeCd = ibsWaitDnaPrep.GetCellValue(row, "ordGrdeCd");//주문등급
        	var cmplPnttmCd = ibsWaitDnaPrep.GetCellValue(row, "cmplPnttmCd");//완료시점에 따른 폰트 컬러
        	if (ordGrdeCd === "10") {
        		ibsWaitDnaPrep.SetCellFontColor(row , "ordGrdeNm" ,"#FF0000");
        	}
        	if(cmplPnttmCd === "SQC"){
        		ibsWaitRna.SetCellFontColor(row , "cmplPnttmNm" ,"#989EB3");
        	}else if(cmplPnttmCd === "LQC"){
        		ibsWaitRna.SetCellFontColor(row , "cmplPnttmNm" ,"#636775");
        	}else if(cmplPnttmCd === "RUN"){
        		ibsWaitRna.SetCellFontColor(row , "cmplPnttmNm" ,"#4C84FF");
        	}
        };
        window["ibsWaitRnaPrep_OnRowSearchEnd"] = function (row) {
        	var ordGrdeCd = ibsWaitRnaPrep.GetCellValue(row, "ordGrdeCd");//주문등급
        	var cmplPnttmCd = ibsWaitDnaPrep.GetCellValue(row, "cmplPnttmCd");//완료시점에 따른 폰트 컬러
        	if (ordGrdeCd === "10") {
        		ibsWaitRnaPrep.SetCellFontColor(row , "ordGrdeNm" ,"#FF0000");
        	}
        	if(cmplPnttmCd === "SQC"){
        		ibsWaitRna.SetCellFontColor(row , "cmplPnttmNm" ,"#989EB3");
        	}else if(cmplPnttmCd === "LQC"){
        		ibsWaitRna.SetCellFontColor(row , "cmplPnttmNm" ,"#636775");
        	}else if(cmplPnttmCd === "RUN"){
        		ibsWaitRna.SetCellFontColor(row , "cmplPnttmNm" ,"#4C84FF");
        	}
        };

        window["ibsWaitDna_OnSearchEnd"] = function(code, msg, stCode, stMsg, responseText) {
        	ibsWaitDna.SetColBackColor("prfmUnusCntnBtn", 'rgb(242, 242, 242)'); // WebColor RGB 표기법
        	$("#checkedRow1").text(ibsWaitDna.CheckedRows("ibCheck"));
        }
        window["ibsWaitRna_OnSearchEnd"] = function(code, msg, stCode, stMsg, responseText) {
        	ibsWaitRna.SetColBackColor("prfmUnusCntnBtn", 'rgb(242, 242, 242)'); // WebColor RGB 표기법
        	$("#checkedRow2").text(ibsWaitRna.CheckedRows("ibCheck"));
        }
        window["ibsWaitDnaPrep_OnSearchEnd"] = function(code, msg, stCode, stMsg, responseText) {
        	ibsWaitDnaPrep.SetColBackColor("prfmUnusCntnBtn", 'rgb(242, 242, 242)'); // WebColor RGB 표기법
        	$("#checkedRow3").text(ibsWaitDnaPrep.CheckedRows("ibCheck"));
        }
        window["ibsWaitRnaPrep_OnSearchEnd"] = function(code, msg, stCode, stMsg, responseText) {
        	ibsWaitRnaPrep.SetColBackColor("prfmUnusCntnBtn", 'rgb(242, 242, 242)'); // WebColor RGB 표기법
        	$("#checkedRow4").text(ibsWaitRnaPrep.CheckedRows("ibCheck"));
        }

 		window["ibsWaitDna_OnCheckAllEnd"] = function(col, value) {
        	$("#checkedRow1").text(ibsWaitDna.CheckedRows("ibCheck"));
        }
 		window["ibsWaitDna_OnFillData"] = function() {
        	$("#checkedRow1").text(ibsWaitDna.CheckedRows("ibCheck"));
        }

 		window["ibsWaitRna_OnCheckAllEnd"] = function(col, value) {
        	$("#checkedRow2").text(ibsWaitRna.CheckedRows("ibCheck"));
        }
 		window["ibsWaitRna_OnFillData"] = function() {
        	$("#checkedRow2").text(ibsWaitRna.CheckedRows("ibCheck"));
        }

 		window["ibsWaitDnaPrep_OnCheckAllEnd"] = function(col, value) {
        	$("#checkedRow3").text(ibsWaitDnaPrep.CheckedRows("ibCheck"));
        }
 		window["ibsWaitDnaPrep_OnFillData"] = function() {
        	$("#checkedRow3").text(ibsWaitDnaPrep.CheckedRows("ibCheck"));
        }

 		window["ibsWaitRnaPrep_OnCheckAllEnd"] = function(col, value) {
        	$("#checkedRow4").text(ibsWaitRnaPrep.CheckedRows("ibCheck"));
        }
 		window["ibsWaitRnaPrep_OnFillData"] = function() {
        	$("#checkedRow4").text(ibsWaitRnaPrep.CheckedRows("ibCheck"));
        }

        // 검색버튼
        $('#btnSearch').click(function() {
        	fnRetrieve(sheet);
        });
        // 검색버튼
        $('#btnUpdateOtdDt01,#btnUpdateOtdDt02,#btnUpdateOtdDt03,#btnUpdateOtdDt04').click(function() {
        	var tabIndex = $("#tabIndex").val();
        	var sheetName = "";
        	if(tabIndex == 0) {
        		sheetName = "ibsWaitDna";
        	} else if(tabIndex == 1) {
        		sheetName = "ibsWaitRna";
        	} else if(tabIndex == 2) {
        		sheetName = "ibsWaitDnaPrep";
        	} else if(tabIndex == 3) {
        		sheetName = "ibsWaitRnaPrep";
        	}

        	var count = eval(sheetName).CheckedRows("ibCheck");
        	if(count == 0){
        		alert("<spring:message code='infm.no.select'/>");
        		return false;
        	}

        	fnRetrieveOrdLibOtdPopup("fnOtdCallBack()", "Y", sheetName,"OTD1");
        });


        //생성버튼
        $("#btnCreateDna").click(function() {
        	fnCreate(sheet);
        });
      	//생성버튼
        $("#btnCreateRna").click(function() {
        	fnCreate(sheet);
        });
      	//생성버튼
        $("#btnCreateDnaPrep").click(function() {
        	fnCreate(sheet);
        });
      	//생성버튼
        $("#btnCreateRnaPrep").click(function() {
        	fnCreate(sheet);
        });

      	//생성버튼
        $("#btnDeferDna").click(function() {
        	fnDefer(sheet);
        });
      	//생성버튼
        $("#btnDeferRna").click(function() {
        	fnDefer(sheet);
        });
      	//생성버튼
        $("#btnDeferDnaPrep").click(function() {
        	fnDefer(sheet);
        });
      	//생성버튼
        $("#btnDeferRnaPrep").click(function() {
        	fnDefer(sheet);
        });
    }

    function fnTabChange(tabIndex) {
    	$("#tabIndex").val(tabIndex);
    	if(tabIndex == 0) {
    		$("#searchGeneTypeCd").val("D");
    		$("#searchSmplStatCd").val("D");
    		sheet = ibsWaitDna;
    	} else if(tabIndex == 1) {
    		$("#searchGeneTypeCd").val("R");
    		$("#searchSmplStatCd").val("R");
    		sheet = ibsWaitRna;
    	} else if(tabIndex == 2) {
    		$("#searchGeneTypeCd").val("D");
    		$("#searchSmplStatCd").val("T");
    		sheet = ibsWaitDnaPrep;
    	} else if(tabIndex == 3) {
    		$("#searchGeneTypeCd").val("R");
    		$("#searchSmplStatCd").val("T");
    		sheet = ibsWaitRnaPrep;
    	}
    	fnRetrieve(sheet);
    }

    // [개발표준]ibsheet 서버통신을 정의함
    /**
     * 샘플대기 목록을 검색함
     */
    function fnRetrieve(sheet) {
        new CommonAjax("/ngs/sample/retrieveWaits.do")
        .addParam(frmWait)
        .callback(function (resultData) {
        	sheet.LoadSearchData({"data": resultData.waits});
        })
        .execute();
    }
    function fnCreate(sheet) {
    	var saveData = sheet.GetSaveJson({
    	    "StdCol":"ibCheck",
    	    "StdColValue" : "1",
    	    "ValidKeyField" : 0
    	});

    	if(saveData.data.length == 0){
    		alert("<spring:message code='infm.select.create.row'/>");//생성 할 행을 선택하여 주세요.
    		return false;
    	}

    	if(saveData.data.length > 384){
    		alert("<spring:message code='infm.max.select.sample'/>");//최대 384개 샘플이 선택 가능합니다.
    		return false;
    	}

    	$("#checkCnt1").text("<spring:message code='cnfm.create.worksheet' arguments='"+ saveData.data.length +"'/>");//체크된 {0}건을 Worksheet로 생성 하시겠습니까?

    	var sheetParam = {};
    	if($("#tabIndex").val() == 0) {
    		sheetParam = {"ibsWaitDna" : saveData}
    	} else if($("#tabIndex").val() == 1) {
    		sheetParam = {"ibsWaitRna" : saveData}
    	} else if($("#tabIndex").val() == 2) {
    		sheetParam = {"ibsWaitDnaPrep" : saveData}
    	} else if($("#tabIndex").val() == 3) {
    		sheetParam = {"ibsWaitRnaPrep" : saveData}
    	}

        new CommonAjax("/ngs/sample/createWaits.do")
        .addParam(sheetParam)
        .addParam(frmWait)
        .confirmDialog("divCreateDialog", {})
        .callback(function (resultData) {
        	alert(resultData.message);
  			if(resultData.result == "S"){
  				var frmWorksheetDetail = document.getElementById("frmWorksheetDetail");
  				$("#worksheetId").val(resultData.worksheetInfo.smplWshId);
  				$("#worksheetName").val(resultData.worksheetInfo.wshNm);
  				frmWorksheetDetail.action = "/ngs/sample/retrieveWorksheetDetailForm.do";
  				frmWorksheetDetail.target = '_self';
  				frmWorksheetDetail.submit();
  			}
        })
        .execute();
    }

    function fnDefer(sheet) {
    	var saveData = sheet.GetSaveJson({
    	    "StdCol":"ibCheck",
    	    "StdColValue" : "1",
    	    "ValidKeyField" : 0
    	});

    	if(saveData.data.length == 0){
    		alert("<spring:message code='infm.select.defer.row'/>");//생성 할 행을 선택하여 주세요.
    		return false;
    	}

    	if(saveData.data.length > 384){
    		alert("<spring:message code='infm.max.select.sample'/>");//최대 384개 샘플이 선택 가능합니다.
    		return false;
    	}

    	$("#checkCnt2").text("<spring:message code='cnfm.defer.worksheet' arguments='"+saveData.data.length+"'/>");//체크된 {0}건을 보류 하시겠습니까?

    	var sheetParam = {};
    	if($("#tabIndex").val() == 0) {
    		sheetParam = {"ibsWaitDna" : saveData}
    	} else if($("#tabIndex").val() == 1) {
    		sheetParam = {"ibsWaitRna" : saveData}
    	} else if($("#tabIndex").val() == 2) {
    		sheetParam = {"ibsWaitDnaPrep" : saveData}
    	} else if($("#tabIndex").val() == 3) {
    		sheetParam = {"ibsWaitRnaPrep" : saveData}
    	}

        new CommonAjax("/ngs/sample/deferWaits.do")
        .addParam(sheetParam)
        .addParam(frmWait)
        .confirmDialog("divDeferDialog", {})
        .callback(function (resultData) {
        	alert(resultData.message);
  			if(resultData.result == "S"){
  				fnRetrieve(sheet);
  			}
        })
        .execute();
    }

    /**
     * Excel 다운로드 버튼 스타일
     */
     function fnExcelStyle(){
    	var bLength = $(".grid_btn .rightBox button").length;
    	$(".grid_btn .rightBox button").addClass("btn_one");
    }
	/*otd 팝업 콜백함수*/
	window.fnOtdCallBack = function (){
    	fnRetrieve(sheet);
    }

  	//그리드 resize(문지환D)
    function gridResize(){
    	$(window).resize(function(){
    		var popWinSize = $(window).height();
    		var hH = $("header").height();
    		var hH2 = $("h2").height();
    		var sH = $(".search_box2").height();
    		var allH = hH + hH2 + sH + 145;
    		//alert(hH + hH2 + sH + sH2);
    		$("#divIbsWaitDna, #divIbsWaitRna, #divIbsWaitDnaPrep #divIbsWaitRnaPrep").height(popWinSize - allH);
    	});
    	var popWinSize = $(window).height();
    	var hH = $("header").height();
    	var hH2 = $("h2").height();
    	var sH = $(".search_box2").height();
    	var allH = hH + hH2 + sH + 145;
    	//alert(hH + hH2 + sH + sH2);
    	$("#divIbsWaitDna, #divIbsWaitRna, #divIbsWaitDnaPrep #divIbsWaitRnaPrep").height(popWinSize - allH);
    }

</script>
<div class="content smplWait">
	<!-- 타이틀/위치정보 -->
	<div class="title-info">
		<h2>${activeMenu.menuNm}</h2>
	</div>
	<form class="form-inline form-control-static" action="/sample/excel/excelDownTest.do" id="frmWait" onsubmit="return false">
		<input type="hidden" id="searchGeneTypeCd" name="searchGeneTypeCd" value="" />
		<input type="hidden" id="searchSmplStatCd" name="searchSmplStatCd" value="" />
		<input type="hidden" id="tabIndex" name="tabIndex" value="" />
		<!-- 검색영역 -->
		<div class="search_box2">
			<div class="leftBox">
				<table>
					<tbody>
						<tr>
							<td class="date_search">
								<select name="searchPerdSrchCd" id="searchPerdSrchCd">
									<option value=""><spring:message code='word.pd.search'/></option><!-- 기간검색 -->
									<option value="01"><spring:message code='word.ord.reg.dt'/></option><!-- 주문등록일자 -->
									<option value="02"><spring:message code='word.ord.app.dt'/></option><!-- 주문접수일자 -->
		                       	</select>
								<input type="text" name="searchBeginDe" id="searchBeginDe" class="date_type1" /><button type="button" class="btn_calendar" id="btnStartCal"></button> ~
								<input type="text" name="searchEndDe" id="searchEndDe" class="date_type1" /><button type="button" class="btn_calendar" id="btnEndCal"></button>
							</td>
							<th></th>
							<td>
								<select name="searchBasiSrchCd1" id="searchBasiSrchCd1" class="bor2">
									<option value=""><spring:message code='word.sch.cond'/>1</option><!-- 검색조건 -->
									<option value="01"><spring:message code='word.ngs.cstmr.nm'/></option><!-- 고객명 -->
									<option value="02"><spring:message code='word.ngs.cstmr.id'/></option><!-- 고객ID -->
									<option value="03"><spring:message code='word.ngs.organization'/></option><!-- 기관 -->
									<option value="04"><spring:message code='word.ord.no'/></option><!-- 주문 번호 -->
									<option value="05"><spring:message code='word.smpl.id'/></option><!-- Sample ID -->
									<option value="06"><spring:message code='word.sample.name'/></option><!-- Sample명 -->
									<option value="07"><spring:message code='word.tube.id'/></option><!-- Tube ID -->
		                       	</select><input type="text" name="searchKeyword1" id="searchKeyword1" class="w246 bor2 iconKeyboard"/>
							</td>
							<th></th>
							<td>
								<select name="searchBasiSrchCd2" id="searchBasiSrchCd2" class="bor2">
									<option value=""><spring:message code='word.sch.cond'/>2</option><!-- 검색조건 -->
									<option value="01"><spring:message code='word.ngs.cstmr.nm'/></option><!-- 고객명 -->
									<option value="02"><spring:message code='word.ngs.cstmr.id'/></option><!-- 고객ID -->
									<option value="03"><spring:message code='word.ngs.organization'/></option><!-- 기관 -->
									<option value="04"><spring:message code='word.ord.no'/></option><!-- 주문 번호 -->
									<option value="05"><spring:message code='word.smpl.id'/></option><!-- Sample ID -->
									<option value="06"><spring:message code='word.sample.name'/></option><!-- Sample명 -->
									<option value="07"><spring:message code='word.tube.id'/></option><!-- Tube ID -->
		                       	</select><input type="text" name="searchKeyword2" id="searchKeyword2" class="bor2 w246 iconKeyboard"/>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			<div class="rightBox"><button type="button" class="btn_search" id="btnSearch"><spring:message code='word.inquiry'/></button><!-- 조회 --></div>
		</div>
	</form>
	<div class="tab_box sh_box">
		<ul class="tab13">
			<li id="tabTitle1"><a href="#tab1"><spring:message code='word.dna'/></a></li><!-- DNA -->
			<li id="tabTitle2"><a href="#tab2"><spring:message code='word.rna'/></a></li><!-- RNA -->
			<li id="tabTitle3"><a href="#tab3"><spring:message code='word.dna.prep'/></a></li><!-- DNA Prep -->
			<li id="tabTitle4"><a href="#tab4"><spring:message code='word.rna.prep'/></a></li><!-- RNA Prep -->
		</ul>
		<div class="cont">
			<div id="tab1" class="tab">
				<div class="grid_wrap gridType2 titType1">
					<!-- <h3><spring:message code='word.dna'/></h3>DNA -->
					<h4>Checked Row : <span id="checkedRow1">0</span></h4>
					<div class="grid_btn">
						<div class="btn-group flex-j-end">
							<div class="flex-j-end">
								<button type="button" class="icon-confirm1-black btn btn-sub bg-active-empty btn-text-icon" id="btnCreateDna"><spring:message code='word.create'/></button><!-- 생성 -->
								<button type="button" class="btn btn-sub size-auto bg-secondary-empty" id="btnUpdateOtdDt01"><spring:message code='word.update.otd.dt'/></button><!-- OTD일자변경 -->
								<button type="button" class="btn btn-sub bg-active-empty btn-text-icon" id="btnDeferDna"><spring:message code='word.defer'/></button><!-- 보류 -->
							</div>
							<div class="vertical-bar-sm"></div>
							<div class="rightBox"></div>
						</div>
						<%-- <div class="leftBox">
							<button type="button" class="btn_normal btn_frst" id="btnCreateDna" ><spring:message code='word.create'/></button><!-- 생성 -->
							<button type="button" class="btn_normal btn_cent" id="btnUpdateOtdDt01"><spring:message code='word.update.otd.dt'/></button><!-- OTD일자변경 -->
							<button type="button" class="btn_normal btn_last" id="btnDeferDna"><spring:message code='word.defer'/></button><!-- 보류 -->
						</div>
						<div class="rightBox"></div> --%>
					</div>
					<div id='divIbsWaitDna'></div>
				</div>
			</div>
			<div id="tab2" class="tab">
				<div class="grid_wrap gridType2 titType1">
					<!-- <h3><spring:message code='word.rna'/></h3>RNA -->
					<h4>Checked Row : <span id="checkedRow2">0</span></h4>
					<div class="grid_btn">
						<div class="btn-group flex-j-end">
							<div class="flex-j-end">
								<button type="button" class="icon-confirm1-black btn btn-sub bg-active-empty btn-text-icon" id="btnCreateRna"><spring:message code='word.create'/></button><!-- 생성 -->
								<button type="button" class="btn btn-sub size-auto bg-secondary-empty" id="btnUpdateOtdDt02"><spring:message code='word.update.otd.dt'/></button><!-- OTD일자변경 -->
								<button type="button" class="btn btn-sub bg-active-empty btn-text-icon" id="btnDeferRna"><spring:message code='word.defer'/></button><!-- 보류 -->
							</div>
							<div class="vertical-bar-sm"></div>
							<div class="rightBox"></div>
						</div>
						<%-- <div class="leftBox">
							<div class="leftBox">
								<button type="button" class="btn_normal btn_frst" id="btnCreateRna" ><spring:message code='word.create'/></button><!-- 생성 -->
								<button type="button" class="btn_normal btn_cent" id="btnUpdateOtdDt02"><spring:message code='word.update.otd.dt'/></button><!-- OTD일자변경 -->
								<button type="button" class="btn_normal btn_last" id="btnDeferRna"><spring:message code='word.defer'/></button><!-- 보류 -->
							</div>
						</div>
						<div class="rightBox"></div> --%>
					</div>
					<div id='divIbsWaitRna'></div>
				</div>
			</div>
			<div id="tab3" class="tab">
				<div class="grid_wrap gridType2 titType1">
					<!--<h3><spring:message code='word.dna.prep'/></h3> DNA Prep -->
					<h4>Checked Row : <span id="checkedRow3">0</span></h4>
					<div class="grid_btn">
						<div class="btn-group flex-j-end">
							<div class="flex-j-end">
								<button type="button" class="icon-confirm1-black btn btn-sub bg-active-empty btn-text-icon" id="btnCreateDnaPrep"><spring:message code='word.create'/></button><!-- 생성 -->
								<button type="button" class="btn btn-sub size-auto bg-secondary-empty" id="btnUpdateOtdDt03"><spring:message code='word.update.otd.dt'/></button><!-- OTD일자변경 -->
								<button type="button" class="btn btn-sub bg-active-empty btn-text-icon" id="btnDeferDnaPrep"><spring:message code='word.defer'/></button><!-- 보류 -->
							</div>
							<div class="vertical-bar-sm"></div>
							<div class="rightBox"></div>
						</div>
						<%-- <div class="leftBox">
							<button type="button" class="btn_normal btn_frst" id="btnCreateDnaPrep" ><spring:message code='word.create'/></button><!-- 생성 -->
							<button type="button" class="btn_normal btn_cent" id="btnUpdateOtdDt03" ><spring:message code='word.update.otd.dt'/></button><!-- OTD일자변경 -->
							<button type="button" class="btn_normal btn_last" id="btnDeferDnaPrep"><spring:message code='word.defer'/></button><!-- 보류 -->
						</div>
						<div class="rightBox"></div> --%>
					</div>
					<div id='divIbsWaitDnaPrep'></div>
				</div>
			</div>
			<div id="tab4" class="tab">
				<div class="grid_wrap gridType2 titType1">
					<!--<h3><spring:message code='word.rna.prep'/></h3> RNA Prep -->
					<h4>Checked Row : <span id="checkedRow4">0</span></h4>
					<div class="grid_btn">
						<div class="btn-group flex-j-end">
							<div class="flex-j-end">
								<button type="button" class="icon-confirm1-black btn btn-sub bg-active-empty btn-text-icon" id="btnCreateRnaPrep"><spring:message code='word.create'/></button><!-- 생성 -->
								<button type="button" class="btn btn-sub size-auto bg-secondary-empty" id="btnUpdateOtdDt04"><spring:message code='word.update.otd.dt'/></button><!-- OTD일자변경 -->
								<button type="button" class="btn btn-sub bg-active-empty btn-text-icon" id="btnDeferRnaPrep"><spring:message code='word.defer'/></button><!-- 보류 -->
							</div>
							<div class="vertical-bar-sm"></div>
							<div class="rightBox"></div>
						</div>
						<%-- <div class="leftBox">
							<button type="button" class="btn_normal btn_frst" id="btnCreateRnaPrep" ><spring:message code='word.create'/></button><!-- 생성 -->
							<button type="button" class="btn_normal btn_cent" id="btnUpdateOtdDt04" ><spring:message code='word.update.otd.dt'/></button><!-- OTD일자변경 -->
							<button type="button" class="btn_normal btn_last" id="btnDeferRnaPrep"><spring:message code='word.defer'/></button><!-- 보류 -->
						</div>
						<div class="rightBox"></div> --%>
					</div>
					<div id='divIbsWaitRnaPrep'></div>
				</div>
			</div>
		</div>
	</div>
</div>

<div id="divCreateDialog" class="dialogWrap" title="Worksheet 생성" style="display:none">
	<form id="frmCreateDialog" onsubmit="return false">
		<p class="dialogTit"><span id="checkCnt1"></span></p>
		<ul>
			<li>
				<dl>
					<dt><spring:message code='word.worksheet.name'/>:</dt><!-- Worksheet명 -->
					<dd><input type="text" name="wshNm" id="wshNm" style="width:300px"/></dd>
				</dl>
			</li>
		</ul>
	</form>
</div>

<div id="divDeferDialog" title="보류" style="display:none">
	<form id="frmDeferDialog" onsubmit="return false">
		<p class="dialogTit"><span id="checkCnt2"></span></p>
		<ul>
			<li>
				<dl>
					<dt><spring:message code='word.defer.rsn'/>:</dt><!-- 보류사유 -->
					<dd><input type="text" name="deferRsn" id="deferRsn" style="width:300px"/></dd>
				</dl>
			</li>
		</ul>
	</form>
</div>

<form class="form-inline form-control-static" action="" id="frmWorksheetDetail" onsubmit="return false">
	<input type="hidden" id="worksheetId" name="worksheetId" value="" />
	<input type="hidden" id="worksheetName" name="worksheetName" value="" />
</form>