Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E89A14F70
	for <fio@vger.kernel.org>; Mon,  2 Feb 2026 15:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.133.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770045761; cv=pass; b=M24lb1XZjUxUCSzN5/aG9opiTG9UJrkwDFyizf6jH/SVOLfUvX8McLSKUTUKLseBETfgR+0VdbYlhpAN+3xrSqmlvXkEF13vAIUuJoSRqJuIs/edMhM8YI0pSm7UAHV76A8/OlLnSIKlhkjYM65N6BgbAludRg/sag+YO8WZWYQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770045761; c=relaxed/simple;
	bh=955kNaT0jYR9/e6cqavrJXfhTSjkzEQZuJ3xa4fL7oI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qBwYPIBEsf6j3sL1rgBKg99tFfbvwEnSYsLdFFqset3I+nLVnHgn+0kFgO2vgMcDR3Lle9DZgVhe3Yc/9yE7dmpB0Bz2UwtiHYS26WRK9c9wvDYj/0/Gij5tYxjp/zdi0sYXpZXh7RPX9fTjLMH/Oy/0oMbx+l3k4ZAFGKkA6Ik=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Xb9uKCz1; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=dxZdf93U; arc=pass smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Xb9uKCz1";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="dxZdf93U"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770045759;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=955kNaT0jYR9/e6cqavrJXfhTSjkzEQZuJ3xa4fL7oI=;
	b=Xb9uKCz1meEYIIx29ETUhzSqesqjx7duGFLzqBhdAtYRbL7R71wq5adq0SvsZ+yNqXgKDx
	dpWFXIufxlNuALzCnuhW7qLEvt8NNWhucQSiWscVYIULaKS9NoZnusKqT1rPm7xUnPbW2o
	43p8/Ofbt1DRjTvebKDi6+4RGlL+jDg=
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com
 [209.85.128.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-86-ynCyp2mdOM-IX-38mseXQQ-1; Mon, 02 Feb 2026 10:22:38 -0500
X-MC-Unique: ynCyp2mdOM-IX-38mseXQQ-1
X-Mimecast-MFC-AGG-ID: ynCyp2mdOM-IX-38mseXQQ_1770045757
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-7943aea6515so63150037b3.1
        for <fio@vger.kernel.org>; Mon, 02 Feb 2026 07:22:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770045757; cv=none;
        d=google.com; s=arc-20240605;
        b=ZmK78p1retXcXKdcDRogmH+X7Rbomqzm31++gvQ2FEvhnBVTV+QWi42iam54cMnlxp
         sY02aQLkzTcw1Bv12OGV6Fs/GUb9SQ5svu+s11gKI7fy6t/2ORfyfbw9troO3nTtUar1
         oL3Li70ZdhC3TSWCnaiSmFYXn3bodeN6EVX8PpyUyOrdPaVXwOtC3m0pIzIv3hwMf0PS
         U4KciHXXwouJRObLRRdlWUZ0Y8ydOJFPs4ctpZLxqWY/16yyiE7aEpgC9l2bQiycjN2n
         nTcCuew9lCt2t/OC3/MSCl0OyVcukqIgBmOb/KLVbrqSdY8XK9Y0n3HRJG7s0tstnZhK
         fm3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=955kNaT0jYR9/e6cqavrJXfhTSjkzEQZuJ3xa4fL7oI=;
        fh=kZv64FkAt+IJj64ephMudw7AXT/Skwy6SGBz5S7TaHM=;
        b=SQEZnztc+0l2o/s9kPT7RylfEL5zldd0nrbJt/fSzVU7K3fQIqu9OSMwU47wTgJCb4
         evkxUXXE2+8aVvlcgwMYvSBDIllbbj9zlIsrddt4mWhJjEmmMVSgkbjq7ZxWGFF9p9Mv
         IdXtSGp8q+ui1PaIQvdtlmMWxnIDYWM6duWsfsCO3JgKMxDJS3aEr2fWE88s9zXuOV9R
         tCuWaYW1ucwQgbeswnItZAn+FqISqJGP84k6ObUvToHNljuYcuuMa8fAhPU/nj9cNMId
         pH02Qnm0jhui89Fs245OJ42ArhTMOlW26RSZRE41FYVh8wqAii0HxdtjZ1aREsMPnTyE
         Ks4Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1770045757; x=1770650557; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=955kNaT0jYR9/e6cqavrJXfhTSjkzEQZuJ3xa4fL7oI=;
        b=dxZdf93U/xZWnv8xUh4V4UewKZHS/3bbHfYIhSfT+HCsm15ZK0UqW7Z6xoC1TnmpJw
         mFixFg9eRVNHTawo9rc+z01En2HtYxflG1xYFy7Oqn0WH4vi/MZijZp4aH4ys9Qv9Kzo
         vZHdgAt1M4Tq4Ip1NtAedzlpEl/z8p0JcwL+xtTRGeEhqjuakZpyDMw5BmaRMk/5bTpV
         Q7kFDlfCmJM8Gh2b/FLPQnwQToc5D6OmNMMke9NzUPcMzCqejl3XrNeATIigrG1TjTxE
         IJZ/b30/uNDA9BZX8AgCFZhG16r4sMnhOivErYQLBANdFs5h35zjyVHgwYprU1bhOSIJ
         Xc/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770045757; x=1770650557;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=955kNaT0jYR9/e6cqavrJXfhTSjkzEQZuJ3xa4fL7oI=;
        b=RP8AkXK7PUbsiBN7yoT+ydIlDSm7ourgmrPWQ0mcILcahTf6pYVgJIQ/4V4dqO2gaO
         LQOFJ1byu2CXNK0WxiBVA5UP5hJG2r5YSCC1mKYyXitJyr/aDedovlo72OtiOr2nz8Yp
         P+RkXKL2QnoUD/Ub3WnUM5jU078gBlLfRAzrowKP3Ef/3VugPe70xs//e8FgLaMZbKEv
         aRnsr66h9NJyNaLYJpg8pQ4ZpWYUPMZAqzq+l5pJhW4+zX9wGU5hpAa/ROsRM50pHciu
         +G84gdeEf1RzoMgouGQc9vIGhuWhLzdzEqYirNx47z00pPHn69NEdlUwoZ4pTP0UrFVS
         FKtw==
X-Gm-Message-State: AOJu0Yw42grgpKk8/CpiOjaqCTKZ/ojzCbQneozGK0Gfl6x/o6kDESMk
	RyFKqABCRIME2vsLNMsoNkNquTiAKz3sMGRAuSBgcowKpjJfiZnF5eqUVKGZRKtBBcAT35wFM3Y
	k1s7ST0eNsSjBLJiyG/4nkDKTaDom/q8+6Tid8BKAwthHbYv5FNdtEWOhRQg7dTiTLQQgt3mP1m
	4o15kC/8N0H373fOysrcdNkRYx9cft
X-Gm-Gg: AZuq6aLWhWX26ZAK3bu/wU4z1jzD7JBBzfX/UX7prCpwVNHXjwTABHKNjvvzv7S5nSr
	EKvJqQkL0c1b8lM300jkuGfqRrHddOH0GmQyf3o1QU7TbG4eWhSyQtW/TsAYGfBvXz67seZJKSG
	6io36fsXdb0wFhGpqQkzHl/zsXD+nKn3QJJjppcMKmL0YoxnvLd2G8QT2KGLqe9Dg6
X-Received: by 2002:a05:690c:dc7:b0:794:9812:a526 with SMTP id 00721157ae682-7949dfb97eamr96436097b3.41.1770045757339;
        Mon, 02 Feb 2026 07:22:37 -0800 (PST)
X-Received: by 2002:a05:690c:dc7:b0:794:9812:a526 with SMTP id
 00721157ae682-7949dfb97eamr96435877b3.41.1770045756968; Mon, 02 Feb 2026
 07:22:36 -0800 (PST)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260129184302.34887-1-npache@redhat.com> <e1509431-d6a9-4644-b52b-118f10672a0b@kernel.dk>
In-Reply-To: <e1509431-d6a9-4644-b52b-118f10672a0b@kernel.dk>
From: Nico Pache <npache@redhat.com>
Date: Mon, 2 Feb 2026 08:22:11 -0700
X-Gm-Features: AZwV_Qgj_BwW3TWv_dNUNqATWQ3yWT64Osm0394elQua73JRjwnG0iWsvPyQZU8
Message-ID: <CAA1CXcCH9+iPxxuAEOzBmTPyR9YyhhVGs9BDeUXwWYXvV--Zcg@mail.gmail.com>
Subject: Re: [RFC 0/2] Introduce a page_fault ioengine for MM workflows
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, vincentfu@gmail.com, david@kernel.org, 
	willy@infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jan 31, 2026 at 6:59=E2=80=AFAM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 1/29/26 11:42 AM, Nico Pache wrote:
> > This series introduces a new page_fault ioengine and a follow?up option
> > to make khugepaged behavior more deterministic for page fault testing.
> >
> > The first patch adds an mmap?backed ioengine that allocates anonymous
> > memory and copies data on read/write to intentionally trigger faults.
> > This enables using fio?s existing framework and job files for memory
> > management style workloads without relying on a filesystem. An example
> > job file is included to demonstrate usage.
> >
> > The second patch adds a hugepage_delay option to the new engine. It
> > initially maps memory with MADV_NOHUGEPAGE, then (after a configurable
> > delay) switches to MADV_HUGEPAGE via a helper thread. This makes
> > khugepaged candidates reproducible, allows for easier khugepaged testin=
g
> > and improves repeatability for page_fault tests.
>
> Looks pretty clean - echo what Vincent added on the option that should
> be an engine specific option, but outside of that, the formatting of
> the code is all wrong. Please follow the style of the code that's in the
> repo already, which means:

Thanks! Yeah the engine specific option makes total sense, I will fix
that. That should also allow me to add some other functionality to
this engine :)

>
> 1) Placement of braces
> 2) Tabs are... tabs, not 4 spaces. The code is a mix and match of this.
> 3) Appropriate empty lines after variable declarations
> 4) Style of switch case (indentation and braces)
>
> etc. It's a good start to just use the clang format from the kernel,
> that should get you basically to where you need to be.

Sounds good! yeah sorry, didn't really consider the formatting at all
for the RFC, was just trying to get the idea out, and make sure there
were no glaring issues!

Thanks for the review!
-- Nico

>
> --
> Jens Axboe
>

