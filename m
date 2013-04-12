Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vc0-f178.google.com ([209.85.220.178]:38033 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675Ab3DLDxH (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 11 Apr 2013 23:53:07 -0400
Received: by mail-vc0-f178.google.com with SMTP id hv10so1871983vcb.37
        for <fio@vger.kernel.org>; Thu, 11 Apr 2013 20:53:06 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 12 Apr 2013 13:53:06 +1000
Message-ID: <CAKCZDg=H1ry20d8sxcHaod3=Z0SfJDzj0Z4sDo2aSvnMAk=R8A@mail.gmail.com>
Subject: [PATCH] fix warning on 32-bit systems
From: Aaron Carroll <xaaronc@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Casting a uint64_t to a pointer emits a warning on 32 bit systems.
This patch fixes the warning, but seems a bit suspicious. Should the
type of 'tag' be uintptr_t ?

--

diff --git a/server.c b/server.c
index 9537c96..3c52083 100644
--- a/server.c
+++ b/server.c
@@ -293,7 +293,7 @@ struct fio_net_cmd *fio_net_recv_cmd(int sk)

 static void add_reply(uint64_t tag, struct flist_head *list)
 {
-       struct fio_net_cmd_reply *reply = (struct fio_net_cmd_reply *) tag;
+       struct fio_net_cmd_reply *reply = (struct fio_net_cmd_reply *)
(uintptr_t)tag;

        flist_add_tail(&reply->list, list);
 }
@@ -313,7 +313,7 @@ static uint64_t alloc_reply(uint64_t tag, uint16_t opcode)

 static void free_reply(uint64_t tag)
 {
-       struct fio_net_cmd_reply *reply = (struct fio_net_cmd_reply *) tag;
+       struct fio_net_cmd_reply *reply = (struct fio_net_cmd_reply *)
(uintptr_t)tag;

        free(reply);
 }
