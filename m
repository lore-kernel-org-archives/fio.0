Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E91721E08D
	for <fio@vger.kernel.org>; Thu, 18 Dec 2025 16:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766075516; cv=none; b=rDILyCcsnrBTka0DAPmsYQ5S7WO0TQu6P9LzplY1JslydaG8nugsjcAL7PgRgkJuk3XMUIxnFK1Zw7032ecyBHWPkZbIjX9BD+M1zbVDzxBERZaJwcc/9MusudP9F94GA5av56slYFM9dkKgAtstiD1vP3s+6i9TbGBjt8JRpIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766075516; c=relaxed/simple;
	bh=jTnwbuOoLUTJRomRRe3yeBNjRTrmLWhNJR8YvR6/xS4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sRBxXO7Yw7wGtQ/4eu2TJo40B5OWKhAerA00B8kzgYRfIO5FtfscHGGSevnhwRMMa4BIfyn2EnH7gireonEN86Efv+5iKrX+nAF7pqbcuHLfV7yx0al55iYVR4LYMyDPksA79izMFPj46AMuoG9OvnQIEmF8/7eXCZoWddU7eUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=GPXrAYV+; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=i5B90nOh; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=0a5x/WsS; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=4HdYHnZH; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="GPXrAYV+";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="i5B90nOh";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="0a5x/WsS";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="4HdYHnZH"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 8ADA95BF50;
	Thu, 18 Dec 2025 16:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1766075512; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=T+i63YIt2WAlJ1zsN8Q84RWh4ZvqWYFAtn2FNV0Slj0=;
	b=GPXrAYV+czZkSbv6SyWOTPxgESEhnK3Tu4a0H9m7PPd8xzJ2nvXqt8/iwIhUUi0xIoJjZ1
	73MG5lzfDm/mfMme1tcJzac8BOnNsn+Vt4wSDxn4qUcN/OjxGrWdrXz2RiZIs2t8CU2PRz
	I6EYCRK971OUDyZEQQr/eOs5Ne2vY4o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1766075512;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=T+i63YIt2WAlJ1zsN8Q84RWh4ZvqWYFAtn2FNV0Slj0=;
	b=i5B90nOhTrPa66Z2+JypKtcbCfQKVjzeAaeXssFu/z2Gitw+c0of4OHKjTLxriWPuhoWKF
	X02eCU/ih15STwBA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="0a5x/WsS";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=4HdYHnZH
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1766075511; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=T+i63YIt2WAlJ1zsN8Q84RWh4ZvqWYFAtn2FNV0Slj0=;
	b=0a5x/WsSKCCRrIgSp6wCRcRSicJmN3GeGcSeccPLLdI9H5KiNW+i4mrXOt3WJY8rYU7Uy2
	R0b93rcHsP6NUSLUgmYd+aihnVMocFjXEcuknRSVSBydjbpAqnfdfpGI9un5mmPhEgEYle
	8nyej3U/Om77sfGP/vSqPS+5G2oxfE0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1766075511;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=T+i63YIt2WAlJ1zsN8Q84RWh4ZvqWYFAtn2FNV0Slj0=;
	b=4HdYHnZHm4q14Gc3p5O0kDJzyo8Pl+u5YbGRjgFJFISr8yY5eGFdy8yoPhVKs3mS4lE6gK
	GSpqLWyNWl+yUKDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 821BD3EA63;
	Thu, 18 Dec 2025 16:31:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Pne8H3csRGltLgAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 18 Dec 2025 16:31:51 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 41784A0918; Thu, 18 Dec 2025 17:31:47 +0100 (CET)
Date: Thu, 18 Dec 2025 17:31:47 +0100
From: Jan Kara <jack@suse.cz>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Jan Kara <jack@suse.cz>, fio@vger.kernel.org, 
	Jens Axboe <axboe@kernel.dk>, Vincent Fu <vincentfu@gmail.com>
Subject: Re: [PATCH 5/5] Add option to specify ramp period by amount of IO
Message-ID: <he6xudnbje7lqwdd7wikgaqvfyhofl57oranzslhckhhjqihag@cbk3rfp6slwa>
References: <20251217160217.15533-1-jack@suse.cz>
 <20251217161722.6357-5-jack@suse.cz>
 <7dab8aa5-3ff1-4031-8c9f-30c2bc8cc050@kernel.org>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7dab8aa5-3ff1-4031-8c9f-30c2bc8cc050@kernel.org>
X-Spam-Flag: NO
X-Spam-Score: -4.01
X-Rspamd-Queue-Id: 8ADA95BF50
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	FREEMAIL_CC(0.00)[suse.cz,vger.kernel.org,kernel.dk,gmail.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.cz:dkim,suse.cz:email,suse.com:email]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Level: 

On Thu 18-12-25 08:03:36, Damien Le Moal wrote:
> On 12/18/25 01:17, Jan Kara wrote:
> > In some cases the ramp up period is not easy to define by amount of
> > time. This is for example a case of buffered writes measurement where we
> > want to start measuring only once dirty throttling kicks in. The time
> > until dirty throttling kicks in depends on dirty limit (easy to figure
> > out) and speed of writes to the page cache (difficult to know in
> > advance). Add option ramp_size which determines the ramp up period by
> > the amount of IO written (either by each job or by each group when group
> > reporting is enabled).
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  HOWTO.rst        |  7 +++++++
> >  fio.1            |  6 ++++++
> >  options.c        | 11 +++++++++++
> >  thread_options.h |  2 ++
> >  time.c           | 50 ++++++++++++++++++++++++++++++++++++++++++++++--
> >  5 files changed, 74 insertions(+), 2 deletions(-)
> > 
> > diff --git a/HOWTO.rst b/HOWTO.rst
> > index 9f55a73bde05..49ebae6275a6 100644
> > --- a/HOWTO.rst
> > +++ b/HOWTO.rst
> > @@ -715,6 +715,13 @@ Time related parameters
> >  	:option:`runtime` is specified.  When the unit is omitted, the value is
> >  	given in seconds.
> >  
> > +.. option:: ramp_size=size
> > +
> > +	If set, fio will wait until the workload does given amount of IO before
> > +	logging any performance numbers. Similar considerations apply as for
> > +	``ramp_time`` option. When the unit is omitted, the value is given in
> > +	megabytes.
> 
> Hmm... It may be less confusing/easier to use the regular fio "int" parameter
> type here, which takes all the kilo, mega etc suffixes. This means that the
> default without any suffix would be bytes, not megabytes.

Well, this argument also takes all the kilo, mega, etc. suffixes. Just
without any suffix it will default to MB. I've copied this behavior from
'size' and 'filesize' options which behave like this striving for some
consistency. That being said I don't really care deeply about the behavior
without units because I think sane people write the units explicitly.

> Other than this, this looks good to me, and indeed super useful when testing
> file systems with buffered I/Os so that the initial super fast buffering spike
> is easily not accounted for.

Thanks for review!

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
