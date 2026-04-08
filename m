Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C502D332ECC
	for <fio@vger.kernel.org>; Wed,  8 Apr 2026 13:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.133.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775654583; cv=pass; b=p/sak7XZKJZjCZgiwEYoUNCFSx2VFupWCpX5BHw/0VXjsvz+u+XVgF4Admmm5ZHqUWrlqvdQCgszfHnu4ZrcU1aQhx/UjK/zqW7Ngmg+y+qW4epkEw5O5z56EeFgwjmeHI1f+srnJ7+RulApsR1zCszlKd1k2hjDLkJ1LJd5Mjc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775654583; c=relaxed/simple;
	bh=1NlVvPCp7yZLdwihA+bNUzxr4RnrXuD8iaRTvpYhboo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jjRrPzf6EYz1ur9h+ZjyL1D0Q3EagD+QcH4uMUQOkYWGlz+lYSz6WXt+GMRAbSk+8cH+6qnGnVDfr+PAtxMeumf7bh/gAYIRxQzAVQ4Tn+qc4c66+3/Qv9nhnTy6J77hh6oWOyqZERDhP2lytc3sh5nLVf3/2XLUzcBFHCikfoE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gU9on6iW; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=In4av0Qm; arc=pass smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gU9on6iW";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="In4av0Qm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775654579;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BKhYmXf8RJm7m+LbrnGFgIJtf/wyuFierxap6ClRI1g=;
	b=gU9on6iW68FwP5fGMajvKM86nQuE3cphvJYXrRHFWkBMgMnDOY9QbGNqp+puLl2VjYrFVW
	cajlFwkOPQ5ac/nPFr2p2Of8dS9LHIBZ6uVhNuFQogpcUaehfzkWIyfRw0wv3JbZiiPBB6
	Hhy8lUhxwxn5tLDEr4PGuqbJP+B8/3s=
Received: from mail-yw1-f199.google.com (mail-yw1-f199.google.com
 [209.85.128.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-215-8DVI2WvJOMqkUKejFWKQ3g-1; Wed, 08 Apr 2026 09:21:42 -0400
X-MC-Unique: 8DVI2WvJOMqkUKejFWKQ3g-1
X-Mimecast-MFC-AGG-ID: 8DVI2WvJOMqkUKejFWKQ3g_1775654502
Received: by mail-yw1-f199.google.com with SMTP id 00721157ae682-7982c3b7da7so74883137b3.1
        for <fio@vger.kernel.org>; Wed, 08 Apr 2026 06:21:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775654502; cv=none;
        d=google.com; s=arc-20240605;
        b=AwsGxwO/lmW2D/YYUpO94t/PnUFAw2Ra1Tu7dMjRmW0h9P19S42Jx9hC0PYROax1Vr
         B2RZpDskhQT9swnR+blZtXuhJbZMgdC1KeQh/jmfQM+SdzeTPFOelvenwUuaaAvP0UlI
         3lxd6WrzptP46faMboSEnbQWtJOLpzRQ8M7A7Ms3p4gLdFTvhfjUeD3R/kkTDmlZzwaL
         AhFca032y4lRHEauBnoYG7O3Px/mWZnZ45rk1+wM/mSltHgCrLg8taTksfL5q+1Ag+od
         xssqLzh1jlBkx/XXv3xmSiA1OhbXqAGuajS2KpeCJ8Zb4oISrdw7P3QBnCfAo/Iud77h
         /btQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=BKhYmXf8RJm7m+LbrnGFgIJtf/wyuFierxap6ClRI1g=;
        fh=suu+GzAxzwltfA6ZtPT3FMjBnku+UKBsUacoU4Bqc6s=;
        b=astWYz3+Sfa6CitsIWYi98IYCsTyzUZh83kBnR+OwmY+iG8g8fdwK1DtyNWOaA8Z9i
         jBrqY+LliC+cr2CMd1Mw25YNQ/eXkr4IlO5jzry43vazB8pNT0xVZHMqgXpKo3G+jkUb
         AFvA3ZUMTip7+DgIqpiodrK2c1sK3pL9C+fgnHGWHHf8AvbpxkfFAzHZfeIXWm/ciXPO
         TCguhpDEpiKFTuPoU7YrHQszG0XVOU0kliIZadXMUnJ7qlcu8fxYV1PdKfiZRCf2svHL
         R/q6nTxf6J2g2sYM5tWfXf9jp+P//+JvnM9J8gEwV0JgzzDOwbh9UCiy85I667Hvpmlp
         SbnQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1775654502; x=1776259302; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BKhYmXf8RJm7m+LbrnGFgIJtf/wyuFierxap6ClRI1g=;
        b=In4av0Qm+YsknpNn0Q/K0gmUPwgdPkv+2YdFFiMsCklrOkbcZ8zGidhW0ziYIJdI88
         i9fxzklAsgkCvsJ6Uqynk82GycvACRr1Zszn9fAUm0K09P1Uc0N7QTRM8aViqxkkfPhD
         7EvX0z+VdNu3m1dQ7B21J39TWfNbCGYP/s5adzZu8e+IAgkDJD36RQwEellTkAAxW+UE
         +iH7qc/BLtjn+3mYKnMUMf6ffncnodUk8aJN65uNwwyXtUONEGutwKvKhTkef6Pn5Eyv
         uA/n/JdwcoUk5IbUox6t5eR6k+jn7EoG0zbT5o63v9GPkZubevowUJiL+QIEQP+bc/EN
         ad5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775654502; x=1776259302;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BKhYmXf8RJm7m+LbrnGFgIJtf/wyuFierxap6ClRI1g=;
        b=BIZ2O3fEsXEc5FwysgkSvYggZ1KW0hc0kDtWfo4nVXQMtxoLrYn9ufj1B4HUjRxb2o
         y+yU8tCZkD/IWe2/ludpr1vcEYL/Ro/kDh9qFq4Cvo9RAaFuqUyoeuqQiH3xuf2l2A4r
         dw8KSA28sJPI/REgyLm/Sh+U1a5QQtBU+xcPO2CFI5EQa0ZxcuZ+Yac5T2pS3QtOPKKu
         Rx0PnwP/6mA0Cze1ApIT60qH9eYBfZJuOdkEDkCj4U2znnKVWdvLwEqfOYQmismoweue
         ouaa1I8tnHmWEgDEBGofW5Pfnn8RsUuQZABwQ2Ci7OVxK0oeyWdRP8Ib2w7myje1JawK
         JD5g==
X-Forwarded-Encrypted: i=1; AJvYcCVRMu3QPoQGOpOCRGE9IiqnHF4h7xbSh1UrKylsGC5JCqbDtOZ09Yc2Z1XIITAmW6xlOG8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxwC8z30l6+SzbootFQyad8bRgX6WDLavGipgM6cwHuL6I5hthC
	XD+Yi4Z5W4RqpJFa5Wvx2+9vaCgu2rMYBt6U1pioiE4Zsg8Kbz9wSM2LrT6nCBRI7kzhyQPJjqO
	cUvEvXhKeLrp53nCCrCAU1RcPcdUkRJaxOkNPwGzBdKhqwfjWT5O+SCKBH8pYaT94XNUTLkBsyo
	kEwjYp96sBWeJYPldUAi8Bdy9Ftx0a
X-Gm-Gg: AeBDiev7ctEI0IUTbHPmOGa5uLpLxM8OzFXzIXLfF/qRQArukElFyXE/XohAhA1GkaC
	+XeMDasDPzXZKxG/wtoh78a0s4Mp7/XeLfMkqXrPtCwUNh2DnMyqvV7TfPQ5pMpZMEGhakDoNTf
	kDhhgsm8FFy3glYVnTj8e3aSWi/Fqgthmdy8kgCAFEWdnlG4EAQQcG02GDn8slaSoGd2LdQgdlQ
	5GoDaxo
X-Received: by 2002:a05:690e:c4d:b0:650:3064:4d20 with SMTP id 956f58d0204a3-6504872bc8fmr17284832d50.30.1775654501746;
        Wed, 08 Apr 2026 06:21:41 -0700 (PDT)
X-Received: by 2002:a05:690e:c4d:b0:650:3064:4d20 with SMTP id
 956f58d0204a3-6504872bc8fmr17284787d50.30.1775654501145; Wed, 08 Apr 2026
 06:21:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260408012004.198115-1-npache@redhat.com> <177561370059.278381.14711080737139189772.b4-ty@b4>
In-Reply-To: <177561370059.278381.14711080737139189772.b4-ty@b4>
From: Nico Pache <npache@redhat.com>
Date: Wed, 8 Apr 2026 07:21:27 -0600
X-Gm-Features: AQROBzDh_xIwwCSeKZVD7t6CT5_G94jOR6iSSiY3YdMpM2w0hS_iz62xrAVtemY
Message-ID: <CAA1CXcC+8B9TKFkZO_Wf5zznJGB_zLyXdYX3gZVtOMCTnCxn2A@mail.gmail.com>
Subject: Re: [PATCH v3 0/2] page_fault: add mmap-backed ioengine for anonymous faults
To: Jens Axboe <axboe@kernel.dk>
Cc: vincentfu@gmail.com, fio@vger.kernel.org, jvozar@redhat.com, 
	jjurca@redhat.com, jhladky@redhat.com, peterx@redhat.com, spetrovi@redhat.com, 
	david@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 7, 2026 at 8:01=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote:
>
>
> On Tue, 07 Apr 2026 19:20:01 -0600, Nico Pache wrote:
> > This series introduces a new page_fault ioengine for Anonymous memory
> > testing. This enables using fio=E2=80=99s existing framework and job fi=
les for
> > memory management style workloads without relying on a filesystem. An
> > example job file is included to demonstrate usage and lays the groundwo=
rk
> > for how we plan on utilizing fio to test a number of MM related workloa=
ds.
> >
> > The first patch adds the mmap=E2=80=91backed ioengine that allocates an=
onymous
> > memory and copies data on read/write to intentionally trigger faults.
> >
> > [...]
>
> Applied, thanks!

Thank you! I have more ideas in mind but they will come in waves given
my current workload. Please let me know if you spot any errors, bugs,
or have suggestions for features to add.

-- Nico

>
> [1/2] page_fault: add mmap-backed ioengine for anonymous faults
>       commit: f5ea7d9e1d7c07053f23e764b281a5e47bf01ba3
> [2/2] Documentation: update the documentation to include the page_fault e=
ngine
>       commit: dceeff3a1dd87b5194c84845d77096b3cdb3cee3
>
> Best regards,
> --
> Jens Axboe
>
>
>

