Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:37358 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753285AbaLTQcf convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Sat, 20 Dec 2014 11:32:35 -0500
Received: by mail-pa0-f53.google.com with SMTP id kq14so3103168pab.26
        for <fio@vger.kernel.org>; Sat, 20 Dec 2014 08:32:35 -0800 (PST)
Received: from [192.168.1.102] (cpe-065-190-048-038.nc.res.rr.com. [65.190.48.38])
        by mx.google.com with ESMTPSA id x16sm12796116pbt.70.2014.12.20.08.32.33
        for <fio@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Sat, 20 Dec 2014 08:32:34 -0800 (PST)
From: Chris Wilson <Chris.Wilson@nutanix.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: Scramble buffers not set by default unless set explicitly 
Message-Id: <58BC9DC1-E3EE-4B45-9ED7-0B5506045A14@nutanix.com>
Date: Sat, 20 Dec 2014 11:32:32 -0500
Mime-Version: 1.0 (Mac OS X Mail 8.1 \(1993\))
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

A change (1bf2498d311155bc4eb43edb4e6d3a04845d94c5) to make scramble buffers easier to understand appears to have made scramble buffers not the default behavior by accident.  The logic would always evaluate such that scramble buffers is not used unless set explicitly.

I think the following little patch changes the logic to what was intended.

diff --git a/init.c b/init.c
index 427768c..a47186b 100644
--- a/init.c
+++ b/init.c
@@ -937,7 +937,7 @@ static void init_flags(struct thread_data *td)
         * set. But if scramble_buffers has been set, always scramble.
         */
        if (o->scramble_buffers && ((!o->zero_buffers &&
-           fio_option_is_set(o, zero_buffers)) ||
+           !fio_option_is_set(o, zero_buffers)) ||
            fio_option_is_set(o, scramble_buffers)))
                td->flags |= TD_F_SCRAMBLE_BUFFERS;
        if (o->verify != VERIFY_NONE)
