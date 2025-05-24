Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8EF7322E
	for <fio@vger.kernel.org>; Sat, 24 May 2025 12:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748088019; cv=none; b=FYbTeE3PG4n7YMvwux1f6i2AERUoxCStAUDqcVSqZlACP68soCgjCpSnvKnz5N8JunzzdQ6FuDeTkLJmghvdVW8jEI/tFDZDw/D4G2AOvh8UVKDsrsza/jVMB3GL3zp0MbqHtr+IdkUM75c//0qY3QTfBuACqUOEWYFWMy8EaIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748088019; c=relaxed/simple;
	bh=L0qbx8a19kOxINcWj1QyVH5u3CvI504d5bmLrRqRKuo=;
	h=Subject:From:To:Message-Id:Date; b=uKR0thUSoPAJp/e7qFPKmQToIFIiyOl8Ip6lbP22A02/ur7tuGjrnWUkUBGLfh6JmuAhtXiUihj1xWAiYtci4gA4QTNntJdGaBkQUukr/bgRcz0x+/+TLV0IDi9QF/J5ahSQYNWBmidx7eKn8tsDhDyAUq8W00baXSGZlMgQ7G0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Q5UoXRCq; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Q5UoXRCq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=O4RT6zPP+jmxjaPfgVrB4D84X57PE7ChsmP89cCv5nM=; b=Q5UoXRCqiZvcyeDxsib9d9L3zv
	H6P9uYEwaXw3ZWh25uawIuRjbmQyEDZtZm//e4vH0WlijOQ6Qmt+Usyq0LfHcOBCoZw2Y/2v281Sc
	ASHxB4bX524O4oI3spQxaLkwZnqtSdAA1lWDWXyqrfmIt0DZj2bQih/Uam6Bry/+qvOIp0cRRtCMw
	97UU/cjAaAF/h8To4oywrIe2aXEAHv0EN0aB7XXI9VSN9ftnzJKUZh3udyIz7KAFGTpcjkKhSGI2e
	LV864f2uEG44It3tKhU0gBRcMDXJyR+BX0EAWJ9THUx/XhqWQ05pBREYoLOIIQSo4mA/mKL72yj4o
	f3hBHgnA==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uInXq-00000008lot-3snf
	for fio@vger.kernel.org;
	Sat, 24 May 2025 12:00:07 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 289FC1BC015C; Sat, 24 May 2025 06:00:02 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20250524120002.289FC1BC015C@kernel.dk>
Date: Sat, 24 May 2025 06:00:02 -0600 (MDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit ff930c4653ae3952d6b09ab3ec89671aeabf2cbe:

  Fio 3.40 (2025-05-20 12:23:01 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to c348db31ccce60f2808dd84c1f43f36a1556141a:

  Add Zhaoxin support to enable tsc_reliable and arch_random features (2025-05-23 09:46:26 -0600)

----------------------------------------------------------------
Runa Guo-oc (1):
      Add Zhaoxin support to enable tsc_reliable and arch_random features

 arch/arch-x86-common.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/arch/arch-x86-common.h b/arch/arch-x86-common.h
index f32835cc..ac26126a 100644
--- a/arch/arch-x86-common.h
+++ b/arch/arch-x86-common.h
@@ -68,7 +68,8 @@ static inline void arch_init(char *envp[])
 			 (unsigned int *) &str[4]);
 
 	str[12] = '\0';
-	if (!strcmp(str, "GenuineIntel"))
+	if (!strcmp(str, "GenuineIntel") || !strcmp(str, "  Shanghai  ") ||
+	    !strcmp(str, "CentaurHauls"))
 		arch_init_intel();
 	else if (!strcmp(str, "AuthenticAMD") || !strcmp(str, "HygonGenuine"))
 		arch_init_amd();
