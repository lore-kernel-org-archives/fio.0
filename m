Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DD63211A2B
	for <fio@vger.kernel.org>; Wed, 22 Jan 2025 13:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737550813; cv=none; b=QSWd3jSIgw3hgHYUuV1OQCSfpj+OPkrDLF/pLkYWlJhh1qLKyj+xvMfCPVzqaS74cc1a8aFZ9Os2rDGb7dHUgkWhf0cqUr8BCoqFzqyjbQ1SRza/wGdvnDTGY9SfUolF0BqTEVcTSvVuPMPxm9lbKl0BkEJxVH+GGUGjNJ1ZHY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737550813; c=relaxed/simple;
	bh=PiygbTST5UZv0zJ6Jkw6FzS+EWH52eQcNmI2IpE4kwE=;
	h=Subject:From:To:Message-Id:Date; b=Ago16Wt/qwxmkqqrxvAEDI0N67FIB/cFt4gp7AbTK63ZPQw1gQNSuH8qTyXqoIsKK6X0bMut+APRJ7YxpU6OS9U375c1q/GMXpWlGGP6krIv+S8XgjjuH9fBGNX2Bxo8zAXqc9v+1RRM/v06AIHWPpQhOwSpqw1JApR48e7peus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=d6yI+rUp; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="d6yI+rUp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=eE7uJNYBiyxeFfDOvBhmkxarzAxcf5IHyhRSgzH9Oy4=; b=d6yI+rUpBpmU1MwcVVLLDzpzhJ
	uAs8mlLTJsyKtXdZn7R1ExghC/AVam371u7ni/JZ31CY9oL9Z5gC2/75m7vNgJkXw9n+LgL//nW/T
	0WZxJ+ayHfOgt+HgznqbsCgvCLTOd/GDU228P9vZPdTjcx+SPvJjNkjBgxvCRwqldbpVPCVk3j5XK
	OkIJUppI+FcQMfvsOHDWDgSsyuI0Cn85V1Ja4tcfHEpc/9iI4qbnN2sde5MByqfQVoFA9aFnGfWZ4
	RLXU8T+BgjLQfKInbIbRhFUv3bzTYYcdNnn/VvkBa928zWp1o22skJAO03Vy9EoI00H+aIqhJDCP5
	Qx82jFlg==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1taaL0-0000000DZ4r-0AoS
	for fio@vger.kernel.org;
	Wed, 22 Jan 2025 13:00:06 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 7A0231BC0166; Wed, 22 Jan 2025 06:00:01 -0700 (MST)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20250122130001.7A0231BC0166@kernel.dk>
Date: Wed, 22 Jan 2025 06:00:01 -0700 (MST)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit d1ebbdd2de8afc6cee885d5a2f04a79e2598217a:

  Merge branch 'master' of https://github.com/termim/fio (2024-12-16 13:23:58 -0500)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 187103ae7c28701d73725200a73dbb39eef72221:

  Merge branch 'pre_success' of https://github.com/kawasaki/fio (2025-01-21 11:38:18 -0500)

----------------------------------------------------------------
Shin'ichiro Kawasaki (1):
      t/run-fio-tests: remove redundant pre_success lines

Vincent Fu (1):
      Merge branch 'pre_success' of https://github.com/kawasaki/fio

 t/run-fio-tests.py | 3 ---
 1 file changed, 3 deletions(-)

---

Diff of recent changes:

diff --git a/t/run-fio-tests.py b/t/run-fio-tests.py
index d713c1c4..384b6871 100755
--- a/t/run-fio-tests.py
+++ b/t/run-fio-tests.py
@@ -931,7 +931,6 @@ TEST_LIST = [
         'success':          SUCCESS_DEFAULT,
         'pre_job':          None,
         'pre_success':      None,
-        'pre_success':      SUCCESS_DEFAULT,
         'requirements':     [Requirements.linux, Requirements.libaio],
     },
     {
@@ -941,7 +940,6 @@ TEST_LIST = [
         'success':          SUCCESS_DEFAULT,
         'pre_job':          None,
         'pre_success':      None,
-        'pre_success':      SUCCESS_DEFAULT,
         'requirements':     [Requirements.linux, Requirements.libaio],
     },
     {
@@ -951,7 +949,6 @@ TEST_LIST = [
         'success':          SUCCESS_DEFAULT,
         'pre_job':          None,
         'pre_success':      None,
-        'pre_success':      SUCCESS_DEFAULT,
         'requirements':     [],
     },
     {
