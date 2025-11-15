# Google Sign-In Debug Guide

## ⚠️ IMPORTANT: Port Changed!
Your dev server is running on **PORT 5174** (not 5173)!

### Update Google Cloud Console
Go to your Google Cloud Console and update:
1. **Authorized JavaScript origins**: `http://localhost:5174`
2. **Authorized redirect URIs**: `http://localhost:5174`

## Console Logging Added

I've added comprehensive console logs throughout the Google sign-in flow. Here's what to look for:

### 1. Application Initialization (`App.tsx`)
```
🚀 [App] Application initialized
🔍 [App] Current URL: ...
🔍 [App] Origin: ...
🔍 [App] OAuth redirect detected! (if applicable)
```

### 2. Enoki Wallet Registration (`RegisterEnokiWallets.tsx`)
```
🔍 [RegisterEnokiWallets] useEffect triggered
🔍 [RegisterEnokiWallets] Current network: testnet
✅ [RegisterEnokiWallets] Network is supported for Enoki
🔍 [RegisterEnokiWallets] Environment variables check
✅ [RegisterEnokiWallets] Enoki wallets registered successfully!
```

**Error Cases:**
```
⚠️ [RegisterEnokiWallets] Enoki wallets not available on {network}
❌ [RegisterEnokiWallets] VITE_ENOKI_API_KEY is not set
❌ [RegisterEnokiWallets] VITE_GOOGLE_CLIENT_ID is not set
❌ [RegisterEnokiWallets] Failed to register Enoki wallets
```

### 3. Available Wallets (`Layout.tsx`)
```
🔍 [Layout] Available wallets: X
  1. Wallet Name { features, version, etc }
✅ [Layout] Enoki/zkLogin wallets found: [...]
🔍 [Layout] ConnectButton clicked
```

**Warning Case:**
```
⚠️ [Layout] No Enoki/zkLogin wallets found in available wallets
```

### 4. Wallet Connection (`WalletStatus.tsx`)
```
✅ [WalletStatus] Wallet connected
  - Address: 0x...
  - Label: ...
  - Full account object: {...}
```

### 5. Network Requests (Global Fetch Monitor)
```
🌐 [Fetch Request] { url, method, headers }
🌐 [Fetch Response] { url, status, ok }
```

**Error Case:**
```
❌ [Fetch Error] { url, error }
```

### 6. Global Error Handler
```
❌ [Global Error] { message, filename, lineno }
❌ [Unhandled Promise Rejection] { reason }
```

## How to Debug

### Step 1: Open DevTools
Press F12 or right-click → Inspect → Console tab

### Step 2: Clear Console
Click the 🚫 icon to clear old logs

### Step 3: Reload Page
Press Ctrl+R or F5

### Step 4: Check Initial Logs
Look for:
- ✅ App initialization
- ✅ Enoki registration success
- ✅ Available wallets list
- ⚠️ Any warnings or errors

### Step 5: Click Connect Button
Watch for:
- 🔍 ConnectButton clicked log
- Available wallets at click time
- Modal opening with wallet options

### Step 6: Select Google (Enoki)
Look for:
- 🌐 Fetch requests to Google OAuth
- 🌐 Fetch requests to Enoki API
- Redirect URL being constructed
- Any OAuth errors

### Step 7: After Google Redirect
When redirected back, look for:
- 🔍 OAuth redirect detected
- OAuth code received
- Any OAuth errors
- Wallet connection success/failure

## Common Issues

### Issue 1: "redirect_uri_mismatch"
**Solution:** Update Google Cloud Console with:
- `http://localhost:5174` (note the port!)

### Issue 2: No Enoki wallets found
**Symptoms:**
```
⚠️ [Layout] No Enoki/zkLogin wallets found
```
**Check:**
- Are environment variables set?
- Did registration succeed?
- Check the registration error logs

### Issue 3: Registration fails
**Check:**
- Network is testnet/mainnet (not localnet)
- VITE_ENOKI_API_KEY is set correctly
- VITE_GOOGLE_CLIENT_ID is set correctly

### Issue 4: Fetch errors
**Look for:**
- 🌐 [Fetch Error] logs
- CORS errors
- Network errors
- 401/403 status codes

## Environment Variables Check

Current .env file should have:
```
VITE_ENOKI_API_KEY=enoki_public_54bfc0e4868c6d9170353e39ece5426a
VITE_GOOGLE_CLIENT_ID=83252073686-0o3fj45812gvdpotte74l066lnm64bes.apps.googleusercontent.com
```

## Next Steps

1. **Update Google Console** with port 5174
2. **Open browser** to http://localhost:5174
3. **Open DevTools** console (F12)
4. **Clear console** and reload
5. **Try connecting** with Google
6. **Screenshot or copy** any error messages
7. **Share the console logs** showing where it breaks

## Quick Test Checklist

- [ ] Server running on http://localhost:5174
- [ ] Google Console updated with correct port
- [ ] Console shows "Enoki wallets registered successfully"
- [ ] Console shows available wallets list
- [ ] Enoki/Google wallet appears in the list
- [ ] Connect button click is logged
- [ ] Google OAuth redirect URL is correct
- [ ] No CORS errors in console
- [ ] No 401/403 errors in console

---

**All logs use emoji prefixes for easy scanning:**
- 🚀 Application lifecycle
- 🔍 Debug/inspection
- ✅ Success
- ⚠️ Warning
- ❌ Error
- 🌐 Network request
- 🧹 Cleanup
