/**
 * Main JavaScript file for Gym Management System
 * Contains all common functions and event handlers
 */

// Wait for DOM to be fully loaded
document.addEventListener('DOMContentLoaded', function() {
    console.log('Gym Management System - JavaScript loaded');
    
    // Initialize all event listeners
    initializeDeleteButtons();
    initializeFormValidation();
    initializeTooltips();
    initializeModals();
    initializeJwtToken();
});

/**
 * Initialize JWT token handling
 */
function initializeJwtToken() {
    // Add JWT token to all AJAX requests
    const originalFetch = window.fetch;
    window.fetch = function(url, options = {}) {
        const jwtToken = getJwtTokenFromCookie();
        if (jwtToken) {
            options.headers = {
                ...options.headers,
                'Authorization': `Bearer ${jwtToken}`
            };
        }
        return originalFetch(url, options);
    };
    
    // Add JWT token to all XMLHttpRequest
    const originalXHROpen = XMLHttpRequest.prototype.open;
    XMLHttpRequest.prototype.open = function(method, url, async, user, password) {
        const jwtToken = getJwtTokenFromCookie();
        if (jwtToken) {
            this.setRequestHeader('Authorization', `Bearer ${jwtToken}`);
        }
        return originalXHROpen.call(this, method, url, async, user, password);
    };
}

/**
 * Get JWT token from cookie
 */
function getJwtTokenFromCookie() {
    const cookies = document.cookie.split(';');
    for (let cookie of cookies) {
        const [name, value] = cookie.trim().split('=');
        if (name === 'jwt_token') {
            return value;
        }
    }
    return null;
}

/**
 * Check if user is authenticated
 */
function isAuthenticated() {
    return getJwtTokenFromCookie() !== null;
}

/**
 * Get user role from JWT token
 */
function getUserRole() {
    const token = getJwtTokenFromCookie();
    if (!token) return null;
    
    try {
        const payload = JSON.parse(atob(token.split('.')[1]));
        return payload.role;
    } catch (e) {
        return null;
    }
}

/**
 * Initialize delete confirmation buttons
 * Used in user management and other list pages
 */
function initializeDeleteButtons() {
    document.querySelectorAll('.delete-btn').forEach(function(button) {
        button.addEventListener('click', function() {
            const userId = this.getAttribute('data-user-id');
            const userName = this.getAttribute('data-user-name');
            
            if (confirm('Bạn có chắc chắn muốn xóa "' + userName + '"?')) {
                const form = document.getElementById('deleteForm');
                if (form) {
                    form.action = '/admin/users/delete/' + userId;
                    form.submit();
                }
            }
        });
    });
}

/**
 * Initialize form validation
 * Add client-side validation for forms
 */
function initializeFormValidation() {
    const forms = document.querySelectorAll('.needs-validation');
    
    forms.forEach(function(form) {
        form.addEventListener('submit', function(event) {
            if (!form.checkValidity()) {
                event.preventDefault();
                event.stopPropagation();
            }
            form.classList.add('was-validated');
        });
    });
}

/**
 * Initialize Bootstrap tooltips
 */
function initializeTooltips() {
    const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    tooltipTriggerList.map(function(tooltipTriggerEl) {
        return new bootstrap.Tooltip(tooltipTriggerEl);
    });
}

/**
 * Initialize Bootstrap modals
 */
function initializeModals() {
    const modalTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="modal"]'));
    modalTriggerList.map(function(modalTriggerEl) {
        return new bootstrap.Modal(modalTriggerEl);
    });
}

/**
 * Show success message
 * @param {string} message - Success message to display
 */
function showSuccess(message) {
    showAlert('success', message);
}

/**
 * Show error message
 * @param {string} message - Error message to display
 */
function showError(message) {
    showAlert('danger', message);
}

/**
 * Show warning message
 * @param {string} message - Warning message to display
 */
function showWarning(message) {
    showAlert('warning', message);
}

/**
 * Show info message
 * @param {string} message - Info message to display
 */
function showInfo(message) {
    showAlert('info', message);
}

/**
 * Generic function to show alerts
 * @param {string} type - Alert type (success, danger, warning, info)
 * @param {string} message - Message to display
 */
function showAlert(type, message) {
    const alertContainer = document.getElementById('alertContainer');
    if (!alertContainer) {
        console.warn('Alert container not found');
        return;
    }
    
    const alertHtml = `
        <div class="alert alert-${type} alert-dismissible fade show" role="alert">
            ${message}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    `;
    
    alertContainer.innerHTML = alertHtml;
    
    // Auto-hide after 5 seconds
    setTimeout(function() {
        const alert = alertContainer.querySelector('.alert');
        if (alert) {
            const bsAlert = new bootstrap.Alert(alert);
            bsAlert.close();
        }
    }, 5000);
}

/**
 * Format date to Vietnamese format
 * @param {string} dateString - Date string to format
 * @returns {string} Formatted date string
 */
function formatDate(dateString) {
    if (!dateString) return '';
    
    const date = new Date(dateString);
    return date.toLocaleDateString('vi-VN', {
        day: '2-digit',
        month: '2-digit',
        year: 'numeric'
    });
}

/**
 * Format datetime to Vietnamese format
 * @param {string} dateString - Date string to format
 * @returns {string} Formatted datetime string
 */
function formatDateTime(dateString) {
    if (!dateString) return '';
    
    const date = new Date(dateString);
    return date.toLocaleDateString('vi-VN', {
        day: '2-digit',
        month: '2-digit',
        year: 'numeric',
        hour: '2-digit',
        minute: '2-digit'
    });
}

/**
 * Confirm action with custom message
 * @param {string} message - Confirmation message
 * @param {function} onConfirm - Function to execute if confirmed
 * @param {function} onCancel - Function to execute if cancelled
 */
function confirmAction(message, onConfirm, onCancel) {
    if (confirm(message)) {
        if (typeof onConfirm === 'function') {
            onConfirm();
        }
    } else {
        if (typeof onCancel === 'function') {
            onCancel();
        }
    }
}

/**
 * Toggle password visibility
 * @param {string} inputId - ID of password input field
 * @param {string} toggleId - ID of toggle button
 */
function togglePasswordVisibility(inputId, toggleId) {
    const passwordInput = document.getElementById(inputId);
    const toggleButton = document.getElementById(toggleId);
    
    if (passwordInput.type === 'password') {
        passwordInput.type = 'text';
        toggleButton.innerHTML = '<i class="fas fa-eye-slash"></i>';
    } else {
        passwordInput.type = 'password';
        toggleButton.innerHTML = '<i class="fas fa-eye"></i>';
    }
}

/**
 * Search functionality for tables
 * @param {string} searchTerm - Search term
 * @param {string} tableId - ID of table to search in
 */
function searchTable(searchTerm, tableId) {
    const table = document.getElementById(tableId);
    if (!table) return;
    
    const rows = table.querySelectorAll('tbody tr');
    const term = searchTerm.toLowerCase();
    
    rows.forEach(function(row) {
        const text = row.textContent.toLowerCase();
        if (text.includes(term)) {
            row.style.display = '';
        } else {
            row.style.display = 'none';
        }
    });
}





 