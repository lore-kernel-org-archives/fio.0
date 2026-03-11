Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54EEB36D4FD
	for <fio@vger.kernel.org>; Wed, 11 Mar 2026 15:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773244344; cv=none; b=h572W7aP0NWfx4yRKZFmCR6vqqGIkW+LqT69k27aTnSQeR5RYh2S7SPEGNHEHUGkYoJyZdCZJcD7XJgxHgRHZzy6lACP9NG0OS0mTD+M9NtaQyox694cnWEs1a6m7i1I3JAvFjpPmmB7paio/t0CkL0gEKD5jkDox6C82iNcBUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773244344; c=relaxed/simple;
	bh=eUyvVD6FYd+kMw8ul/+hsYa7OSLo2gHI7iX+J4PvZdA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BQOukoo27b3fOhmQ4Ov3BYYA9o6NdwN4MQbIoP6wFBHGAqMrsWI9Y73yfyw5jBd3zzzbhJ/WFzTVtjfURqI1ckPLOSlbMV14p1H2sWssT6SZQvMcERvHWz7wf1fAmE/G/E28t+hveYS/xV0QE/04TBqCTos9O70RfkYTw8g9eWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hkup4Pao; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hkup4Pao"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773244342;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=purWKtahervkQmWpAi/9lFqpQ7reFN3BVta2hICrs2c=;
	b=hkup4Pao7kaVrhqnp2IB/iDC9jdTqQOufTRzP5seHCEEE7lkezZnC+PVuK2ZhFhld4u6/v
	otjiiT3oLupsRUVqniUptD1fdQg27UIG8D3us5pFtsoz87jB+vJWBhVy/lnJi7WUJloCvm
	jCk9PVvcZtyKIGqPPS2fCZsADOpvhoc=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-399-hN8ZNrUpNL2LP0o8BV-hrg-1; Wed,
 11 Mar 2026 11:52:19 -0400
X-MC-Unique: hN8ZNrUpNL2LP0o8BV-hrg-1
X-Mimecast-MFC-AGG-ID: hN8ZNrUpNL2LP0o8BV-hrg_1773244338
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EE3E018002CB;
	Wed, 11 Mar 2026 15:52:17 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.89.69])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3D5F41800107;
	Wed, 11 Mar 2026 15:52:16 +0000 (UTC)
From: Nico Pache <npache@redhat.com>
To: vincentfu@gmail.com,
	axboe@kernel.dk,
	fio@vger.kernel.org
Cc: jvozar@redhat.com,
	jjurca@redhat.com,
	jhladky@redhat.com,
	peterx@redhat.com,
	spetrovi@redhat.com,
	david@kernel.org
Subject: [PATCH v2 2/2] Documentation: update the HOWTO to include the page_fault engine
Date: Wed, 11 Mar 2026 09:51:12 -0600
Message-ID: <20260311155114.198006-3-npache@redhat.com>
In-Reply-To: <20260311155114.198006-1-npache@redhat.com>
References: <20260311155114.198006-1-npache@redhat.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Document the new page fault engine.

Signed-off-by: Nico Pache <npache@redhat.com>
---
 HOWTO.rst | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/HOWTO.rst b/HOWTO.rst
index e712ee2e..421e6408 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -2376,6 +2376,11 @@ I/O engine
 			several instances to access the same device or file
 			simultaneously, but allow it for threads.
 
+		**page_fault**
+			I/O engine that uses an mmap region to simulate data transfer by
+			allocating anonymous memory and copying data on read/write to
+			intentionally trigger page faults.
+
 	File/directory operation engines define how the job operates file or directory. The
 	following types are defined:
 
-- 
2.53.0

