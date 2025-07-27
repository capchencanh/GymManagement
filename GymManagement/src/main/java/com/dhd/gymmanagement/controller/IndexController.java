package com.dhd.gymmanagement.controller;

import com.dhd.gymmanagement.service.CategoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class IndexController {
    @Autowired
    private CategoryService categoryService;

    @GetMapping("/")
    public String index(Model model) {
        model.addAttribute("categories", categoryService.getAllCategories());
        return "index";
    }
    
    @GetMapping("/admin")
    public String admin(Model model, @RequestParam(required = false) Integer categoryId) {
        if (categoryId != null) {
            // Redirect đến controller tương ứng dựa trên categoryId
            switch (categoryId) {
                case 7: // Quản lý tài khoản
                    return "redirect:/admin/users";
                case 8: // Quản lý huấn luyện viên
                    return "redirect:/admin/trainers";
                case 9: // Quản lý lớp tập
                    return "redirect:/admin/classes";
                case 10: // Quản lý gói tập
                    return "redirect:/admin/packages";
                case 11: // Quản lý thanh toán
                    return "redirect:/admin/payments";
                case 12: // Báo cáo thống kê
                    return "redirect:/admin/reports";
                default:
                    // Nếu không tìm thấy category, chuyển về dashboard
                    break;
            }
        }
        
        model.addAttribute("categories", categoryService.getAllCategories());
        return "admin/dashboard";
    }
} 