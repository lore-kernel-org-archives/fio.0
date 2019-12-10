Return-Path: <vincentfu@gmail.com>
Return-Path: <vincentfu@gmail.com>
From: vincentfu@gmail.com
Subject: [PATCH 7/9] .travis.yml: run t/run-fio.tests.py as part of build
Date: Tue, 10 Dec 2019 12:54:40 -0500
Message-Id: <20191210175442.2975-8-vincentfu@gmail.com>
In-Reply-To: <20191210175442.2975-1-vincentfu@gmail.com>
References: <20191210175442.2975-1-vincentfu@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Vincent Fu <vincent.fu@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Vincent Fu <vincent.fu@wdc.com>

- install SciPy and CUnit support
- skip test 6 because of timeout
- skip zbd tests 1007, 1008 because installing kernel modules is not supported
- replace xcode8.3 (lacks python3) with latest xcode11.2
---
 .travis.yml | 26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/.travis.yml b/.travis.yml
index 4a87fe6c..0017db56 100644
--- a/.travis.yml
+++ b/.travis.yml
@@ -15,19 +15,13 @@ matrix:
     - os: osx
       compiler: clang # Workaround travis setting CC=["clang", "gcc"]
       env: BUILD_ARCH="x86_64"
-    # Build using the 10.12 SDK but target and run on OSX 10.11
-#   - os: osx
-#     compiler: clang
-#     osx_image: xcode8
-#     env: SDKROOT=/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk MACOSX_DEPLOYMENT_TARGET=10.11
-    # Build on the latest OSX version (will eventually become obsolete)
     - os: osx
       compiler: clang
-      osx_image: xcode8.3
+      osx_image: xcode9.4
       env: BUILD_ARCH="x86_64"
     - os: osx
       compiler: clang
-      osx_image: xcode9.4
+      osx_image: xcode11.2
       env: BUILD_ARCH="x86_64"
   exclude:
     - os: osx
@@ -39,17 +33,27 @@ matrix:
 before_install:
   - EXTRA_CFLAGS="-Werror"
   - if [[ "$TRAVIS_OS_NAME" == "linux" ]]; then
-        pkgs=(libaio-dev libnuma-dev libz-dev librbd-dev libibverbs-dev librdmacm-dev);
+        pkgs=(libaio-dev libnuma-dev libz-dev librbd-dev libibverbs-dev librdmacm-dev libcunit1 libcunit1-dev);
         if [[ "$BUILD_ARCH" == "x86" ]]; then
             pkgs=("${pkgs[@]/%/:i386}");
-            pkgs+=(gcc-multilib);
+            pkgs+=(gcc-multilib python-scipy);
             EXTRA_CFLAGS="${EXTRA_CFLAGS} -m32";
         else
-            pkgs+=(glusterfs-common);
+            pkgs+=(glusterfs-common python-scipy);
         fi;
         sudo apt-get -qq update;
         sudo apt-get install --no-install-recommends -qq -y "${pkgs[@]}";
     fi
+  - if [[ "$TRAVIS_OS_NAME" == "osx" ]]; then
+        brew update;
+        brew install cunit;
+        if [[ "$TRAVIS_OSX_IMAGE" == "xcode11.2" ]]; then
+            pip3 install scipy;
+        else
+            pip install scipy;
+        fi;
+    fi
 script:
   - ./configure --extra-cflags="${EXTRA_CFLAGS}" && make
   - make test
+  - sudo python3 t/run-fio-tests.py --skip 6 1007 1008
-- 
2.17.1


