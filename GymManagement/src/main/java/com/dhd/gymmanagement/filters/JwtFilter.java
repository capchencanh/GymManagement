package com.dhd.gymmanagement.filters;

import com.dhd.gymmanagement.utils.JwtUtils;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.http.HttpServletRequest;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;

import java.io.IOException;
import java.util.Collections;
import java.util.List;
import java.util.Map;

public class JwtFilter implements Filter {
    private static final Logger logger = LoggerFactory.getLogger(JwtFilter.class);

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        String header = httpRequest.getHeader("Authorization");
        String requestPath = httpRequest.getRequestURI().substring(httpRequest.getContextPath().length());

        if ("OPTIONS".equalsIgnoreCase(httpRequest.getMethod())) {
            chain.doFilter(request, response);
            return;
        }

        logger.debug("JwtFilter processing request: {} {} with Authorization header: {}",
                httpRequest.getMethod(), requestPath, (header != null && header.startsWith("Bearer ")));

        if (header != null && header.startsWith("Bearer ")) {
            String token = header.substring(7);
            try {
                Map<String, Object> claims = JwtUtils.validateTokenAndGetClaims(token);
                if (claims != null && SecurityContextHolder.getContext().getAuthentication() == null) {
                    String email = (String) claims.get("email");
                    String role = (String) claims.get("role");
                    List<SimpleGrantedAuthority> authorities = Collections.singletonList(new SimpleGrantedAuthority(role));
                    UsernamePasswordAuthenticationToken authentication =
                            new UsernamePasswordAuthenticationToken(email, null, authorities);
                    SecurityContextHolder.getContext().setAuthentication(authentication);
                    logger.debug("Successfully authenticated user '{}' with role '{}' from token for request: {}", email, role, requestPath);
                } else if (claims == null) {
                    logger.warn("Token validation failed (claims is null) for request: {}. Token: {}", requestPath, token);
                } else {
                    logger.debug("Authentication already exists in SecurityContext for user '{}', request: {}",
                            SecurityContextHolder.getContext().getAuthentication().getName(), requestPath);
                }
            } catch (Exception e) {
                logger.warn("Invalid JWT token for request {}: {}. Error: {}", requestPath, token, e.getMessage());
                SecurityContextHolder.clearContext();
            }
        } else {
            logger.debug("No Authorization Bearer token found for request: {}", requestPath);
        }

        chain.doFilter(request, response);
    }
} 