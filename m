Return-Path: <tkusumi@tuxera.com>
From: Tomohiro Kusumi <tkusumi@tuxera.com>
Subject: [PATCH 4/6] Remove irrelevant Cygwin config flag CONFIG_FADVISE
Date: Sun, 19 Feb 2017 20:22:21 +0200
Message-ID: <20170219182223.120559-4-tkusumi@tuxera.com>
In-Reply-To: <20170219182223.120559-1-tkusumi@tuxera.com>
References: <20170219182223.120559-1-tkusumi@tuxera.com>
MIME-Version: 1.0
Content-Type: text/plain
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

This is unused and nothing happens regardless of this flag being
set on Cygwin. The one for POSIX fadvise is CONFIG_POSIX_FADVISE.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 configure | 2 --
 1 file changed, 2 deletions(-)

diff --git a/configure b/configure
index be29db9..584ebc2 100755
--- a/configure
+++ b/configure
@@ -311,9 +311,7 @@ CYGWIN*)
   else
     output_sym "CONFIG_64BIT_LLP64"
   fi
-  output_sym "CONFIG_FADVISE"
   output_sym "CONFIG_SOCKLEN_T"
-  output_sym "CONFIG_FADVISE"
   output_sym "CONFIG_SFAA"
   output_sym "CONFIG_RUSAGE_THREAD"
   output_sym "CONFIG_WINDOWSAIO"
-- 
2.9.3


