Return-Path: <fio-owner@vger.kernel.org>
Received: from tone.orchestra.cse.unsw.EDU.AU ([129.94.242.59]:33669 "EHLO
	tone.orchestra.cse.unsw.EDU.AU" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751264Ab3DOETC (ORCPT
	<rfc822;fio@vger.kernel.org>); Mon, 15 Apr 2013 00:19:02 -0400
Received: From
	[10.13.1.8] ([203.143.161.65] == vampire.ertos.nicta.com.au) (auth-user aaronc) (cse-authentic-sender aaronc)
	(for <fio@vger.kernel.org>) By tone With Smtp ;
	Mon, 15 Apr 2013 14:18:59 +1000 
From: Aaron Carroll <aaronc@cse.unsw.edu.au>
Date: Mon, 15 Apr 2013 14:18:15 +1000
Message-ID: <516B7F87.8080607@cse.unsw.edu.au>
MIME-Version: 1.0
Subject: [PATCH] README: quick note on how to cross compile
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Signed-off-by: Aaron Carroll <aaronc@cse.unsw.edu.au>
---
   README |    5 +++++
   1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/README b/README
index 7df6306..3782570 100644
--- a/README
+++ b/README
@@ -96,6 +96,11 @@ For gfio, you need gtk 2.18 or newer and associated glib threads
   and cairo. gfio isn't built automatically, it needs to be enabled
   with a --enable-gfio option to configure.

+To build FIO with a cross-compiler:
+ $ make clean
+ $ make CROSS_COMPILE=/path/to/toolchain/prefix
+Configure will attempt to determine the target platform automatically.
+

   Windows
   -------
-- 
1.7.0.4
