package lims.web.chp.rtpcr.controller;

import java.io.File;
import java.io.FileInputStream;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import lims.web.chp.rtpcr.model.ChpPlateDesign;
import lims.web.chp.rtpcr.model.ChpRtpcrWk;
import lims.web.chp.rtpcr.service.ChpRtpcrWkService;
import lims.web.com.frame.ajax.CommonData;
import lims.web.com.frame.popup.PopupConstants;
import lims.web.com.frame.validator.CustomValidator;
import lims.web.com.frame.validator.DeleteHint;
import lims.web.com.frame.validator.RetrieveHint;
import lims.web.com.frame.validator.SaveHint;

/**
* @FileName : ChpRtpcrWkController.java
* @Project : lims
* @Date : 2019. 11. 19.
* @작성자 : 강희승
* @변경이력 :
* @프로그램 설명 :
*/
@Controller
public class ChpRtpcrWkController {
    Logger logger = LogManager.getLogger();

    @Resource(name="customValidator")
    private CustomValidator customValidator;

	@Resource(name="messageSourceAccessor")
	private MessageSourceAccessor messageSourceAccessor;

	@Resource(name="chpRtpcrWkService")
	ChpRtpcrWkService chpRtpcrWkService;

	@RequestMapping(value="/chp/rtpcr/retrieveRtpcrWkForm.do")
	public String retrieveRtpcrWkForm() {
		return "chp/rtpcr/retrieveRtpcrWkForm";
	}

	/**워크시트리스트 조회*/
	@RequestMapping(value="/chp/rtpcr/retrievePcrWkList.do")
	public String retrieveWkList(Model model, CommonData commonData) throws Exception {
		ChpRtpcrWk searchKeyword = commonData.get("rtpcrWkForm", ChpRtpcrWk.class);

		if ("searchOrderNo".equals(searchKeyword.getSearchBaseCd() ) )
		{
			searchKeyword.setSearchOrderNo(searchKeyword.getSearchKeyword());
		} else {
			searchKeyword.setSearchOrderCustNm(searchKeyword.getSearchKeyword());
		}
		boolean validate = customValidator.validate(searchKeyword, model, RetrieveHint.class);
		if (validate) {
			model.addAttribute("result", chpRtpcrWkService.retrieveWkList(searchKeyword));
		}

		return "jsonView";
	}

	/*PRODUCT 조회*/
	@RequestMapping(value="/chp/rtpcr/retrievePcrPrdctList.do")
	public String retrievePrdctList(Model model, CommonData commonData) throws Exception {
		ChpRtpcrWk searchKeyword = commonData.getJson(ChpRtpcrWk.class);
		if (searchKeyword != null) {
			model.addAttribute("result", chpRtpcrWkService.retrievePrdctList(searchKeyword));
		}
		return "jsonView";
	}

	@RequestMapping(value="/chp/rtpcr/retrievePcrExport.do")
	public String retrievePcrExport(Model model, CommonData commonData) throws Exception {
		ChpRtpcrWk searchKeyword = commonData.get("rtpcrWkForm", ChpRtpcrWk.class);

		boolean validate = customValidator.validate(searchKeyword, model, RetrieveHint.class);
		if (validate) {
			model.addAttribute("result", chpRtpcrWkService.retrievePcrExport(searchKeyword));
		}
		return "jsonView";
	}

	/*워크시트 삭제*/
	@RequestMapping(value="chp/rtpcr/deleteRtPcrWk.do")
	public String deleteRtPcrWk(Model model, CommonData commonData) throws Exception {
		List<ChpRtpcrWk> ibSheetData = commonData.getIBSheetData("workSheet", ChpRtpcrWk.class);
		boolean validate = customValidator.validate(ibSheetData, model, DeleteHint.class);
		if (validate) {
			chpRtpcrWkService.deleteRtPcrWkList(ibSheetData);
        	model.addAttribute("message", messageSourceAccessor.getMessage("infm.delete"));
        	model.addAttribute("result", "S");
		}
		return "jsonView";
	}

	/*워크시트 저장*/
	@RequestMapping(value="/chp/rtpcr/saveRtPcrWk.do")
	public String saveRtPcrWk(Model model, CommonData commonData) throws Exception {
		List<ChpRtpcrWk> ibSheetData = commonData.getIBSheetData("workSheet", ChpRtpcrWk.class);
		boolean validate = customValidator.validate(ibSheetData, model, SaveHint.class);

		if (validate) {
			chpRtpcrWkService.saveRtPcrWk(ibSheetData);
        	model.addAttribute("message", messageSourceAccessor.getMessage("infm.save"));
        	model.addAttribute("result", "S");
		}
		return "jsonView";

	}

	/**Product 저장*/
	@RequestMapping(value="/chp/rtpcr/saveRtPcrPrdct.do")
	public String saveRtPcrPrdct(Model model, CommonData commonData) throws Exception {
		List<ChpRtpcrWk> ibSheetData = commonData.getIBSheetData("prdctSheet", ChpRtpcrWk.class);
		boolean validate = customValidator.validate(ibSheetData, model, SaveHint.class);
		if (validate) {
			chpRtpcrWkService.saveRtPcrPrdct(ibSheetData);
        	model.addAttribute("message", messageSourceAccessor.getMessage("infm.save"));
        	model.addAttribute("result", "S");
		}
		return "jsonView";

	}

	/*PlateDesignPopup*/
	@RequestMapping(value="/chp/rtpcr/retrievePlateDesignPopup.do")
	public String retrievePlateDesignPopupForm(Model model, ChpRtpcrWk plateId) throws Exception{
		String title = messageSourceAccessor.getMessage("word.title.rtpcr.plate"); //Real-Time PCR Plate 디자인
		model.addAttribute(PopupConstants.POPUP_TITLE, title);
		return "chp/rtpcr/retrievePlateDesignPopup";
	}

	/*PlateDesignPopup*/
	@RequestMapping(value="/chp/rtpcr/retrievePlateStructure.do")
	public String retrievePlateStructure(Model model, CommonData commonData) throws Exception{
		ChpRtpcrWk wshId = commonData.getJson(ChpRtpcrWk.class);
		boolean validate = customValidator.validate(wshId, model, RetrieveHint.class);
		if (validate) {
			List<ChpPlateDesign> chpPlateDesign  = chpRtpcrWkService.retrievePlateStructure(wshId);
			String [][] prdctNameArray = new String[16][24];
			String [][] bgColorArray = new String[16][24];
			String [][] ctrlYnArray = new String[16][24];

			for (int i=0; i < chpPlateDesign.size(); i++) {
				//prdctNameArray
				prdctNameArray[i][0] = (chpPlateDesign.get(i).getPrdctNm01() == null ? prdctNameArray[i][0]="" :   chpPlateDesign.get(i).getPrdctNm01());
				prdctNameArray[i][1] = (chpPlateDesign.get(i).getPrdctNm02() == null ? prdctNameArray[i][1] ="" :  chpPlateDesign.get(i).getPrdctNm02());
				prdctNameArray[i][2] = (chpPlateDesign.get(i).getPrdctNm03() == null ? prdctNameArray[i][2] ="" :  chpPlateDesign.get(i).getPrdctNm03());
				prdctNameArray[i][3] = (chpPlateDesign.get(i).getPrdctNm04() == null ? prdctNameArray[i][3] = "" : chpPlateDesign.get(i).getPrdctNm04());
				prdctNameArray[i][4] = (chpPlateDesign.get(i).getPrdctNm05() == null ? prdctNameArray[i][4] = "" : chpPlateDesign.get(i).getPrdctNm05());
				prdctNameArray[i][5] = (chpPlateDesign.get(i).getPrdctNm06() == null ? prdctNameArray[i][5] = "" : chpPlateDesign.get(i).getPrdctNm06());
				prdctNameArray[i][6] = (chpPlateDesign.get(i).getPrdctNm07() == null ? prdctNameArray[i][6] = "" : chpPlateDesign.get(i).getPrdctNm07());
				prdctNameArray[i][7] = (chpPlateDesign.get(i).getPrdctNm08() == null ? prdctNameArray[i][7] = "" : chpPlateDesign.get(i).getPrdctNm08());
				prdctNameArray[i][8] = (chpPlateDesign.get(i).getPrdctNm09() == null ? prdctNameArray[i][8] = "" : chpPlateDesign.get(i).getPrdctNm09());
				prdctNameArray[i][9] = (chpPlateDesign.get(i).getPrdctNm10() == null ? prdctNameArray[i][9] = "" : chpPlateDesign.get(i).getPrdctNm10());

				prdctNameArray[i][10] = (chpPlateDesign.get(i).getPrdctNm11() == null ? prdctNameArray[i][10] = "" : chpPlateDesign.get(i).getPrdctNm11());
				prdctNameArray[i][11] = (chpPlateDesign.get(i).getPrdctNm12() == null ? prdctNameArray[i][11] = "" : chpPlateDesign.get(i).getPrdctNm12());
				prdctNameArray[i][12] = (chpPlateDesign.get(i).getPrdctNm13() == null ? prdctNameArray[i][12] = "" : chpPlateDesign.get(i).getPrdctNm13());
				prdctNameArray[i][13] = (chpPlateDesign.get(i).getPrdctNm14() == null ? prdctNameArray[i][13] = "" : chpPlateDesign.get(i).getPrdctNm14());
				prdctNameArray[i][14] = (chpPlateDesign.get(i).getPrdctNm15() == null ? prdctNameArray[i][14] = "" : chpPlateDesign.get(i).getPrdctNm15());
				prdctNameArray[i][15] = (chpPlateDesign.get(i).getPrdctNm16() == null ? prdctNameArray[i][15] = "" : chpPlateDesign.get(i).getPrdctNm16());
				prdctNameArray[i][16] = (chpPlateDesign.get(i).getPrdctNm17() == null ? prdctNameArray[i][16] = "" : chpPlateDesign.get(i).getPrdctNm17());
				prdctNameArray[i][17] = (chpPlateDesign.get(i).getPrdctNm18() == null ? prdctNameArray[i][17] = "" : chpPlateDesign.get(i).getPrdctNm18());
				prdctNameArray[i][18] = (chpPlateDesign.get(i).getPrdctNm19() == null ? prdctNameArray[i][18] = "" : chpPlateDesign.get(i).getPrdctNm19());
				prdctNameArray[i][19] = (chpPlateDesign.get(i).getPrdctNm20() == null ? prdctNameArray[i][19] = "" : chpPlateDesign.get(i).getPrdctNm20());

				prdctNameArray[i][20] = (chpPlateDesign.get(i).getPrdctNm21() == null ? prdctNameArray[i][20] = "" : chpPlateDesign.get(i).getPrdctNm21());
				prdctNameArray[i][21] = (chpPlateDesign.get(i).getPrdctNm22() == null ? prdctNameArray[i][21] = "" : chpPlateDesign.get(i).getPrdctNm22());
				prdctNameArray[i][22] = (chpPlateDesign.get(i).getPrdctNm23() == null ? prdctNameArray[i][22] = "" : chpPlateDesign.get(i).getPrdctNm23());
				prdctNameArray[i][23] = (chpPlateDesign.get(i).getPrdctNm24() == null ? prdctNameArray[i][23] = "" : chpPlateDesign.get(i).getPrdctNm24());

				//bgColorArray
				bgColorArray[i][0] = (chpPlateDesign.get(i).getBgColor01() == null ? bgColorArray[i][0] = "" : chpPlateDesign.get(i).getBgColor01());
				bgColorArray[i][1] = (chpPlateDesign.get(i).getBgColor02() == null ? bgColorArray[i][1] = "" : chpPlateDesign.get(i).getBgColor02());
				bgColorArray[i][2] = (chpPlateDesign.get(i).getBgColor03() == null ? bgColorArray[i][2] = "" : chpPlateDesign.get(i).getBgColor03());
				bgColorArray[i][3] = (chpPlateDesign.get(i).getBgColor04() == null ? bgColorArray[i][3] = "" : chpPlateDesign.get(i).getBgColor04());
				bgColorArray[i][4] = (chpPlateDesign.get(i).getBgColor05() == null ? bgColorArray[i][4] = "" : chpPlateDesign.get(i).getBgColor05());
				bgColorArray[i][5] = (chpPlateDesign.get(i).getBgColor06() == null ? bgColorArray[i][5] = "" : chpPlateDesign.get(i).getBgColor06());
				bgColorArray[i][6] = (chpPlateDesign.get(i).getBgColor07() == null ? bgColorArray[i][6] = "" : chpPlateDesign.get(i).getBgColor07());
				bgColorArray[i][7] = (chpPlateDesign.get(i).getBgColor08() == null ? bgColorArray[i][7] = "" : chpPlateDesign.get(i).getBgColor08());
				bgColorArray[i][8] = (chpPlateDesign.get(i).getBgColor09() == null ? bgColorArray[i][8] = "" : chpPlateDesign.get(i).getBgColor09());
				bgColorArray[i][9] = (chpPlateDesign.get(i).getBgColor10() == null ? bgColorArray[i][9] = "" : chpPlateDesign.get(i).getBgColor10());

				bgColorArray[i][10] = (chpPlateDesign.get(i).getBgColor11() == null ? bgColorArray[i][10] = "" : chpPlateDesign.get(i).getBgColor11());
				bgColorArray[i][11] = (chpPlateDesign.get(i).getBgColor12() == null ? bgColorArray[i][11] = "" : chpPlateDesign.get(i).getBgColor12());
				bgColorArray[i][12] = (chpPlateDesign.get(i).getBgColor13() == null ? bgColorArray[i][12] = "" : chpPlateDesign.get(i).getBgColor13());
				bgColorArray[i][13] = (chpPlateDesign.get(i).getBgColor14() == null ? bgColorArray[i][13] = "" : chpPlateDesign.get(i).getBgColor14());
				bgColorArray[i][14] = (chpPlateDesign.get(i).getBgColor15() == null ? bgColorArray[i][14] = "" : chpPlateDesign.get(i).getBgColor15());
				bgColorArray[i][15] = (chpPlateDesign.get(i).getBgColor16() == null ? bgColorArray[i][15] = "" : chpPlateDesign.get(i).getBgColor16());
				bgColorArray[i][16] = (chpPlateDesign.get(i).getBgColor17() == null ? bgColorArray[i][16] = "" : chpPlateDesign.get(i).getBgColor17());
				bgColorArray[i][17] = (chpPlateDesign.get(i).getBgColor18() == null ? bgColorArray[i][17] = "" : chpPlateDesign.get(i).getBgColor18());
				bgColorArray[i][18] = (chpPlateDesign.get(i).getBgColor19() == null ? bgColorArray[i][18] = "" : chpPlateDesign.get(i).getBgColor19());
				bgColorArray[i][19] = (chpPlateDesign.get(i).getBgColor20() == null ? bgColorArray[i][19] = "" : chpPlateDesign.get(i).getBgColor20());

				bgColorArray[i][20] = (chpPlateDesign.get(i).getBgColor21() == null ? bgColorArray[i][20] = "" : chpPlateDesign.get(i).getBgColor21());
				bgColorArray[i][21] = (chpPlateDesign.get(i).getBgColor22() == null ? bgColorArray[i][21] = "" : chpPlateDesign.get(i).getBgColor22());
				bgColorArray[i][22] = (chpPlateDesign.get(i).getBgColor23() == null ? bgColorArray[i][22] = "" : chpPlateDesign.get(i).getBgColor23());
				bgColorArray[i][23] = (chpPlateDesign.get(i).getBgColor24() == null ? bgColorArray[i][23] = "" : chpPlateDesign.get(i).getBgColor24());

				//ctrlYnArray
				ctrlYnArray[i][0] = (chpPlateDesign.get(i).getCtrlYn01() == null ? ctrlYnArray[i][0] = "" : chpPlateDesign.get(i).getCtrlYn01());
				ctrlYnArray[i][1] = (chpPlateDesign.get(i).getCtrlYn02() == null ? ctrlYnArray[i][1] = "" : chpPlateDesign.get(i).getCtrlYn02());
				ctrlYnArray[i][2] = (chpPlateDesign.get(i).getCtrlYn03() == null ? ctrlYnArray[i][2] = "" : chpPlateDesign.get(i).getCtrlYn03());
				ctrlYnArray[i][3] = (chpPlateDesign.get(i).getCtrlYn04() == null ? ctrlYnArray[i][3] = "" : chpPlateDesign.get(i).getCtrlYn04());
				ctrlYnArray[i][4] = (chpPlateDesign.get(i).getCtrlYn05() == null ? ctrlYnArray[i][4] = "" : chpPlateDesign.get(i).getCtrlYn05());
				ctrlYnArray[i][5] = (chpPlateDesign.get(i).getCtrlYn06() == null ? ctrlYnArray[i][5] = "" : chpPlateDesign.get(i).getCtrlYn06());
				ctrlYnArray[i][6] = (chpPlateDesign.get(i).getCtrlYn07() == null ? ctrlYnArray[i][6] = "" : chpPlateDesign.get(i).getCtrlYn07());
				ctrlYnArray[i][7] = (chpPlateDesign.get(i).getCtrlYn08() == null ? ctrlYnArray[i][7] = "" : chpPlateDesign.get(i).getCtrlYn08());
				ctrlYnArray[i][8] = (chpPlateDesign.get(i).getCtrlYn09() == null ? ctrlYnArray[i][8] = "" : chpPlateDesign.get(i).getCtrlYn09());
				ctrlYnArray[i][9] = (chpPlateDesign.get(i).getCtrlYn10() == null ? ctrlYnArray[i][9] = "" : chpPlateDesign.get(i).getCtrlYn10());

				ctrlYnArray[i][10] = (chpPlateDesign.get(i).getCtrlYn11() == null ? ctrlYnArray[i][10] = "" : chpPlateDesign.get(i).getCtrlYn11());
				ctrlYnArray[i][11] = (chpPlateDesign.get(i).getCtrlYn12() == null ? ctrlYnArray[i][11] = "" : chpPlateDesign.get(i).getCtrlYn12());
				ctrlYnArray[i][12] = (chpPlateDesign.get(i).getCtrlYn13() == null ? ctrlYnArray[i][12] = "" : chpPlateDesign.get(i).getCtrlYn13());
				ctrlYnArray[i][13] = (chpPlateDesign.get(i).getCtrlYn14() == null ? ctrlYnArray[i][13] = "" : chpPlateDesign.get(i).getCtrlYn14());
				ctrlYnArray[i][14] = (chpPlateDesign.get(i).getCtrlYn15() == null ? ctrlYnArray[i][14] = "" : chpPlateDesign.get(i).getCtrlYn15());
				ctrlYnArray[i][15] = (chpPlateDesign.get(i).getCtrlYn16() == null ? ctrlYnArray[i][15] = "" : chpPlateDesign.get(i).getCtrlYn16());
				ctrlYnArray[i][16] = (chpPlateDesign.get(i).getCtrlYn17() == null ? ctrlYnArray[i][16] = "" : chpPlateDesign.get(i).getCtrlYn17());
				ctrlYnArray[i][17] = (chpPlateDesign.get(i).getCtrlYn18() == null ? ctrlYnArray[i][17] = "" : chpPlateDesign.get(i).getCtrlYn18());
				ctrlYnArray[i][18] = (chpPlateDesign.get(i).getCtrlYn19() == null ? ctrlYnArray[i][18] = "" : chpPlateDesign.get(i).getCtrlYn19());
				ctrlYnArray[i][19] = (chpPlateDesign.get(i).getCtrlYn20() == null ? ctrlYnArray[i][19] = "" : chpPlateDesign.get(i).getCtrlYn20());

				ctrlYnArray[i][20] = (chpPlateDesign.get(i).getCtrlYn21() == null ? ctrlYnArray[i][20] = "" : chpPlateDesign.get(i).getCtrlYn21());
				ctrlYnArray[i][21] = (chpPlateDesign.get(i).getCtrlYn22() == null ? ctrlYnArray[i][21] = "" : chpPlateDesign.get(i).getCtrlYn22());
				ctrlYnArray[i][22] = (chpPlateDesign.get(i).getCtrlYn23() == null ? ctrlYnArray[i][22] = "" : chpPlateDesign.get(i).getCtrlYn23());
				ctrlYnArray[i][23] = (chpPlateDesign.get(i).getCtrlYn24() == null ? ctrlYnArray[i][23] = "" : chpPlateDesign.get(i).getCtrlYn24());
			}

			Map<String, Object>result = new HashMap<String, Object>();
			result.put("prdctNameArray", prdctNameArray);
			result.put("bgColorArray", bgColorArray);
			result.put("ctrlYnArray", ctrlYnArray);

			model.addAttribute("result", result);

		}
		return "jsonView";
	}

	/*384Plate.xls 저장*/
	@RequestMapping("/chp/rtpcr/save384Plate.do")
	public String save384Plate(Model model, CommonData commonData) throws Exception {
		ChpRtpcrWk fmData = commonData.get("retrievePlateDesignPopup", ChpRtpcrWk.class);
		ChpPlateDesign chpPlateDesign = commonData.getJson(ChpPlateDesign.class);
		boolean validate = customValidator.validate(fmData, model, SaveHint.class);
		if (validate) {
			chpRtpcrWkService.save384PlateExcel(chpPlateDesign, fmData);
			model.addAttribute("message", messageSourceAccessor.getMessage("infm.save"));
			model.addAttribute("result", "S");
		}
		return "jsonView";
	}

	/*템플릿 파일 다운로드*/
	@RequestMapping("/chp/rtpcr/templateFileDown.do")
	public void templateFileDown(HttpServletResponse response, HttpServletRequest request) throws Exception {

		//String path = UrlUtil.getDomain() + "resources/excel_template/384_plate.xls";
		String path = request.getSession().getServletContext().getRealPath("/")+"resources/excel_template/384_plate.xls";
		String fileName = "384_plate.xls";
	    FileInputStream inputStream = null;
	    ServletOutputStream outputStream = null;
		File file = new File(path);

        String downName = null;
        String browser = request.getHeader("User-Agent");

        if (file.exists() && file.isFile()) {
		        if(browser.contains("MSIE") ||  browser.contains("Chrome")){//브라우저 확인 파일명 encode
		            downName = URLEncoder.encode(fileName,"UTF-8").replaceAll("\\+", "%20");
		        }else{
		            downName = new String(fileName.getBytes("UTF-8"), "ISO-8859-1");
		        }

		        downName = URLEncoder.encode(fileName,"UTF-8").replaceAll("\\+", "%20");
		        response.setHeader("Content-Disposition","attachment; filename=\"" + downName+"\"");
		        response.setContentType("application/octet-stream");
		        response.setHeader("Content-Transfer-Encoding", "binary;");

		        try {
			        inputStream = new FileInputStream(file);
			        outputStream = response.getOutputStream();

			        byte bytes [] = new byte[512];
			        int nCount = 0;

			        while((nCount= inputStream.read(bytes)) != -1) {
			        	outputStream.write(bytes, 0, nCount);
			        }
		        } finally {
		        	if(inputStream != null) inputStream.close();
		        	if(outputStream != null) outputStream.close();
		        }
        }
   }
}
