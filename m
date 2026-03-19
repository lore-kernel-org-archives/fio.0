Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D16B43CFF66
	for <fio@vger.kernel.org>; Thu, 19 Mar 2026 12:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773921609; cv=none; b=kzrgptvpxXDVpE6tbuNWKW1XF3rtgjQVDp/koXMUg2mZ4FkIx1imST32MJpA0xk7uLlDFFubb3PXxfj+bCL6qL4PmAM9tG+akzuPqAD0TnXtLtUfP09g5hIHHNqs4lLN+nph/Ao8BgQbreIt787INzX7bh+nZJLGFBXbjb9qy24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773921609; c=relaxed/simple;
	bh=tgm58JJDV4renFhp5VQrPGQgxqGTmllr/ySbrcdr+QA=;
	h=Subject:From:To:Date:Message-Id; b=JcQVYxlq3WiNKrWlour3uN2Y1pauNIiYpoAVA4Bg8fdxQdbOkXTQPVCOqHevEnHScqkBNV7pkYDQNbsQexeOUs8Etj/lro1meWsimJx42gA8ISzJK9lfaW+PEU67yiKQJZMd8XtgGROFMbyJ6krVu4V3RkmlFcKYlbx7maFi06I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=TWlH5VKT; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="TWlH5VKT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Message-Id:Date:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=QX5WCSeI+EqfjLuaclIY7j4cC42HP0M7v48but/geSc=; b=TWlH5VKTNEI0SCbhAxLVSnyZ/F
	H33pZwTnpp5LawMfrDfRDnjN7mZY8AUeIFwEuZtjpcar9u1HHwPREqyPKzrd7iB+oKpkiJtTXO7i7
	pVimslEL1kksAzJf6ohyv+3Kd9WrfbB+jZHOEP+UcYhUDNZIqRwFqokPdDjOv8dbQVDBLhVbFoa4W
	jQjmGNpQ3MC0mkfIIzy41U11tI+P6g9turWXRZ+uJ90mjwtTZalp6UHkHWH97zSUoqYDVaEx1WN7m
	TwfNSZRqSrtDzR3GzZ8GUEfOlYyep/uCd/zWw1o+S+rcfSgJrtqQ8r/6ziQFtIFppEdUSKoasNmp9
	Ba6I2ThA==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w3C2m-0000000DQPN-2Itg
	for fio@vger.kernel.org;
	Thu, 19 Mar 2026 12:00:04 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 3BC571BC012A; Thu, 19 Mar 2026 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Thu, 19 Mar 2026 06:00:01 -0600
Message-Id: <20260319120001.3BC571BC012A@kernel.dk>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 4db5740d27942e5a36b091ace763b188888b6f9e:

  stat: improve latency target reporting (2026-03-16 11:13:04 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 698fa8f0682b809b3f85f50c593067e90108f92e:

  Merge branch 'fix-null-comm-prctl' of https://github.com/Criticayon/fio (2026-03-18 19:31:08 -0600)

----------------------------------------------------------------
Criticayon Black (1):
      backend: guard prctl(PR_SET_NAME) against NULL thread name

Jens Axboe (1):
      Merge branch 'fix-null-comm-prctl' of https://github.com/Criticayon/fio

Minwoo Im (1):
      options: add support more POSIX errnos

Vincent Fu (1):
      Merge branch 'posix-errnos' of https://github.com/minwooim/fio

 backend.c |  3 ++-
 options.c | 34 +++++++++++++++++++++++++++++++---
 2 files changed, 33 insertions(+), 4 deletions(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index 8ce85818..c63bbd07 100644
--- a/backend.c
+++ b/backend.c
@@ -1823,7 +1823,8 @@ static void *thread_main(void *data)
 	fio_local_clock_init();
 
 #ifdef CONFIG_LINUX
-	prctl(PR_SET_NAME, o->comm);
+	if (o->comm)
+		prctl(PR_SET_NAME, o->comm);
 #endif
 
 	dprint(FD_PROCESS, "jobs pid=%d started\n", (int) td->pid);
diff --git a/options.c b/options.c
index a4cd1a77..f418179b 100644
--- a/options.c
+++ b/options.c
@@ -525,12 +525,40 @@ static int str2error(char *str)
 			    "EXDEV", "ENODEV", "ENOTDIR", "EISDIR",
 			    "EINVAL", "ENFILE", "EMFILE", "ENOTTY",
 			    "ETXTBSY","EFBIG", "ENOSPC", "ESPIPE",
-			    "EROFS","EMLINK", "EPIPE", "EDOM", "ERANGE" };
+			    "EROFS","EMLINK", "EPIPE", "EDOM", "ERANGE",
+			    "EDEADLK", "ENAMETOOLONG", "ENOLCK", "ENOSYS", "ENOTEMPTY",
+			    "ELOOP", "EWOULDBLOCK", "ENOMSG", "EIDRM", "ECHRNG",
+			    "EL2NSYNC", "EL3HLT", "EL3RST", "ELNRNG", "EUNATCH",
+			    "ENOCSI", "EL2HLT", "EBADE", "EBADR", "EXFULL",
+			    "ENOANO", "EBADRQC", "EBADSLT", "EDEADLOCK", "EBFONT",
+			    "ENOSTR", "ENODATA", "ETIME", "ENOSR", "ENONET",
+			    "ENOPKG", "EREMOTE", "ENOLINK", "EADV", "ESRMNT",
+			    "ECOMM", "EPROTO", "EMULTIHOP", "EDOTDOT", "EBADMSG",
+			    "EOVERFLOW", "ENOTUNIQ", "EBADFD", "EREMCHG", "ELIBACC",
+			    "ELIBBAD", "ELIBSCN", "ELIBMAX", "ELIBEXEC", "EILSEQ",
+			    "ERESTART", "ESTRPIPE", "EUSERS", "ENOTSOCK", "EDESTADDRREQ",
+			    "EMSGSIZE", "EPROTOTYPE", "ENOPROTOOPT", "EPROTONOSUPPORT", "ESOCKTNOSUPPORT",
+			    "EOPNOTSUPP", "EPFNOSUPPORT", "EAFNOSUPPORT", "EADDRINUSE", "EADDRNOTAVAIL",
+			    "ENETDOWN", "ENETUNREACH", "ENETRESET", "ECONNABORTED", "ECONNRESET",
+			    "ENOBUFS", "EISCONN", "ENOTCONN", "ESHUTDOWN", "ETOOMANYREFS",
+			    "ETIMEDOUT", "ECONNREFUSED", "EHOSTDOWN", "EHOSTUNREACH", "EALREADY",
+			    "EINPROGRESS", "ESTALE", "EUCLEAN", "ENOTNAM", "ENAVAIL",
+			    "EISNAM", "EREMOTEIO", "EDQUOT", "ENOMEDIUM", "EMEDIUMTYPE",
+			    "ECANCELED", "ENOKEY", "EKEYEXPIRED", "EKEYREVOKED", "EKEYREJECTED",
+			    "EOWNERDEAD", "ENOTRECOVERABLE", "ERFKILL", "EHWPOISON" };
 	int i = 0, num = sizeof(err) / sizeof(char *);
+	int retval;
 
 	while (i < num) {
-		if (!strcmp(err[i], str))
-			return i + 1;
+		if (!strcmp(err[i], str)) {
+			retval = i + 1;
+			/* Handle errno aliases that should map to actual errno values */
+			if (!strcmp(str, "EWOULDBLOCK"))
+				retval = EAGAIN;
+			else if (!strcmp(str, "EDEADLOCK"))
+				retval = EDEADLK;
+			return retval;
+		}
 		i++;
 	}
 	return 0;
