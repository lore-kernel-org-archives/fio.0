Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 847CB2836A3
	for <fio@vger.kernel.org>; Fri, 25 Jul 2025 06:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753424272; cv=none; b=KDJqGhbxap7ZCX3HBaC7xFbfzJtKaUNB8XyAHH4yvPVnvdNH0MjSPy2xU1S9n+e690upZkY0wv8TJQuCRSjgosi3KFlXiaIvdd9PNoF9cDxBlnHr18cmPGVcwg6fwH9bSTeuOUkCQsDi5rtRQAPvt3ikqM38dpMSToBdiPTQC08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753424272; c=relaxed/simple;
	bh=nlu2+SMO8QtXmA5ASZqbGsfrf6FbX3kZ+mS3YodALo4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CiZJFqFSLcf+2JAU769W2WWoOVQ6Zk36DnDTXA2Z1VjsvvRVNYcpP/wh+wVLCCMB8yBLObZFGq2AUztYi+3wCMNate4nBfLVkAMWPtYN8UGf3552RkKSjFdO3PdHREzcVUvWJuyv+JG3qZQ+jM9zgL+QKqMhyBRG+7quj9suySM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ewrLna/D; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ewrLna/D"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=vPhV4xlNbgSpeDNbdVBXVeI6krXpQ9qahGgDjWq7PKI=; b=ewrLna/D/nLgOzC3gDoyKdijyd
	kjhICov2ezcjbnOvw0q6ZXqRupZ8G99Xwd+0i4gC/VSwkIZGyOpRhSJlBddY5lIUNn5dQ8tWNX1Ah
	N5GG47T662PDeJNGNAVI3VIjwBUwAceSyhlmAF5RtKIgCz9GcruRW0UnwOa1aXjY7q6DDyFDm5hzl
	Cw+gQzXKbx0fb2gxYI28yhH9z+iJoHaFjvatl/FQuqN6UE6ee3SSl68lUELjr95iKO+TXUOL7t7gJ
	n62e/p//17ck9RDhqZNdOL4SGJtZcM2sqFayKIDJ889vpPJVxNRAnezQBZgyUZ7rt5HqRjZqlb+SV
	a9BuJcNA==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ufBkc-000000099M0-3Fpn;
	Fri, 25 Jul 2025 06:17:50 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
To: vincent.fu@samsung.com,
	fio@vger.kernel.org
Cc: mcgrof@kernel.org
Subject: [PATCH 1/2] configure: libnfs + gnutls
Date: Thu, 24 Jul 2025 23:17:47 -0700
Message-ID: <20250725061748.2180898-2-mcgrof@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250725061748.2180898-1-mcgrof@kernel.org>
References: <20250725061748.2180898-1-mcgrof@kernel.org>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>

The problem is that the configure script tries to get both libnfs and
gnutls flags together, but gnutls is missing. Let me check the configure
script's logic and fix it:

The configure script is trying to link both libnfs and gnutls together,
but gnutls is not installed. Let me fix this by modifying the configure
script to only require libnfs:

Generated-by: Claude AI
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 configure | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/configure b/configure
index 9e69dc4b..1769ef38 100755
--- a/configure
+++ b/configure
@@ -2359,8 +2359,8 @@ print_config "DAOS File System (dfs) Engine" "$dfs"
 if test "$libnfs" != "no" ; then
   if $(pkg-config libnfs > /dev/null 2>&1); then
     libnfs="yes"
-    libnfs_cflags=$(pkg-config --cflags libnfs gnutls)
-    libnfs_libs=$(pkg-config --libs libnfs gnutls)
+    libnfs_cflags=$(pkg-config --cflags libnfs)
+    libnfs_libs=$(pkg-config --libs libnfs)
   else
     if test "$libnfs" = "yes" ; then
       feature_not_found "libnfs" "libnfs"
-- 
2.47.2

