Return-Path: <rebecca@bsdio.com>
From: Rebecca Cran <rebecca@bsdio.com>
Subject: [PATCH 2/2] Windows: Update URLs to https, and remove mention of WiX version
Date: Mon, 30 Sep 2019 14:57:08 -0600
Message-Id: <20190930205708.2302-2-rebecca@bsdio.com>
In-Reply-To: <20190930205708.2302-1-rebecca@bsdio.com>
References: <20190930205708.2302-1-rebecca@bsdio.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org
Cc: Rebecca Cran <rebecca@bsdio.com>
List-ID: <fio@vger.kernel.org>

---
 README | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/README b/README
index 7c65906d..0f943bcc 100644
--- a/README
+++ b/README
@@ -164,9 +164,9 @@ configure.
 Windows
 ~~~~~~~
 
-On Windows, Cygwin (http://www.cygwin.com/) is required in order to build
-fio. To create an MSI installer package install WiX 3.8 from
-http://wixtoolset.org and run :file:`dobuild.cmd` from the :file:`os/windows`
+On Windows, Cygwin (https://www.cygwin.com/) is required in order to build
+fio. To create an MSI installer package install WiX from
+https://wixtoolset.org and run :file:`dobuild.cmd` from the :file:`os/windows`
 directory.
 
 How to compile fio on 64-bit Windows:
-- 
2.21.0


