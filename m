Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C32E4F21F
	for <fio@vger.kernel.org>; Fri, 19 Jan 2024 13:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705669209; cv=none; b=KFQcsV7uL4aFAGOQ/nHNmShTWRlaXvqR+NhXLpg0wzw17+ARvN8C0uN8IAxdGIVXd7nQj0F1wBEAwzYmisDLjxTP1NIISykeuWSf+jt+BHtOf6fBY+wsa+xHg5m/jN27yKCTyke34SydwL2ksLE9+X2bqbQYjiXpW7mLDP3OSvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705669209; c=relaxed/simple;
	bh=LL8VZpItsNh+Ks6B7ZaCHTCyWyg3qe5QKi8yVwl8VQY=;
	h=Subject:From:To:Message-Id:Date; b=GyZAkWcgbwqHLKc58KEdhIGTtcFAhYiAX2ylqw5nAAHNTMlLu9Zi8yRhQGBzSqIiQB1J582nD5qcyhKLti8lMIXr1CldCOPgO3aZHAjd3S6X4UKVDfkDMOMBdMveUcUkjdnQgpjsFYcaH5YcUrQ5BenR1fZghDk7ETQS3PX4tJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=BfQiPLVP; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BfQiPLVP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=skDbO8nhjBInw9N3OPyZ2Pazb3pGNKLep5h2PDtF2Dw=; b=BfQiPLVPGy3W1jtin6xLjkC/lo
	XZ7SY5JHG23j0J76LQeYWTRru1j9RPhwbxdmNPqE+H9qEUvAYZHtwmrftkbxAqVttT1pCcPZadDuK
	GWgSom8e6D3qiVPszuoHN6swcpmB73XOLyjBrm5OoPUazs0HdIWM7LaOSiG59AvUzgfalNxPLY+3Q
	qyeEhTfU3SzaJ7yj1VK7VSptj7wT3HU3gB8ZBYz8yNWCIzKAchfAVzPIFZ+r6qaGTbkVb8w+MNYCg
	0FOXpuehQlcRJFjH51IMCRjFM3fFkYjkYOVEeSh/8LHu2fkJKfphSPQewGTAGbkWGphzWOWuefQDp
	A2nTEhZQ==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rQoTb-00000001Yup-2hlu
	for fio@vger.kernel.org;
	Fri, 19 Jan 2024 13:00:03 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 68E131BC0134; Fri, 19 Jan 2024 06:00:01 -0700 (MST)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20240119130001.68E131BC0134@kernel.dk>
Date: Fri, 19 Jan 2024 06:00:01 -0700 (MST)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 9eefdcc1dd820a936684168468fa9c81960ea461:

  configure: enable NVME_URING_CMD checking for Android (2024-01-17 09:11:15 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to aa84b5ba581add84ce6e73b20ca0fbd04f6058c8:

  ci: stop hard coding number of jobs for make (2024-01-18 13:00:31 -0500)

----------------------------------------------------------------
Vincent Fu (1):
      ci: stop hard coding number of jobs for make

 ci/actions-build.sh | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/ci/actions-build.sh b/ci/actions-build.sh
index 31d3446c..47d4f044 100755
--- a/ci/actions-build.sh
+++ b/ci/actions-build.sh
@@ -61,7 +61,9 @@ main() {
     configure_flags+=(--extra-cflags="${extra_cflags}")
 
     ./configure "${configure_flags[@]}"
-    make -j 2
+    make -j "$(nproc 2>/dev/null || sysctl -n hw.logicalcpu)"
+# macOS does not have nproc, so we have to use sysctl to obtain the number of
+# logical CPUs.
 }
 
 main
