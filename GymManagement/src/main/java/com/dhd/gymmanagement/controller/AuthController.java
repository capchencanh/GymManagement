package com.dhd.gymmanagement.controller;

import com.dhd.gymmanagement.entity.User;
import com.dhd.gymmanagement.service.UserService;
import com.dhd.gymmanagement.utils.JwtUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Controller
public class AuthController {

    @Autowired
    private UserService userService;

    @Autowired
    private BCryptPasswordEncoder passwordEncoder;

    // Hiển thị trang đăng nhập
    @GetMapping("/login")
    public String showLoginForm(Model model) {
        return "login";
    }

    // Xử lý đăng nhập
    @PostMapping("/login")
    public String login(@RequestParam String email,
                       @RequestParam String password,
                       @RequestParam(required = false) String redirect,
                       HttpSession session,
                       HttpServletResponse response,
                       RedirectAttributes redirectAttributes) {
        try {
            // Tìm user theo email
            User user = userService.getUserByEmail(email)
                    .orElseThrow(() -> new RuntimeException("Email không tồn tại"));

            // Kiểm tra mật khẩu
            if (!passwordEncoder.matches(password, user.getPasswordHash())) {
                redirectAttributes.addFlashAttribute("error", "Mật khẩu không đúng");
                return "redirect:/login";
            }

            // Tạo JWT token
            String jwtToken = JwtUtils.generateToken(
                user.getUserId().longValue(), 
                user.getEmail(), 
                user.getRole().name()
            );
            
            // Lưu JWT token vào cookie
            Cookie jwtCookie = new Cookie("jwt_token", jwtToken);
            jwtCookie.setHttpOnly(true);
            jwtCookie.setSecure(false); // Set true nếu dùng HTTPS
            jwtCookie.setPath("/");
            jwtCookie.setMaxAge(86400); // 1 day
            response.addCookie(jwtCookie);
            
            // Lưu thông tin user vào session
            session.setAttribute("user", user);
            session.setAttribute("userId", user.getUserId());
            session.setAttribute("userName", user.getName());
            session.setAttribute("userRole", user.getRole().name());
            session.setAttribute("jwtToken", jwtToken);

            redirectAttributes.addFlashAttribute("success", "Đăng nhập thành công! Chào mừng " + user.getName());
            
            // Nếu có redirect URL, chuyển hướng về đó
            if (redirect != null && !redirect.isEmpty()) {
                return "redirect:" + redirect;
            }
            
            // Redirect dựa trên role
            switch (user.getRole()) {
                case ADMIN:
                    return "redirect:/admin";
                case PT:
                    return "redirect:/pt/dashboard";
                case USER:
                    return "redirect:/user/dashboard";
                default:
                    return "redirect:/";
            }

        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            return "redirect:/login";
        }
    }

    // Hiển thị trang đăng ký
    @GetMapping("/register")
    public String showRegisterForm(Model model) {
        model.addAttribute("user", new User());
        return "register";
    }

    // Xử lý đăng ký
    @PostMapping("/register")
    public String register(@RequestParam String name,
                          @RequestParam String email,
                          @RequestParam String phoneNumber,
                          @RequestParam String password,
                          @RequestParam String confirmPassword,
                          @RequestParam String gender,
                          @RequestParam(required = false) String birthdate,
                          @RequestParam(required = false) Double height,
                          @RequestParam(required = false) Double weight,
                          @RequestParam(required = false) String fitnessGoal,
                          RedirectAttributes redirectAttributes) {
        try {
            // Kiểm tra mật khẩu xác nhận
            if (!password.equals(confirmPassword)) {
                redirectAttributes.addFlashAttribute("error", "Mật khẩu xác nhận không khớp");
                return "redirect:/register";
            }

            // Kiểm tra email đã tồn tại
            if (userService.getUserByEmail(email).isPresent()) {
                redirectAttributes.addFlashAttribute("error", "Email đã được sử dụng");
                return "redirect:/register";
            }

            // Kiểm tra số điện thoại đã tồn tại
            if (userService.getUserByPhoneNumber(phoneNumber).isPresent()) {
                redirectAttributes.addFlashAttribute("error", "Số điện thoại đã được sử dụng");
                return "redirect:/register";
            }

            // Tạo user mới
            User newUser = new User();
            newUser.setName(name);
            newUser.setEmail(email);
            newUser.setPhoneNumber(phoneNumber);
            newUser.setPasswordHash(password); // Sẽ được encode trong service
            newUser.setGender(gender);
            newUser.setRole(User.Role.USER); // Mặc định là USER
            newUser.setFitnessGoal(fitnessGoal);

            // Parse birthdate nếu có
            if (birthdate != null && !birthdate.trim().isEmpty()) {
                try {
                    newUser.setBirthdate(java.sql.Date.valueOf(birthdate));
                } catch (Exception e) {
                    // Ignore invalid date
                }
            }

            // Set height và weight nếu có
            if (height != null) newUser.setHeight(height);
            if (weight != null) newUser.setWeight(weight);

            // Lưu user
            userService.createUser(newUser);

            redirectAttributes.addFlashAttribute("success", "Đăng ký thành công! Vui lòng đăng nhập.");
            return "redirect:/login";

        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            return "redirect:/register";
        }
    }

    // Đăng xuất
    @GetMapping("/logout")
    public String logout(HttpSession session, HttpServletResponse response, RedirectAttributes redirectAttributes) {
        // Xóa JWT cookie
        Cookie jwtCookie = new Cookie("jwt_token", null);
        jwtCookie.setHttpOnly(true);
        jwtCookie.setSecure(false);
        jwtCookie.setPath("/");
        jwtCookie.setMaxAge(0); // Xóa cookie
        response.addCookie(jwtCookie);
        
        // Xóa session
        session.invalidate();
        redirectAttributes.addFlashAttribute("success", "Đăng xuất thành công!");
        return "redirect:/";
    }

    // Quên mật khẩu
    @GetMapping("/forgot-password")
    public String showForgotPasswordForm() {
        return "forgot_password";
    }

    @PostMapping("/forgot-password")
    public String forgotPassword(@RequestParam String email, RedirectAttributes redirectAttributes) {
        try {
            User user = userService.getUserByEmail(email)
                    .orElseThrow(() -> new RuntimeException("Email không tồn tại"));

            // TODO: Implement email sending functionality
            // For now, just show success message
            redirectAttributes.addFlashAttribute("success", 
                "Hướng dẫn đặt lại mật khẩu đã được gửi đến email: " + email);
            
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }
        
        return "redirect:/forgot-password";
    }
}
