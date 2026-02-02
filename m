Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79A2B4A3E
	for <fio@vger.kernel.org>; Mon,  2 Feb 2026 15:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.133.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770045874; cv=pass; b=edtrqKU1UfmSb/PtPAYFSSjtI2IEWquQOmucr9mzU/ZllvYr2VkV7Z4AnP+MtHOBDY+JmDGX4jh2wgO1pa/gf//9IyfjGfdAu8rMGpx7k7FWOfdV66V0sZjV7rYj66gGfpeAfSug0ZYd3uDQpFUekylF6dn6pvnmKOy2QfjWcrA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770045874; c=relaxed/simple;
	bh=7XeYlsxUkbMQHAIQqAJuTtRn+P5r7C2k+MrvTn7cN4Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ek5RNKVDNUAeY2aVbwJP/1wiu95jsl0JfjgZ0kgwLfmBj1AkViGJv9EaGde933tl8aILMUwWh13ajt5Nndj8T9fPMaMVOB8D5ukSfKLDePOcdx9TnN73om9LmYwGqxlO1Wk+g51UaPGZUqgcrvFnwgw38rZqiKuvDlUBjIH8zEM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ld8C1WKO; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=AIu9azX6; arc=pass smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ld8C1WKO";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="AIu9azX6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770045870;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7XeYlsxUkbMQHAIQqAJuTtRn+P5r7C2k+MrvTn7cN4Y=;
	b=Ld8C1WKOnF00kRdFKmOT1lQCY4cQGroOnJ3FzxOvRK4r2I9YFyZr6cjr+lPva2l+/VDMuT
	8IMJPu5+PHUE3zVLImVFa0oMrJzc5tLO5eySDiQbKaZZjStesPyq4m9QIiSw21pApphZ/d
	BVKXmlO/IJPqjwI2+pLTdhHVAWornLs=
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com
 [209.85.128.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-696-VjgIx8AIMeyhW_8whkkXQQ-1; Mon, 02 Feb 2026 10:24:29 -0500
X-MC-Unique: VjgIx8AIMeyhW_8whkkXQQ-1
X-Mimecast-MFC-AGG-ID: VjgIx8AIMeyhW_8whkkXQQ_1770045869
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-794b74a8b2bso32468657b3.3
        for <fio@vger.kernel.org>; Mon, 02 Feb 2026 07:24:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770045869; cv=none;
        d=google.com; s=arc-20240605;
        b=jBTQtzO9LNO/3RdB4Y7Syp1bx/eMlgW/zWa7HYfLyh+0yHSGuI+RE/fwvFNvaIX4o+
         pqHnnI3PpVGbjGhOx6Se7ufsoeGc+hDh9Xm7AphwDyiT/T9dcwRX7kL1C2DuBnZWIQLI
         BpnI0+VYgwK8hUGUlnLvr8WtS8OyPJ5xhi1bgHICA0mz8K0faeDNaNXX3CEHFimlmJGr
         2wJT2ExKUTLOFwWIpMbiQ+lJ/5kGIFSkqqICnpgdSQhiwqksC5F9kc23aD/SRtDRXDVm
         k+bkf7zsJl+e5hQ0ooXdha4IizSJ2hSLDZJELpRrqIs69TK4v8jPrBCAjQ2Wmj1sZLzv
         EEUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=7XeYlsxUkbMQHAIQqAJuTtRn+P5r7C2k+MrvTn7cN4Y=;
        fh=CwsOeVgb2sf9k4S+PXfMO+8hlYhrtd01JMaOqRar84Y=;
        b=bK1CaSVpsIdf0FIaM8j5L4vLhFciH7LKjCkeX9TMDjKjmFBPRpAxhLxb7bdWXlngjy
         5mj8CArb3u7ykyV0j7S7UcnaONjODUWmIgkGTLFl5uwSIGV1EvmL+deOU5QYJ3+VWMMp
         5xA3QkeS2gXBkUjn2sp3B5qrT+DtGOSjBzhG4Esu9rc7nZtzHAIbXZATOohbrgJlgt+E
         GEWV0oo6a+mk0V5igKAmYKmvPnDR0oetKTHaEG/LcoJJTnd35msrevfB9kcyIWM2CHRC
         H6L7xGHFs5FwfX7473wXktE2Kak5AgdxTp29CfLTjMqKHZ1nyY1RIdxDm5gbDC24Ep1V
         sArg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1770045869; x=1770650669; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7XeYlsxUkbMQHAIQqAJuTtRn+P5r7C2k+MrvTn7cN4Y=;
        b=AIu9azX6PFhZl1tqdgocCb+JEhARsJBTxN2Plqvw5mtxKoB4arX2CxaMa37n9aImJI
         wKXYdDmWRZOY7ctWzuZ7Rc77Kq1NNnU6I4ZBMzSSqv5mQ0LsZ7SERwEp/Ha7OsD4vdL+
         gHEzZOO1JQ1m/wYv4ca1Bg6I/U51Cy6mSqN0PHz+ny+pTmSvKH/DqZqY1RkO3tP9rR0a
         3cWph7TWe82Q2nsJc+4gbL7Q+ZKAO/Xi0gkMTKxxn/IJO8DAaUoG+ZJTnRQWLQSksmbm
         xh5C4ZZJqDdeCv4vf0pg/h9+yeVicffpLpEt7Uj7Cvkz7iO+CAyclhL6wutSswCOOS13
         F3tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770045869; x=1770650669;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7XeYlsxUkbMQHAIQqAJuTtRn+P5r7C2k+MrvTn7cN4Y=;
        b=SbjYhBkMHdULU4fOI7NFv7i6KXu9l+9jxNAzZ0yWHCc/fvHIUamUBMJrM8Y8E68Pzt
         lq1orjTKtIMHdQzq4BUXtFBvOI0H2UPyrAgKcbIQTPS2kR11iK/inHseU30we/hYO38S
         juoCF6j6oQybEyUnAfQK0gzJIYjBKHR2fXMF9P5wVQW6bvtvTh/FuQs7mA2AuRw0vBs/
         YTdm7+IQ1IA/ln2vDMVoTwWfQTZeNjtxYgXrZAmPJzu9QERWxkFWAxlhBeSk3PT4Xk/l
         itnqnnvwZH+iWOswyYTBcouJu99XWoKmJ/IGMct5O6bUn1dS4eYUBP2Aai8ptK6eMurk
         PwNw==
X-Gm-Message-State: AOJu0YxvF5pYe/1fUh8ubqT10dSjJrIQejlHKWE7rt7iNIiDOj72a+wc
	tIU6vtxGP4oo16ifddeP/R4XUgnTrFlZB2cODaPczrV0XXCe2cfaTms0hwsLycIU+uCcF8ZZods
	4XsOSVci4nhn+VMo+dqIKQdfSgBiJrch8veQVzZ+9BAUA/bDxM3XHZTfwP4CxliBv25JoB44J4U
	tdFL4r88VxkaRMsHG2yX54L50V/Lf0
X-Gm-Gg: AZuq6aLqZVJsxIstXCtg0q+pwTmoeSTWfr1VW4LGRmmePWkimcA5eoSFIGmUR5EB1yI
	1nMaZe2GreCqVFh7gVXu8dzxdC/Y3UoILpTlttTnYPWSksFoQIUxLnZHlGiT2NlzpuKKAdJe+Am
	RTIgaFYyGQPfgLfoQ81eZ7QEgHuzIZwiBWMy9xHSfGJqLXjuBZ5JkQNlSSYC4csimT
X-Received: by 2002:a05:690c:39d:b0:794:b36f:7a6e with SMTP id 00721157ae682-794b36f805cmr59304387b3.9.1770045869062;
        Mon, 02 Feb 2026 07:24:29 -0800 (PST)
X-Received: by 2002:a05:690c:39d:b0:794:b36f:7a6e with SMTP id
 00721157ae682-794b36f805cmr59304227b3.9.1770045868633; Mon, 02 Feb 2026
 07:24:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260129184302.34887-1-npache@redhat.com> <20260129184302.34887-3-npache@redhat.com>
 <CAOp=CXkRbfsuzHYrB0qVnZPNx3OQgVUE48iZTzjDFtBB0x-Uyg@mail.gmail.com>
In-Reply-To: <CAOp=CXkRbfsuzHYrB0qVnZPNx3OQgVUE48iZTzjDFtBB0x-Uyg@mail.gmail.com>
From: Nico Pache <npache@redhat.com>
Date: Mon, 2 Feb 2026 08:24:02 -0700
X-Gm-Features: AZwV_Qg197r7IaRuSBZtEoOlvfeO4EeslxwI_aTSy4I0jTR-4elg6mYy9R7JToo
Message-ID: <CAA1CXcCUN3ZtayLiMFFE6rb8XaP+91ZWxdU+TtC=F-ghhfHQvA@mail.gmail.com>
Subject: Re: [RFC 2/2] page_fault: add hugepage_delay option for delayed MADV_HUGEPAGE
To: Vincent Fu <vincentfu@gmail.com>
Cc: fio@vger.kernel.org, axboe@kernel.dk, david@kernel.org, 
	willy@infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 30, 2026 at 1:08=E2=80=AFPM Vincent Fu <vincentfu@gmail.com> wr=
ote:
>
> On Thu, Jan 29, 2026 at 1:43=E2=80=AFPM Nico Pache <npache@redhat.com> wr=
ote:
> >
> > Introduce hugepage_delay to map with MADV_NOHUGEPAGE first, then
> > madvise MADV_HUGEPAGE after a configurable delay via a helper thread.
> > This makes khugepaged candidates reproducible for page_fault tests.
> >
> > Signed-off-by: Nico Pache <npache@redhat.com>
> > ---
>
> I would add this option as an *ioengine* option instead of a general
> FIo option. There are examples in sync.c, io_uring.c, etc.
>
> This option also needs to be added to the documentation.


Hey Vincent,

Thanks for the review. I will switch over to ioengine options and add
some documentation!

Cheers,
-- Nico
>
> Vincent
>

