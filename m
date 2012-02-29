Return-Path: <dehrenberg@google.com>
MIME-Version: 1.0
From: Dan Ehrenberg <dehrenberg@google.com>
Subject: [PATCH] fallocate: enable fallocate options on Linux
Date: Wed, 29 Feb 2012 12:54:02 -0800
Message-Id: <1330548842-31981-1-git-send-email-dehrenberg@google.com>
To: fio@vger.kernel.org, axboe@kernel.dk
Cc: nauman@google.com, egouriou@google.com, tirea@google.com, Dan Ehrenberg <dehrenberg@google.com>
List-ID: <fio@vger.kernel.org>

Simple bug fix to ensure that fallocate-related options are
once again enabled on Linux systems with the right headers present.
A previous patch gated the FIO_HAVE_LINUX_FALLOCATE flag on
header versions but failed to enable FIO_HAVE_FALLOCATE in this
case.
---
 os/os-linux.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/os/os-linux.h b/os/os-linux.h
index 3bf6bd9..b911753 100644
--- a/os/os-linux.h
+++ b/os/os-linux.h
@@ -51,6 +51,7 @@
  * missing
  */
 #if __GLIBC__ >= 2 && __GLIBC_MINOR__ >= 8
+#define FIO_HAVE_FALLOCATE
 #define FIO_HAVE_LINUX_FALLOCATE
 #endif
 
-- 
1.7.7.3


