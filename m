Return-Path: <vincentfu@gmail.com>
Return-Path: <vincentfu@gmail.com>
From: vincentfu@gmail.com
Subject: [PATCH 8/9] .appveyor.yml: run run-fio-tests.py
Date: Tue, 10 Dec 2019 12:54:41 -0500
Message-Id: <20191210175442.2975-9-vincentfu@gmail.com>
In-Reply-To: <20191210175442.2975-1-vincentfu@gmail.com>
References: <20191210175442.2975-1-vincentfu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Vincent Fu <vincent.fu@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Vincent Fu <vincent.fu@wdc.com>

- Add CUnit support
- install SciPy
- skip test 5 because Windows does not support direct I/O with sync
ioengines
---
 .appveyor.yml | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/.appveyor.yml b/.appveyor.yml
index ca8b2ab1..f6934096 100644
--- a/.appveyor.yml
+++ b/.appveyor.yml
@@ -13,8 +13,9 @@ environment:
       CONFIGURE_OPTIONS: --build-32bit-win --target-win-ver=xp
 
 install:
-  - '%CYG_ROOT%\setup-x86_64.exe --quiet-mode --no-shortcuts --only-site --site "%CYG_MIRROR%" --packages "mingw64-%PACKAGE_ARCH%-zlib" > NUL'
-  - SET PATH=%CYG_ROOT%\bin;%PATH% # NB: Changed env variables persist to later sections
+  - '%CYG_ROOT%\setup-x86_64.exe --quiet-mode --no-shortcuts --only-site --site "%CYG_MIRROR%" --packages "mingw64-%PACKAGE_ARCH%-zlib,mingw64-%PACKAGE_ARCH%-CUnit" > NUL'
+  - SET PATH=C:\Python38-x64;%CYG_ROOT%\bin;%PATH% # NB: Changed env variables persist to later sections
+  - python.exe -m pip install scipy
 
 build_script:
   - 'bash.exe -lc "cd \"${APPVEYOR_BUILD_FOLDER}\" && ./configure --disable-native --extra-cflags=\"-Werror\" ${CONFIGURE_OPTIONS} && make.exe'
@@ -24,6 +25,7 @@ after_build:
 
 test_script:
   - 'bash.exe -lc "cd \"${APPVEYOR_BUILD_FOLDER}\" && file.exe fio.exe && make.exe test'
+  - 'bash.exe -lc "cd \"${APPVEYOR_BUILD_FOLDER}\" && python.exe t/run-fio-tests.py --skip 5 --debug'
 
 artifacts:
   - path: os\windows\*.msi
-- 
2.17.1


