# User Management Console & Account Governance

## 1. Scope & Responsibility
Documents the administrative user governance interface, account status toggling, role administration, and gamification points audit.

---

## 2. Component Specifications

### 2.1 User Management Hub (`PageUserManagementWidget`)
- **Location**: `lib/admin/page_user_management/`
- **Route**: `/pageUserManagement`
- **Capabilities**:
  - Paginated table listing registered users with email, display name, registered date, active role, and point total.
  - Search bar filtering users by email or display name.
  - Detail inspection modal per user.

### 2.2 Role & Status Administration
- **Role Assignment**: Elevate standard users to `admin` or downgrade admins to standard users.
- **Account Moderation**: Temporarily suspend or ban users violating reporting rules or attempting prompt injections.
- **Points Ledger Adjustments**: Manually correct points balance in `user_subtable` if fraudulent scans were deleted.
