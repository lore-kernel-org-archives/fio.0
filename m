Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-qc0-f172.google.com ([209.85.216.172]:41957 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058AbbA0TYi (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 27 Jan 2015 14:24:38 -0500
Received: by mail-qc0-f172.google.com with SMTP id i8so13631166qcq.3
        for <fio@vger.kernel.org>; Tue, 27 Jan 2015 11:24:38 -0800 (PST)
Received: from vass-desktop (ool-18e4aba6.dyn.optonline.net. [24.228.171.166])
        by mx.google.com with ESMTPSA id r9sm1919123qak.2.2015.01.27.11.24.37
        for <fio@vger.kernel.org>
        (version=TLSv1.2 cipher=RC4-SHA bits=128/128);
        Tue, 27 Jan 2015 11:24:37 -0800 (PST)
Date: Tue, 27 Jan 2015 14:24:48 -0500
From: Vasily Tarasov <tarasov@vasily.name>
Subject: [PATCH] dedupe_percentage should work even if compress_percentage is
 not set
Message-ID: <20150127192448.GA16313@vass-desktop>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="bg08WKrSYDhXBjb5"
Content-Disposition: inline
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org


--bg08WKrSYDhXBjb5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

[PATCH] dedupe_percentage should work even if compress_percentage is not set 

Currently dedupe_percentage option does not work properly if compress_percentage
is not set. This can be easily demonstrated using the following job file:

[job-/dev/dm-0]
filename=/dev/dm-0
rw=randwrite
blocksize=4096
direct=1
ioengine=libaio
iodepth=32
dedupe_percentage=50
time_based=1
runtime=5
numjobs=1

All writes will contain zeroes for the above job file.

The problem is in fill_io_buffer() function that switches dedupe random state
only if o->compress_percentage is set.                                                                                                                                                                         

This patch updates the condition appropriately in fill_io_buffer()
appropriately.

Signed-off-by: Vasily Tarasov <tarasov@vasily.name>

--bg08WKrSYDhXBjb5
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: inline; filename="diff-dedupe.diff"

diff --git a/backend.c b/backend.c
index 9012140..25db74a 100644
--- a/backend.c
+++ b/backend.c
@@ -1866,7 +1867,7 @@ void fill_io_buffer(struct thread_data *td, void *buf, unsigned int min_write,
 {
 	struct thread_options *o = &td->o;
 
-	if (o->compress_percentage) {
+	if (o->compress_percentage || o->dedupe_percentage) {
 		unsigned int perc = td->o.compress_percentage;
 		struct frand_state *rs;
 		unsigned int left = max_bs;

--bg08WKrSYDhXBjb5--
