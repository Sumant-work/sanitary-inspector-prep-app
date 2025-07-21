#!/usr/bin/env bash

# Colors for better output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Starting Sanitary Inspector Prep App Deployment...${NC}"
echo -e "${BLUE}================================================${NC}"

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo -e "${RED}❌ Flutter is not installed or not in PATH${NC}"
    echo -e "${YELLOW}Please install Flutter and try again${NC}"
    exit 1
fi

# Check if Git is installed
if ! command -v git &> /dev/null; then
    echo -e "${RED}❌ Git is not installed or not in PATH${NC}"
    echo -e "${YELLOW}Please install Git and try again${NC}"
    exit 1
fi

# Step 1: Clean the project
echo -e "\n${YELLOW}🧹 Step 1: Cleaning Flutter project...${NC}"
flutter clean

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Failed to clean project${NC}"
    exit 1
fi

# Step 2: Get dependencies
echo -e "\n${YELLOW}📦 Step 2: Getting Flutter dependencies...${NC}"
flutter pub get

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Failed to get dependencies${NC}"
    exit 1
fi

# Step 3: Analyze code (optional but recommended)
echo -e "\n${YELLOW}🔍 Step 3: Analyzing code...${NC}"
flutter analyze --no-fatal-infos

# Step 4: Build APK
echo -e "\n${YELLOW}🔨 Step 4: Building release APK...${NC}"
flutter build apk --release

# Step 5: Check if build was successful
if [ $? -eq 0 ]; then
    echo -e "\n${GREEN}✅ Build successful!${NC}"
    echo -e "${GREEN}📍 APK location: build/app/outputs/flutter-apk/app-release.apk${NC}"
    
    # Get APK size
    if [ -f "build/app/outputs/flutter-apk/app-release.apk" ]; then
        APK_SIZE=$(du -h build/app/outputs/flutter-apk/app-release.apk | cut -f1)
        echo -e "${GREEN}📏 APK Size: $APK_SIZE${NC}"
    fi
    
    # Step 6: Git operations
    echo -e "\n${YELLOW}📝 Step 5: Committing changes to Git...${NC}"
    
    # Check if there are changes to commit
    if [[ -n $(git status --porcelain) ]]; then
        git add .
        git commit -m "Fix Android v1 embedding issue - migrate to v2 embedding - $(date +'%Y-%m-%d %H:%M:%S')"
        
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✅ Changes committed successfully${NC}"
            
            # Step 7: Push to GitHub
            echo -e "\n${YELLOW}📤 Step 6: Pushing to GitHub...${NC}"
            git push origin main
            
            if [ $? -eq 0 ]; then
                echo -e "\n${GREEN}🎉 Deployment completed successfully!${NC}"
                echo -e "${GREEN}🔄 Codemagic will automatically trigger a new build${NC}"
                echo -e "\n${PURPLE}📱 Next steps:${NC}"
                echo -e "${PURPLE}1. Check Codemagic dashboard for build progress${NC}"
                echo -e "${PURPLE}2. Download APK from: build/app/outputs/flutter-apk/app-release.apk${NC}"
                echo -e "${PURPLE}3. Test the APK on your Android device${NC}"
            else
                echo -e "${RED}❌ Failed to push to GitHub${NC}"
                echo -e "${YELLOW}Please check your Git configuration and network connection${NC}"
                exit 1
            fi
        else
            echo -e "${RED}❌ Failed to commit changes${NC}"
            exit 1
        fi
    else
        echo -e "${YELLOW}ℹ️  No changes to commit${NC}"
        echo -e "${GREEN}✅ Repository is already up to date${NC}"
    fi
    
else
    echo -e "\n${RED}❌ Build failed! Please check the error messages above.${NC}"
    echo -e "${YELLOW}Common solutions:${NC}"
    echo -e "${YELLOW}1. Check AndroidManifest.xml for v1 embedding issues${NC}"
    echo -e "${YELLOW}2. Run 'flutter doctor' to check for issues${NC}"
    echo -e "${YELLOW}3. Ensure all dependencies are properly configured${NC}"
    exit 1
fi

echo -e "\n${BLUE}================================================${NC}"
echo -e "${BLUE}🏁 Script execution completed${NC}"
