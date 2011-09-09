Return-Path: <fio-owner@vger.kernel.org>
Received: from www7149u.sakura.ne.jp ([59.106.184.187]:51624 "EHLO
	i.rakugaki.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754542Ab1IIFc4 (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 9 Sep 2011 01:32:56 -0400
Received: from [10.253.0.10] (KD125053235206.ppp-bb.dion.ne.jp [125.53.235.206])
	by i.rakugaki.org (Postfix) with ESMTPSA id 0C9182030D
	for <fio@vger.kernel.org>; Fri,  9 Sep 2011 14:26:14 +0900 (JST)
Message-ID: <4E69A16D.1030407@rakugaki.org>
Date: Fri, 09 Sep 2011 14:17:33 +0900
From: Taisuke Yamada <tai@rakugaki.org>
MIME-Version: 1.0
Subject: [PATCH 2/2] Added wraparound IO support for replay on smaller/offsetted
 device.
Content-Type: multipart/mixed;
 boundary="------------080305020604090705020602"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

This is a multi-part message in MIME format.
--------------080305020604090705020602
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

This patch is related to previous one, but is independent.

When replayed IO goes beyond end of IO-redirected drive,
fio currently fails with lseek error. This happens when
IO offset shifting in previous patch is done, or when
redirected device is smaller than that of log-generating
device.

This patch wraps around IO offset by target device size
to keep fio running.

Signed-off-by: Taisuke Yamada <tai@rakugaki.org>
---
 log.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)



--------------080305020604090705020602
Content-Type: text/x-patch;
 name="0002-Added-wraparound-IO-support-for-replay-on-smaller-of.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0002-Added-wraparound-IO-support-for-replay-on-smaller-of.pa";
 filename*1="tch"

diff --git a/log.c b/log.c
index 57fc0f4..a636b7e 100644
--- a/log.c
+++ b/log.c
@@ -87,6 +87,7 @@ static int ipo_special(struct thread_data *td, struct io_piece *ipo)
 
 	switch (ipo->file_action) {
 	case FIO_LOG_OPEN_FILE:
+		ret = td_io_get_file_size(td, f); /* for wraparound replay */
 		ret = td_io_open_file(td, f);
 		if (!ret)
 			break;
@@ -132,6 +133,8 @@ int read_iolog_get(struct thread_data *td, struct io_u *io_u)
 			io_u->offset = ipo->offset + td->o.replay_rebase * td->thread_number;
 			io_u->buflen = ipo->len;
 			io_u->file = td->files[ipo->fileno];
+			if (io_u->file->real_file_size > 0)
+				io_u->offset %= io_u->file->real_file_size;
 			get_file(io_u->file);
 			dprint(FD_IO, "iolog: get %llu/%lu/%s\n", io_u->offset,
 						io_u->buflen, io_u->file->file_name);


--------------080305020604090705020602--
--:
To unsubscribe from this list: send the line "unsubscribe fio" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html


