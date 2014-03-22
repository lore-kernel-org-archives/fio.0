Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:58485 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbaCVMAF (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 22 Mar 2014 08:00:05 -0400
Received: from kernel.dk ([54.225.238.116] helo=strynoevaenget.dk)
	by merlin.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1WRKaq-0007lY-BO
	for fio@vger.kernel.org; Sat, 22 Mar 2014 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20140322120003.70AB9400B4@strynoevaenget.dk>
Date: Sat, 22 Mar 2014 06:00:03 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 1417daeb92c44632f2e1e376d736a0f198d7af8d:

  Don't re-create/unlink write file for append workload (2014-03-20 09:33:13 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 190b8f0c9c1c1a99ed26fd953f7af9023f9533ee:

  Pass -Wstrict-prototypes -Wold-style-definition, whitespace (2014-03-21 09:28:08 -0600)

----------------------------------------------------------------
Castor Fu (1):
      Pass -Wstrict-prototypes -Wold-style-definition, whitespace

 crc/xxhash.c |   14 +++++++-------
 crc/xxhash.h |    2 +-
 filesetup.c  |    9 ++++++---
 3 files changed, 14 insertions(+), 11 deletions(-)

---

Diff of recent changes:

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
index 5ce0f68..db80a8b 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -1109,7 +1109,8 @@ static void get_file_type(struct fio_file *f)
 	}
 }
 
-static void set_already_allocated(const char *fname) {
+static void set_already_allocated(const char *fname)
+{
 	struct file_name *fn;
 
 	fn = malloc(sizeof(struct file_name));
@@ -1135,7 +1136,8 @@ static int is_already_allocated(const char *fname)
 	return 0;
 }
 
-static void free_already_allocated() {
+static void free_already_allocated(void)
+{
 	struct flist_head *entry, *tmp;
 	struct file_name *fn;
 
@@ -1488,6 +1490,7 @@ int fio_files_done(struct thread_data *td)
 }
 
 /* free memory used in initialization phase only */
-void filesetup_mem_free() {
+void filesetup_mem_free(void)
+{
 	free_already_allocated();
 }
