Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19CF62586FE
	for <fio@vger.kernel.org>; Fri,  8 Aug 2025 12:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754654415; cv=none; b=PzQIzSmQjBBcB4G0Qp+N9HEvYM/0KiaKXy8j0/9ZjzRjEBsJZkiOFvYN5QkgMLsIncALYBqItfDzM+TTVnERfR3Chdj6ousi9pl0xFthTGYRqZVrBkyMlHFZ8Ruz3I9wN/iKc0/1vD/1wje2S721i/1Dj9/9/qlz8t3CKNknhXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754654415; c=relaxed/simple;
	bh=FyYjz1sb5UJJgt3mIbd6dPNkrKcYUf8FNXZyze/CzCk=;
	h=Subject:From:To:Message-Id:Date; b=eM8mPIUcU+GbKM2Xc2a5cfnvhgjZvo5olkVwuLD0ANPMVtz4liLyy9q18jqSgSgbT0YtnqrP/xkKTagB5ANb1byOq0A+wArOjDQSgK6h196rYTkL2cD6QNRaPFrRaTCwa/gdxjKL5TxqXLOwYpzrPXsMrDdN4d8IYONYsXWmVX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=dHcWTChN; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dHcWTChN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=+FY5cSSYb6VAf+8ZhKqnBp24Kwh9O+YBsLexNj8o0wY=; b=dHcWTChNMfbs7jS7/AqhJo9ceU
	+dI0L5LM6YlqCnVRfyrpylVLA4z+Iw+gRaFkA+2GkE2PbNHktkHbrk9J3BFbklbLTR6BSrVCfJzKB
	iQCcm8fIj48ETwD75lkt0V6cA7smftjF2NIutxagNNVu2PX+h3kA9ZVCjBuYxvPK+nrPgRm5SFrC+
	IfMWxyBxK1olyyPCVQA2u6YscaBneTAIPTJHZZgi3v3Ti3BbCIHab31EgnWXmtTdb30jReOmemEJl
	gKTJET7QixPl5mmPj8vcSh95Wb5jeHjnMfgtV1an8cB8mfW6bCQ5M2/WauGIx9eZovM7FTNfx13qa
	39/4zOYQ==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ukLlX-0000000EpAP-407E
	for fio@vger.kernel.org;
	Fri, 08 Aug 2025 12:00:08 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id EBD171BC016D; Fri,  8 Aug 2025 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20250808120001.EBD171BC016D@kernel.dk>
Date: Fri,  8 Aug 2025 06:00:01 -0600 (MDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit b1b07c8dfbb562a949afd127d693e9c0cb009827:

  ioengines: bump version number (2025-08-05 15:56:45 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to f95cf49e1d2a8d2babb8aa385fb902d927533644:

  crc: use ISA-L for crc64 NVMe if available (2025-08-07 10:54:04 -0400)

----------------------------------------------------------------
Vincent Fu (1):
      crc: use ISA-L for crc64 NVMe if available

 configure   | 27 +++++++++++++++++++++++++++
 crc/crc64.c | 13 +++++++++++++
 2 files changed, 40 insertions(+)

---

Diff of recent changes:

diff --git a/configure b/configure
index 9e69dc4b..7a295eab 100755
--- a/configure
+++ b/configure
@@ -190,6 +190,7 @@ libnbd="no"
 libnfs=""
 xnvme=""
 isal=""
+isal64=""
 libblkio=""
 libzbc=""
 dfs=""
@@ -265,6 +266,8 @@ for opt do
   ;;
   --disable-isal) isal="no"
   ;;
+  --disable-isal64) isal64="no"
+  ;;
   --disable-libblkio) libblkio="no"
   ;;
   --disable-tcmalloc) disable_tcmalloc="yes"
@@ -326,6 +329,7 @@ if test "$show_help" = "yes" ; then
   echo "--enable-libnbd         Enable libnbd (NBD engine) support"
   echo "--disable-xnvme         Disable xnvme support even if found"
   echo "--disable-isal          Disable isal support even if found"
+  echo "--disable-isal64        Disable isal CRC64 support even if found"
   echo "--disable-libblkio      Disable libblkio support even if found"
   echo "--disable-libzbc        Disable libzbc even if found"
   echo "--disable-tcmalloc      Disable tcmalloc support"
@@ -2693,6 +2697,26 @@ fi
 print_config "isal" "$isal"
 fi
 
+##########################################
+# Check ISA-L CRC64 Rocksoft support
+cat > $TMPC << EOF
+#include <isa-l/crc64.h>
+#include <stddef.h>
+int main(void)
+{
+  return crc64_rocksoft_refl(0, NULL, 4096);
+}
+EOF
+if test "$isal64" != "no" ; then
+  if compile_prog "" "-lisal" "ISAL"; then
+    isal64="yes"
+    LIBS="-lisal $LIBS"
+  else
+    isal64="no"
+  fi
+fi
+print_config "isal CRC64" "$isal64"
+
 ##########################################
 # Check if we have libblkio
 if test "$libblkio" != "no" ; then
@@ -3338,6 +3362,9 @@ fi
 if test "$isal" = "yes" ; then
   output_sym "CONFIG_LIBISAL"
 fi
+if test "$isal64" = "yes" ; then
+  output_sym "CONFIG_LIBISAL64"
+fi
 if test "$libblkio" = "yes" ; then
   output_sym "CONFIG_LIBBLKIO"
   echo "LIBBLKIO_CFLAGS=$libblkio_cflags" >> $config_host_mak
diff --git a/crc/crc64.c b/crc/crc64.c
index c910e5b8..aae54f40 100644
--- a/crc/crc64.c
+++ b/crc/crc64.c
@@ -114,6 +114,17 @@ unsigned long long fio_crc64(const unsigned char *buffer, unsigned long length)
 	return crc;
 }
 
+#ifdef CONFIG_LIBISAL64
+#include <isa-l/crc64.h>
+
+unsigned long long fio_crc64_nvme(unsigned long long crc, const void *p,
+				  unsigned int len)
+{
+	return crc64_rocksoft_refl(crc, p, len);
+}
+
+#else
+
 /**
  * fio_crc64_nvme - Calculate bitwise NVMe CRC64
  * @crc: seed value for computation. 0 for a new CRC calculation, or the
@@ -134,3 +145,5 @@ unsigned long long fio_crc64_nvme(unsigned long long crc, const void *p,
 
 	return ~crc;
 }
+
+#endif
