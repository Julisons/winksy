import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:winksy/mixin/extentions.dart';
import '../../../mixin/constants.dart';
import '../../../mixin/mixins.dart';
import '../../../theme/custom_colors.dart';

class ProfessionalInfoTab extends StatelessWidget {
  const ProfessionalInfoTab({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).extension<CustomColors>()!;
    final user = Mixin.user;

    return SingleChildScrollView(
      padding: EdgeInsets.all(20.r),
      child: Column(
        children: [
          // Personal Information Card
          _buildInfoCard(
            context,
            "Personal Information",
            Icons.person_outline,
            [
              InfoItem("Full Name", user?.usrFullNames ?? '', Icons.badge_outlined),
              InfoItem("Email Address", user?.usrEmail ?? '', Icons.email_outlined),
              InfoItem("Age", '${user?.usrDob != null ? '${user?.usrDob}'.age() : 0} Years', Icons.cake_outlined),
              InfoItem("Gender", user?.usrGender ?? '', Icons.wc_outlined),
            ],
          ),
          
          SizedBox(height: 16.h),
          
          // Contact & Location Card
          _buildInfoCard(
            context,
            "Contact & Location", 
            Icons.location_on_outlined,
            [
              InfoItem("Phone Number", user?.usrMobileNumber ?? '', Icons.phone_outlined),
              InfoItem("Location", "${user?.usrCountry ?? ''}, ${user?.usrAdministrativeArea ?? ''}", Icons.place_outlined),
            ],
          ),
          
          SizedBox(height: 16.h),
          
          // About Me Card
          _buildAboutCard(context, "About Me", user?.usrDesc ?? ''),
          
          SizedBox(height: 16.h),
          
          // Account Status Card
          _buildStatusCard(context),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, String title, IconData titleIcon, List<InfoItem> items) {
    final color = Theme.of(context).extension<CustomColors>()!;
    
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: color.xSecondaryColor,
        borderRadius: BorderRadius.circular(12.r),
        /*boxShadow: [
          BoxShadow(
            color: color.xTextColor.withOpacity(0.05),
            blurRadius: 8.r,
            offset: Offset(0, 2.h),
          ),
        ],*/
      ),
      child: Padding(
        padding: EdgeInsets.all(8.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card Header
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: color.xTrailing.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    titleIcon,
                    size: 20.r,
                    color: color.xTrailing,
                  ),
                ),
                SizedBox(width: 12.w),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: FONT_TITLE,
                    fontWeight: FontWeight.w600,
                    color: color.xTextColorSecondary,
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 16.h),
            
            // Card Content
            ...items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isLast = index == items.length - 1;
              
              return Column(
                children: [
                  _buildInfoItem(context, item),
                  if (!isLast) 
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: Divider(
                        color: color.xTextColor.withOpacity(0.1),
                        height: 1.h,
                      ),
                    ),
                ],
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(BuildContext context, InfoItem item) {
    final color = Theme.of(context).extension<CustomColors>()!;
    
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Icon(
            item.icon,
            size: 18.r,
            color: color.xTextColor,
          ),
          SizedBox(width: 12.w),
          Expanded(
            flex: 2,
            child: Text(
              item.label,
              style: TextStyle(
                fontSize: FONT_13,
                fontWeight: FontWeight.w500,
                color: color.xTextColor,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            flex: 3,
            child: Text(
              item.value.isNotEmpty ? item.value : 'Not provided',
              style: TextStyle(
                fontSize: FONT_13,
                fontWeight: FontWeight.w400,
                color: item.value.isNotEmpty 
                    ? color.xTextColorSecondary 
                    : color.xTextColorTertiary,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildAboutCard(BuildContext context, String title, String description) {
    final color = Theme.of(context).extension<CustomColors>()!;
    
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: color.xSecondaryColor,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
         /* BoxShadow(
            color: color.xTextColor.withOpacity(0.05),
            blurRadius: 8.r,
            offset: Offset(0, 2.h),
          ),*/
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(8.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card Header
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: color.xTrailing.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    Icons.info_outline,
                    size: 20.r,
                    color: color.xTrailing,
                  ),
                ),
                SizedBox(width: 12.w),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: FONT_TITLE,
                    fontWeight: FontWeight.w600,
                    color: color.xTextColorSecondary,
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 16.h),
            
            // Description
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: color.xPrimaryColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: color.xTextColor.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Text(
                description.isNotEmpty 
                    ? description 
                    : 'No description provided yet. Tell people about yourself!',
                style: TextStyle(
                  fontSize: FONT_13,
                  height: 1.5,
                  color: description.isNotEmpty 
                      ? color.xTextColorSecondary 
                      : color.xTextColorTertiary,
                  fontStyle: description.isEmpty ? FontStyle.italic : FontStyle.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(BuildContext context) {
    final color = Theme.of(context).extension<CustomColors>()!;
    
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: color.xSecondaryColor,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: color.xTextColor.withOpacity(0.05),
            blurRadius: 8.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(20.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card Header
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    Icons.verified_user_outlined,
                    size: 20.r,
                    color: Colors.green,
                  ),
                ),
                SizedBox(width: 12.w),
                Text(
                  "Account Status",
                  style: TextStyle(
                    fontSize: FONT_TITLE,
                    fontWeight: FontWeight.w600,
                    color: color.xTextColorSecondary,
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 16.h),
            
            // Status Items
            Row(
              children: [
                Expanded(
                  child: _buildStatusItem(
                    context,
                    "Verified Account",
                    Icons.check_circle,
                    Colors.green,
                    true,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _buildStatusItem(
                    context,
                    "Active Status",
                    Icons.circle,
                    Colors.green,
                    true,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusItem(BuildContext context, String label, IconData icon, Color statusColor, bool isActive) {
    final color = Theme.of(context).extension<CustomColors>()!;
    
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: statusColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 24.r,
            color: statusColor,
          ),
          SizedBox(height: 8.h),
          Text(
            label,
            style: TextStyle(
              fontSize: FONT_SMALL,
              fontWeight: FontWeight.w500,
              color: color.xTextColorSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class InfoItem {
  final String label;
  final String value;
  final IconData icon;

  InfoItem(this.label, this.value, this.icon);
}

