Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBC5B1F3D56
	for <fio@vger.kernel.org>; Tue, 17 Dec 2024 13:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734440411; cv=none; b=pmz/tirEEuq0ducJjK/eUcR4suLZnZ0q0EUGfVbGhzXMEbCasJUEy2HtmBaxtgzzFfj8L3/MzXS/AMTt660iMq730dc7z+Da3+e+mTGFx7mZSq1fTslvLH7jJftSDaY9MOw5llvaQLBkLFxX86CT4GifLzEKC8AFTeQuoPQmrt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734440411; c=relaxed/simple;
	bh=nJSBwenJst4c6VJXMuZ6zRJF2du9l1ykeSa3gar33wE=;
	h=Subject:From:To:Message-Id:Date; b=vEfXhqGk8TwP6K4Mm8DACrnu2anV7G6WXIn2lU2ABl+rfl/S2MY8JhMi/xSmkltdI6guxdjiVkWqBNfsP00Ps0NL+XC96T1xYQDJGRBj/bdPREC2C7pbiayaetCBVptpk3s1CURs0HOjDGktnV/RPximuCfdcT5FyUaLhZts9i0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=f9WQyR/Q; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="f9WQyR/Q"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=gbgxQsLlLj8lX9OiXxMcEbTMy3EZA2xlNgGTMQZTC4U=; b=f9WQyR/QMKEiNZFGRnWemxCY2s
	RYdeuuz/sm/we45FCbyVtSBO7m0sjKFhcMKkFaJFhVQqsPyr7c13f7ysSDj59dHyqMQHUr5HiPLr8
	M3zYBdbsPQqcvUBtyRtAKF6cJRdp+D2umELrNwG5AoMzSO0EBY6R+KchN0QxUXv8hrbnn6ogXOlFG
	znR42K11Y4g+d0eDPL90cmeJXp+whVARERkwuU/rvvSu1yHn3eJ+1/1k516jsU8PyDcdHFmxDRgBN
	rPBQAvuu3Ron2v7xqQpUDzN6vHSizYz2T8Lmg3LCJF3kHK+orWgfDpm6ov67e/4biSWhWBA7oEr8/
	J2QwkNWw==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tNXBF-000000054nF-26pV
	for fio@vger.kernel.org;
	Tue, 17 Dec 2024 13:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id BC40A1BC0134; Tue, 17 Dec 2024 06:00:01 -0700 (MST)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20241217130001.BC40A1BC0134@kernel.dk>
Date: Tue, 17 Dec 2024 06:00:01 -0700 (MST)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit f512744be77f2c65e17e3ddde90c2458124ac152:

  nfs: add support for new libnfs API (2024-12-09 10:44:15 -0500)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to d1ebbdd2de8afc6cee885d5a2f04a79e2598217a:

  Merge branch 'master' of https://github.com/termim/fio (2024-12-16 13:23:58 -0500)

----------------------------------------------------------------
Mikhail Terekhov (1):
      Add .readthedocs.yaml file.

Vincent Fu (1):
      Merge branch 'master' of https://github.com/termim/fio

 .readthedocs.yaml | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)
 create mode 100644 .readthedocs.yaml

---

Diff of recent changes:

diff --git a/.readthedocs.yaml b/.readthedocs.yaml
new file mode 100644
index 00000000..e731de6d
--- /dev/null
+++ b/.readthedocs.yaml
@@ -0,0 +1,20 @@
+# .readthedocs.yaml
+# Read the Docs configuration file
+# See https://docs.readthedocs.io/en/stable/config-file/v2.html for details
+
+# Required
+version: 2
+
+build:
+  os: ubuntu-22.04
+  tools:
+    python: "3"
+
+# Build documentation in the docs/ directory with Sphinx
+sphinx:
+   configuration: doc/conf.py
+
+# Optionally build your docs in additional formats such as PDF
+formats:
+   - epub
+   - pdf
