Return-Path: <fio-owner@vger.kernel.org>
Received: from postman.teamix.net ([194.150.191.120]:38630 "EHLO
	rproxy.teamix.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933732Ab1JEJqu convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Wed, 5 Oct 2011 05:46:50 -0400
Received: from zimbra.of.teamix.net (unknown [172.21.242.23])
	by rproxy.teamix.net (Postfix) with ESMTP id 77F057FB2
	for <fio@vger.kernel.org>; Wed,  5 Oct 2011 11:46:49 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by zimbra.of.teamix.net (Postfix) with ESMTP id 6ABA6146EF7
	for <fio@vger.kernel.org>; Wed,  5 Oct 2011 11:46:49 +0200 (CEST)
Received: from zimbra.of.teamix.net ([127.0.0.1])
	by localhost (zimbra.of.teamix.net [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id iTq7MTKfBC6k for <fio@vger.kernel.org>;
	Wed,  5 Oct 2011 11:46:48 +0200 (CEST)
Received: from mango.localnet (mango.of.teamix.net [172.21.123.1])
	by zimbra.of.teamix.net (Postfix) with ESMTPSA id E2CA2146EEA
	for <fio@vger.kernel.org>; Wed,  5 Oct 2011 11:46:48 +0200 (CEST)
From: Martin Steigerwald <ms@teamix.de>
Subject: [PATCH] Escape minus signs in manpage to fix lintian warning
Date: Wed, 5 Oct 2011 11:46:47 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Message-Id: <201110051146.47562.ms@teamix.de>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi Jens!

I have patch to fix a recently introduced lintian warning. It is my first
try with "git format-patch origin" and KMail without line wrappings.

Please tell me, whether its okay.

I will include the patch in my debian package until I package a version
where you merged it.


From 0d572b5e317ec8c93d8594c40c05c2464fcef59f Mon Sep 17 00:00:00 2001
From: Martin Steigerwald <ms@teamix.de>
Date: Wed, 5 Oct 2011 11:41:54 +0200
Subject: [PATCH] Escape minus signs in manpage to fix lintian warning:

I: fio: hyphen-used-as-minus-sign usr/share/man/man1/fio.1.gz:934

see:
http://lintian.debian.org/tags/hyphen-used-as-minus-sign.html
---
 fio.1 |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fio.1 b/fio.1
index dc10b40..513caa9 100644
--- a/fio.1
+++ b/fio.1
@@ -931,7 +931,7 @@ Enable the reporting of percentiles of completion latencies.
 Overwrite the default list of percentiles for completion
 latencies. Each number is a floating number in the range (0,100], and
 the maximum length of the list is 20. Use ':' to separate the
-numbers. For example, --percentile_list=99.5:99.9 will cause fio to
+numbers. For example, \-\-percentile_list=99.5:99.9 will cause fio to
 report the values of completion latency below which 99.5% and 99.9% of
 the observed latencies fell, respectively.
 .SH OUTPUT
-- 
1.7.6.3

Thanks,
-- 
Martin Steigerwald - teamix GmbH - http://www.teamix.de
gpg: 19E3 8D42 896F D004 08AC A0CA 1E10 C593 0399 AE90
