Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1ED0320CA8
	for <fio@vger.kernel.org>; Fri, 19 Dec 2025 13:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766151803; cv=none; b=ApCQFZicp1HqQBtufBt85kT2+ofM50kbBTYrIn9y2TN+RsuS+Cx3LdOEIYT4WSne8LyOMWWVqdBdaBHmZh8KnyYD/3LfMnLyq24VpI5ml/b5w8tAebGXSvYnuSPLwXTOEwcH8Tqt4vlSvN6uDg1CHc6wtBa4IRGPy5py8e8QuJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766151803; c=relaxed/simple;
	bh=muR2SWhXjSyWsbt//djtZyHYWjhRauFbU2WS5lG8o9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QKFLp1MrXXbDh481QLk6MgXDqfcJ9l1/vo7iPIrHDRRNNZcjNzFs1pNl2dPOEpUQShbSLDAaNk+mtX5V/3xj/sqIuC7d3wuX608csX80oMtW75nTpFSlWL/AKVuWBWTV6NLZZlvnWpsyYFbY45LCkVwgmHiAaVV6crXko29Pd+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=HESvM2V2; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=wzqh5mh9; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=wkNKsswL; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=3p6Gp84Z; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="HESvM2V2";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="wzqh5mh9";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="wkNKsswL";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="3p6Gp84Z"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 3893E5BD33;
	Fri, 19 Dec 2025 13:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1766151784; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=WuEB6ypoODHFkzeqm0zUXpaKVAK46HjXfcaBMZdX4Ew=;
	b=HESvM2V23SBiYe8kOK5MREItOg5EiVJLaYr1DKrK1Ro/SQyWbb5DvZkU8NoMSBzgRYGHLM
	opdz1vfOli4KznLPqri98lR3NsmhpOrmXU9EMfFO192Dx6o42JHt8/Jw/WzjX+gCzD9xwX
	eSaA+3SV1Segy7l3ZyssOzM5Lqdw9VI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1766151784;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=WuEB6ypoODHFkzeqm0zUXpaKVAK46HjXfcaBMZdX4Ew=;
	b=wzqh5mh9OW2W3X1CZ5JgmR3zjbwKuNjIS359vA+VUDtuSk5VicrZGeIuVU2oapMQS/a8QO
	Tup6EGABB8dqjoAw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=wkNKsswL;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=3p6Gp84Z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1766151783; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=WuEB6ypoODHFkzeqm0zUXpaKVAK46HjXfcaBMZdX4Ew=;
	b=wkNKsswLfU8TZK8RTx3R6gn0tyKEWCRpeqd6K7+kcMLjZoGuOVaY/0rVRDf/BmUrD37StR
	NaOBSrQE0EuhcmfZspNhBwtKlPs+kOP6BHW7H6YLz9wSIwgOXbW7Y3AYfxC1KVZ1H9/2+A
	JPw9YmlQyXWHXhco896H0iMA38DWUf4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1766151783;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=WuEB6ypoODHFkzeqm0zUXpaKVAK46HjXfcaBMZdX4Ew=;
	b=3p6Gp84ZBnXQVzcAvVnHuZZ6G7M0td5HnjPw44BTMRctCDl42jUfMdmjmo1P07HpCWl95b
	5eoB7aCA6aRQb8Cw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2CE3F3EA63;
	Fri, 19 Dec 2025 13:43:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 1JwKC2dWRWmcMQAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 19 Dec 2025 13:43:03 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id E276CA090B; Fri, 19 Dec 2025 14:42:47 +0100 (CET)
From: Jan Kara <jack@suse.cz>
To: Vincent Fu <vincentfu@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>,
	fio@vger.kernel.org,
	Jan Kara <jack@suse.cz>
Subject: [PATCH v2 0/5] Add support for specifying ramp up period by amount of IO
Date: Fri, 19 Dec 2025 14:42:34 +0100
Message-ID: <20251219133853.8548-1-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_COUNT_THREE(0.00)[3];
	FREEMAIL_TO(0.00)[gmail.com];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.cz:dkim,suse.cz:mid];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DWL_DNSWL_BLOCKED(0.00)[suse.cz:dkim];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spam-Level: 
X-Rspamd-Queue-Id: 3893E5BD33
X-Spam-Flag: NO
X-Spam-Score: -3.01

Hello!

In some cases the ramp up period is not easy to define by amount of time. This
is for example a case of buffered writes measurement where we want to start
measuring only once dirty throttling kicks in. The time until dirty throttling
kicks in depends on dirty limit (easy to figure out) and speed of writes to the
page cache (difficult to know in advance). This patch series adds to fio an
option to specify ramp up period in terms of amount to IO - i.e., the ramp up
period finishes once given amount of IO is done.

Changes since v1:
* Improved documentation to explain behavior with group reporting, replace wrong
  note about default unit being megabytes
* Add sanity checks for inconsistent ramp_size values within reporting group
  and usage of both ramp_size and ramp_time for a single job.
* Fix fio server support for the new option

								Honza

Previous versions:
Link: http://lore.kernel.org/r/20251217160217.15533-1-jack@suse.cz # v1
