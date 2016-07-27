Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Subject: [PATCH 14/15] Add missing archs in fio_arch_strings[]
Date: Wed, 27 Jul 2016 22:37:19 +0900
Message-Id: <1469626640-13335-14-git-send-email-kusumi.tomohiro@gmail.com>
In-Reply-To: <1469626640-13335-1-git-send-email-kusumi.tomohiro@gmail.com>
References: <1469626640-13335-1-git-send-email-kusumi.tomohiro@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
List-ID: <fio@vger.kernel.org>

Add MIPS and AArch64 after PARISC.

Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
---
 libfio.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/libfio.c b/libfio.c
index 2586675..fb7d35a 100644
--- a/libfio.c
+++ b/libfio.c
@@ -47,6 +47,7 @@ unsigned long arch_flags = 0;
 uintptr_t page_mask = 0;
 uintptr_t page_size = 0;
 
+/* see os/os.h */
 static const char *fio_os_strings[os_nr] = {
 	"Invalid",
 	"Linux",
@@ -62,6 +63,7 @@ static const char *fio_os_strings[os_nr] = {
 	"DragonFly",
 };
 
+/* see arch/arch.h */
 static const char *fio_arch_strings[arch_nr] = {
 	"Invalid",
 	"x86-64",
@@ -75,6 +77,8 @@ static const char *fio_arch_strings[arch_nr] = {
 	"arm",
 	"sh",
 	"hppa",
+	"mips",
+	"aarch64",
 	"generic"
 };
 
-- 
2.5.5


