Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 846FC23F412
	for <fio@vger.kernel.org>; Fri, 25 Jul 2025 06:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753424272; cv=none; b=RZG3GgGlFgKjjAqMKfoTIvS89IPE9vpnSGoFkwzQzDMQRxVGA3Gv8b+9HuBiqauJTO3Xk9AoLWfY9Vsc0FU3HaYDM37ZeVNKYt+aeULMTiLyaWpL8QngyKeh9veQ9dbiEjuvg/1e1zRss+mdrrGBv/FKZl/nrIaPZmXHmscuioQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753424272; c=relaxed/simple;
	bh=NFdF30sONvXAtny/AKY4EVeCipTf13Cz8v1BqHnbjbs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=L0EkWKnrFXE+QCo/ikzy3qcXUFX5gjmokEdKorlr+AU9xnvRsl/L4RaFg3Ytm3/PGLSvYy+45/U1FI59n5g3Z3gK2lA3BXXwDG9I9d4sEi3RxI90NqfR2zlMp2ZZbTCxI1+2JihlJ0VYPS7F3Kew2QZVZNuqrhnzijq9rUVyNK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ytPwerCc; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ytPwerCc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=fegdslJfhWSbzu9W6H/4rHa9pzblGEseQVG7msRcB14=; b=ytPwerCciogiGPNv7m1MlAptj6
	tySrJip1w2bz5Vsb6yXcJFP2DAERI4rcrc4fkzhErx6kphLPnoCKcU9kbkqGB1+zje+O1ZdcFz/iM
	o2hn3qJggqlmfjYJzH+eCSUaqfbm7orx1RTXOaOVEtImU2XvYCSULy47kCNHX2g9Eyekx0AY8iLQo
	Gp7zcymGXXlXt3qOl+xM2fh1lIoTT38k3J6DsGFn89EKZDaCOQPCVe0sff64rO3J2W8Fo49wZWrVG
	cejTsv1F4Om6rbuRXlIbyjUuC2irj4cQk8EVoz7b/ZeYR7WzYi6RdN2EalcsH/e3WluVHVvfKgIOJ
	iPmD0tiw==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ufBkc-000000099Ly-37AJ;
	Fri, 25 Jul 2025 06:17:50 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
To: vincent.fu@samsung.com,
	fio@vger.kernel.org
Cc: mcgrof@kernel.org
Subject: [PATCH 0/2] fio: steady state for latency
Date: Thu, 24 Jul 2025 23:17:46 -0700
Message-ID: <20250725061748.2180898-1-mcgrof@kernel.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>

I've been testing Claude Code for things lately, I figured one good task
may be to try steady state latency support which we lack support for. It
also fixed a small build bug.

Luis Chamberlain (2):
  configure: libnfs + gnutls
  fio: add latency steady state detection

 HOWTO.rst                       | 12 +++++
 client.c                        |  1 +
 configure                       |  4 +-
 example_latency_steadystate.fio | 47 ++++++++++++++++++++
 options.c                       | 26 ++++++++++-
 stat.h                          | 10 +++++
 steadystate.c                   | 78 ++++++++++++++++++++++++++++-----
 steadystate.h                   |  7 +++
 8 files changed, 170 insertions(+), 15 deletions(-)
 create mode 100644 example_latency_steadystate.fio

-- 
2.47.2

