Received: from fhigh3-smtp.messagingengine.com (fhigh3-smtp.messagingengine.com [103.168.172.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A60B9146588
	for <fio@vger.kernel.org>; Fri,  6 Sep 2024 21:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725657620; cv=none; b=qIQ3GLT2gOX/lIRSTmeqEBfgPnLPTngJXKScbEr5SRn0PAlJ23DqbuKPEoY1OQEnaeqV3yL0so9dn/kfc3/kykSIPmf+uUGwBT5z/RXdUn2vdEcpbPa/ItjgyTu/jDEnVyfcU3gL/h7PEy0AlaiU8t2YJyADuUPOkDC+tXvYK3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725657620; c=relaxed/simple;
	bh=KkImU5PDh9GkJynJhO8S30TYgaSeQN9D9avDmEbH5Y0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gpuehz002vJcPTm4dr7mRwTmlfPtKVQr5C6fWpLPglMCaEYQRziw+gkg6wrsZ4/Z+03hQgzwE7UIQ5MqiMKUa7caFsW4YLrgH2wD35gVlP6RZAx0U/zbO3rQK+e090CPzB13frK91AKE2FKLEh+ymH4cUiUbLxpFLxEb0gm41mc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bsdio.com; spf=fail smtp.mailfrom=bsdio.com; dkim=pass (2048-bit key) header.d=bsdio.com header.i=@bsdio.com header.b=Al+YuPRN; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=DXk3RVTb; arc=none smtp.client-ip=103.168.172.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bsdio.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=bsdio.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bsdio.com header.i=@bsdio.com header.b="Al+YuPRN";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="DXk3RVTb"
Received: from phl-compute-10.internal (phl-compute-10.phl.internal [10.202.2.50])
	by mailfhigh.phl.internal (Postfix) with ESMTP id B3EE11140116;
	Fri,  6 Sep 2024 17:20:15 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-10.internal (MEProxy); Fri, 06 Sep 2024 17:20:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bsdio.com; h=cc
	:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm2; t=1725657615; x=1725744015; bh=PWLf6BKvJXQwSpqHcO6Yz
	RUuDXv5Il/VT8yrxgHRBUQ=; b=Al+YuPRNTkEfA70vwT5BCG9IZ04UxQ3I/7TlX
	6/o/QAXQ931mjTz6GkrwQHrjRNsijPZa1h0A5k/H4PKFLALU07Z7DE7+bCFj2bVs
	WcYJbY1Afe83LSZ9AkEp9+1oVbP5I4hIxOr7fxsdjmlRQCZrdhX5vufwT54mpGLF
	5Y3CWKdpYflnA/nfsxsMIeJSNZR2DvZE/SeXf/WoXLQVuK1PUWhYHda5XOiBggYN
	lb0692IsdMlcGj0lorsrRmtWkrGWhcGKHuU/a7zXGsLSwnDBtdwx3eySLOkm9K6O
	u6JuK/Ac1cv/K4q0Kwcbqvn6qqT1YjpdwIeciewoyfWeWDFGw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm1; t=1725657615; x=1725744015; bh=PWLf6BKvJXQwSpqHcO6YzRUuDXv5
	Il/VT8yrxgHRBUQ=; b=DXk3RVTb6k/z0qENtoOr2TtKJOVza8u87msChLCjNHeq
	leUf3TavloW/l5N0hMpGegAGONpkma/Jm3C2i2Wo059OpvOKczzDBtxMGEeLxYZ9
	9NLvNUCGPBaCK14LkWBQne85uVk8CJ/fN8ZiPU4e5KX5BCmzG8nz52okuYRYQXch
	Nkug9jyJbSKhzXebHcDkfnE1rErDi0ryq7SepAJMjtPB0D8uAXEcYFoc4pK9px/r
	4PHfRB4AwiS4hv8Rc/jqwZAI5159J8ODlaQXyFPzU5jBZe9GvOwOSP9grneic+D+
	XxjzVwJzal04vR72UjITSB6EakFOfb4yR8POJenUCw==
X-ME-Sender: <xms:D3LbZhuZyPAzWT6Ddx1S0xE3-a6VeGU9JXJhlCE4I_zk1sHxr3nbtA>
    <xme:D3LbZqeO0ZVfXCiSgJWFOAz97Qnbnv3fZ1av4GAFgXfMxagV-5NOKqMb721bXwEg8
    GmX9mGFb3urI9SZ-J0>
X-ME-Received: <xmr:D3LbZkwfuFte1gPWX8oXYKTdDtEr-2HacDdbzpq7KPzcLg31hYOrUWcNhCE9MQb1hATk>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrudeiuddgudeivdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpggftfghnshhusghstghrihgsvgdp
    uffrtefokffrpgfnqfghnecuuegrihhlohhuthemuceftddtnecunecujfgurhephffvve
    fufffkofgggfestdekredtredttdenucfhrhhomheptfgvsggvtggtrgcuvehrrghnuceo
    rhgvsggvtggtrgessghsughiohdrtghomheqnecuggftrfgrthhtvghrnhepgeefjeeuud
    evleevgeeigeduhffghffhhfffueektdekteehheevheeuledvuddtnecuffhomhgrihhn
    pehkvghrnhgvlhdrohhrghdpshhpihhnihgtshdrnhgvthenucevlhhushhtvghrufhiii
    gvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehrvggsvggttggrsegsshguihhordgt
    ohhmpdhnsggprhgtphhtthhopeefpdhmohguvgepshhmthhpohhuthdprhgtphhtthhope
    grgigsohgvsehkvghrnhgvlhdrughkpdhrtghpthhtohepfhhiohesvhhgvghrrdhkvghr
    nhgvlhdrohhrghdprhgtphhtthhopehrvggsvggttggrsegsshguihhordgtohhm
X-ME-Proxy: <xmx:D3LbZoMHd4BK32G__VGyUvCggOFt_zchoVC6_1juQntrpBhvaI3WXg>
    <xmx:D3LbZh-pdWbLl717X18OK_dDx99rtAr5QMMHLqlfLxBoFvOaIS3JNA>
    <xmx:D3LbZoV4haFjCgUk-EzEcw7p5Z59ahZWvMq2NfLfyJc9R9xYIi895Q>
    <xmx:D3LbZidgVZPrIW-Xal4dY2_-oHAhafJa2S---0gK5ob42LEm0NeWVw>
    <xmx:D3LbZsaJ8KMXSQorahkkD19VYC8ct4VX3Zg5U59CodNES5tziucVqoR5>
Feedback-ID: i5b994698:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 6 Sep 2024 17:20:14 -0400 (EDT)
From: Rebecca Cran <rebecca@bsdio.com>
To: axboe@kernel.dk,
	fio@vger.kernel.org
Cc: Rebecca Cran <rebecca@bsdio.com>
Subject: [PATCH] Update mailing list details in README.rst
Date: Fri,  6 Sep 2024 15:19:40 -0600
Message-ID: <20240906211941.850156-1-rebecca@bsdio.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Majordomo commands are no longer used, so update README.rst with the new
method of subscribing to the mailing list.

Signed-off-by: Rebecca Cran <rebecca@bsdio.com>
---
 README.rst | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/README.rst b/README.rst
index dd521daf..e672ce64 100644
--- a/README.rst
+++ b/README.rst
@@ -53,11 +53,10 @@ see REPORTING-BUGS.
 
 An automated mail detailing recent commits is automatically sent to the list at
 most daily. The list address is fio@vger.kernel.org, subscribe by sending an
-email to majordomo@vger.kernel.org with
+email to fio+subscribe@vger.kernel.org or visit
+https://subspace.kernel.org/vger.kernel.org.html.
 
-	subscribe fio
-
-in the body of the email. Archives can be found here:
+Archives can be found here:
 
 	https://www.spinics.net/lists/fio/
 
-- 
2.46.0

