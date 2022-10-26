package lims.web.ngs.setup.controller;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import egovframework.rte.fdl.cmmn.exception.EgovBizException;
import lims.web.com.frame.ajax.CommonData;
import lims.web.com.frame.validator.CustomValidator;
import lims.web.com.frame.validator.RetrieveHint;
import lims.web.com.frame.validator.SaveHint;
import lims.web.ngs.setup.model.NgsSetupPerformCode;
import lims.web.ngs.setup.service.NgsSetupPerformCodeService;

@Controller
public class NgsSetupPerformCodeController {

	@Resource(name="customValidator")
    private CustomValidator customValidator;

    @Resource(name = "ngsSetupPerformCodeService")
    NgsSetupPerformCodeService ngsSetupPerformCodeService;

	@Resource(name="messageSourceAccessor")
	private MessageSourceAccessor messageSourceAccessor;

    @RequestMapping("/ngs/setup/retrievePerformCodeMgtForm.do")
    public String retrievePerformCodeMgtForm() {
        return "ngs/setup/retrievePerformCodeMgtForm";
    }

    /**
	 * 수행코드 목록을 조회함
	 *
	 * @param model
	 * @param commonData
	 * @return
	 * @throws EgovBizException
	 */
	@RequestMapping("/ngs/setup/retrievePerformCodes.do")
	public String retrievePerformCodes(Model model, CommonData commonData) throws EgovBizException {
		NgsSetupPerformCode performCode = commonData.get("performCodeForm", NgsSetupPerformCode.class);
		boolean validate = customValidator.validate(performCode, model, RetrieveHint.class);
		if (validate) {
			model.addAttribute("performCodes", ngsSetupPerformCodeService.retrievePerformCodes(performCode));
		}
		// Json타입으로 응답함
		return "jsonView";
	}
	/**
	 * 수행코드상세 목록을 조회함
	 *
	 * @param model
	 * @param commonData
	 * @return
	 * @throws EgovBizException
	 */
	@RequestMapping("/ngs/setup/retrievePerformCodeDetails.do")
	public String retrievePerformCodeDetails(Model model, CommonData commonData) {
		// CommonAjax의 addParam으로 Json을 추가한 경우 지정한 모델로 추출함
		NgsSetupPerformCode searchCode = commonData.getJson(NgsSetupPerformCode.class);

		model.addAttribute("performCodeDetails", ngsSetupPerformCodeService.retrievePerformCodeDetails(searchCode));

		// Json타입으로 응답함
		return "jsonView";
	}

	/**
     * 수행코드상세 목록을 저장함
     * @param model
     * @param commonData
     * @return
     * @throws EgovBizException
     */
    @RequestMapping("/ngs/setup/savePerformCodeDetails.do")
    public String savePerformCodeDetails(Model model, CommonData commonData) throws EgovBizException {
    	// CommonAjax의 addParam으로 ibsheet를 추가한 경우 목록을 지정한 모델의 리스트로 추출함
        List<NgsSetupPerformCode> ibSheetData = commonData.getIBSheetData("ibsPerformCodeDetail", NgsSetupPerformCode.class);
        // 유효성 검증
        boolean validate = customValidator.validate(ibSheetData, model, SaveHint.class);
        if(validate) {
        	ngsSetupPerformCodeService.savePerformCodeDetails(ibSheetData);
        	model.addAttribute("message", messageSourceAccessor.getMessage("infm.save"));
        	model.addAttribute("result", "S");
        }
        // Json타입으로 응답함
        return "jsonView";
    }
}
