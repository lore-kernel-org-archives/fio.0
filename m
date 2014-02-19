Return-Path: <fio-owner@vger.kernel.org>
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:49175 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408AbaBSPNG (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 19 Feb 2014 10:13:06 -0500
Received: from /spool/local
	by e06smtp14.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <fio@vger.kernel.org> from <ehrhardt@linux.vnet.ibm.com>;
	Wed, 19 Feb 2014 15:13:04 -0000
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
	by d06dlp01.portsmouth.uk.ibm.com (Postfix) with ESMTP id EE12617D8062
	for <fio@vger.kernel.org>; Wed, 19 Feb 2014 15:13:31 +0000 (GMT)
Received: from d06av12.portsmouth.uk.ibm.com (d06av12.portsmouth.uk.ibm.com [9.149.37.247])
	by b06cxnps4074.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id s1JFCnWZ50200714
	for <fio@vger.kernel.org>; Wed, 19 Feb 2014 15:12:50 GMT
Received: from d06av12.portsmouth.uk.ibm.com (localhost [127.0.0.1])
	by d06av12.portsmouth.uk.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id s1JFD0Zf006322
	for <fio@vger.kernel.org>; Wed, 19 Feb 2014 08:13:01 -0700
Message-ID: <5304C9FB.8030205@linux.vnet.ibm.com>
Date: Wed, 19 Feb 2014 16:12:59 +0100
From: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
MIME-Version: 1.0
Subject: [patch 9/9] fio: allow 0 as compress percentage
References: <20140219143639.168501090@linux.vnet.ibm.com>
In-Reply-To: <20140219143639.168501090@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: oberpar@linux.vnet.ibm.com, Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>

From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>

Allow 0 as value for option compress_percentage which can be useful for
certain deduplication and compression based storage back ends.

Signed-off-by: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
---
[diffstat]
  options.c |    2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

--- a/options.c
+++ b/options.c
@@ -3072,7 +3072,7 @@ struct fio_option fio_options[FIO_MAX_OP
  		.type	= FIO_OPT_INT,
  		.off1	= td_var_offset(compress_percentage),
  		.maxval	= 100,
-		.minval	= 1,
+		.minval	= 0,
  		.help	= "How compressible the buffer is (approximately)",
  		.interval = 5,
  		.category = FIO_OPT_C_IO,




