Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62B832C6BA
	for <fio@vger.kernel.org>; Fri, 15 Dec 2023 13:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="T7dSoLXI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=26r1dRkOm/9liFReFhyOIhXhy1zIMMXd8TvsqJ58d8g=; b=T7dSoLXIVvdnYtb9y9QNV+uWeS
	gf5ZHRdOYSSdV46gyXfOmOIe7BjmVAJZeUjNva8g72g8S19lH7vtLbU0/dJo2OnWq3Zd4Qxf9purB
	5eXToo4b27lWNLl3K5HqKNMt4bg9fX+mPNY/jdLo1bVIFT3Xx6ws7Cl3KibLdLacj3j2I3pXaSGfj
	7eciCCR14iayFytZwUvDZPO20oY07i6CGGuKkyRc4/FOASjPaj7NImthJfrsmWSqlYmUDdkBgQDI2
	G4aNBGk0DAZzq9E7ILX60MHMDdD3KhQHYUM2l591ZkDVcP1WpOXVQ1qY6b1DwfNml2bhKYNyHCV5S
	gafcyevw==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1rE7nU-00H4sL-Ak
	for fio@vger.kernel.org; Fri, 15 Dec 2023 13:00:09 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 462CA1BC0176; Fri, 15 Dec 2023 06:00:01 -0700 (MST)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20231215130001.462CA1BC0176@kernel.dk>
Date: Fri, 15 Dec 2023 06:00:01 -0700 (MST)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit f53eaac02ec46bdf7f87058f30667be80975caf6:

  engines/io_uring_cmd: skip pi verify checks for error cases (2023-12-12 09:39:06 -0500)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 4e472f8806571ea5799bc898e44609697ba0e140:

  Merge branch 'master' of https://github.com/preichl/fio (2023-12-14 14:15:34 -0700)

----------------------------------------------------------------
Jens Axboe (2):
      Merge branch 'patch-3' of https://github.com/0mp/fio
      Merge branch 'master' of https://github.com/preichl/fio

Mateusz Piotrowski (1):
      doc: Reference geom(4) for FreeBSD users

Pavel Reichl (1):
      engines/http: Fix memory leak

 HOWTO.rst      | 2 +-
 engines/http.c | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/HOWTO.rst b/HOWTO.rst
index d173702b..847c0356 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -801,7 +801,7 @@ Target file/device
 
 	On Windows, disk devices are accessed as :file:`\\\\.\\PhysicalDrive0` for
 	the first device, :file:`\\\\.\\PhysicalDrive1` for the second etc.
-	Note: Windows and FreeBSD prevent write access to areas
+	Note: Windows and FreeBSD (refer to geom(4)) prevent write access to areas
 	of the disk containing in-use data (e.g. filesystems).
 
 	The filename "`-`" is a reserved name, meaning *stdin* or *stdout*.  Which
diff --git a/engines/http.c b/engines/http.c
index 56dc7d1b..83cfe8bb 100644
--- a/engines/http.c
+++ b/engines/http.c
@@ -250,6 +250,7 @@ static char *_aws_uriencode(const char *uri)
 	for (i = 0; (c = uri[i]); i++) {
 		if (n > bufsize-5) {
 			log_err("encoding the URL failed\n");
+			free(r);
 			return NULL;
 		}
 
