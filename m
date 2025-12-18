Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DE254C92
	for <fio@vger.kernel.org>; Thu, 18 Dec 2025 17:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766078302; cv=none; b=jca+rO8+4s4kmUKtC9poeFtX3ULuR5LG4z7bjIBILTa0McPLXvLzDQvxrEeySZhBykLwi5xecBUK2lBGdsrlUwssBtuIkZVP7WScYuw+XHM7/4SqM3zDlSLHKFVcNx8Yd9Shscz7cUBvAU1T0lxlgiHo+vHoo+PZmI8M0FQtFPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766078302; c=relaxed/simple;
	bh=JM+Wb/suwzhYkG9x08z8MMljtNLj8jsQLw/ACkE+y+k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sOjLTE3ZjJfGcSglEeg8Udd7ZOUIL0IJYD8dWmd3t3A/4YoPr678HIEdPw5Q89ZvHKoMI2fFBhO+aEItLJXVZeu79BU75c29QkE9EIUhdS71uFWa/IK+cyJPgLhxYvCfw39u+JxxIrTHwLVnzHimtAJwcRYQe5OLfqPjmLdq/Rw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=qVFWk9l3; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=fkT89QdP; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=qVFWk9l3; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=fkT89QdP; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="qVFWk9l3";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="fkT89QdP";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="qVFWk9l3";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="fkT89QdP"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 23AFF5BE46;
	Thu, 18 Dec 2025 17:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1766078298; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nqZMP84f1n6f4AH58rsNeW/9RCIafjADa0DjSzsfVtI=;
	b=qVFWk9l3q/COCbVvLp66u51eW0IlYzcJDeGAFtlcRIdTA1X6f4TBZ9hbd6446CsrfIbedd
	bub5BNPT9sXJRzz4uLHP9kR/6buAi82CrKjuPI7XPygTF4dvV1VenTrsmFQ2oA1/n0HT5D
	FQvY4e96h0vdvNlaq764LPnV3mGWXns=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1766078298;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nqZMP84f1n6f4AH58rsNeW/9RCIafjADa0DjSzsfVtI=;
	b=fkT89QdPK/BLvLjJlXxGHLpfBGcTjz7uoWqa1e04Opa7rWDi2EvdCGSsdpcst5gYenmJd8
	RWwxljDPimDYrlCw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=qVFWk9l3;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=fkT89QdP
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1766078298; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nqZMP84f1n6f4AH58rsNeW/9RCIafjADa0DjSzsfVtI=;
	b=qVFWk9l3q/COCbVvLp66u51eW0IlYzcJDeGAFtlcRIdTA1X6f4TBZ9hbd6446CsrfIbedd
	bub5BNPT9sXJRzz4uLHP9kR/6buAi82CrKjuPI7XPygTF4dvV1VenTrsmFQ2oA1/n0HT5D
	FQvY4e96h0vdvNlaq764LPnV3mGWXns=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1766078298;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nqZMP84f1n6f4AH58rsNeW/9RCIafjADa0DjSzsfVtI=;
	b=fkT89QdPK/BLvLjJlXxGHLpfBGcTjz7uoWqa1e04Opa7rWDi2EvdCGSsdpcst5gYenmJd8
	RWwxljDPimDYrlCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1A9A13EA63;
	Thu, 18 Dec 2025 17:18:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 3MJ5Blo3RGngNwAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 18 Dec 2025 17:18:18 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id D7351A0918; Thu, 18 Dec 2025 18:18:17 +0100 (CET)
Date: Thu, 18 Dec 2025 18:18:17 +0100
From: Jan Kara <jack@suse.cz>
To: Vincent Fu <vincentfu@gmail.com>
Cc: Jan Kara <jack@suse.cz>, fio@vger.kernel.org, 
	Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 5/5] Add option to specify ramp period by amount of IO
Message-ID: <j64gvowvjtdgwexf5hl5pneh35fu74o7yloy2zp2bejjig7pbi@ws6ufq2glv4b>
References: <20251217160217.15533-1-jack@suse.cz>
 <20251217161722.6357-5-jack@suse.cz>
 <CAOp=CXkbuuue6N=VVkqOX_vnsR+urtJWcizTTOG9LOWeCeihFA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOp=CXkbuuue6N=VVkqOX_vnsR+urtJWcizTTOG9LOWeCeihFA@mail.gmail.com>
X-Spam-Flag: NO
X-Spam-Score: -4.01
X-Rspamd-Queue-Id: 23AFF5BE46
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
	FREEMAIL_TO(0.00)[gmail.com];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	MISSING_XM_UA(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.cz:dkim,suse.cz:email]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Level: 

On Thu 18-12-25 10:19:12, Vincent Fu wrote:
> On Wed, Dec 17, 2025 at 11:17 AM Jan Kara <jack@suse.cz> wrote:
> >
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
> >         :option:`runtime` is specified.  When the unit is omitted, the value is
> >         given in seconds.
> >
> > +.. option:: ramp_size=size
> > +
> > +       If set, fio will wait until the workload does given amount of IO before
> > +       logging any performance numbers. Similar considerations apply as for
> > +       ``ramp_time`` option. When the unit is omitted, the value is given in
> > +       megabytes.
> > +
> 
> At the very least the documentation should explain how this options works with
> reporting groups.

Right, I'll improve that.

> Currently this patch compares the running total of the group's bytes to one
> job's value for ramp_size and then declares ramp time over for all jobs in
> the group if the threshold is exceeded. A little more thought should be put
> into potential use cases here. Should fio allow ramp_size to differ among jobs
> in a reporting group? Consider adding an option to enable/disable connections
> between jobs in the same reporting group.

My intention (somewhat inspired by the steadystate logic) was that IO of
all jobs in the group gets summed together and the specified limit is the
amount of IO for the whole group as well. This was motivated by the usecase
where you have multiple tasks doing buffered writes and you want ramp up to
terminate once they together write given amount of data. I didn't even think
of a case where ramp_size for different jobs in one group would be different.
Now that I'm checking steadystate logic, it rejects configs where different
jobs in a group have different configurations so if I add this consistency
check to ramp_size would you be fine with it?

I think connections between jobs are a bit of an overkill at this point - I
don't have a usecase for that...

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
