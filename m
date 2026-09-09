Received: from mail-ed2-f12.google.com (mail-ed2-f12.google.com [74.125.228.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09385342532
	for <fio@vger.kernel.org>; Wed,  9 Sep 2026 17:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788973768; cv=pass; b=Hp1423ts1seZdqheOornOMVWfJfxHpAJl1eJwzmdXJC4llnQ11uW0rDAD4eozCWwb4GzvCMJCpGBc3I2feG32yYSzCtXCk9tAVqCOKJQqpspu4Wdes2KIFmAHYYsnjcOESH0XEDkjG3SrvwXLUr2Ikq/A4ZFvTtdntKN5McVS7c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788973768; c=relaxed/simple;
	bh=yGJN5ZvgyrNxchpqR9Z4cGKPRtW+CTiw6e7Ec8ECYmE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=II1gwAzuSFMIrZ6Qyx5LJwokc+RxKfqYGjTI+y9eOjoRHjQIraNB9kjXTHcgIWX2+O0Yad+1EIsGhjqFPWDn4JRA0DtAjPWA/+pUf2jmxhJUMSKrK4cUtMGfMoOQNIx/bc1/UED2TckNFqnzm8pNZVx2NK8nLsSRkdRSyM6DupE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=So/+4QaD; arc=pass smtp.client-ip=74.125.228.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="So/+4QaD"
Received: by mail-ed2-f12.google.com with SMTP id 4fb4d7f45d1cf-6a8814f93e0so707671a12.0
        for <fio@vger.kernel.org>; Wed, 09 Sep 2026 10:09:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788973765; cv=none;
        d=google.com; s=arc-20260327;
        b=LOmxJdFm52R/ZkMFkpTFfooFqPjJzFMr68/y8PspjLJolPM/C6rFw9ZncrcpfNEty8
         bPJTSxh85la+OXSiB+rREsCWGf5RE9PcXt9crWYwSocgtYDaSHoP8K/rjWk4DiXFPA1V
         5x2nZpDr313O+wq9o0Sjw7mGzbLcSn7ebzN//BekVi9f3r7nR30VwP4xtkEtPfDLLjf7
         3qnNH4RvTHWLnrOK0S1j7tHCD0yCcXSYvSnq60DGTZUEIgdW+DGqcRj1f5WXZO/sjEOY
         sm+2WFYgjhpPsJF4lL7AdKaqhV10PZ6YFS0+0e+Hj6RtOStRbHef9rU7okuyQ5fbzaZa
         WT3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=yGJN5ZvgyrNxchpqR9Z4cGKPRtW+CTiw6e7Ec8ECYmE=;
        fh=4U1Hn5Lg8YZkznXeQefaaGN8uE77LIcuj7VRWbLiznE=;
        b=VBQ6aQu1H2P2gVnJKhNxP2b7hIXZUXxzhJMunwkMAPeM2Rr0pqhLWfzfI0uKizKiOH
         RFDGzOh9faJtG4Y+9J0KCQR1xFoHDAVsiPBOc+K3YNUas8GN+Gfh6Gk7YywmdQRWIT0L
         ZGi7jAqsh4ru9I10tQbutNznlor/1nOnqbtANT3sOy51abWAwmMIHW4Hxzr5rb0r6pCW
         zEopa/oUBPI9TflPKuA6eyEcJcsvc8Q9snJqfiwTWm7Ahaf7RgwLfRpJUFyFy3pKvJHp
         7Qk/x/j8yEGFlglyUNtathvcikhd0UtGvJq6hf3BfMgRfIh+JQM0bvML2tKfyu7lVcTD
         T83g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788973765; x=1789578565; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=yGJN5ZvgyrNxchpqR9Z4cGKPRtW+CTiw6e7Ec8ECYmE=;
        b=So/+4QaDikBY28CZCy9vApTN5GQKQYb3SwZdKLT0n5b+dojYMIYeo8Tu1xODZjPB6M
         tTMOrDX2INunnWeL4Zb8PkEE/iF+tvsR1WKAy17AX+P1MuTT5VTtcw9wQHaOUNfx5eVV
         +u1vKb0nROIWYRqlGCX1/8hPOrA1kCabUZO6Z1cV8h+kbwWpHq4Qy5rpBdXYRcE7s+bA
         sh6giX7RaHrHw586Pa0Mb/Zux0sVeRyHZ62OkQkDb5qu8nwJhm0E/+JIqx6jjTo05sbr
         u3ezVJKagWmwaPqaxuUnwEdqhu55FU0523P9nYS2C3iJntU7a+v2Lf6aoMCP+Y/9J3Dm
         CWRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788973765; x=1789578565;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yGJN5ZvgyrNxchpqR9Z4cGKPRtW+CTiw6e7Ec8ECYmE=;
        b=DaMneTpMXFkAweM9J9D1QXPbpahTPVSnlf6rJh5reSxJj8U9P/fnszm0M9XNWvDD3H
         Ybsp/D+tBUtMxEeExkEgK+g51xXxn55Ifd4CKazPjT5vZMqF9lwEMQd7cCIPKsSjlpjO
         wVMkwl4FDclKt0zE9kUoF/FKMJIAvzSxZ/ZBvQFS5Nr0vEPxF3Ecq6rSskCpW24dIfHw
         ajbSFrgvwZV+Dfwav8L5xE4n8A5oRenpwLXdRZvP6JP6jvNNUJvVJuG0tnUmgxbK5gnT
         LVEwZfXmagI1G0cFTylsL4o/0hFx9DXPyAzbexeDjmMQgUmV0L0kFRzx+wSHxxknqH/a
         RqKA==
X-Gm-Message-State: AFuF++k7VykHVhwQ3JAAxZ2dfs2PO+Ovj79ApdEVRyBoYQBqvzMQAcXa
	JdbbDaX4GFirK1DyxhX5+gwSGkdplQwvfF4xDOGlGBagnwTofTqq+Iml6kSdC77z3N2CpgeV79/
	o2L3d8x9Qt1jJ9xTzyv0lhe3OTjCDZdprL7Pv
X-Gm-Gg: AYBFou2DoaT4BH9oHSz2dCDJ/bhZy6TPnhTxyPvGeS/kNnTsWbfsb6qGZ+QHpf3BZ7O
	8eSWQSi5wH+s7zJERsX6+L159XeM6CjMRjyicn6SezrB7MR65wtxA90tgTQh8R1qlhb3zaPXIys
	lR9QkrL/jNlhJalFV4K24i475zUwwQdSQUCzN0i1Dap0ZLWWnH7PMPZg/fPbteomSu78jkkAiLK
	M2hkSliKTasZGN2v+Bw1kQxOHs5hiVa2BejNmxwJEh2rMPe6QH/92LEES60sh7vbUp20U3OOuiU
	znJU6SO0II9++yqNT01BhWCC/GK6Xuj17zItuhENh5odRpvd9m5GOgzQOI5+xfcO9pvplExKV/4
	2G2QzKTYZ3ME=
X-Received: by 2002:a05:651c:19a9:b0:3a3:1674:a814 with SMTP id
 38308e7fff4ca-3a58d33e002mr4875061fa.2.1788973304882; Wed, 09 Sep 2026
 10:01:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260903172101.1886315-1-kbusch@meta.com> <20260903172101.1886315-2-kbusch@meta.com>
In-Reply-To: <20260903172101.1886315-2-kbusch@meta.com>
From: Vincent Fu <vincentfu@gmail.com>
Date: Wed, 9 Sep 2026 13:01:32 -0400
X-Gm-Features: AcwNN1WHa_A0B6wB3Q6IWVTSqTyDzCkRGkGCZ4fZelAjloEAVAMoI10XR7_dIB0
Message-ID: <CAOp=CXnd3oqKZ5OC5Sv6nAkjD6k6979moPNNPoMC_SbnAJz6=Q@mail.gmail.com>
Subject: Re: [PATCH 1/3] eta: don't estimate runtime from an unset job epoch
To: Keith Busch <kbusch@meta.com>
Cc: fio@vger.kernel.org, axboe@kernel.dk, Keith Busch <kbusch@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 3, 2026 at 1:21=E2=80=AFPM Keith Busch <kbusch@meta.com> wrote:
>
> From: Keith Busch <kbusch@kernel.org>
>
> run_threads() moves a job from TD_INITIALIZED to TD_RUNNING and only
> then releases it. The job itself doesn't call set_epoch_time() until
> well into thread_main(), after exec_prerun, pre_read_files(),
> fio_verify_init() and rate_submit_init() have run. Until that point
> td->epoch is still zeroed, so the "elapsed" that thread_eta() derives
> from it is the time since the unix epoch rather than the time this job
> has been running.
>
> Nothing currently notices, because the one consumer of elapsed that
> could care wraps around on the unsigned subtraction, but it is a trap
> for anyone using elapsed as a real number of seconds.
>
> Take a local copy of the runstate and demote a TD_RUNNING or
> TD_VERIFYING job whose epoch is not set yet to TD_CREATED, so it gets
> estimated as a job that is still starting up.
>

I think a better fix would be to improve Fio's state machine so that it doe=
s
not jump directly into TD_RUNNING from TD_INITIALIZED. Perhaps run_threads
should promote jobs to TD_SETTING_UP instead. And after set_epoch_time()
succeeds, transition to TD_RUNNING.

The current patch is safer, but it doesn't address the underlying problem t=
hat
a job is marked as TD_RUNNING when it actually has not attained that state.=
 And
It's this problem which is one of the sources of the ETA issue.

Vincent
