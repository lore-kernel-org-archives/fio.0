Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBDCA28641E
	for <fio@vger.kernel.org>; Wed, 17 Dec 2025 16:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765988253; cv=none; b=Xv5hRHuZOaKYSkraZ0HA7r4zYyMz6ocMp5ZzuhioRUF/Ug3R4xiUVxR7A5yDKNyWZSCCb4XxxsWzlOLGt006R77mKCv5Eg4Z2VZUj0kKbPzk6jPr889Hv/sDiAfAv2qAC9W+7suJmo/81AKesYnaixSSl4oT1rKYSSHkDTog1zI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765988253; c=relaxed/simple;
	bh=M5Yq4vZusQiVtPhYso2/k3DgzNqudNKeG8aVxMoszK0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dcMNP62ZCS7cx/I/n3RmxQN9zWRP8KMnWdzznEGonXYZXHfitd3kVG1fFY4vRGlg4x2Uzu48sl/SejjZIBtlbumuTRTuHgcABiSVmxGFQ3rsog2AONXkIp9ggDXe1v4Pd4n+FMuSP4twowRCIcC2Y05pQFoTxN8YD7cnir/JIs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=3CapqFQc; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=50ElZ9eC; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=3CapqFQc; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=50ElZ9eC; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="3CapqFQc";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="50ElZ9eC";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="3CapqFQc";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="50ElZ9eC"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id BD9F55BCFF;
	Wed, 17 Dec 2025 16:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1765988246; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=MoxxI9/SAH3emqvba1T7wP4yRGjubxK2SCliHEZbIoo=;
	b=3CapqFQc6V5YOF1NZcKWmr9Rhkc0jZGAS8lKzRHP30ZIPTrJ2PyPRPpjJzPCyZnGximr8w
	BExeY8P22NpL/yxXoUFJKZfXPhZLn+29ddHbQvEDQOhefs0lIYMdzX11Us3lpMSS7ueXXs
	QZimpxQea4ZUzV1yYIEyWY6J3O0X8Mo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1765988246;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=MoxxI9/SAH3emqvba1T7wP4yRGjubxK2SCliHEZbIoo=;
	b=50ElZ9eCnPoXCwHHXzyoXu9l4CLl/gfFBeehi+P4Pk8qX2LpGBXIGjUORPmMSIglizYBlW
	IBZEL7za4oWEvvBg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1765988246; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=MoxxI9/SAH3emqvba1T7wP4yRGjubxK2SCliHEZbIoo=;
	b=3CapqFQc6V5YOF1NZcKWmr9Rhkc0jZGAS8lKzRHP30ZIPTrJ2PyPRPpjJzPCyZnGximr8w
	BExeY8P22NpL/yxXoUFJKZfXPhZLn+29ddHbQvEDQOhefs0lIYMdzX11Us3lpMSS7ueXXs
	QZimpxQea4ZUzV1yYIEyWY6J3O0X8Mo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1765988246;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=MoxxI9/SAH3emqvba1T7wP4yRGjubxK2SCliHEZbIoo=;
	b=50ElZ9eCnPoXCwHHXzyoXu9l4CLl/gfFBeehi+P4Pk8qX2LpGBXIGjUORPmMSIglizYBlW
	IBZEL7za4oWEvvBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AEF8A3EA65;
	Wed, 17 Dec 2025 16:17:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 70OzKpbXQmnscAAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 17 Dec 2025 16:17:26 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 22DEFA07B6; Wed, 17 Dec 2025 17:17:22 +0100 (CET)
From: Jan Kara <jack@suse.cz>
To: fio@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 0/5] Add support for specifying ramp up period by amount of IO
Date: Wed, 17 Dec 2025 17:17:10 +0100
Message-ID: <20251217160217.15533-1-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[kernel.dk,gmail.com,suse.cz];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_COUNT_THREE(0.00)[3];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Level: 
X-Spam-Flag: NO
X-Spam-Score: -2.80

Hello!

In some cases the ramp up period is not easy to define by amount of time. This
is for example a case of buffered writes measurement where we want to start
measuring only once dirty throttling kicks in. The time until dirty throttling
kicks in depends on dirty limit (easy to figure out) and speed of writes to the
page cache (difficult to know in advance). This patch series adds to fio an
option to specify ramp up period in terms of amount to IO - i.e., the ramp up
period finishes once given amount of IO is done.

Please consider including this feature in fio, it would help us make some
testing we do more reliable. Thanks!

								Honza
