Return-Path: <fio-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:20211 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762019AbZJNWQr (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 14 Oct 2009 18:16:47 -0400
Received: from spaceape10.eur.corp.google.com (spaceape10.eur.corp.google.com [172.28.16.144])
	by smtp-out.google.com with ESMTP id n9EMFdPC017916
	for <fio@vger.kernel.org>; Wed, 14 Oct 2009 15:15:40 -0700
Received: from gxk26 (gxk26.prod.google.com [10.202.11.26])
	by spaceape10.eur.corp.google.com with ESMTP id n9EMF4vG032507
	for <fio@vger.kernel.org>; Wed, 14 Oct 2009 15:15:37 -0700
Received: by gxk26 with SMTP id 26so283464gxk.11
        for <fio@vger.kernel.org>; Wed, 14 Oct 2009 15:15:36 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 14 Oct 2009 15:15:36 -0700
Message-ID: <7ce25bc50910141515y3f43f6c1xdb903594377a51c0@mail.gmail.com>
Subject: [PATCH] Fix bug in bssplit parsing
From: Kenneth Waters <kwaters@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Fio,

I found a bug is bssplit parsing in bssplit_ddir() when trying to use
FIO on an ARM platform.  It looks like str_to_decimal() takes a "void
*" as its fourth argument, which it passes to get_multi_bytes(), which
is passes to fio_get_kb_base(), which casts it to a "struct
thread_data *".  bssplit_ddir() is passing in "struct thread_data **",
which I think is causing fio_get_kb_base() to go paw around in the
stack; I believe the different stack layouts between ARM and x86 is
causing me to see this problem.  The first change that introduces this
bug seems to be d6978a3242daad9cb7b0710b724f19225d1ed7e2.

Kenneth Waters

I apologize if this patch is in the wrong format.

---
 options.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/options.c b/options.c
index 549775c..b5abd74 100644
--- a/options.c
+++ b/options.c
@@ -82,7 +82,7 @@ static int bssplit_ddir(struct thread_data *td, int
ddir, char *str)
 		} else
 			perc = -1;

-		if (str_to_decimal(fname, &val, 1, &td)) {
+		if (str_to_decimal(fname, &val, 1, td)) {
 			log_err("fio: bssplit conversion failed\n");
 			free(td->o.bssplit);
 			return 1;
-- 
1.6.5
