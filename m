Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-qt0-f180.google.com ([209.85.216.180]:33133 "EHLO
        mail-qt0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752108AbdGCGjM (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 3 Jul 2017 02:39:12 -0400
Received: by mail-qt0-f180.google.com with SMTP id r30so136142096qtc.0
        for <fio@vger.kernel.org>; Sun, 02 Jul 2017 23:39:11 -0700 (PDT)
MIME-Version: 1.0
From: Keith Owens <kaos.ocs@gmail.com>
Date: Mon, 3 Jul 2017 16:39:10 +1000
Message-ID: <CAFOWsvt5joru9mNN3VM65spn77VQDvCQp-OPwAXrtfi4SSbEJA@mail.gmail.com>
Subject: Inverted test in fio ipo_bytes_align()
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

ipo_bytes_align() does nothing when replay_align is set, when
replay_align is 0 it incorrectly masks all replay offsets to 0. The
test is inverted.

diff --git a/iolog.h b/iolog.h
index 60ee3e9..37f27bc 100644
--- a/iolog.h
+++ b/iolog.h
@@ -271,7 +271,7 @@ static inline bool inline_log(struct io_log *log)

 static inline void ipo_bytes_align(unsigned int replay_align, struct
io_piece *ipo)
 {
-    if (replay_align)
+    if (!replay_align)
         return;

     ipo->offset &= ~(replay_align - (uint64_t)1);
