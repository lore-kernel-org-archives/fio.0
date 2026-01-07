Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18D1F3A0B17
	for <fio@vger.kernel.org>; Wed,  7 Jan 2026 17:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767805385; cv=none; b=M+HJXDhN/LvGKaMnX01f6UNppQ6M7JmRxOodubW+2Eg3aOcQw4D0LyGuK3wH/6FSsA9MmDb4b+BIgcxSrNOfu/RbDDy86ok4fv3NrXoiMKzrHlmnOJtKtctfKP6URCA1bwJAHqWd80PRjnHQwzCVHLoWOALXddRMaIcBpKAa8ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767805385; c=relaxed/simple;
	bh=R1/HGKeSbulQt9zdsLeNwdxWJVSODKe/YFGy9rm+0u8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F83pdIfckC+4LgKqQcuX8+mawG3h5vTEHysg9b6caQlBllujfLHgSSoQR+5PSbILBXF/y9YHqJ/KVPUm+BwFknPh0LOLY4GIAenE47Q09j/r2fyW2iQEkdIZlTUrZP0Bw6m5fyjA9zx5fCu7/LAcCWQtUeBTOIZWZ+VEuviuKRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=wMIp3CFf; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=ouc2hE0O; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=3C0+wnen; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=al6EUNyh; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="wMIp3CFf";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="ouc2hE0O";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="3C0+wnen";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="al6EUNyh"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id EF22F34077;
	Wed,  7 Jan 2026 17:03:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1767805381; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YphaWqRjqW5W7srg3ckQwvF8mL+5oCduZsqAuzTW60o=;
	b=wMIp3CFfB6xt0fqIC4aIq4hxJUtMPdB/m/l02Ss4M67/MCy/IFVkxpxclAe4RrUpHL0r6W
	Dlts0+HbCwl4nbhQUBPADI9AjqGA2BogtvT6jJKrRcok0ft2XQPr/wxdKYGX4bPUahcmhq
	SZlr1chQH8MG2tCg1cJjjOXYyJdZ5us=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1767805381;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YphaWqRjqW5W7srg3ckQwvF8mL+5oCduZsqAuzTW60o=;
	b=ouc2hE0OA16+QLpSxSaQCdz8Ohwpv+2RPAByHxX1gHHxnfqx7AihMRNg6CI8y3qmiox1NQ
	XEaxG8EKTWAapUBA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=3C0+wnen;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=al6EUNyh
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1767805380; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YphaWqRjqW5W7srg3ckQwvF8mL+5oCduZsqAuzTW60o=;
	b=3C0+wnen+WtdIRMv9/I9XT8aBZqqVLARScjuQyqhnEkKGxreXerHfdMOC10EeCXlJ0XT4f
	ofOYKoBDeUTkIa4O5FjFuN8QrToDmNB+6vX0TDNiAqAxRvUe6UReTGYzp04fT1g1aS/dPA
	gCBukPvxcHEXn09BmJaeY6aMDLia6WU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1767805380;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YphaWqRjqW5W7srg3ckQwvF8mL+5oCduZsqAuzTW60o=;
	b=al6EUNyhIz2FGOo3P8Kh+e8z9KhOafMnpu3/1CSFJGXN9PJgqGHqiJKNeI1Rz7zHCYUvM7
	5ubs+JPlLFvyESAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E2E1B3EA63;
	Wed,  7 Jan 2026 17:03:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id lXpeN8SRXmmlXQAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 07 Jan 2026 17:03:00 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 6A494A0858; Wed,  7 Jan 2026 18:02:52 +0100 (CET)
Date: Wed, 7 Jan 2026 18:02:52 +0100
From: Jan Kara <jack@suse.cz>
To: Vincent Fu <vincentfu@gmail.com>
Cc: Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>, 
	fio@vger.kernel.org
Subject: Re: [PATCH v2 0/5] Add support for specifying ramp up period by
 amount of IO
Message-ID: <6c4o2uapq7t4tj52lvxrq4vxfiprvbp2lbdzcdbew6b6qmh7ur@kttcfiv2wrg2>
References: <20251219133853.8548-1-jack@suse.cz>
 <CAOp=CX=fRTQnd=CEM9=7fprFF=gbK+Gs37AiHxh3-ivdiRLcqA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOp=CX=fRTQnd=CEM9=7fprFF=gbK+Gs37AiHxh3-ivdiRLcqA@mail.gmail.com>
X-Spam-Flag: NO
X-Spam-Score: -4.01
X-Rspamd-Queue-Id: EF22F34077
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
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	MISSING_XM_UA(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:email]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Level: 

Hello!

On Wed 24-12-25 14:44:13, Vincent Fu wrote:
> On Fri, Dec 19, 2025 at 8:43 AM Jan Kara <jack@suse.cz> wrote:
> > In some cases the ramp up period is not easy to define by amount of time. This
> > is for example a case of buffered writes measurement where we want to start
> > measuring only once dirty throttling kicks in. The time until dirty throttling
> > kicks in depends on dirty limit (easy to figure out) and speed of writes to the
> > page cache (difficult to know in advance). This patch series adds to fio an
> > option to specify ramp up period in terms of amount to IO - i.e., the ramp up
> > period finishes once given amount of IO is done.
> >
> > Changes since v1:
> > * Improved documentation to explain behavior with group reporting, replace wrong
> >   note about default unit being megabytes
> > * Add sanity checks for inconsistent ramp_size values within reporting group
> >   and usage of both ramp_size and ramp_time for a single job.
> > * Fix fio server support for the new option
> >
> >                                                                 Honza
> >
> > Previous versions:
> > Link: http://lore.kernel.org/r/20251217160217.15533-1-jack@suse.cz # v1
> 
> I see some evidence that this series lowers reported performance levels.

Thanks for reporting. I had a look and on my machine it actually improves
reported performance levels:

	    AVG	     STDDEV
old  50818766.4  845445.763
new  54965054.6 1113699.088

But IMHO this is mostly just a benchmarking noise due to changes in code
alignment wrt caches and possibly data structure alignment as well. Just if
I do two compilations of the same sources I get easily a difference in
averages ~2 million ops (i.e., ~4%). So at this point I don't think it's
really worth it to worry about...

								Honza

> I measured 13.7-13.9M IOPS before applying this series but 13.5-13.6M
> IOPS with these patches applied.
> 
> https://github.com/vincentkfu/fio has these patches applied.
> 
> vincent@meeki:~/fio-dev/fio-canonical$ ./perftest.sh
> fio-3.41-65-gd028 **current tip
>   read: IOPS=13.7M, BW=52.2GiB/s (56.0GB/s)(522GiB/10000msec)
>      issued rwts: total=136806337,0,0,0 short=0,0,0,0 dropped=0,0,0,0
>   read: IOPS=13.8M, BW=52.6GiB/s (56.5GB/s)(526GiB/10000msec)
>      issued rwts: total=137832044,0,0,0 short=0,0,0,0 dropped=0,0,0,0
>   read: IOPS=13.8M, BW=52.6GiB/s (56.5GB/s)(526GiB/10000msec)
>      issued rwts: total=138017790,0,0,0 short=0,0,0,0 dropped=0,0,0,0
>   read: IOPS=13.8M, BW=52.8GiB/s (56.7GB/s)(528GiB/10000msec)
>      issued rwts: total=138339173,0,0,0 short=0,0,0,0 dropped=0,0,0,0
>   read: IOPS=13.7M, BW=52.3GiB/s (56.2GB/s)(523GiB/10000msec)
>      issued rwts: total=137141350,0,0,0 short=0,0,0,0 dropped=0,0,0,0
>   read: IOPS=13.9M, BW=52.9GiB/s (56.8GB/s)(529GiB/10000msec)
>      issued rwts: total=138603471,0,0,0 short=0,0,0,0 dropped=0,0,0,0
>   read: IOPS=13.8M, BW=52.5GiB/s (56.4GB/s)(525GiB/10000msec)
>      issued rwts: total=137722819,0,0,0 short=0,0,0,0 dropped=0,0,0,0
>   read: IOPS=13.8M, BW=52.7GiB/s (56.6GB/s)(527GiB/10000msec)
>      issued rwts: total=138275811,0,0,0 short=0,0,0,0 dropped=0,0,0,0
>   read: IOPS=13.8M, BW=52.5GiB/s (56.4GB/s)(525GiB/10000msec)
>      issued rwts: total=137584790,0,0,0 short=0,0,0,0 dropped=0,0,0,0
>   read: IOPS=13.8M, BW=52.7GiB/s (56.6GB/s)(527GiB/10000msec)
>      issued rwts: total=138181955,0,0,0 short=0,0,0,0 dropped=0,0,0,0
> 
> fio-3.41-70-g19ea **with series applied
>   read: IOPS=13.6M, BW=51.8GiB/s (55.6GB/s)(518GiB/10000msec)
>      issued rwts: total=135851169,0,0,0 short=0,0,0,0 dropped=0,0,0,0
>   read: IOPS=13.6M, BW=51.7GiB/s (55.6GB/s)(517GiB/10000msec)
>      issued rwts: total=135621968,0,0,0 short=0,0,0,0 dropped=0,0,0,0
>   read: IOPS=13.6M, BW=51.8GiB/s (55.7GB/s)(518GiB/10000msec)
>      issued rwts: total=135896609,0,0,0 short=0,0,0,0 dropped=0,0,0,0
>   read: IOPS=13.6M, BW=52.0GiB/s (55.8GB/s)(520GiB/10000msec)
>      issued rwts: total=136300772,0,0,0 short=0,0,0,0 dropped=0,0,0,0
>   read: IOPS=13.6M, BW=51.9GiB/s (55.8GB/s)(519GiB/10000msec)
>      issued rwts: total=136113441,0,0,0 short=0,0,0,0 dropped=0,0,0,0
>   read: IOPS=13.5M, BW=51.6GiB/s (55.4GB/s)(516GiB/10000msec)
>      issued rwts: total=135364363,0,0,0 short=0,0,0,0 dropped=0,0,0,0
>   read: IOPS=13.6M, BW=52.0GiB/s (55.9GB/s)(520GiB/10000msec)
>      issued rwts: total=136375631,0,0,0 short=0,0,0,0 dropped=0,0,0,0
>   read: IOPS=13.5M, BW=51.5GiB/s (55.3GB/s)(515GiB/10000msec)
>      issued rwts: total=135055043,0,0,0 short=0,0,0,0 dropped=0,0,0,0
>   read: IOPS=13.5M, BW=51.5GiB/s (55.3GB/s)(515GiB/10000msec)
>      issued rwts: total=135058705,0,0,0 short=0,0,0,0 dropped=0,0,0,0
>   read: IOPS=13.5M, BW=51.5GiB/s (55.3GB/s)(515GiB/10000msec)
>      issued rwts: total=135092086,0,0,0 short=0,0,0,0 dropped=0,0,0,0
> 
> This is the script I ran:
> 
> --------------------------------------------------
> #!/usr/bin/env bash
> 
> ITERATIONS=10
> 
> echo $(./fio-old --version)
> for (( i=0; i<$ITERATIONS; i++ ))
> do
>     ./fio-old --name=test --ioengine=null --filesize=1T --time_based
> --ramp_time=5s --runtime=10s | grep "read:\|rwts"
> done
> 
> echo
> echo $(./fio-new --version)
> for (( i=0; i<$ITERATIONS; i++ ))
> do
>     ./fio-new --name=test --ioengine=null --filesize=1T --time_based
> --ramp_time=5s --runtime=10s | grep "read:\|rwts"
> done
> --------------------------------------------------
> 
> Vincent
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
