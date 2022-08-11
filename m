Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B05A3C19F2A
	for <fio@archiver.kernel.org>; Thu, 11 Aug 2022 12:00:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234651AbiHKMAI (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 11 Aug 2022 08:00:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234521AbiHKMAI (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 11 Aug 2022 08:00:08 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8569296770
        for <fio@vger.kernel.org>; Thu, 11 Aug 2022 05:00:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=shxz3UgvuaidcYOR802WeXzWixTwMocTpMhgqMRW24o=; b=JRIa3br+yaeqYAtVo+eTcP+R/c
        VIkZUvcx1ClxTGdYJs9OdrpUYQF23Rs0+odEqQ9v/ffnr5UFbQ3PqFwXlWVUGuVfYxqmiVc5Q7Ohp
        +i6L5Acqni8yzRFgAKAWl3khyxKiurcH25aQZzNoOeBcbhG8WW7tC1iy+Wf1Ixa/1775LprMcZuAG
        902Wy+BVo8VGD5iB3XeWoCiQDLhQ7bnOR1NxEviC82o9K+rVdkpwmg7gdDN4ycxI8XhJp6+O3ThGJ
        XfUKOIV2rtJuwHrZ9qc/iezfKZzZFQVJ1VCSPD41l9ub3gimjsgrkPTzoK2V3vgm/6YKjjpxSassy
        CTxLu1xw==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oM6r6-000dN0-Nf
        for fio@vger.kernel.org; Thu, 11 Aug 2022 12:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id B445A1BC016E; Thu, 11 Aug 2022 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20220811120001.B445A1BC016E@kernel.dk>
Date:   Thu, 11 Aug 2022 06:00:01 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 6cafe8445fd1e04e5f7d67bbc73029a538d1b253:

  Fio 3.31 (2022-08-09 14:41:25 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 9dc528b1638b625b5e167983a74de4e85c5859ea:

  lib/rand: get rid of unused MAX_SEED_BUCKETS (2022-08-10 09:51:49 -0600)

----------------------------------------------------------------
Jens Axboe (2):
      Merge branch 'multi_seed_refill' of https://github.com/sungup/fio
      lib/rand: get rid of unused MAX_SEED_BUCKETS

Sungup Moon (1):
      lib/rand: Enhance __fill_random_buf using the multi random seed

 configure  | 17 +++++++++++++++++
 lib/rand.c | 33 ++++++++++++++++++++++++++++++++-
 2 files changed, 49 insertions(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/configure b/configure
index 36450df8..a2b9bd4c 100755
--- a/configure
+++ b/configure
@@ -116,6 +116,10 @@ has() {
   type "$1" >/dev/null 2>&1
 }
 
+num() {
+  echo "$1" | grep -P -q "^[0-9]+$"
+}
+
 check_define() {
   cat > $TMPC <<EOF
 #if !defined($1)
@@ -174,6 +178,7 @@ libnfs=""
 xnvme=""
 libzbc=""
 dfs=""
+seed_buckets=""
 dynamic_engines="no"
 prefix=/usr/local
 
@@ -255,6 +260,8 @@ for opt do
   ;;
   --enable-asan) asan="yes"
   ;;
+  --seed-buckets=*) seed_buckets="$optarg"
+  ;;
   --help)
     show_help="yes"
     ;;
@@ -302,6 +309,7 @@ if test "$show_help" = "yes" ; then
   echo "--dynamic-libengines    Lib-based ioengines as dynamic libraries"
   echo "--disable-dfs           Disable DAOS File System support even if found"
   echo "--enable-asan           Enable address sanitizer"
+  echo "--seed-buckets=         Number of seed buckets for the refill-buffer"
   exit $exit_val
 fi
 
@@ -3273,6 +3281,15 @@ if test "$disable_tcmalloc" != "yes"; then
   fi
 fi
 print_config "TCMalloc support" "$tcmalloc"
+if ! num "$seed_buckets"; then
+  seed_buckets=4
+elif test "$seed_buckets" -lt 2; then
+  seed_buckets=2
+elif test "$seed_buckets" -gt 16; then
+  seed_buckets=16
+fi
+echo "#define CONFIG_SEED_BUCKETS $seed_buckets" >> $config_host_h
+print_config "seed_buckets" "$seed_buckets"
 
 echo "LIBS+=$LIBS" >> $config_host_mak
 echo "GFIO_LIBS+=$GFIO_LIBS" >> $config_host_mak
diff --git a/lib/rand.c b/lib/rand.c
index 1e669116..0e787a62 100644
--- a/lib/rand.c
+++ b/lib/rand.c
@@ -95,7 +95,7 @@ void init_rand_seed(struct frand_state *state, uint64_t seed, bool use64)
 		__init_rand64(&state->state64, seed);
 }
 
-void __fill_random_buf(void *buf, unsigned int len, uint64_t seed)
+void __fill_random_buf_small(void *buf, unsigned int len, uint64_t seed)
 {
 	uint64_t *b = buf;
 	uint64_t *e = b  + len / sizeof(*b);
@@ -110,6 +110,37 @@ void __fill_random_buf(void *buf, unsigned int len, uint64_t seed)
 		__builtin_memcpy(e, &seed, rest);
 }
 
+void __fill_random_buf(void *buf, unsigned int len, uint64_t seed)
+{
+	static uint64_t prime[] = {1, 2, 3, 5, 7, 11, 13, 17,
+				   19, 23, 29, 31, 37, 41, 43, 47};
+	uint64_t *b, *e, s[CONFIG_SEED_BUCKETS];
+	unsigned int rest;
+	int p;
+
+	/*
+	 * Calculate the max index which is multiples of the seed buckets.
+	 */
+	rest = (len / sizeof(*b) / CONFIG_SEED_BUCKETS) * CONFIG_SEED_BUCKETS;
+
+	b = buf;
+	e = b + rest;
+
+	rest = len - (rest * sizeof(*b));
+
+	for (p = 0; p < CONFIG_SEED_BUCKETS; p++)
+		s[p] = seed * prime[p];
+
+	for (; b != e; b += CONFIG_SEED_BUCKETS) {
+		for (p = 0; p < CONFIG_SEED_BUCKETS; ++p) {
+			b[p] = s[p];
+			s[p] = __hash_u64(s[p]);
+		}
+	}
+
+	__fill_random_buf_small(b, rest, s[0]);
+}
+
 uint64_t fill_random_buf(struct frand_state *fs, void *buf,
 			 unsigned int len)
 {
