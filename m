Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E991731A807
	for <fio@vger.kernel.org>; Mon, 16 Mar 2026 15:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.179
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773675217; cv=pass; b=jTNOL/U+tlK9YvL4jwEONpViirhKx+/9o3eWT/fJn1x+IIp5s9ACjSF8KGszs0AG8/nqBlVh6oInD8gbtMnh9yshLt+dNTcGuYLm9l+Kmm7w1Cwrus60Tw8jH0nQPuTwqqzh1FOVuPtvL1ouyw0MD4hVO4+vm9vDeTdkOfcznms=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773675217; c=relaxed/simple;
	bh=yHmPqJDHVMR8N1CNZ3iLNmVptl54lPsS2Q3KD9b+6t8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hJSJ3kJjHgjchTMMJTDDQaw71WfKjxZdA7Osgdt09/z7eYa1uIx9j0He6di0L0ourFqPGTeD+7vctb0kCjqVvkNBLLizv1JY5f2ZwbCuIF1CWlvNGXwCOTFNx4+DCTRQN2tgHxuptg2SPe08rSTcZa3mzrQ9zE+1zqxpSvR9Ovc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k5/UP7RN; arc=pass smtp.client-ip=209.85.208.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k5/UP7RN"
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-38a3486419cso31055951fa.3
        for <fio@vger.kernel.org>; Mon, 16 Mar 2026 08:33:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773675214; cv=none;
        d=google.com; s=arc-20240605;
        b=P3QtbmTSpxirAjcVLqLbZ3iXclQP5839Ipu66qpWoxskyaL2azdBtJiSSLpwFG+UR/
         g0UtcYG05gePR4ZAqcI2RViPEZ2KsH1yNlBHoxusU23G564/FRkcUHdMvGe01QqcyMaa
         4bBEGVGlo7A2Ewpg+PqYJd1WMCw7oZqUhl5eMTgdDTQawMJkORkWi2xVkwcvTHGB4xsn
         iWWhQhjMJ5C5n1l4EwPKtLQ4okGE5sHmuHvpHLGtR58n5CmGvQ+L0cRKXJGeqNEhCS5z
         xigKr1SAdUCVXQZPrh9X1jFOIxHrX7nf0SsnhdLqTrnBTrd8tkHEz2J8YG9KfxN1aSf9
         WaNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=yHmPqJDHVMR8N1CNZ3iLNmVptl54lPsS2Q3KD9b+6t8=;
        fh=nBltqKqfxTE99M5G9+1rlF/NG4SNbssOl7Ph2vbb53E=;
        b=lK8DEL5eS2pL2ZFzWtneYYpkOXFiTX+hCB2gWfaPP90EMxRcpqOBaQFdtdGAG4u6js
         FUbNMKktMfX0A3CQ3SnrNwyUkZoUTu1H1o5NKPvb7dbUIsd5BcjS67f9NmvQvWP+rp2D
         cdgCcqqNZtKkXy8KTIKgT5oDSA0VtLSLMX4SNDEElyzGiyLI8/oIcR7yetKLVosesehb
         X0yQw71eYSf9zE5AdfVWYido6UQ2GhZJ5eqzQS6mEt443ZtB5Jspv1WjiR7VqRvHVpG4
         AFCTnGCed919mtp4SHpqE1+eX3YvwrzbW1YtdTZ7/0K8NKsVt70w0SRKrgFCJBbaKB9/
         nIuA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773675214; x=1774280014; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yHmPqJDHVMR8N1CNZ3iLNmVptl54lPsS2Q3KD9b+6t8=;
        b=k5/UP7RN8W6PfP7WOIWqGd+1xwKctvlqZkpONFxXXEs+qZyvOKYzVv9vQT1UnKW7oA
         IyyCXi5YaTsz40hfvk01U8AFKFvTX+IRREzFQjFcxagqDCtTLC+7JH3c5JjamouGYYAX
         4HWPkDdmF2Ee9FXOe6mvYXAoyoRaOPs4HiKblV3SJD6Tp50UnkBED8z4e0wFZSroPsLP
         MXFi5rwDeqQlotU/wpt/yqQ2A98cz1wq/htfuqAZXZgHj9uhmYvmvOlsF0w0L0v2EgDS
         Ut8OM5d8mTw5xwvSBaJ1Obto75oyC8b8jv/YDIpop24vU9lEQH2ZfE66Ywp/Kz2d4V5q
         X88Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773675214; x=1774280014;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yHmPqJDHVMR8N1CNZ3iLNmVptl54lPsS2Q3KD9b+6t8=;
        b=ahCqPm0i6A1OCibeA+shubiiaXmwRTjxueHrqZJdir5dusjhO3R5aDgt6t44J0XXHC
         hJrP6pFtpvd1zc+UWVOv4WlZOJgBPEyPzmp6l7/wvPqERRbcH8+tptOGUKl/qafhgUCo
         QZS7ifzZvf5U7IFTAxGESo81YGNQm82MGWOCGnjQzNbYShqXeeKBFBnknVuBlM33ODbz
         BI2NLufBDIu4jGAy3LWUuKv/MPP5YXaqvdQC0LbrLiN/WlpjWdZrbzV4QjvZLteRQA1R
         8hxohKlUmThNQlr9sdRw+ov2XVOBe7takahhHA+JXl1Ma7yC9xOpAkE0nc6JfbsSMCky
         q+TQ==
X-Gm-Message-State: AOJu0YyeZQYN69Tk5+GvJIyK3IYPAwe1KVsgImBXsHDKjKll67ndplXK
	VtKbQA1dI+ERlsypMTKOxyaOP4uqA3Pmx1oWPMqV2OVIn3mwTBAP04IC1KJoRB0kV7F/EHeiKny
	BEfDoiTrulGimm5YuENPMZF7JYMPZ3FY=
X-Gm-Gg: ATEYQzyc+gvfu95OZ1jy3JunR7yhCX2yC4fJ86jUm2VUZ2ngw7yPnweCMDjQzbSNlXt
	AXPacBAUcleaVBRITt6fgnKckqwbeiWrPeCMQ5M/qOsZef4EbOO2uyhi3EiBLXSmtcG5d9Alzm8
	lmX/1Wwd71yd46lLcEpRU4te7xlO9Iujkp/K6QcYO/CbC749k9fEFEUSGNv5d/6eYrT3LM+c23K
	0tiSHIDXK3xjKB33+Ejv+duBWPASxIFqq3JrXQlWs+Exy7dNABqEwy7mKsxKR19Jyaf39tu7G9S
	jspX7g==
X-Received: by 2002:a05:651c:1582:b0:38a:45b:41ec with SMTP id
 38308e7fff4ca-38a8979eabemr42463691fa.21.1773675213650; Mon, 16 Mar 2026
 08:33:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CA+kyTLJ7oyfzM08dH1Xdk_c2ub4hmX7aXTtxJr1YLWhjzTT99g@mail.gmail.com>
 <CAOp=CX=qEYiGLUepFc5myXaUVZFv4CdPRt9g2WzVe-ARBr6_ng@mail.gmail.com>
 <CA+kyTLLmBPoB983JqBWTy_Mv8dW_QNBY8OpFauKJ1ESjx+zP+w@mail.gmail.com>
 <CA+kyTLL3QJSNdDySa570MypgbhWEc0fB9QG8LBbL1rZui8GWOw@mail.gmail.com> <CAOp=CXnmKtQf0mK0uWveOsjKpZ04d9icQLyWWOtgQSJJS91Jbw@mail.gmail.com>
In-Reply-To: <CAOp=CXnmKtQf0mK0uWveOsjKpZ04d9icQLyWWOtgQSJJS91Jbw@mail.gmail.com>
From: Vincent Fu <vincentfu@gmail.com>
Date: Mon, 16 Mar 2026 11:33:21 -0400
X-Gm-Features: AaiRm51Md0AvrJ8llXloq2oE401_W1rZusXz-6qoJdXUeFTKiQ7Gqm2C3T1z4XU
Message-ID: <CAOp=CXnxyO8xpD3m8omCD2gB2Qd0Td3CX9Uutr9z=mvS2g6y_w@mail.gmail.com>
Subject: Re: fio parsing issue when trying to use latency_target and latency_window
To: Mark Erdos <mark.erdos@gmail.com>
Cc: fio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 16, 2026 at 11:19=E2=80=AFAM Vincent Fu <vincentfu@gmail.com> w=
rote:
>
> On Thu, Mar 12, 2026 at 2:46=E2=80=AFPM Mark Erdos <mark.erdos@gmail.com>=
 wrote:
> >
> > Hello,
> >
> > With further testing I can see that the input is in microseconds both
> > for the latency target and the window, and that means the manual is
> > correct too. So, yes, if the output could match that or per Vincent,
> > your suggestion had the unit designation, it would certainly prevent
> > confusion for the next person. I am ok, since Vincent gave me the key.
> > Thanks, Mark
> >
>
> I committed a patch to the repository that adds units to the normal
> and JSON output. If you are able to test this, please report back if
> you encounter any problems.
>
> There is still a problem that --latency_target=3D10000ns specified in
> nsec units is not parsed correctly.
>
> Vincent

Upon closer investigation, fio has never supported specifying time
using nsec units, actually.

Vincent
