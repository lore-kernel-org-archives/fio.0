Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-pd0-f180.google.com ([209.85.192.180]:36326 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964AbbFYNjz (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 25 Jun 2015 09:39:55 -0400
Received: by pdcu2 with SMTP id u2so53822385pdc.3
        for <fio@vger.kernel.org>; Thu, 25 Jun 2015 06:39:54 -0700 (PDT)
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH] Fix testing and setting set_options bitmap
Date: Thu, 25 Jun 2015 22:39:41 +0900
Message-Id: <1435239581-6642-1-git-send-email-akinobu.mita@gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>

set_options bitmap is an array of uint64_t.  But while testing and
setting a bit in the bitmap, the bit mask is calculated with an
unsigned long value.  For the systems which have 32-bit long type,
upper 32-bit cannot be set correctly.

Fix it by using (uint64_t)1 instead of 1UL to calculate correct bit
mask.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 options.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/options.c b/options.c
index 76146a7..ed5d37e 100644
--- a/options.c
+++ b/options.c
@@ -4365,7 +4365,7 @@ static int opt_is_set(struct thread_options *o, struct fio_option *opt)
 	opt_off = opt - &fio_options[0];
 	index = opt_off / (8 * sizeof(uint64_t));
 	offset = opt_off & ((8 * sizeof(uint64_t)) - 1);
-	return (o->set_options[index] & (1UL << offset)) != 0;
+	return (o->set_options[index] & ((uint64_t)1 << offset)) != 0;
 }
 
 int __fio_option_is_set(struct thread_options *o, unsigned int off1)
@@ -4390,5 +4390,5 @@ void fio_option_mark_set(struct thread_options *o, struct fio_option *opt)
 	opt_off = opt - &fio_options[0];
 	index = opt_off / (8 * sizeof(uint64_t));
 	offset = opt_off & ((8 * sizeof(uint64_t)) - 1);
-	o->set_options[index] |= 1UL << offset;
+	o->set_options[index] |= (uint64_t)1 << offset;
 }
-- 
1.9.1

