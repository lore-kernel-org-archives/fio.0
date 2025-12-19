Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32DBF322520
	for <fio@vger.kernel.org>; Fri, 19 Dec 2025 13:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766151795; cv=none; b=ZiZBnzujegQuJmWnoUTfQCkQjEZ9l4USPpJ3ywPHtxqW5jmLP+BgiVCGMeKUoeYDgG+Lu+qCI/0gwc73mdYSDfDH+S70ZxawzdS1NrUlxkYtw9C95FC/pRpRgqmf4oDnJkeO6i1D/KzlIUSvAJb9sVM/lb8pJFjlxRDgpPrUnjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766151795; c=relaxed/simple;
	bh=j8JNQSqOZy2naw+q1oHMOcC/Y187+ivM7qtfI1aRUjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kzz0JvqLum4rtwQrdF+rna0CI8ZgaCOpX+4Zf9eR5NTV115723xDExw4dPOx4stmrRHiKcnETem4uanfqk9Iwkx5oMHyJoKw+sFWAiwCYYIbzNTRUqZyQFyDZYF2I9TI4P7aeWwx4S7vCz92vvbKJ7ZmPS9/J3JVnya68XH6FE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Tryl9P/u; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=AOH8b50m; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=ewaoG14S; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=fXz1BP8M; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Tryl9P/u";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="AOH8b50m";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="ewaoG14S";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="fXz1BP8M"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 50CE133714;
	Fri, 19 Dec 2025 13:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1766151784; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X6hyqIltI0IFO16nZ1XdiGyLmVkjNlFJts8jAHDZ9s4=;
	b=Tryl9P/uxenOuzXFcNgAJElleZZ8lanbhHjTxpPh1JRe6lkox1f9rruJm2lBwU1mSBoyeF
	duShGzDP0nyEhMdf4RfEvgG+dihYHSQzFwUIDH8fteBiwMNhIDkb1FFS/UeHaniGW0NHxz
	4EyM4vKzl0JUYuDlx7UttP2+TLsJb1E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1766151784;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X6hyqIltI0IFO16nZ1XdiGyLmVkjNlFJts8jAHDZ9s4=;
	b=AOH8b50mp3P6gL2145XC9pH0R2AnWAcN3QE67r5u2ss+KQ/lNDuqK71WzUptOSbP7sop6i
	32ITCDPnKI1ZSpBQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ewaoG14S;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=fXz1BP8M
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1766151783; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X6hyqIltI0IFO16nZ1XdiGyLmVkjNlFJts8jAHDZ9s4=;
	b=ewaoG14Savs6NyacJs12wIz7iPfxC6vC2ClKrFUk3rKYnm4l24pfxcNXTRwTKAWEOvOtYI
	AXojX+GOCMbuwm0pF5TE+9HzYXSaar5KwyaZxpafQhuuk6Wqt2hTWDnCLql7mR4Ap+DaLM
	xSoMVynz3LUvMxa/Yz+5i5RV16iLACA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1766151783;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X6hyqIltI0IFO16nZ1XdiGyLmVkjNlFJts8jAHDZ9s4=;
	b=fXz1BP8M4H1iCQwj8B6HDhLbS+D8+J6zpElBk9zZ6MNDz9BHrd6x/yjECV5kjZvTZhklAY
	LomIdUgp8tzbPpBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3FB9B3EA67;
	Fri, 19 Dec 2025 13:43:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id NR+PD2dWRWmkMQAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 19 Dec 2025 13:43:03 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 01BF4A0A17; Fri, 19 Dec 2025 14:42:47 +0100 (CET)
From: Jan Kara <jack@suse.cz>
To: Vincent Fu <vincentfu@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>,
	fio@vger.kernel.org,
	Jan Kara <jack@suse.cz>,
	Damien Le Moal <dlemoal@kernel.org>
Subject: [PATCH v2 3/5] eta: Use in_ramp_period() instead of opencoding it
Date: Fri, 19 Dec 2025 14:42:37 +0100
Message-ID: <20251219134247.14195-3-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251219133853.8548-1-jack@suse.cz>
References: <20251219133853.8548-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Rspamd-Queue-Id: 50CE133714
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCPT_COUNT_FIVE(0.00)[5];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.cz:mid,suse.cz:dkim,suse.cz:email];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Level: 

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
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

