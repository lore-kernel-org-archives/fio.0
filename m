Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:57740 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727727AbeIJQxw (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 10 Sep 2018 12:53:52 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1fzKrL-0005VM-7K
        for fio@vger.kernel.org; Mon, 10 Sep 2018 12:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180910120002.000BA2C00A8@kernel.dk>
Date: Mon, 10 Sep 2018 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit fd98fb689d5ad7e9977461e961fff3fdd37f9cb8:

  Kill fusion atomic write engine (2018-09-08 08:09:53 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to ed06328df452330b7210db2558ae125f6e0d8fe2:

  Merge branch 'master' of https://github.com/bvanassche/fio (2018-09-09 17:42:10 -0600)

----------------------------------------------------------------
Bart Van Assche (3):
      iolog: Ensure that sockaddr_un.sun_path is '\0'-terminated
      Micro-optimize num2str()
      num2str(): Avoid an out-of-bounds array access

Jens Axboe (1):
      Merge branch 'master' of https://github.com/bvanassche/fio

 iolog.c       |  5 ++++-
 lib/num2str.c | 16 ++++++++--------
 2 files changed, 12 insertions(+), 9 deletions(-)

---

Diff of recent changes:

diff --git a/iolog.c b/iolog.c
index f3eedb5..26c3458 100644
--- a/iolog.c
+++ b/iolog.c
@@ -580,7 +580,10 @@ static int open_socket(const char *path)
 	if (fd < 0)
 		return fd;
 	addr.sun_family = AF_UNIX;
-	strncpy(addr.sun_path, path, sizeof(addr.sun_path));
+	if (snprintf(addr.sun_path, sizeof(addr.sun_path), "%s", path) >=
+	    sizeof(addr.sun_path))
+		log_err("%s: path name %s is too long for a Unix socket\n",
+			__func__, path);
 	if (connect(fd, (const struct sockaddr *)&addr, strlen(path) + sizeof(addr.sun_family)) == 0)
 		return fd;
 	else
diff --git a/lib/num2str.c b/lib/num2str.c
index 40fb3ae..1abe22f 100644
--- a/lib/num2str.c
+++ b/lib/num2str.c
@@ -30,7 +30,7 @@ char *num2str(uint64_t num, int maxlen, int base, int pow2, enum n2s_unit units)
 		[N2S_BYTEPERSEC]= "B/s",
 		[N2S_BITPERSEC]	= "bit/s"
 	};
-	const unsigned int thousand[] = { 1000, 1024 };
+	const unsigned int thousand = pow2 ? 1024 : 1000;
 	unsigned int modulo;
 	int post_index, carry = 0;
 	char tmp[32], fmt[32];
@@ -49,7 +49,7 @@ char *num2str(uint64_t num, int maxlen, int base, int pow2, enum n2s_unit units)
 		unitprefix = sistr;
 
 	for (post_index = 0; base > 1; post_index++)
-		base /= thousand[!!pow2];
+		base /= thousand;
 
 	switch (units) {
 	case N2S_NONE:
@@ -72,14 +72,14 @@ char *num2str(uint64_t num, int maxlen, int base, int pow2, enum n2s_unit units)
 	 * Divide by K/Ki until string length of num <= maxlen.
 	 */
 	modulo = -1U;
-	while (post_index < sizeof(sistr)) {
+	while (post_index < ARRAY_SIZE(sistr)) {
 		sprintf(tmp, "%llu", (unsigned long long) num);
 		if (strlen(tmp) <= maxlen)
 			break;
 
-		modulo = num % thousand[!!pow2];
-		num /= thousand[!!pow2];
-		carry = modulo >= thousand[!!pow2] / 2;
+		modulo = num % thousand;
+		num /= thousand;
+		carry = modulo >= thousand / 2;
 		post_index++;
 	}
 
@@ -110,9 +110,9 @@ done:
 	 * Fill in everything and return the result.
 	 */
 	assert(maxlen - strlen(tmp) - 1 > 0);
-	assert(modulo < thousand[!!pow2]);
+	assert(modulo < thousand);
 	sprintf(fmt, "%%.%df", (int)(maxlen - strlen(tmp) - 1));
-	sprintf(tmp, fmt, (double)modulo / (double)thousand[!!pow2]);
+	sprintf(tmp, fmt, (double)modulo / (double)thousand);
 
 	sprintf(buf, "%llu.%s%s%s", (unsigned long long) num, &tmp[2],
 			unitprefix[post_index], unitstr[units]);

