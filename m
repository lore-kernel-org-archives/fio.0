Return-Path: <fio-owner@vger.kernel.org>
Received: from smtp2.provo.novell.com ([137.65.250.81]:42483 "EHLO
        smtp2.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752566AbeGBT0X (ORCPT
        <rfc822;groupwise-fio@vger.kernel.org:0:0>);
        Mon, 2 Jul 2018 15:26:23 -0400
Message-ID: <c799b578ed44ed560c36ec7ef1a93b8076e6cc64.camel@suse.com>
Subject: Assertion `t->bytes' failed in blktrace replay
From: Martin Wilck <mwilck@suse.com>
Date: Mon, 02 Jul 2018 21:26:15 +0200
Content-Type: text/plain; charset="utf-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

While trying to replay a blktrace file with fio 3.7, I got the
following error:

io: blktrace.c:326: handle_trace_fs: Assertion `t->bytes' failed.
fio: pid=7353, got signal=6

After reverting c1f22c2 "blktrace: kill zero sized write test",
I could replay the file, which was generated with blkparse from
blktrace 1.1.0.

The way I read the commit message of c1f22c2, it means that fio can't
deal with 0-byte writes. But they do occur in the trace in question.
AFAICS it's true that they're flushes but how else would I get rid of
them?

Does fio require blktrace files with a certain version?

Thanks,
Martin

-- 
Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)

