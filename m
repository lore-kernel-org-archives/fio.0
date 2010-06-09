Return-Path: <fio-owner@vger.kernel.org>
Received: from mail.valinux.co.jp ([210.128.90.3]:60170 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754050Ab0FIGZB (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 9 Jun 2010 02:25:01 -0400
Subject: missing include
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Message-Id: <20100609062459.B135A71A54@kuma.localdomain>
Date: Wed,  9 Jun 2010 15:24:59 +0900 (JST)
From: yamamoto@valinux.co.jp (YAMAMOTO Takashi)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

hi,

please incorporate the following trivial patch.

YAMAMOTO Takashi

Signed-off-by: YAMAMOTO Takashi <yamamoto@valinux.co.jp>

commit 0d8b33274c738784c26d842d66c41ee5e7ddc0a3
Author: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
Date:   Wed Jun 9 15:23:07 2010 +0900

    include libgen.h for basename.

diff --git a/filesetup.c b/filesetup.c
index ec5d781..9cc4872 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -3,6 +3,7 @@
 #include <string.h>
 #include <assert.h>
 #include <dirent.h>
+#include <libgen.h>
 #include <sys/stat.h>
 #include <sys/mman.h>
 #include <sys/types.h>
