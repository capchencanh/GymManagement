package com.dhd.gymmanagement.controller.admin;

import com.dhd.gymmanagement.entity.User;
import com.dhd.gymmanagement.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
@RequestMapping("/admin/users")
public class AdminUserController {
    
    @Autowired
    private UserService userService;
    
    @GetMapping
    public String listUsers(Model model, 
                           @RequestParam(required = false) String keyword,
                           @RequestParam(required = false) String role) {
        List<User> users;
        
        if (keyword != null && !keyword.trim().isEmpty()) {
            if (role != null && !role.trim().isEmpty()) {
                try {
                    User.Role userRole = User.Role.valueOf(role.toUpperCase());
                    users = userService.searchUsersByRole(userRole, keyword);
                } catch (IllegalArgumentException e) {
                    users = userService.searchUsers(keyword);
                }
            } else {
                users = userService.searchUsers(keyword);
            }
        } else if (role != null && !role.trim().isEmpty()) {
            try {
                User.Role userRole = User.Role.valueOf(role.toUpperCase());
                users = userService.getUsersByRole(userRole);
            } catch (IllegalArgumentException e) {
                users = userService.getAllUsers();
            }
        } else {
            users = userService.getAllUsers();
        }
        
        // Tính toán thống kê
        long totalUsers = users.size();
        long adminCount = users.stream().filter(u -> u.getRole() == User.Role.ADMIN).count();
        long ptCount = users.stream().filter(u -> u.getRole() == User.Role.PT).count();
        long userCount = users.stream().filter(u -> u.getRole() == User.Role.USER).count();
        
        model.addAttribute("users", users);
        model.addAttribute("keyword", keyword);
        model.addAttribute("selectedRole", role);
        model.addAttribute("roles", User.Role.values());
        model.addAttribute("totalUsers", totalUsers);
        model.addAttribute("adminCount", adminCount);
        model.addAttribute("ptCount", ptCount);
        model.addAttribute("userCount", userCount);
        
        return "admin/user/simple-list";
    }
    
    @GetMapping("/create")
    public String createUserForm(Model model) {
        model.addAttribute("user", new User());
        model.addAttribute("roles", User.Role.values());
        return "admin/user/form";
    }
    
    @PostMapping("/create")
    public String createUser(@ModelAttribute User user, RedirectAttributes redirectAttributes) {
        try {
            userService.createUser(user);
            redirectAttributes.addFlashAttribute("success", "Tạo tài khoản thành công!");
            return "redirect:/admin/users";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            return "redirect:/admin/users/create";
        }
    }
    
    @GetMapping("/edit/{id}")
    public String editUserForm(@PathVariable Integer id, Model model) {
        User user = userService.getUserById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy người dùng"));
        
        model.addAttribute("user", user);
        model.addAttribute("roles", User.Role.values());
        return "admin/user/form";
    }
    
    @PostMapping("/edit/{id}")
    public String editUser(@PathVariable Integer id, @ModelAttribute User user, RedirectAttributes redirectAttributes) {
        try {
            userService.updateUser(id, user);
            redirectAttributes.addFlashAttribute("success", "Cập nhật tài khoản thành công!");
            return "redirect:/admin/users";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            return "redirect:/admin/users/edit/" + id;
        }
    }
    
    @PostMapping("/delete/{id}")
    public String deleteUser(@PathVariable Integer id, RedirectAttributes redirectAttributes) {
        try {
            userService.deleteUser(id);
            redirectAttributes.addFlashAttribute("success", "Xóa tài khoản thành công!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }
        return "redirect:/admin/users";
    }
    
    @GetMapping("/view/{id}")
    public String viewUser(@PathVariable Integer id, Model model) {
        User user = userService.getUserById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy người dùng"));
        
        model.addAttribute("user", user);
        return "admin/user/view";
    }
    
    @GetMapping("/reset-password/{id}")
    public String resetPasswordForm(@PathVariable Integer id, Model model) {
        User user = userService.getUserById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy người dùng"));
        
        model.addAttribute("user", user);
        return "admin/user/reset-password";
    }
    
    @PostMapping("/reset-password/{id}")
    public String resetPassword(@PathVariable Integer id, 
                               @RequestParam String newPassword, 
                               RedirectAttributes redirectAttributes) {
        try {
            userService.resetPassword(id, newPassword);
            redirectAttributes.addFlashAttribute("success", "Đặt lại mật khẩu thành công!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }
        return "redirect:/admin/users";
    }
}
