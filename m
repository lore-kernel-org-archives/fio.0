Return-Path: <fio-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36964 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726304AbeI2Dxf (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 28 Sep 2018 23:53:35 -0400
Received: from smtp.corp.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.26])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D3F9B3001C5A
        for <fio@vger.kernel.org>; Fri, 28 Sep 2018 21:27:59 +0000 (UTC)
Received: from segfault.boston.devel.redhat.com (segfault.boston.devel.redhat.com [10.19.60.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8D8333091373
        for <fio@vger.kernel.org>; Fri, 28 Sep 2018 21:27:59 +0000 (UTC)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: [patch] fix hung fio process with large I/O sizes and verify= option
Date: Fri, 28 Sep 2018 17:27:58 -0400
Message-ID: <x49sh1t48ip.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,

If you use a very large I/O size (1G in this instance), and also specify
the verify option, fio will hang, using up 100% cpu, for ever and ever.
The problem is that __fill_random_buf_percentage does math that
overflows the size of an unsigned int.  Fixing that gets fio to
terminate as expected.

Here is the job file which showed the problem:

[global]
ioengine=dev-dax
direct=0
filename=/dev/dax0.0
verify=crc32c
bs=1G
[write]
rw=write
runtime=5
[read]
stonewall
rw=read
runtime=5

Reported-by: sujith_pandel@dell.com
Signed-off-by: Jeff Moyer <jmoyer@redhat.com>

diff --git a/lib/rand.c b/lib/rand.c
index 46ffe4fb..99846a8d 100644
--- a/lib/rand.c
+++ b/lib/rand.c
@@ -156,7 +156,7 @@ void __fill_random_buf_percentage(unsigned long seed, void *buf,
 		/*
 		 * Fill random chunk
 		 */
-		this_len = (segment * (100 - percentage)) / 100;
+		this_len = ((unsigned long long)segment * (100 - percentage)) / 100;
 		if (this_len > len)
 			this_len = len;
 

