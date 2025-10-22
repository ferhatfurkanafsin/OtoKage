# OtoKage - Google Play Store Data Collection & Security Guide

**App Version:** 1.3.0
**Document Date:** January 22, 2025
**Purpose:** Complete guide for filling out Play Store's "Data collection and security" section

---

## Overview

OtoKage collects minimal user data required for core functionality:
- **Email addresses** (for authentication)
- **Search history** (for user convenience)
- **Audio recordings** (temporarily, for music recognition)

**Answer to "Does your app collect or share any of the required user data types?"**
✅ **YES**

---

## Section 1: Data Types Collected

### 1.1 Personal Information

#### **Email Addresses**

| Field | Answer |
|-------|--------|
| **Is this data collected?** | YES |
| **Is this data collected, shared, or both?** | Collected only |
| **Is collection optional or required?** | Optional (guest mode available) |
| **Why is this data collected?** | Account management, Fraud prevention, personalization, Account management |
| **Is data encrypted in transit?** | YES (HTTPS) |
| **Can users request data deletion?** | ✅ YES (Delete Account feature implemented v1.3.0) |

**Technical Details:**
- Collected via: Google Sign-In or manual entry
- Stored in: Backend database (Render.com), SharedPreferences (local)
- Used for: User authentication, search history sync
- Retention: Until user deletes account
- Shared with: NO third parties

---

### 1.2 App Activity

#### **Search History**

| Field | Answer |
|-------|--------|
| **Is this data collected?** | YES |
| **Is this data collected, shared, or both?** | Collected only |
| **Is collection optional or required?** | Optional (guest mode = local only) |
| **Why is this data collected?** | App functionality, Personalization |
| **Is data encrypted in transit?** | YES (HTTPS) |
| **Can users request data deletion?** | YES (clear history button) |

**Technical Details:**
- Collected: Automatically when song is recognized
- Contains: Song title, artist, album, timestamp, Spotify/YouTube URLs, match score
- Stored in:
  - **Guest users**: SharedPreferences (local only, max 20 items)
  - **Signed-in users**: Backend JSON files (max 100 items) + local cache
- Retention:
  - Guest: Until app deleted or cleared
  - Signed-in: Until user clears history
- Shared with: NO third parties

---

### 1.3 Audio Files

#### **Audio Recordings (Voice or Sound)**

| Field | Answer |
|-------|--------|
| **Is this data collected?** | YES |
| **Is this data collected, shared, or both?** | Collected and shared |
| **Is collection optional or required?** | Required (core app functionality) |
| **Why is this data collected?** | App functionality (music recognition) |
| **Is data encrypted in transit?** | YES (HTTPS) |
| **Can users request data deletion?** | N/A (immediately deleted) |

**Technical Details:**
- Collected: When user taps record button (microphone permission required)
- Format: M4A audio file
- Duration: 5-15 seconds
- Stored in: Local device temporarily
- Shared with: ACRCloud API (third-party music recognition service)
- Retention: ✅ **IMMEDIATELY DELETED** after recognition completes
- Process:
  1. User records audio → saved to device
  2. Sent to ACRCloud for recognition
  3. Recognition result returned
  4. **Audio file deleted from device**
  5. **Audio NOT stored on OtoKage backend**

---

### 1.4 Device or Other IDs

#### **Google Advertising ID / User IDs**

| Field | Answer |
|-------|--------|
| **Is this data collected?** | NO |

**Note:** OtoKage does NOT collect:
- Advertising IDs
- Device IDs
- Android IDs
- IMEI/MEID
- Any tracking identifiers

---

## Section 2: Data Sharing

### Third-Party Services

#### **ACRCloud (Music Recognition API)**

| Field | Details |
|-------|---------|
| **Service Name** | ACRCloud |
| **Purpose** | Music recognition |
| **Data Shared** | Audio recordings (15 seconds max) |
| **Data Retention** | Per ACRCloud privacy policy |
| **Privacy Policy** | https://www.acrcloud.com/privacy |

#### **Google Sign-In (Optional Authentication)**

| Field | Details |
|-------|---------|
| **Service Name** | Google LLC |
| **Purpose** | User authentication |
| **Data Shared** | Email address (if user chooses Google Sign-In) |
| **Data Retention** | Per Google privacy policy |
| **Privacy Policy** | https://policies.google.com/privacy |

#### **Render.com (Backend Hosting)**

| Field | Details |
|-------|---------|
| **Service Name** | Render Services Inc. |
| **Purpose** | Backend hosting |
| **Data Stored** | Email addresses, search history JSON files |
| **Data Retention** | Until user deletes data |
| **Privacy Policy** | https://render.com/privacy |

---

## Section 3: Security Practices

### Encryption

✅ **Data encrypted in transit**
- All API calls use HTTPS
- Backend URL: `https://otokage-backend.onrender.com`
- TLS 1.2+ required

⚠️ **Data encrypted at rest**
- Verify with Render.com if they encrypt storage
- Local data (SharedPreferences) uses Android's built-in encryption

### User Controls

✅ **Users can request data deletion**
- Clear history button (deletes search history)
- ⚠️ **Recommend adding**: "Delete Account" button to remove all data

❌ **Independent security review**
- Not yet completed
- This is OPTIONAL for the badge

---

## Section 4: Privacy Policy (REQUIRED)

Google Play Store **REQUIRES** a privacy policy URL. You must create one.

### Quick Privacy Policy Generator

Use one of these free tools:
1. **TermsFeed**: https://www.termsfeed.com/privacy-policy-generator/
2. **FreePrivacyPolicy**: https://www.freeprivacypolicy.com/
3. **PrivacyPolicies**: https://www.privacypolicies.com/

### What to Include in Privacy Policy

1. **Information We Collect**
   - Email addresses (for authentication)
   - Search history (song searches)
   - Audio recordings (temporarily for recognition)

2. **How We Use Information**
   - Authenticate users
   - Provide music recognition service
   - Display search history

3. **Information Sharing**
   - ACRCloud for music recognition
   - Google for authentication (if using Google Sign-In)

4. **Data Retention**
   - Audio: Immediately deleted after recognition
   - Email: Until account deletion
   - Search history: Until user clears or deletes account

5. **User Rights**
   - Right to clear search history
   - Right to delete account (if implemented)
   - Right to access collected data

6. **Children's Privacy**
   - App is for ages 13+ (or specify your age requirement)
   - Compliant with COPPA if applicable

7. **Contact Information**
   - Your email address for privacy questions

### Where to Host Privacy Policy

Options:
1. **GitHub Pages** (free) - Create a simple HTML page
2. **Google Sites** (free) - Use templates
3. **Your own website** - If you have one

---

## Section 5: Play Store Form - Exact Answers

### Step 1: Does your app collect or share data?

**Answer:** ✅ **YES**

---

### Step 2: Data Types

Select these data types:

#### **Personal info**
- ☑️ Email addresses

#### **App activity**
- ☑️ In-app search history

#### **Audio**
- ☑️ Voice or sound recordings

#### **DO NOT SELECT:**
- ❌ Name
- ❌ Phone number
- ❌ Photos and videos
- ❌ Files and docs
- ❌ Location
- ❌ Messages
- ❌ Contacts
- ❌ Browsing history
- ❌ Device or other IDs

---

### Step 3: Data Safety for Each Type

#### **For "Email addresses":**

1. **Is this data type collected, shared, or both?**
   - Select: **Collected**

2. **Is collection of this data type required or optional?**
   - Select: **Optional**
   - Why: Users can use guest mode

3. **Why is this user data collected?** (select all that apply)
   - ☑️ Account management
   - ☑️ Fraud prevention, security, and compliance
   - ☑️ Personalization

4. **Is this data encrypted in transit?**
   - Select: **Yes**

5. **Can users request that this data be deleted?**
   - Select: **Yes** (if you add delete account feature)
   - Or: **No** (current state - but should add this)

---

#### **For "In-app search history":**

1. **Is this data type collected, shared, or both?**
   - Select: **Collected**

2. **Is collection of this data type required or optional?**
   - Select: **Optional**
   - Why: Users can use guest mode (local only)

3. **Why is this user data collected?**
   - ☑️ App functionality
   - ☑️ Personalization

4. **Is this data encrypted in transit?**
   - Select: **Yes**

5. **Can users request that this data be deleted?**
   - Select: **Yes** (clear history button exists)

---

#### **For "Voice or sound recordings":**

1. **Is this data type collected, shared, or both?**
   - Select: **Collected and shared**

2. **Is collection of this data type required or optional?**
   - Select: **Required**
   - Why: Core app functionality

3. **Why is this user data collected?**
   - ☑️ App functionality

4. **What third parties is this user data shared with?**
   - Add: **ACRCloud** (select "Analytics")
   - Purpose: Music recognition service

5. **Is this data encrypted in transit?**
   - Select: **Yes**

6. **Can users request that this data be deleted?**
   - Select: **N/A** (explain: "Audio files are immediately deleted after recognition and are not stored")

---

### Step 4: Security Practices

#### **Data encrypted in transit**
- Select: ✅ **YES**
- Explanation: "All network communications use HTTPS with TLS encryption"

#### **Data encrypted at rest**
- Select: ⚠️ **Verify with Render.com first**
- If YES: "Backend data is encrypted at rest using industry-standard encryption"
- If NO: "Audio files are not stored; user data is protected by hosting provider's security measures"

#### **Users can request data deletion**
- Select: ✅ **YES** (if you add delete account)
- Or: ⚠️ **Partial** (only history, not account)

#### **Independent security review**
- Select: ❌ **NO** (unless you get one done)

#### **Security whitepaper/documentation**
- Optional: Add link to this document if hosted online

---

## Section 6: Recommendations Before Submission

### ⚠️ MUST IMPLEMENT:

1. **Privacy Policy Page**
   - Create and host a privacy policy
   - Add URL to Play Store listing
   - Add link in app (Settings → Privacy Policy)

2. **Terms of Service** (Recommended)
   - Protect yourself legally
   - Clarify user responsibilities

### ⚠️ SHOULD IMPLEMENT:

3. **Delete Account Feature**
   - Add button in app settings
   - API endpoint: `DELETE /account/{email}`
   - Removes email, all search history, authentication data
   - Shows confirmation dialog before deletion

4. **Data Export Feature** (Nice to have)
   - Let users download their search history
   - JSON or CSV format
   - Required by GDPR if you have EU users

### ✅ ALREADY GOOD:

- ✅ Audio files not stored
- ✅ Guest mode available (privacy-friendly)
- ✅ Clear history button
- ✅ HTTPS encryption
- ✅ Optional authentication

---

## Section 7: Age Rating

Based on OtoKage content (music recognition for anime/game music):

### Recommended Age Rating: **Everyone (E)**

Justification:
- No violent content
- No sexual content
- No user-generated content (UGC)
- No social features
- No in-app purchases
- No advertising
- Music recognition service only

### Questions You'll Answer:

1. **Does your app contain ads?** NO
2. **Does your app contain in-app purchases?** NO
3. **Does your app access location?** NO
4. **Does your app request sensitive permissions?** YES (Microphone - for core functionality)

---

## Section 8: Content Rating Questionnaire

### IARC (International Age Rating Coalition)

You'll need to fill out the IARC questionnaire. Here are expected answers for OtoKage:

| Question | Answer | Reasoning |
|----------|--------|-----------|
| Violence | None | Music recognition app |
| Sexuality | None | No adult content |
| Language | None | No user-generated content |
| Controlled Substances | None | Not applicable |
| Gambling | None | No gambling features |
| User Interaction | None | No chat, no social features |
| Shares User Location | No | No location tracking |
| Unrestricted Internet Access | No | Only connects to specific APIs |
| Digital Purchases | No | No IAPs |

**Expected Rating:** PEGI 3, ESRB Everyone, USK 0

---

## Section 9: Quick Checklist Before Submission

- [ ] Privacy Policy created and hosted
- [ ] Privacy Policy URL added to Play Store listing
- [ ] Data collection form completed accurately
- [ ] All data types declared
- [ ] Security practices documented
- [ ] Screenshots ready (show new sign-in screen, history screen)
- [ ] App description mentions authentication and history features
- [ ] Age rating questionnaire completed
- [ ] APK/AAB uploaded (`OtoKage-v1.2.0-fixed-design.aab`)
- [ ] App tested on multiple devices
- [ ] (Recommended) Delete account feature added

---

## Section 10: Sample Privacy Policy Text

Here's a starter template you can customize:

```
# Privacy Policy for OtoKage

Last updated: October 22, 2025

## Introduction
OtoKage ("we", "our", or "us") operates the OtoKage mobile application (the "Service").

## Information We Collect

### Email Addresses
We collect email addresses when you choose to sign up for an account. This is optional - you can use our Guest Mode without providing an email.

### Search History
We store your song search history to provide convenience features. Guest users' history is stored locally on their device only. Signed-in users' history is synced across devices.

### Audio Recordings
We temporarily collect audio recordings (5-15 seconds) to provide music recognition. These recordings are:
- Immediately deleted after processing
- Shared only with ACRCloud (our music recognition partner)
- Never stored on our servers

## How We Use Your Information
- Authenticate your account
- Provide music recognition services
- Display your search history
- Sync history across your devices

## Information Sharing
We share audio recordings with ACRCloud for music recognition. We do not sell your personal information to third parties.

## Data Retention
- Audio: Immediately deleted after recognition
- Email & History: Until you clear your history or delete your account

## Your Rights
- Clear your search history at any time
- Delete your account and all associated data
- Use Guest Mode for maximum privacy

## Children's Privacy
OtoKage is intended for users aged 13 and above.

## Changes to This Policy
We may update this privacy policy from time to time.

## Contact Us
For questions about this privacy policy, contact us at: [your-email@example.com]
```

---

## Section 11: After Approval

### Post-Launch Compliance:

1. **Monitor Reviews**
   - Respond to privacy concerns
   - Update policy if you add features

2. **Regular Audits**
   - Review data collection annually
   - Update Play Store form if practices change

3. **GDPR Compliance** (if EU users)
   - Add cookie consent if you add analytics later
   - Implement data export feature
   - Honor deletion requests within 30 days

4. **COPPA Compliance** (if <13 users)
   - Get parental consent
   - Limit data collection
   - Disable social features

---

## Contact for Questions

If you have questions about filling out the Play Store form, you can refer to:
- **Google Play Console Help**: https://support.google.com/googleplay/android-developer
- **Data Safety Section Guide**: https://support.google.com/googleplay/android-developer/answer/10787469

---

**End of Play Store Data Collection Guide**

*This document should be updated whenever OtoKage's data practices change.*
