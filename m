Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C51644C92
	for <fio@vger.kernel.org>; Thu, 18 Dec 2025 17:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766078322; cv=none; b=iL4X4NfbWiS7kcf4+2/hwTaaPSOOUiWmImGRPqUvmDL9V3k5/8PnJQHt6AUEQQUi2bNf7J/2MHbL743IqbryQ/5v+MJrJ30q9sdfe3x2v8NJFF94BX53K745yrP5Cv6tzs6o/m1+zSa11XvooY2qgmf+YA3SLEbxUP/38e85b7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766078322; c=relaxed/simple;
	bh=/qjzBtBxrfwaeRn7Eaz1eaJJGPSUA5C+0kvsOys9fmY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Hwwr78W5U4XVVj3e/z17sJ96t+ZEHZT1qQ+4d0M8vDH4XmaGouRAHxYo8bSCgIVt6mjAQPbrFMAYAbKezeIyyS/dlFQFjMLBz+CX6ILhQB476fw3o4oNiwdpzUt9J0T1lVCisxeQ0OTby22MjICfhp9OpHrh3Yf4YEisNp/sOMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=JU6GFxQm; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=b9ap0DpD; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=JU6GFxQm; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=b9ap0DpD; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="JU6GFxQm";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="b9ap0DpD";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="JU6GFxQm";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="b9ap0DpD"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 08B825BE65;
	Thu, 18 Dec 2025 17:18:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1766078319; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5QU7xTy+V7n76m+ddKSno3Wgphr1S1qTok+J7p0LHs8=;
	b=JU6GFxQmsfxyLF62tjpZ34Ch34JShUwqnpDCC+RFW/KAp8yJKz9dbe9zdquYxkXP82KESu
	rVh9T4ielw9yYqGaqA+zU/3tItNVXq/Ti5eh9s11tqucyd2Jzrj/idoZ5YjSOKnoSr/mDV
	WdjNzFEmkG9vIowxyfQ7CtHnfUDr7k8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1766078319;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5QU7xTy+V7n76m+ddKSno3Wgphr1S1qTok+J7p0LHs8=;
	b=b9ap0DpDFApu1hut/qarbwj8EhPWGSsT6zmldgSPwGpmYvdfPvqyHrD9MwLbgLXUYS1O+F
	7JnGQZ9aBkiMq3BQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1766078319; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5QU7xTy+V7n76m+ddKSno3Wgphr1S1qTok+J7p0LHs8=;
	b=JU6GFxQmsfxyLF62tjpZ34Ch34JShUwqnpDCC+RFW/KAp8yJKz9dbe9zdquYxkXP82KESu
	rVh9T4ielw9yYqGaqA+zU/3tItNVXq/Ti5eh9s11tqucyd2Jzrj/idoZ5YjSOKnoSr/mDV
	WdjNzFEmkG9vIowxyfQ7CtHnfUDr7k8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1766078319;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5QU7xTy+V7n76m+ddKSno3Wgphr1S1qTok+J7p0LHs8=;
	b=b9ap0DpDFApu1hut/qarbwj8EhPWGSsT6zmldgSPwGpmYvdfPvqyHrD9MwLbgLXUYS1O+F
	7JnGQZ9aBkiMq3BQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 009F83EA63;
	Thu, 18 Dec 2025 17:18:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id oVUmAG83RGnwNwAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 18 Dec 2025 17:18:39 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id C04ACA0918; Thu, 18 Dec 2025 18:18:38 +0100 (CET)
Date: Thu, 18 Dec 2025 18:18:38 +0100
From: Jan Kara <jack@suse.cz>
To: Jens Axboe <axboe@kernel.dk>
Cc: Jan Kara <jack@suse.cz>, fio@vger.kernel.org, 
	Vincent Fu <vincentfu@gmail.com>
Subject: Re: [PATCH 5/5] Add option to specify ramp period by amount of IO
Message-ID: <6gcxfhhqsiqfjujzp7ypro6keord7g7f4f3zhas7njmmxns4fh@kf32ewhwkbr2>
References: <20251217160217.15533-1-jack@suse.cz>
 <20251217161722.6357-5-jack@suse.cz>
 <be8e2e1b-a77e-4985-b283-9b22fe87144a@kernel.dk>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <be8e2e1b-a77e-4985-b283-9b22fe87144a@kernel.dk>
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[suse.cz,vger.kernel.org,gmail.com];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email]
X-Spam-Level: 
X-Spam-Flag: NO
X-Spam-Score: -3.80

On Wed 17-12-25 15:56:00, Jens Axboe wrote:
> On 12/17/25 9:17 AM, Jan Kara wrote:
> > In some cases the ramp up period is not easy to define by amount of
> > time. This is for example a case of buffered writes measurement where we
> > want to start measuring only once dirty throttling kicks in. The time
> > until dirty throttling kicks in depends on dirty limit (easy to figure
> > out) and speed of writes to the page cache (difficult to know in
> > advance). Add option ramp_size which determines the ramp up period by
> > the amount of IO written (either by each job or by each group when group
> > reporting is enabled).
> 
> Looks fine, but needs cconv additions and bumping of the server version
> number or this won't work on client/server configurations.

Thanks for review. Fixed.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
