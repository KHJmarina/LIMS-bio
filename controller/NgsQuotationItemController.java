package lims.web.ngs.setup.controller;

import java.util.List;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import egovframework.rte.fdl.cmmn.exception.EgovBizException;
import lims.web.com.frame.ajax.CommonData;
import lims.web.com.frame.popup.PopupConstants;
import lims.web.com.frame.validator.CustomValidator;
import lims.web.com.frame.validator.RetrieveHint;
import lims.web.ngs.setup.model.NgsEstmtItmBomInfo;
import lims.web.ngs.setup.model.NgsEstmtItmGropInfo;
import lims.web.ngs.setup.model.NgsEstmtItmInfo;
import lims.web.ngs.setup.model.NgsEstmtItmUnprInfo;
import lims.web.ngs.setup.service.NgsQuotationItemService;

@Controller
public class NgsQuotationItemController {

    Logger logger = LogManager.getLogger();

    @Resource(name="customValidator")
    private CustomValidator customValidator;

    @Resource(name = "ngsQuotationItemService")
    NgsQuotationItemService ngsQuotationItemService;

	@Resource(name="messageSourceAccessor")
	private MessageSourceAccessor messageSourceAccessor;

	/**견적품목관리**/
    @RequestMapping(value = "/ngs/setup/quotation/retrieveQuotationItemForm.do")
    public String retrieveQuotationItemForm() {
        return "ngs/setup/retrieveQuotationItemListForm";
    }

    /**견적품목정보 목록 조회**/
    @RequestMapping("/ngs/setup/quotation/retrieveQuotationItemList.do")
    public String retrieveQuotationItemList(Model model, CommonData commonData) {
    	NgsEstmtItmInfo searchKeyword = commonData.get("quotationForm", NgsEstmtItmInfo.class);
    	boolean validate = customValidator.validate(searchKeyword, model, RetrieveHint.class);
    	if(validate) {
    		model.addAttribute("result", ngsQuotationItemService.retrieveQuotationItemList(searchKeyword));
    	}

        // Json타입으로 응답함
        return "jsonView";
    }

    /**견적품목정보 목록 삭제**/
	@RequestMapping("/ngs/setup/quotation/deleteQuotationItemList.do")
    public String deleteQuotationItemList(Model model, CommonData commonData) throws EgovBizException {
        List<NgsEstmtItmInfo> sheetData = commonData.getIBSheetData("itemSheet", NgsEstmtItmInfo.class);

        ngsQuotationItemService.deleteQuotationItemList(sheetData);

    	String msg = messageSourceAccessor.getMessage("infm.delete");

		model.addAttribute("message", msg);
		model.addAttribute("result", "S");

        // Json타입으로 응답함
        return "jsonView";
    }

    /**견적품목정보 목록 저장**/
	@RequestMapping("/ngs/setup/quotation/saveQuotationItemList.do")
    public String saveQuotationItemList(Model model, CommonData commonData) throws EgovBizException {
        List<NgsEstmtItmInfo> sheetData = commonData.getIBSheetData("itemSheet", NgsEstmtItmInfo.class);

        ngsQuotationItemService.saveQuotationItemList(sheetData);

    	String msg = messageSourceAccessor.getMessage("infm.save");

		model.addAttribute("message", msg);
		model.addAttribute("result", "S");

        // Json타입으로 응답함
        return "jsonView";
    }

    /**견적품목정보 상태 수정**/
	@RequestMapping("/ngs/setup/quotation/updateEstmtItmInfoStatCd.do")
    public String updateEstmtItmInfoStatCd(Model model, CommonData commonData) throws EgovBizException {
    	NgsEstmtItmInfo formData = commonData.get("quotationForm", NgsEstmtItmInfo.class);

        ngsQuotationItemService.updateEstmtItmInfoStatCd(formData);

    	String msg = messageSourceAccessor.getMessage("infm.save");

		model.addAttribute("message", msg);
		model.addAttribute("result", "S");

        // Json타입으로 응답함
        return "jsonView";
    }


    /**견적품목단가정보 목록 조회**/
    @RequestMapping("/ngs/setup/quotation/retrieveQuotationItemPriceList.do")
    public String retrieveQuotationItemPriceList(Model model, CommonData commonData) {
    	NgsEstmtItmUnprInfo searchKeyword = commonData.get("quotationForm", NgsEstmtItmUnprInfo.class);
    	boolean validate = customValidator.validate(searchKeyword, model, RetrieveHint.class);
    	if(validate) {
    		model.addAttribute("result", ngsQuotationItemService.retrieveQuotationItemPriceList(searchKeyword));
    	}

        // Json타입으로 응답함
        return "jsonView";
    }

    /**견적품목단가정보 목록 삭제**/
	@RequestMapping("/ngs/setup/quotation/deleteQuotationItemPriceList.do")
    public String deleteQuotationItemPriceList(Model model, CommonData commonData) throws EgovBizException {
        List<NgsEstmtItmUnprInfo> sheetData = commonData.getIBSheetData("priceSheet", NgsEstmtItmUnprInfo.class);

        ngsQuotationItemService.deleteQuotationItemPriceList(sheetData);

    	String msg = messageSourceAccessor.getMessage("infm.delete");

		model.addAttribute("message", msg);
		model.addAttribute("result", "S");

        // Json타입으로 응답함
        return "jsonView";
    }

    /**견적품목단가정보 목록 저장**/
	@RequestMapping("/ngs/setup/quotation/saveQuotationItemPriceList.do")
    public String saveQuotationItemPriceList(Model model, CommonData commonData) throws EgovBizException {
        List<NgsEstmtItmUnprInfo> sheetData = commonData.getIBSheetData("priceSheet", NgsEstmtItmUnprInfo.class);

        ngsQuotationItemService.saveQuotationItemPriceList(sheetData);

    	String msg = messageSourceAccessor.getMessage("infm.save");

		model.addAttribute("message", msg);
		model.addAttribute("result", "S");

        // Json타입으로 응답함
        return "jsonView";
    }


	/**견적품목그룹정보 팝업**/
    @RequestMapping(value = "/ngs/setup/quotation/retrieveQuotationItemGroupListPopup.do")
    public String retrieveQuotationItemGroupListPopup(Model model) {
        model.addAttribute(PopupConstants.POPUP_TITLE, messageSourceAccessor.getMessage("word.prdlst.group.info"));
        return "ngs/setup/retrieveQuotationItemGroupListPopup";
    }

    /**견적품목그룹정보 목록 조회**/
    @RequestMapping("/ngs/setup/quotation/retrieveQuotationItemGroupList.do")
    public String retrieveQuotationItemGroupList(Model model, CommonData commonData) {
    	NgsEstmtItmGropInfo searchKeyword = commonData.get("groupForm", NgsEstmtItmGropInfo.class);
    	boolean validate = customValidator.validate(searchKeyword, model, RetrieveHint.class);
    	if(validate) {
    		model.addAttribute("result", ngsQuotationItemService.retrieveQuotationItemGroupList(searchKeyword));
    	}

        // Json타입으로 응답함
        return "jsonView";
    }

    /**견적품목그룹정보 목록 삭제**/
	@RequestMapping("/ngs/setup/quotation/deleteQuotationItemGroupList.do")
    public String deleteQuotationItemGroupList(Model model, CommonData commonData) throws EgovBizException {
        List<NgsEstmtItmGropInfo> sheetData = commonData.getIBSheetData("groupSheet", NgsEstmtItmGropInfo.class);

        ngsQuotationItemService.deleteQuotationItemGroupList(sheetData);

    	String msg = messageSourceAccessor.getMessage("infm.delete");

		model.addAttribute("message", msg);
		model.addAttribute("result", "S");

        // Json타입으로 응답함
        return "jsonView";
    }

    /**견적품목그룹정보 목록 저장**/
	@RequestMapping("/ngs/setup/quotation/saveQuotationItemGroupList.do")
    public String saveQuotationItemGroupList(Model model, CommonData commonData) throws EgovBizException {
        List<NgsEstmtItmGropInfo> sheetData = commonData.getIBSheetData("groupSheet", NgsEstmtItmGropInfo.class);

        ngsQuotationItemService.saveQuotationItemGroupList(sheetData);

    	String msg = messageSourceAccessor.getMessage("infm.save");

		model.addAttribute("message", msg);
		model.addAttribute("result", "S");

        // Json타입으로 응답함
        return "jsonView";
    }


	/**견적품목BOM정보**/
    @RequestMapping(value = "/ngs/setup/quotation/retrieveQuotationItemBomForm.do")
    public String retrieveQuotationItemBomForm() {
        return "ngs/setup/retrieveQuotationItemBomListForm";
    }

    /**견적품목BOM정보 목록 조회**/
    @RequestMapping("/ngs/setup/quotation/retrieveQuotationItemBomList.do")
    public String retrieveQuotationItemBomList(Model model, CommonData commonData) {
    	NgsEstmtItmBomInfo searchKeyword = commonData.get("quotationForm", NgsEstmtItmBomInfo.class);
    	boolean validate = customValidator.validate(searchKeyword, model, RetrieveHint.class);
    	if(validate) {
    		model.addAttribute("result", ngsQuotationItemService.retrieveQuotationItemBomList(searchKeyword));
    	}

        // Json타입으로 응답함
        return "jsonView";
    }

    /**견적품목BOM정보 목록 삭제**/
	@RequestMapping("/ngs/setup/quotation/deleteQuotationItemBomList.do")
    public String deleteQuotationItemBomList(Model model, CommonData commonData) throws EgovBizException {
        List<NgsEstmtItmBomInfo> sheetData = commonData.getIBSheetData("bomSheet", NgsEstmtItmBomInfo.class);

        ngsQuotationItemService.deleteQuotationItemBomList(sheetData);

    	String msg = messageSourceAccessor.getMessage("infm.delete");

		model.addAttribute("message", msg);
		model.addAttribute("result", "S");

        // Json타입으로 응답함
        return "jsonView";
    }

    /**견적품목BOM정보 목록 저장**/
	@RequestMapping("/ngs/setup/quotation/saveQuotationItemBomList.do")
    public String saveQuotationItemBomList(Model model, CommonData commonData) throws EgovBizException {
        List<NgsEstmtItmBomInfo> sheetData = commonData.getIBSheetData("bomSheet", NgsEstmtItmBomInfo.class);

        ngsQuotationItemService.saveQuotationItemBomList(sheetData);

    	String msg = messageSourceAccessor.getMessage("infm.save");

		model.addAttribute("message", msg);
		model.addAttribute("result", "S");

        // Json타입으로 응답함
        return "jsonView";
    }


}


