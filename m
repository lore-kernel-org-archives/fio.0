Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51D0033B961
	for <fio@vger.kernel.org>; Tue,  3 Feb 2026 13:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770123610; cv=none; b=dU1W3Sn9SqjC3j1PKkWYl4YMqPySwZzExPmqtlm4urA2umor3dsKCjalQ1lsIWEeK6McNukWTnQr9ewQsjoubKhKZkbDY9pdrlYfRziP8m31S3txqFhJxZLZ+yjwAl2dZL3nFcK8Nl485NPIWdBEqvo8ezUjUlBzLmdT456Aok4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770123610; c=relaxed/simple;
	bh=i8d6Rnra+00FAGLe1XTZJiSE3/aI41LptP8hajmbS3k=;
	h=Subject:From:To:Date:Message-Id; b=aXXVy5tW+CLVW7nH7wa8/khbCSnT5tH8ksSnynBKmzEd1DpoTERDJP6Mc2KFx312S+FnfXtulc8xruIBtKf9F7PciaCSRPJGN5EGY4uujVQ1QrFo8UZuN4NRIemcqoaxzpSDWbXms+TFBbD9wvy1kXv9Sa/+qatxCGp5tzlqRvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=OLzfBjA8; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="OLzfBjA8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Message-Id:Date:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=1cgTj+IF2YAV4kYoKtxQHP0oKEnL7OAngbGJmWYztrY=; b=OLzfBjA89FnD4zezGBBURqI+rx
	4X+Z/RTtNKTMLj0BS88ExizI3N6Fxt6i2iC/3WOvTe8feXAZZDqY4VERwSczyfx7SSRiPtLHkNVlM
	RDyB6mwj9g3yYk0/AQIPYX1VRbwwV6Wz7IueBRoHDfdlPAwhr+TE7Fto8ciKRI0tuhb93YyURc7j/
	1zYaeSe4cw2JFYqwyfjhLkQG5T6egqOupq5NNdal8Idxmn6sB2bKS1RRAppKmmsjUVkAS0wdevj/y
	zWp0H6mywG8Qr4k+7HUXlIM7VGM3XG96FvSlZn/J/0tPdHm1kMyvuDLSYz5dZh48m71QNESZnKnnb
	7YHqEvbg==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vnG0i-00000000Vfp-3e3A
	for fio@vger.kernel.org;
	Tue, 03 Feb 2026 13:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id D08031BC0170; Tue,  3 Feb 2026 06:00:01 -0700 (MST)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Tue,  3 Feb 2026 06:00:01 -0700
Message-Id: <20260203130001.D08031BC0170@kernel.dk>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit a50d7ce532510ab467d307c1ee010386e20ee652:

  Merge branch 'fix-fork-memleak' of https://github.com/malikoyv/fio (2026-01-30 08:03:56 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 5e5975a411cfd2af04c49f8d822e8e06a01a3771:

  Merge branch 'sprandom-fix' of https://github.com/tomas-winkler-sndk/fio (2026-02-02 08:05:59 -0500)

----------------------------------------------------------------
Tomas Winkler (1):
      fio: sprandom: append newline to error message

Vincent Fu (1):
      Merge branch 'sprandom-fix' of https://github.com/tomas-winkler-sndk/fio

 init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/init.c b/init.c
index 5a982b53..130158cb 100644
--- a/init.c
+++ b/init.c
@@ -715,7 +715,7 @@ static int fixup_options(struct thread_data *td)
 				o->norandommap = 1;
 			}
 		} else {
-			log_err("fio: sprandom requires random write, random_generator=lfsr, norandommap=1");
+			log_err("fio: sprandom requires random write, random_generator=lfsr, norandommap=1\n");
 			ret |= 1;
 		}
 	}
