Return-Path: <fio-owner@vger.kernel.org>
Received: from muon.cran.org.uk ([93.89.92.64]:26841 "EHLO muon.cran.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751417AbaBME6N (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 12 Feb 2014 23:58:13 -0500
Received: from muon.cran.org.uk (localhost [127.0.0.1])
	by muon.cran.org.uk (Postfix) with ESMTP id 3DB6FE73AB
	for <fio@vger.kernel.org>; Thu, 13 Feb 2014 04:58:09 +0000 (GMT)
Received: from [10.0.10.11] (c-67-177-60-232.hsd1.ut.comcast.net [67.177.60.232])
	(using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by muon.cran.org.uk (Postfix) with ESMTPSA id 81ABAE7399
	for <fio@vger.kernel.org>; Thu, 13 Feb 2014 04:58:08 +0000 (GMT)
Message-ID: <52FC50FF.6060008@cran.org.uk>
Date: Wed, 12 Feb 2014 21:58:39 -0700
From: Bruce Cran <bruce@cran.org.uk>
MIME-Version: 1.0
Subject: [patch] Fix IPv6 check on FreeBSD by including netinet/in.h
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

I noticed IPv6 support was being disabled on FreeBSD; it seems the 
configure script needs netinet/in.h so in6_addr is known.

-- 
Bruce

 From 21fc22b5f510d8dc93a9b200f3787a7aa6638d35 Mon Sep 17 00:00:00 2001
From: Bruce Cran <bruce@cran.org.uk>
Date: Thu, 13 Feb 2014 04:53:36 +0000
Subject: [PATCH] According to POSIX, in6_addr requires netinet/in.h

---
  configure | 1 +
  1 file changed, 1 insertion(+)

diff --git a/configure b/configure
index 78a6ccb..89405cd 100755
--- a/configure
+++ b/configure
@@ -1098,6 +1098,7 @@ ipv6="no"
  cat > $TMPC << EOF
  #include <sys/types.h>
  #include <sys/socket.h>
+#include <netinet/in.h>
  #include <netdb.h>
  #include <stdio.h>
  int main(int argc, char **argv)
--
1.8.4.3

