Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3704230E83F
	for <fio@vger.kernel.org>; Wed, 17 Dec 2025 16:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765988263; cv=none; b=Uvmq4mEai29PhhWjuDWMFe3dkvgHkYWXLHpCgT7Y6QwlfNu82DKp8I+kN+KSYAbPIe5cv+ZrDEdh/dwPSzSR9h7ZSRRaVty6MfDCxy1e6JGFQswc2MjM+8wdG4hgV7aXwwXx2uuXvlxsyPw5VMUB28614loXGt87PQQpZCO+qAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765988263; c=relaxed/simple;
	bh=XjBXLJEv38RkR97UiEUIqWFpc1v9+0x0Gxuj3mw7v8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EL0KJuLImh82IQivJRwf+NUHqTTNyWMrW1dZFKdSo4vNK7fO8sdSPDPGGo9fxCWsXbxddHy5NFNfyGMxZqfM6ol/QT0VeDwq8CmJ9A/XfoPBrCgUZJmKy0YBrK3X2xS+IIMnSX7kDTtOHL3Ulh9L6iLG0ievfAzhsEY9zoG8+eo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=bKv43hZq; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=pLDyoEyP; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="bKv43hZq";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="pLDyoEyP"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id CDAC533686;
	Wed, 17 Dec 2025 16:17:26 +0000 (UTC)
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1765988246; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Jc/ixQm1uxP6iNm+J30Oi3GjQj59yXgil6hC1vq3MaQ=;
	b=bKv43hZqp2sWL1zFMvoWdDTbdFrmaBd7nkMDt0ZUmX4zZsT/0Gf4YucSpWHeD3/Ol7IjQY
	qb1wT3/uZ+1z0K7bSm7PsGxwiz+a4lyuEod1VMyE7AocOx+9qQqy+udF6PxMnTClG4e8PN
	ySHQ+mRfb65Bxa+bF6NlvdXvCZwoHxE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1765988246;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Jc/ixQm1uxP6iNm+J30Oi3GjQj59yXgil6hC1vq3MaQ=;
	b=pLDyoEyPSHyowzZD95R7eG2RGITXnIsiYoG4HPUjs59ps+jcuBNOpn6Qg5n4f3IVqoqVVu
	tDlakxshId+0PfBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BB6423EA66;
	Wed, 17 Dec 2025 16:17:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id pPa3LZbXQmnwcAAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 17 Dec 2025 16:17:26 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 35526A09D8; Wed, 17 Dec 2025 17:17:22 +0100 (CET)
From: Jan Kara <jack@suse.cz>
To: fio@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 3/5] eta: Use in_ramp_period() instead of opencoding it
Date: Wed, 17 Dec 2025 17:17:13 +0100
Message-ID: <20251217161722.6357-3-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251217160217.15533-1-jack@suse.cz>
References: <20251217160217.15533-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[]
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Rspamd-Queue-Id: CDAC533686
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Level: 

Signed-off-by: Jan Kara <jack@suse.cz>
---
 eta.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/eta.c b/eta.c
index 947752b9dc17..c6e3cffb81d6 100644
--- a/eta.c
+++ b/eta.c
@@ -274,9 +274,8 @@ static unsigned long thread_eta(struct thread_data *td)
 			uint64_t ramp_time = td->o.ramp_time;
 
 			t_eta = __timeout + start_delay;
-			if (!td->ramp_period_over) {
+			if (in_ramp_period(td))
 				t_eta += ramp_time;
-			}
 			t_eta /= 1000000ULL;
 
 			if ((td->runstate == TD_RAMP) && in_ramp_period(td)) {
-- 
2.51.0

