Return-Path: <fio-owner@vger.kernel.org>
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:53224 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754646AbaBTNVB (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 20 Feb 2014 08:21:01 -0500
Received: from /spool/local
	by e06smtp14.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <fio@vger.kernel.org> from <ehrhardt@linux.vnet.ibm.com>;
	Thu, 20 Feb 2014 13:20:59 -0000
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
	by d06dlp03.portsmouth.uk.ibm.com (Postfix) with ESMTP id CA3BF1B08070
	for <fio@vger.kernel.org>; Thu, 20 Feb 2014 13:20:36 +0000 (GMT)
Received: from d06av09.portsmouth.uk.ibm.com (d06av09.portsmouth.uk.ibm.com [9.149.37.250])
	by b06cxnps4074.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id s1KDKk3U30933198
	for <fio@vger.kernel.org>; Thu, 20 Feb 2014 13:20:46 GMT
Received: from d06av09.portsmouth.uk.ibm.com (localhost [127.0.0.1])
	by d06av09.portsmouth.uk.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id s1KDKvsB023772
	for <fio@vger.kernel.org>; Thu, 20 Feb 2014 06:20:58 -0700
Message-Id: <20140220132051.840462957@linux.vnet.ibm.com>
Date: Thu, 20 Feb 2014 14:20:07 +0100
From: ehrhardt@linux.vnet.ibm.com
Subject: [patch 9/9] fio: allow 0 as compress percentage
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: oberpar@linux.vnet.ibm.com, Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>

*Resend with hopefully non mangled patches*
References: <20140220131958.965092001@linux.vnet.ibm.com>
Content-Disposition: inline; filename=buffer_compress_zero.diff

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

