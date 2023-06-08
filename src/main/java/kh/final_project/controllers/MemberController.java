package kh.final_project.controllers;


import kh.final_project.dto.MemberDTO;
import kh.final_project.repositories.MemberDAO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpSession;

@Controller
@RequestMapping("/member/")
public class MemberController {

    @Autowired
    private MemberDAO mdao;
    @Autowired
    private HttpSession session;


    @RequestMapping("signup")
    public String signup(){
        return"member/signupForm";
    }

    @RequestMapping("loginForm")
    public String loginForm(){
        return "/member/loginForm";
    }

    @PostMapping("login")
    public String login(MemberDTO dto){
        dto.setEmail_type(1002);
        mdao.login(dto);

        System.out.println(dto);

        if(dto.getNickname() != null){
            session.setAttribute("code",dto.getCode());
            session.setAttribute("nickName",dto.getNickname());
            session.setAttribute("memberType",dto.getMember_type());
        }
        return "/member/loginForm";
    }

    @RequestMapping("mypage")
    public String mypage(){
        return "/member/myPageForm";
    }
}
