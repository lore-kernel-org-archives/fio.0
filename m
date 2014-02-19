Return-Path: <fio-owner@vger.kernel.org>
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:37179 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753771AbaBSPNA (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 19 Feb 2014 10:13:00 -0500
Received: from /spool/local
	by e06smtp16.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <fio@vger.kernel.org> from <ehrhardt@linux.vnet.ibm.com>;
	Wed, 19 Feb 2014 15:12:59 -0000
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
	by d06dlp02.portsmouth.uk.ibm.com (Postfix) with ESMTP id 19F3B219005C
	for <fio@vger.kernel.org>; Wed, 19 Feb 2014 15:12:55 +0000 (GMT)
Received: from d06av12.portsmouth.uk.ibm.com (d06av12.portsmouth.uk.ibm.com [9.149.37.247])
	by b06cxnps4075.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id s1JFCjsA46596350
	for <fio@vger.kernel.org>; Wed, 19 Feb 2014 15:12:45 GMT
Received: from d06av12.portsmouth.uk.ibm.com (localhost [127.0.0.1])
	by d06av12.portsmouth.uk.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id s1JFCufc006112
	for <fio@vger.kernel.org>; Wed, 19 Feb 2014 08:12:57 -0700
Message-ID: <5304C9F7.30001@linux.vnet.ibm.com>
Date: Wed, 19 Feb 2014 16:12:55 +0100
From: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
MIME-Version: 1.0
Subject: [patch 8/9] fio: fix last block never being touched by random offsets
References: <20140219143639.168501090@linux.vnet.ibm.com>
In-Reply-To: <20140219143639.168501090@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: oberpar@linux.vnet.ibm.com, Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>

From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>

Fix the available range for random offsets which never touched the last 
block.

Signed-off-by: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
---
[diffstat]
  io_u.c |    2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

--- a/io_u.c
+++ b/io_u.c
@@ -104,7 +104,7 @@ static int __get_next_rand_offset(struct
   		dprint(FD_RANDOM, "off rand %llu\n", (unsigned long long) r);
  -		*b = (lastb - 1) * (r / ((uint64_t) rmax + 1.0));
+		*b = lastb * (r / ((uint64_t) rmax + 1.0));
  	} else {
  		uint64_t off = 0;


