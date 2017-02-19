Return-Path: <tkusumi@tuxera.com>
From: Tomohiro Kusumi <tkusumi@tuxera.com>
Subject: [PATCH 5/6] Silence Cygwin warning "'vsprintf_s' redeclared without dllimport..."
Date: Sun, 19 Feb 2017 20:22:22 +0200
Message-ID: <20170219182223.120559-5-tkusumi@tuxera.com>
In-Reply-To: <20170219182223.120559-1-tkusumi@tuxera.com>
References: <20170219182223.120559-1-tkusumi@tuxera.com>
MIME-Version: 1.0
Content-Type: text/plain
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

Silence a compiler warning which used to didn't show up with some
old version of Cygwin. ad9c0fbc in 2012 added this, but it seems
this prototype should have been declared by an appropriate header
that's already been included here, so drop this prototype.
It also sounds what this message means according to Google.

Feel free to drop this if this is really needed for some reason.

  os/windows/posix.c:43:5: warning: 'vsprintf_s' redeclared without dllimport attribute: previous dllimport ignored [-Wattributes]
   int vsprintf_s(
       ^

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 os/windows/posix.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/os/windows/posix.c b/os/windows/posix.c
index f468cbf..eae8c86 100755
--- a/os/windows/posix.c
+++ b/os/windows/posix.c
@@ -40,12 +40,6 @@ HRESULT WINAPI StringCchPrintfA(
   const char *pszFormat,
   ...);
 
-int vsprintf_s(
-  char *buffer,
-  size_t numberOfElements,
-  const char *format,
-  va_list argptr);
-
 int win_to_posix_error(DWORD winerr)
 {
 	switch (winerr)
-- 
2.9.3


