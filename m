Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 242FC355051
	for <fio@vger.kernel.org>; Wed, 19 Nov 2025 13:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763557221; cv=none; b=LV1R4wX69fbOKLReyYYB+YsVGWSQWgWzOrzM2JsaF6Ps5p/yrtKJAq06PqFB2XfDA+f/0JL8OcJSrtR/cjUfI7MvxWaQc440ILER1bgPHcorkVk5oxXjN08XJCy7of8kH3PiLRG2o4IX/SGNtVuMkd5nep62V01+aCRMDTpAzWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763557221; c=relaxed/simple;
	bh=0kRo0ep1qZlOFcNUuQH6VafyMJBJyOg3s1DQASOnctc=;
	h=Subject:From:To:Date:Message-Id; b=QELbyEVmxCg5avOw2MA464UOH0I1Rnz4tLeHY/jo11QTkhPT/ck7Cm6k9pYAec4bh7Lytn+KOVfXTU+awwRyVXRELPqthXfKHCMg9BqXmpv3GTy3zWkFcRFvAR7N4s1oxLso4+AqeJNrdW9I9+KGjFRV8o9kklhcZ/qhlefW/G0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=mjmtgGig; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mjmtgGig"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Message-Id:Date:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=pH6+pj1LXC9tM6wOve/NgsrVBRjxGoqvTqSzipmm0Nc=; b=mjmtgGig1ADO6L525Z9XJqanqw
	66Zqy2w6QVFLSsIN2JIFFVO3FliQb7cQQchQ/OLBFWFyQdgCHSfy0c6wJ6BXzmfDqNUBZhwClFpB4
	064YUpoTgLPnIlbNjQ+WCUa0U4v1Jvy8i6uZG1GBV/u66IsuHLnVbqWG5Tn63RQtznMuQ40J3C+rJ
	S6x8yiKgBJ86CeMDBuztkNErxC6pEgu6H9j2t9/Qa7jaKlTfvCi0xt+ao+3rVFV1SeM2TzPQrzNrp
	rWFpIQmHloFAxfJ5rX8jo9N2H6+7GlTZ4+iupKGklfmyEw/Q39ugGq9WKFzlkDEF2gKoKY9WPL2/i
	2KWnya7w==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vLhn7-0000000H6Dy-0MSE
	for fio@vger.kernel.org;
	Wed, 19 Nov 2025 13:00:09 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 05AA21BC0192; Wed, 19 Nov 2025 06:00:02 -0700 (MST)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Wed, 19 Nov 2025 06:00:01 -0700
Message-Id: <20251119130002.05AA21BC0192@kernel.dk>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit b2c62314298db2269df5fe9c2454faef677bf464:

  Merge branch 'fix/zero-numberio' of https://github.com/minwooim/fio (2025-11-17 11:41:39 -0500)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 7c8dbca4aa7ff0172d70846e04f8e9909ab81094:

  ci: work around macOS pip restrictions (2025-11-18 20:15:42 -0500)

----------------------------------------------------------------
Vincent Fu (1):
      ci: work around macOS pip restrictions

 ci/actions-install.sh | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/ci/actions-install.sh b/ci/actions-install.sh
index 30b815f3..6940e5b9 100755
--- a/ci/actions-install.sh
+++ b/ci/actions-install.sh
@@ -191,8 +191,8 @@ install_macos() {
     #echo "Updating homebrew..."
     #brew update >/dev/null 2>&1
     echo "Installing packages..."
-    HOMEBREW_NO_AUTO_UPDATE=1 brew install cunit libnfs
-    pip3 install scipy six statsmodels sphinx
+    HOMEBREW_NO_AUTO_UPDATE=1 brew install cunit libnfs sphinx-doc
+    pip3 install scipy six statsmodels --user --break-system-packages
 }
 
 install_windows() {
