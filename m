Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-pb0-f68.google.com ([209.85.160.68]:33230 "EHLO
	mail-pb0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933251AbaCTSAh (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 20 Mar 2014 14:00:37 -0400
Received: by mail-pb0-f68.google.com with SMTP id jt11so510194pbb.7
        for <fio@vger.kernel.org>; Thu, 20 Mar 2014 11:00:37 -0700 (PDT)
From: castor.fu@egocast.org
Subject: [PATCH 1/2] Pass -Wstrict-prototypes -Wold-style-definition, whitespace
Date: Thu, 20 Mar 2014 10:59:29 -0700
Message-Id: <1395338370-89038-2-git-send-email-castor.fu@egocast.org>
In-Reply-To: <1395338370-89038-1-git-send-email-castor.fu@egocast.org>
References: <c1160a632c8b42e28487bf5902346d7e@DB4PR03MB572.eurprd03.prod.outlook.com>
 <1395338370-89038-1-git-send-email-castor.fu@egocast.org>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Castor Fu <castor@alumni.caltech.edu>

From: Castor Fu <castor@alumni.caltech.edu>

---
 crc/xxhash.c | 14 +++++++-------
 crc/xxhash.h |  2 +-
 filesetup.c  |  9 ++++++---
 3 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/crc/xxhash.c b/crc/xxhash.c
index 5190330..db7890b 100644
--- a/crc/xxhash.c
+++ b/crc/xxhash.c
@@ -149,11 +149,11 @@ typedef enum { XXH_bigEndian=0, XXH_littleEndian=1 } XXH_endianess;
 typedef enum { XXH_aligned, XXH_unaligned } XXH_alignment;
 
 uint32_t XXH_readLE32_align(const uint32_t* ptr, XXH_endianess endian, XXH_alignment align)
-{ 
+{
     if (align==XXH_unaligned)
-        return endian==XXH_littleEndian ? A32(ptr) : XXH_swap32(A32(ptr)); 
+        return endian==XXH_littleEndian ? A32(ptr) : XXH_swap32(A32(ptr));
     else
-        return endian==XXH_littleEndian ? *ptr : XXH_swap32(*ptr); 
+        return endian==XXH_littleEndian ? *ptr : XXH_swap32(*ptr);
 }
 
 uint32_t XXH_readLE32(const uint32_t* ptr, XXH_endianess endian) { return XXH_readLE32_align(ptr, endian, XXH_unaligned); }
@@ -253,15 +253,15 @@ uint32_t XXH32(const void* input, int len, uint32_t seed)
 // Advanced Hash Functions
 //****************************
 
-int XXH32_sizeofState() 
+int XXH32_sizeofState(void)
 {
     XXH_STATIC_ASSERT(XXH32_SIZEOFSTATE >= sizeof(struct XXH_state32_t));   // A compilation error here means XXH32_SIZEOFSTATE is not large enough
-    return sizeof(struct XXH_state32_t); 
+    return sizeof(struct XXH_state32_t);
 }
 
 
 XXH_errorcode XXH32_resetState(void* state_in, uint32_t seed)
-{ 
+{
     struct XXH_state32_t * state = (struct XXH_state32_t *) state_in;
     state->seed = seed;
     state->v1 = seed + PRIME32_1 + PRIME32_2;
@@ -307,7 +307,7 @@ XXH_errorcode XXH32_update_endian (void* state_in, const void* input, int len, X
         {
             const uint32_t* p32 = (const uint32_t*)state->memory;
             state->v1 += XXH_readLE32(p32, endian) * PRIME32_2; state->v1 = XXH_rotl32(state->v1, 13); state->v1 *= PRIME32_1; p32++;
-            state->v2 += XXH_readLE32(p32, endian) * PRIME32_2; state->v2 = XXH_rotl32(state->v2, 13); state->v2 *= PRIME32_1; p32++; 
+            state->v2 += XXH_readLE32(p32, endian) * PRIME32_2; state->v2 = XXH_rotl32(state->v2, 13); state->v2 *= PRIME32_1; p32++;
             state->v3 += XXH_readLE32(p32, endian) * PRIME32_2; state->v3 = XXH_rotl32(state->v3, 13); state->v3 *= PRIME32_1; p32++;
             state->v4 += XXH_readLE32(p32, endian) * PRIME32_2; state->v4 = XXH_rotl32(state->v4, 13); state->v4 *= PRIME32_1; p32++;
         }
diff --git a/crc/xxhash.h b/crc/xxhash.h
index bcd060e..e80a91d 100644
--- a/crc/xxhash.h
+++ b/crc/xxhash.h
@@ -134,7 +134,7 @@ Memory will be freed by XXH32_digest().
 */
 
 
-int           XXH32_sizeofState();
+int           XXH32_sizeofState(void);
 XXH_errorcode XXH32_resetState(void* state, unsigned int seed);
 
 #define       XXH32_SIZEOFSTATE 48
diff --git a/filesetup.c b/filesetup.c
index 4bfa470..033b119 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -1103,7 +1103,8 @@ static void get_file_type(struct fio_file *f)
 	}
 }
 
-static void set_already_allocated(const char *fname) {
+static void set_already_allocated(const char *fname)
+{
 	struct file_name *fn;
 
 	fn = malloc(sizeof(struct file_name));
@@ -1129,7 +1130,8 @@ static int is_already_allocated(const char *fname)
 	return 0;
 }
 
-static void free_already_allocated() {
+static void free_already_allocated(void)
+{
 	struct flist_head *entry, *tmp;
 	struct file_name *fn;
 
@@ -1482,6 +1484,7 @@ int fio_files_done(struct thread_data *td)
 }
 
 /* free memory used in initialization phase only */
-void filesetup_mem_free() {
+void filesetup_mem_free(void)
+{
 	free_already_allocated();
 }
-- 
1.7.11.5

