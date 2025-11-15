# Suitter Walrus Deployment Guide

## Prerequisites

Before deploying, ensure you have:

### 1. Sui CLI Installed
```powershell
# Check if installed
sui --version

# If not installed, download from:
# https://docs.sui.io/guides/developer/getting-started/sui-install
```

### 2. Walrus CLI Installed
```powershell
# Check if installed
walrus --version

# If not installed, download the Windows binary from:
# https://github.com/MystenLabs/walrus/releases
# Extract and add to PATH
```

### 3. Walrus Site Builder Installed
```powershell
# Check if installed
site-builder --version

# If not installed, download from:
# https://github.com/MystenLabs/walrus-sites/releases
# Look for 'site-builder-windows-x64.exe'
# Rename to 'site-builder.exe' and add to PATH
```

### 4. Sui Wallet with Testnet SUI
```powershell
# Check your address
sui client active-address

# Get testnet SUI
sui client faucet

# Check balance (need at least 1 SUI)
sui client gas
```

## Deployment Steps

### Step 1: Test Local Build

First, make sure your app builds correctly:

```powershell
cd C:\Users\User\Desktop\suitter7\frontend-dApp\Suitter7-dApp

# Build the project
npm run build

# Preview locally
npm run preview
```

Visit http://localhost:4173 and verify everything works.

### Step 2: Update Google OAuth Redirect URIs

**IMPORTANT:** Before deploying, you need to update your Google Cloud Console with the Walrus domain.

After deployment, you'll get a URL like: `https://YOUR_SITE_ID.walrus.site`

Add these to Google Cloud Console → Credentials → OAuth 2.0 Client IDs:

**Authorized JavaScript origins:**
- `https://YOUR_SITE_ID.walrus.site`

**Authorized redirect URIs:**
- `https://YOUR_SITE_ID.walrus.site`
- `https://YOUR_SITE_ID.walrus.site/`

### Step 3: Deploy to Walrus

```powershell
# Make sure you're in the project directory
cd C:\Users\User\Desktop\suitter7\frontend-dApp\Suitter7-dApp

# Run deployment script
npm run deploy:walrus
```

### Step 4: Save Your Site Object ID

After deployment, you'll see output like:

```
Created new site: 0x1234567890abcdef...
Site URL: https://1234567890abcdef.walrus.site
```

**CRITICAL:** Save this Site Object ID for future updates!

```powershell
# Set environment variable for future updates
$env:SUITTER_SITE_ID = "0x1234567890abcdef..."

# To make it permanent, add to your PowerShell profile:
notepad $PROFILE
# Add this line:
# $env:SUITTER_SITE_ID = "0x1234567890abcdef..."
```

### Step 5: Update Google OAuth

Now go back to Google Cloud Console and add your actual Walrus URL from Step 3.

### Step 6: Test Your Live Site

Visit your Walrus URL and test:
- ✅ Page loads correctly
- ✅ Wallet connection works
- ✅ Google sign-in works (after OAuth update)
- ✅ Can create suits
- ✅ Can like/comment
- ✅ Profile pages work
- ✅ Images load correctly

## Updating Your Site

When you make changes to your code:

```powershell
# Make sure SUITTER_SITE_ID is set
$env:SUITTER_SITE_ID = "0xYOUR_SITE_ID"

# Deploy update (only changed files are uploaded)
npm run deploy:walrus
```

Or use the update script directly:

```powershell
npm run build
cd dist
site-builder update --epochs 100 . $env:SUITTER_SITE_ID
cd ..
```

## Manual Deployment (Alternative)

If the script doesn't work, deploy manually:

```powershell
# 1. Build
npm run build

# 2. Copy config
Copy-Item walrus-site.yaml dist/

# 3. Navigate to dist
cd dist

# 4. First time publish
site-builder publish --epochs 100 .

# OR update existing site
site-builder update --epochs 100 . 0xYOUR_SITE_ID

# 5. Return to project root
cd ..
```

## Troubleshooting

### Error: "sui: command not found"
Install Sui CLI from https://docs.sui.io/guides/developer/getting-started/sui-install

### Error: "site-builder: command not found"
Download site-builder from https://github.com/MystenLabs/walrus-sites/releases and add to PATH

### Error: "Insufficient gas"
Get more testnet SUI:
```powershell
sui client faucet
```

### Error: Assets not loading (404)
Make sure `vite.config.ts` has `base: './'` (already configured)

### Error: Google OAuth "redirect_uri_mismatch"
Update Google Cloud Console with your Walrus URL

### Error: Blank pages with React Router
Make sure `walrus-site.yaml` is in the dist folder (script does this automatically)

## Cost Information

- **Storage Duration:** 100 epochs (~200 days)
- **Estimated Cost:** 5-10 SUI for initial deployment
- **Updates:** Only pay for changed files
- **Site Size:** ~2-5 MB (typical)

## Files Modified for Walrus

Your project has been configured with:

1. ✅ `vite.config.ts` - Updated with `base: './'` and build optimization
2. ✅ `walrus-site.yaml` - Routing config for React Router
3. ✅ `deploy-walrus.ps1` - Automated deployment script
4. ✅ `package.json` - Added deployment scripts

## Deployment Checklist

Before submitting to hackathon:

- [ ] Smart contracts deployed to testnet
- [ ] Contract IDs in `.env` file
- [ ] Local build works (`npm run build && npm run preview`)
- [ ] Sui wallet has testnet SUI
- [ ] Walrus tools installed
- [ ] Deploy to Walrus (`npm run deploy:walrus`)
- [ ] Save Site Object ID
- [ ] Update Google OAuth redirect URIs
- [ ] Test live site
- [ ] Add Walrus URL to README

## Your Deployment Info

Once deployed, document this:

```markdown
## 🌐 Live Demo

**Deployed on Walrus Sites (Fully Decentralized)**

- Frontend: https://YOUR_SITE_ID.walrus.site
- Smart Contracts: Sui Testnet
- Package ID: 0xc9b9f6d8d275a0860d4433bef712cb3ec28f0b014064e56b13931071661ff99c

### Decentralized Stack
- Frontend Hosting: Walrus Sites
- Smart Contracts: Sui Network
- Media Storage: Walrus Storage
- Authentication: Enoki (zkLogin)

All components are fully decentralized - no central servers!
```

## Quick Commands Reference

```powershell
# Build and preview locally
npm run build && npm run preview

# Deploy to Walrus (first time)
npm run deploy:walrus

# Update existing site
$env:SUITTER_SITE_ID = "0xYOUR_SITE_ID"
npm run deploy:walrus

# Check Sui balance
sui client gas

# Get testnet SUI
sui client faucet
```

## Next Steps

1. Run `npm run build` to test your build
2. Make sure you have testnet SUI in your wallet
3. Run `npm run deploy:walrus` to deploy
4. Save the Site Object ID you receive
5. Update Google OAuth settings with your Walrus URL
6. Test everything on the live site
7. Add the URL to your README and demo materials

Good luck with your deployment! 🚀
