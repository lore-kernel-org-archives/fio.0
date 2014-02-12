Return-Path: <fio-owner@vger.kernel.org>
Received: from mailout09.t-online.de ([194.25.134.84]:56288 "EHLO
	mailout09.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218AbaBLPMP (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 12 Feb 2014 10:12:15 -0500
From: "Daniel Gollub" <daniel.gollub@t-online.de>
Subject: [PATCH 1/2] Make file.h C++ safe by casting fio_file_flags
Date: Wed, 12 Feb 2014 15:51:54 +0100
Message-Id: <1392216715-9539-2-git-send-email-d.gollub@telekom.de>
In-Reply-To: <1392216715-9539-1-git-send-email-d.gollub@telekom.de>
References: <1392216715-9539-1-git-send-email-d.gollub@telekom.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Daniel Gollub <d.gollub@telekom.de>

Fixes for g++ (4.7.2) following compiler errors when fio.h
gets included (e.g. in an external C++ ioengine):

--8<---
[...]
os/../file.h: In function ‘void fio_file_set_open(fio_file*)’:
os/../file.h:142:1: error: invalid conversion from ‘int’ to ‘fio_file_flags’ [-fpermissive]
os/../file.h: In function ‘void fio_file_clear_open(fio_file*)’:
os/../file.h:142:1: error: invalid conversion from ‘int’ to ‘fio_file_flags’ [-fpermissive]
os/../file.h: In function ‘void fio_file_set_closing(fio_file*)’:
[...]
--->8---

Signed-off-by: Daniel Gollub <d.gollub@telekom.de>
---
 file.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/file.h b/file.h
index d7e05f4..12d2d11 100644
--- a/file.h
+++ b/file.h
@@ -128,11 +128,11 @@ struct fio_file {
 #define FILE_FLAG_FNS(name)						\
 static inline void fio_file_set_##name(struct fio_file *f)		\
 {									\
-	(f)->flags |= FIO_FILE_##name;					\
+	(f)->flags = (enum fio_file_flags) ((f)->flags | FIO_FILE_##name);	\
 }									\
 static inline void fio_file_clear_##name(struct fio_file *f)		\
 {									\
-	(f)->flags &= ~FIO_FILE_##name;					\
+	(f)->flags = (enum fio_file_flags) ((f)->flags & ~FIO_FILE_##name);	\
 }									\
 static inline int fio_file_##name(struct fio_file *f)			\
 {									\
-- 
1.7.10.4

