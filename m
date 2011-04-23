Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:37237 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469Ab1DWD51 (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 22 Apr 2011 23:57:27 -0400
Received: by pzk9 with SMTP id 9so543183pzk.19
        for <fio@vger.kernel.org>; Fri, 22 Apr 2011 20:57:26 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 23 Apr 2011 05:57:26 +0200
Message-ID: <BANLkTiktKRjW235qUUFAMES88BbQXNc5cw@mail.gmail.com>
Subject: [BUG] [PATCH] Undefined symbols: "_posix_memalign" on Mac OS X
From: Filip Sneppe <filip.sneppe@gmail.com>
Content-Type: multipart/mixed; boundary=bcaec52e5b47009b1a04a18df96c
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

--bcaec52e5b47009b1a04a18df96c
Content-Type: text/plain; charset=ISO-8859-1

Hi,

(I am not subscribed to this list, nor am I a Unix developer).

I wanted to give fio a try on my OS X 10.5.8 machine, but
this is the error I received when compiling:

    CC helpers.o
    CC engines/posixaio.o
    DEP depend
    CC fio
Undefined symbols:
  "_posix_memalign", referenced from:
      _thread_main in fio.o
ld: symbol(s) not found
collect2: ld returned 1 exit status
make: *** [fio] Error 1

After some googling, I learned that OS X doesn't
provide _posix_memalign, and that apparently it's not
needed on this platform. I "fixed" my compile problem with the
attached patch. You may find it useful to write a better fix for this.

Best regards and thanks for providing this tool,
Filip

diff -urN fio/Makefile fio-patched/Makefile
--- fio/Makefile        2011-04-23 05:40:54.000000000 +0200
+++ fio-patched/Makefile        2011-04-23 05:39:13.000000000 +0200
@@ -46,7 +46,7 @@
   CPPFLAGS += -D_LARGE_FILES -D__ppc__
 endif
 ifeq ($(UNAME), Darwin)
-  SOURCE += helpers.c engines/posixaio.c
+  SOURCE += helpers.c darwin.c engines/posixaio.c
   LIBS  += -lpthread -ldl
 endif
 ifneq (,$(findstring CYGWIN,$(UNAME)))
diff -urN fio/darwin.c fio-patched/darwin.c
--- fio/darwin.c        1970-01-01 01:00:00.000000000 +0100
+++ fio-patched/darwin.c        2011-04-23 05:38:54.000000000 +0200
@@ -0,0 +1,15 @@
+#include <stdlib.h>
+#include <errno.h>
+#include "compiler/compiler.h"
+
+/*
+ * Darwin doesn't have posix_memalign(), provide a private
+ * weak alternative
+ */
+int __weak posix_memalign(void **ptr, size_t align, size_t size)
+{
+       if (*ptr)
+               return 0;
+
+       return ENOMEM;
+}

--bcaec52e5b47009b1a04a18df96c
Content-Type: application/octet-stream; name="fio.darwin.patch"
Content-Disposition: attachment; filename="fio.darwin.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gmu0hitd0

ZGlmZiAtdXJOIGZpby9NYWtlZmlsZSBmaW8tcGF0Y2hlZC9NYWtlZmlsZQotLS0gZmlvL01ha2Vm
aWxlCTIwMTEtMDQtMjMgMDU6NDA6NTQuMDAwMDAwMDAwICswMjAwCisrKyBmaW8tcGF0Y2hlZC9N
YWtlZmlsZQkyMDExLTA0LTIzIDA1OjM5OjEzLjAwMDAwMDAwMCArMDIwMApAQCAtNDYsNyArNDYs
NyBAQAogICBDUFBGTEFHUyArPSAtRF9MQVJHRV9GSUxFUyAtRF9fcHBjX18KIGVuZGlmCiBpZmVx
ICgkKFVOQU1FKSwgRGFyd2luKQotICBTT1VSQ0UgKz0gaGVscGVycy5jIGVuZ2luZXMvcG9zaXhh
aW8uYworICBTT1VSQ0UgKz0gaGVscGVycy5jIGRhcndpbi5jIGVuZ2luZXMvcG9zaXhhaW8uYwog
ICBMSUJTCSArPSAtbHB0aHJlYWQgLWxkbAogZW5kaWYKIGlmbmVxICgsJChmaW5kc3RyaW5nIENZ
R1dJTiwkKFVOQU1FKSkpCmRpZmYgLXVyTiBmaW8vZGFyd2luLmMgZmlvLXBhdGNoZWQvZGFyd2lu
LmMKLS0tIGZpby9kYXJ3aW4uYwkxOTcwLTAxLTAxIDAxOjAwOjAwLjAwMDAwMDAwMCArMDEwMAor
KysgZmlvLXBhdGNoZWQvZGFyd2luLmMJMjAxMS0wNC0yMyAwNTozODo1NC4wMDAwMDAwMDAgKzAy
MDAKQEAgLTAsMCArMSwxNSBAQAorI2luY2x1ZGUgPHN0ZGxpYi5oPgorI2luY2x1ZGUgPGVycm5v
Lmg+CisjaW5jbHVkZSAiY29tcGlsZXIvY29tcGlsZXIuaCIKKworLyoKKyAqIERhcndpbiBkb2Vz
bid0IGhhdmUgcG9zaXhfbWVtYWxpZ24oKSwgcHJvdmlkZSBhIHByaXZhdGUKKyAqIHdlYWsgYWx0
ZXJuYXRpdmUKKyAqLworaW50IF9fd2VhayBwb3NpeF9tZW1hbGlnbih2b2lkICoqcHRyLCBzaXpl
X3QgYWxpZ24sIHNpemVfdCBzaXplKQoreworCWlmICgqcHRyKQorCQlyZXR1cm4gMDsKKworCXJl
dHVybiBFTk9NRU07Cit9Cg==
--bcaec52e5b47009b1a04a18df96c--
--:
To unsubscribe from this list: send the line "unsubscribe fio" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html


