Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:63397 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753837AbaFIUvL (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 9 Jun 2014 16:51:11 -0400
Received: by mail-la0-f48.google.com with SMTP id mc6so3410933lab.35
        for <fio@vger.kernel.org>; Mon, 09 Jun 2014 13:51:09 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 9 Jun 2014 16:51:09 -0400
Message-ID: <CAKO35LNYsNNzcPqJKiiZ12As698qAo1QOs4piZw=-dB_rrHvyg@mail.gmail.com>
Subject: build from cmake
From: George Dowding <gdowding@nutanix.com>
Content-Type: multipart/mixed; boundary=047d7b33da60f1fb9904fb6d5e60
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

--047d7b33da60f1fb9904fb6d5e60
Content-Type: text/plain; charset=UTF-8

I spent a few hours on this. Might save someone else some time.

I'm working in a larger project that uses cmake for its builds. cmake
supports adding external projects using the ExternalProject_Add
function.

But, there is some issue in the fio Makefile that causes a problem
when run from cmake. I could never reproduce it from the command line.

I was able to get the build to happen by changing the implicit rule
.c.o to use pattern notation. Not sure if this will work in all cases
or has other side effects.

Without this change, I was getting this error.

make[4]: *** No rule to make target `gettime.o', needed by `fio'.  Stop.


-- 
George Dowding
http://www.nutanix.com/
(669) 200 6682

--047d7b33da60f1fb9904fb6d5e60
Content-Type: application/octet-stream; name="cmake.patch"
Content-Disposition: attachment; filename="cmake.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hw898fws0

ZGlmZiAtLWdpdCBhL01ha2VmaWxlIGIvTWFrZWZpbGUKaW5kZXggYTBmMGY3MS4uMDMyMWE2ZCAx
MDA2NDQKLS0tIGEvTWFrZWZpbGUKKysrIGIvTWFrZWZpbGUKQEAgLTIxMyw3ICsyMTMsNyBAQCBG
SU8tVkVSU0lPTi1GSUxFOiBGT1JDRQogCiBvdmVycmlkZSBDRkxBR1MgKz0gLURGSU9fVkVSU0lP
Tj0nIiQoRklPX1ZFUlNJT04pIicKIAotLmMubzogRk9SQ0UgRklPLVZFUlNJT04tRklMRQorJS5v
IDogJS5jCiAJJChRVUlFVF9DQykkKENDKSAtbyAkQCAkKENGTEFHUykgJChDUFBGTEFHUykgLWMg
JDwKIAlAJChDQykgLU1NICQoQ0ZMQUdTKSAkKENQUEZMQUdTKSAkKi5jID4gJCouZAogCUBtdiAt
ZiAkKi5kICQqLmQudG1wCg==
--047d7b33da60f1fb9904fb6d5e60--
