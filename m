Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-pg1-f196.google.com ([209.85.215.196]:47007 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729769AbeHAISp (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 1 Aug 2018 04:18:45 -0400
Received: by mail-pg1-f196.google.com with SMTP id p23-v6so10293211pgv.13
        for <fio@vger.kernel.org>; Tue, 31 Jul 2018 23:34:39 -0700 (PDT)
From: dev.madaari@gmail.com
Subject: [PATCH] Fix function definition and declaration mismatch
Date: Wed,  1 Aug 2018 12:04:06 +0530
Message-Id: <1533105246-15148-1-git-send-email-dev.madaari@gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Udit kumar agarwal <dev.madaari@gmail.com>

From: Udit kumar agarwal <dev.madaari@gmail.com>

during the declaration of, let's say XXH32_init parameter type is
'unsigned int' while during the definition it is 'uint32_t'. Now, on
most desktop os, they are are usually same, however on some embedded
platforms, for example RTEMS which uses newlib as it's standard c library,
they both are different.
---
 crc/xxhash.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/crc/xxhash.h b/crc/xxhash.h
index 8850d20..9019089 100644
--- a/crc/xxhash.h
+++ b/crc/xxhash.h
@@ -107,9 +107,9 @@ XXH32() :
 // Advanced Hash Functions
 //****************************
 
-void*         XXH32_init   (unsigned int seed);
+void*         XXH32_init   (uint32_t seed);
 XXH_errorcode XXH32_update (void* state, const void* input, int len);
-unsigned int  XXH32_digest (void* state);
+uint32_t  XXH32_digest (void* state);
 
 /*
 These functions calculate the xxhash of an input provided in several small packets,
@@ -135,7 +135,7 @@ Memory will be freed by XXH32_digest().
 
 
 int           XXH32_sizeofState(void);
-XXH_errorcode XXH32_resetState(void* state, unsigned int seed);
+XXH_errorcode XXH32_resetState(void* state, uint32_t seed);
 
 #define       XXH32_SIZEOFSTATE 48
 typedef struct { long long ll[(XXH32_SIZEOFSTATE+(sizeof(long long)-1))/sizeof(long long)]; } XXH32_stateSpace_t;
@@ -151,7 +151,7 @@ use the structure XXH32_stateSpace_t, which will ensure that memory space is lar
 */
 
 
-unsigned int XXH32_intermediateDigest (void* state);
+uint32_t XXH32_intermediateDigest (void* state);
 /*
 This function does the same as XXH32_digest(), generating a 32-bit hash,
 but preserve memory context.
-- 
1.9.1

