package lims.web.ngs.setup.controller;


import java.util.List;

import javax.annotation.Resource;

import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import egovframework.com.utl.fcc.service.EgovDateUtil;
import egovframework.rte.fdl.cmmn.exception.EgovBizException;
import lims.web.com.frame.ajax.CommonData;
import lims.web.com.frame.validator.CustomValidator;
import lims.web.com.frame.validator.RetrieveHint;
import lims.web.com.frame.validator.SaveHint;
import lims.web.ngs.setup.model.NgsSetupPlatform;
import lims.web.ngs.setup.model.NgsSetupPlatformEqtb;
import lims.web.ngs.setup.model.NgsSetupPlatformRunScale;
import lims.web.ngs.setup.service.NgsSetupPlatformService;

@Controller
public class NgsSetupPlatformController {

    @Resource(name="customValidator")
    private CustomValidator customValidator;

    @Resource(name = "ngsSetupPlatformService")
    NgsSetupPlatformService ngsSetupPlatformService;

    @Resource(name="messageSourceAccessor")
    private MessageSourceAccessor messageSourceAccessor;

    @RequestMapping("/ngs/setup/retrievePlatformMgtForm.do")
    public String retrievePlatformMgtForm() {
        return "ngs/setup/retrievePlatformMgtForm";
    }

    /**
     * 플렛폼 목록을 조회함
     * @param model
     * @param commonData
     * @return
     * @throws EgovBizException
     */
    @RequestMapping("/ngs/setup/retrievePlatforms.do")
    public String retrievePlatforms(Model model, CommonData commonData) throws EgovBizException {
        // CommonAjax의 addParam으로 폼을 추가한 경우 지정한 모델로 추출함
    	NgsSetupPlatform ngsSetupPlatform = commonData.get("frmPlatform", NgsSetupPlatform.class);

        // 유효성 검증
        boolean validate = customValidator.validate(ngsSetupPlatform, model, RetrieveHint.class);
        if(validate) {
            // CommonAjax에서 execute 후 Json형태로 전달받을 데이터를 등록함
            model.addAttribute("ibsPlatforms", ngsSetupPlatformService.retrievePlatforms(ngsSetupPlatform));
        }

        // Json타입으로 응답함
        return "jsonView";
    }

    /**
     * 플렛폼 목록을 저장함
     * @param model
     * @param commonData
     * @return
     * @throws EgovBizException
     */
    @RequestMapping("/ngs/setup/savePlatforms.do")
    public String savePlatforms(Model model, CommonData commonData) throws EgovBizException {
    	// CommonAjax의 addParam으로 ibsheet를 추가한 경우 목록을 지정한 모델의 리스트로 추출함
        List<NgsSetupPlatform> ibSheetData = commonData.getIBSheetData("ibsPlatform", NgsSetupPlatform.class);

        // 유효성 검증
        boolean validate = customValidator.validate(ibSheetData, model, SaveHint.class);

        if(validate) {
        	ngsSetupPlatformService.savePlatforms(ibSheetData);
        	model.addAttribute("message", messageSourceAccessor.getMessage("infm.save"));
        	model.addAttribute("result", "S");
        }
        // Json타입으로 응답함
        return "jsonView";
    }

    /**
     * 플렛폼 장비 목록을 조회함
     * @param model
     * @param commonData
     * @return
     * @throws EgovBizException
     */
    @RequestMapping("/ngs/setup/retrievePlatformEqtbs.do")
    public String retrievePlatformEqtbs(Model model, CommonData commonData) throws EgovBizException {
        // CommonAjax의 addParam으로 폼을 추가한 경우 지정한 모델로 추출함
    	NgsSetupPlatformEqtb ngsSetupPlatformEqtb = commonData.getJson(NgsSetupPlatformEqtb.class);

        // 유효성 검증
        boolean validate = customValidator.validate(ngsSetupPlatformEqtb, model, RetrieveHint.class);
        if(validate) {
            // CommonAjax에서 execute 후 Json형태로 전달받을 데이터를 등록함
            model.addAttribute("ibsPlatformEqtbs", ngsSetupPlatformService.retrievePlatformEqtbs(ngsSetupPlatformEqtb));
        }

        // Json타입으로 응답함
        return "jsonView";
    }

    /**
     * 플렛폼 장비 목록을 저장함
     * @param model
     * @param commonData
     * @return
     * @throws EgovBizException
     */
    @RequestMapping("/ngs/setup/savePlatformEqtbs.do")
    public String savePlatformEqtbs(Model model, CommonData commonData) throws EgovBizException {
    	// CommonAjax의 addParam으로 ibsheet를 추가한 경우 목록을 지정한 모델의 리스트로 추출함
        List<NgsSetupPlatformEqtb> ibSheetData = commonData.getIBSheetData("ibsPlatformEqtb", NgsSetupPlatformEqtb.class);
        EgovDateUtil.getToday();
        for(NgsSetupPlatformEqtb data : ibSheetData) {
        	if(EgovDateUtil.getDaysDiff(data.getAplyEndDt(), EgovDateUtil.getToday()) >= 0) {
        		throw new EgovBizException("종료일자는 현재일자 이후로 입력 할 수 있습니다.");
        	}
        }
        // 유효성 검증
        boolean validate = customValidator.validate(ibSheetData, model, SaveHint.class);

        if(validate) {
			ngsSetupPlatformService.savePlatformEqtbs(ibSheetData);
			model.addAttribute("message", messageSourceAccessor.getMessage("infm.save"));
        	model.addAttribute("result", "S");
        }
        // Json타입으로 응답함
        return "jsonView";
    }

    /**
     * 플렛폼 장비 목록을 조회함
     * @param model
     * @param commonData
     * @return
     * @throws EgovBizException
     */
    @RequestMapping("/ngs/setup/retrievePlatformRunScales.do")
    public String retrievePlatformRunScales(Model model, CommonData commonData) throws EgovBizException {
        // CommonAjax의 addParam으로 폼을 추가한 경우 지정한 모델로 추출함
    	NgsSetupPlatformRunScale ngsSetupPlatformRunScale = commonData.getJson(NgsSetupPlatformRunScale.class);

        // 유효성 검증
        boolean validate = customValidator.validate(ngsSetupPlatformRunScale, model, RetrieveHint.class);
        if(validate) {
            // CommonAjax에서 execute 후 Json형태로 전달받을 데이터를 등록함
            model.addAttribute("ibsPlatformRunScales", ngsSetupPlatformService.retrievePlatformRunScales(ngsSetupPlatformRunScale));
        }

        // Json타입으로 응답함
        return "jsonView";
    }


	/**
     * 플렛폼 목록을 저장함
     * @param model
     * @param commonData
     * @return
     * @throws EgovBizException
     */
    @RequestMapping("/ngs/setup/savePlatformRunScales.do")
    public String savePlatformRunScales(Model model, CommonData commonData) throws EgovBizException {
    	// CommonAjax의 addParam으로 ibsheet를 추가한 경우 목록을 지정한 모델의 리스트로 추출함
        List<NgsSetupPlatformRunScale> ibSheetData = commonData.getIBSheetData("ibsPlatformRunScale", NgsSetupPlatformRunScale.class);
        EgovDateUtil.getToday();
        for(NgsSetupPlatformRunScale data : ibSheetData) {
        	if(EgovDateUtil.getDaysDiff(data.getAplyEndDt(), EgovDateUtil.getToday()) >= 0) {
        		throw new EgovBizException("종료일자는 현재일자 이후로 입력 할 수 있습니다.");
        	}
        }
        // 유효성 검증
        boolean validate = customValidator.validate(ibSheetData, model, SaveHint.class);

        if(validate) {
        	ngsSetupPlatformService.savePlatformRunScales(ibSheetData);
        	model.addAttribute("message", messageSourceAccessor.getMessage("infm.save"));
        	model.addAttribute("result", "S");
        }
        // Json타입으로 응답함
        return "jsonView";
    }
}
