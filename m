Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17C241C84DC
	for <fio@vger.kernel.org>; Fri, 19 Dec 2025 13:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766149857; cv=none; b=qv/+OW/7tISL9Gx1Cw0tSKQfxxaGoB6K5Xvsk1wlbga4CkwzOy3qGOOzd8lVBAlCT0FrGkebYCK6GOU6Kcl8N2GgJH+L9xgHTDxWZE5vYoUkdTSNdFTOpeePzsvasF0n3OgeA3Qyg22lknDJpOF7HBRiJo/+mFSIfx+Upei34sU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766149857; c=relaxed/simple;
	bh=mHrwk4x7Sd/4sUlIyBw+wub4zkvr4tsv82UQOqmwIYM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cD7QK7gYAQYMzarHCrZagvMlEqqkTzuKAsE/E5QvY14WjBlF4rRbjulW8eq/ilTgCNjZlR2yfNYxYuIT43XlygJCi6pLWwUx69t335ZmDmq26thjtANsTGW4gON6B8fND+ZqIuE45hlp+0hG9nluKka45H2KSyXI6OK2ZcOLlF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=m3IN4UeL; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=QIJ8Frg7; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=mKf/Une/; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=XXj+VPor; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="m3IN4UeL";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="QIJ8Frg7";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="mKf/Une/";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="XXj+VPor"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D4AE1336B8;
	Fri, 19 Dec 2025 13:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1766149854; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4M8xdze7q+UiIKwuTNYOsHDvMXxOhsTl7Y2MlEXKv+o=;
	b=m3IN4UeLuXFH5xXa3fmVSacYkGQ6AylEJFlm6GfWuUp23edT0WsQGQhEKvPxP11u+aTOsO
	kHARbUD7Yo0zsZ6+a8uLFGbmot8P5lK9LLptTMW0vNC8jUYAz1xoyDsswjm+ZEciAnjQXv
	yPSjy3MW7SA3JLgObhM61rvc4oR/3tA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1766149854;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4M8xdze7q+UiIKwuTNYOsHDvMXxOhsTl7Y2MlEXKv+o=;
	b=QIJ8Frg7EWNV1K8p7Oqa4S39cmlHMWdzQvuSgpaZUPHjM3vTeamC1bzRbLjx0ZqajBusFU
	czM7wOFuUNBMiLAg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="mKf/Une/";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=XXj+VPor
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1766149853; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4M8xdze7q+UiIKwuTNYOsHDvMXxOhsTl7Y2MlEXKv+o=;
	b=mKf/Une/GvT6RGKr8dcVS4lH2R5+CfOJdQtO5T0M+WFMuFaToCWgjAv0jvM3jcBGwambHf
	FBEc2G7MK5sILiFtp+uCVsWFJnTOARSTedpVtDb1IHSW7NgnD0DYa2GAgnsljENwLXnWh+
	n7YFO+s69n1vr/3O5WARwj6vod/qCS4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1766149853;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4M8xdze7q+UiIKwuTNYOsHDvMXxOhsTl7Y2MlEXKv+o=;
	b=XXj+VPorbHojQZ69ijE+oAfb4cdIvwchPUErZZNsXZX0nTcL9CXJOOGgtCIsf4diKdwO2J
	quvhY94g61ztDgCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C8C533EA63;
	Fri, 19 Dec 2025 13:10:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id lN79MN1ORWlnKwAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 19 Dec 2025 13:10:53 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 7B0A1A090B; Fri, 19 Dec 2025 14:10:53 +0100 (CET)
Date: Fri, 19 Dec 2025 14:10:53 +0100
From: Jan Kara <jack@suse.cz>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Jan Kara <jack@suse.cz>, fio@vger.kernel.org, 
	Jens Axboe <axboe@kernel.dk>, Vincent Fu <vincentfu@gmail.com>
Subject: Re: [PATCH 5/5] Add option to specify ramp period by amount of IO
Message-ID: <3orwxlgfpwwpwgzvjiq2b4wtfyqpyknplaadhoxmj7d7tok3rf@dtgcnlr5kvfi>
References: <20251217160217.15533-1-jack@suse.cz>
 <20251217161722.6357-5-jack@suse.cz>
 <7dab8aa5-3ff1-4031-8c9f-30c2bc8cc050@kernel.org>
 <he6xudnbje7lqwdd7wikgaqvfyhofl57oranzslhckhhjqihag@cbk3rfp6slwa>
 <d68515f5-4335-40fd-b9ee-c3017908d3d9@kernel.org>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d68515f5-4335-40fd-b9ee-c3017908d3d9@kernel.org>
X-Spam-Flag: NO
X-Spam-Score: -4.01
X-Rspamd-Queue-Id: D4AE1336B8
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	FREEMAIL_CC(0.00)[suse.cz,vger.kernel.org,kernel.dk,gmail.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.cz:dkim,suse.com:email]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Level: 

On Fri 19-12-25 17:12:02, Damien Le Moal wrote:
> On 12/19/25 01:31, Jan Kara wrote:
> >>> +.. option:: ramp_size=size
> >>> +
> >>> +	If set, fio will wait until the workload does given amount of IO before
> >>> +	logging any performance numbers. Similar considerations apply as for
> >>> +	``ramp_time`` option. When the unit is omitted, the value is given in
> >>> +	megabytes.
> >>
> >> Hmm... It may be less confusing/easier to use the regular fio "int" parameter
> >> type here, which takes all the kilo, mega etc suffixes. This means that the
> >> default without any suffix would be bytes, not megabytes.
> > 
> > Well, this argument also takes all the kilo, mega, etc. suffixes. Just
> > without any suffix it will default to MB. I've copied this behavior from
> > 'size' and 'filesize' options which behave like this striving for some
> > consistency. That being said I don't really care deeply about the behavior
> > without units because I think sane people write the units explicitly.
> 
> Sam here: I do not really mind one way or the other. I raised this comment so
> that the options stay consistent in behavior, same as you aim for.
> 
> Checking with some quick runs, if I run something like:
> 
> fio --name=write --ioengine=psync --bs=512 --rw=write --directory=/mnt \
> 	--filename_format='test.$jobnum.$filenum' --nrfiles=16 --openfiles=1 \
> 	--create_fsync=0 --filesize=1024 --create_on_open=1 \
> 	--allow_file_create=1 --end_fsync=1
> 
> I get files of 1024B, not 1GiB. Same with even smaller values like:
> 	--bs=8 --filesize=8
> I get files of 8 Bytes.
> 
> So I doubt that the default is MiB when there is no unit specified.
> 
> Checking the code, the .interval field of filesize option (and all other options
> in fact) seems to be unused, except by the goptions.c file, which I think is for
> the fio GUI.
> 
> So the default it seems is Bytes when no unit suffix is specified. Your code is
> good then, except the man page and HOWTO files where you should remove the text
> "When the unit is omitted, the value is given in megabytes."

Indeed. Thanks for checking! My experiments confirm that as well. I've left
in the doc comment that "When the unit is omitted, the value is given in bytes."
just for the clarity and I've removed the .interval argument to not add to
the confusion.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
