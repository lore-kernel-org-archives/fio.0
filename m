Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9850C248886
	for <fio@vger.kernel.org>; Thu, 18 Dec 2025 21:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766094177; cv=none; b=ImJdlKhhLnZwD9EwqL9/nxfWYu6pI19JPdziUt/TrrPQv5IodcH3Z/1gNl5tRxUYNSrI1La4U2RYjt4LqG5DIZ8Sze3AV3yfMziZYCEuKfqrzQExKiYCOgr4KJQQNT8wuTl0vMY9PQPwktd1DZVr+D2fnJlhN3lslA9wjXz4/IA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766094177; c=relaxed/simple;
	bh=QEVBG4wBaEEdfnss4u+3pYt8H8FgBZh419aU38rruN0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SUgM7+HPqEIzco0OLkw4DaOMGQR9IJgnz5+DufExD8eboR8ZIaCz+qIKpNiTl18Fp7vzHJXFT4DwRLQoJp8/yXBoY9UzOyKhau77VldJPaS/GvH0zA+KLreZEXyHWG8zKxhm3+FQO/VMfJEv5gUTt7EWPPhgu0XoTZlpf38Z1HU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GrM0MzS0; arc=none smtp.client-ip=209.85.208.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GrM0MzS0"
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-37b95f87d4eso8514981fa.1
        for <fio@vger.kernel.org>; Thu, 18 Dec 2025 13:42:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766094168; x=1766698968; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QEVBG4wBaEEdfnss4u+3pYt8H8FgBZh419aU38rruN0=;
        b=GrM0MzS0Hi0hvWv4GeMYuJ6ktb0eXn/5IecCcB0l7OvWAPG/XulK6vCJ47ijKrgv9u
         ZPxoFvC+5U9cIyIT1ABnNbLygBv/S/bFn4DOWeDJsuU06tl5J5RzKpRJYWjVrG6h0/Qt
         b1XajV9Te9gBtb3IG6WMT9P2GKVMjkASEfuAGsWG4tzrS2fNj1LYrsezHeOU9/9sKQ17
         Qynv8o1jiYkeZWQUG4xE3fINYYu3hmmUOZLmylvnNuHnnItHRzFSQzdy504Z8E90Ck5g
         h1TwUUF3DWV6sU+s5lOVveyYbVR7d1MczycgE7vZ9W2YDROV1NyOFz8HbFytKKS1xDxh
         P6pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766094168; x=1766698968;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QEVBG4wBaEEdfnss4u+3pYt8H8FgBZh419aU38rruN0=;
        b=QY0DVKLRpNU/jhxb8yJoM9l80y7yKBv8V6KZpGBWXPh/8hViFaXihuVoZVhix44a1q
         8Ot6URnGZyVZwHa5eFw+Bd+WFgSQV2cQng1FSYRR8enGxjute/ITaAmgliBsNFJ11Kxr
         LIXCRPt3yrw41l1WLEmFIoOWL3/GaanndMXiIAxyJHRz33P9IGWgJIh/P7SDq+Dj1o1q
         JMX83i9OvausLplFb+UnGneiQsmKX0XeswjGF9ROVpMpQmet/GvV3+1vxJ1R4h2V0LMV
         JB3RUVb597vLExroQvtGCUVlxrucVKncsIKqXtV8L8Fdb7mTZWRCPYa860GxP9fsyKmY
         BJ1A==
X-Gm-Message-State: AOJu0YyVkpW9UHOz9kVlz9EF6d5izepChLHTLkxg3lKfegRY80AFLXhC
	+VHqqhmcPhS/hTH31afPABc4/xxVU792KbnI/5ymhOChnQfTrjCETzq5moq2rCil8WjNOVV/UQv
	SGKVZ/H6HNI/49AJyLjGWOvLeQoewqpPtM8S7
X-Gm-Gg: AY/fxX7PNis82uoX9Zv/PFAeubs5xDgOiccproHMzExdwGj9DsTw6AfLQYNZayKUazB
	V5FmkmyarhXbbSn1FAOscEH8woC/KfaoLyV2x1DogovXrciwrJjZUAiPePqSgCkMq85/RZUn179
	T790guERMgJ+0AyEV2J4HCTwFJdFwr1QOOCC4avvxWuJKZzYre699nnFs4zFM4gTvZumjwY7d9t
	tXcceo3xZYyU2JVX8sd+0cesRuqfaXr/TAdWHx5/a3E7OTboc9t+xZ5+D+wnhk6pY2o7Q==
X-Google-Smtp-Source: AGHT+IHNxUqXtjek8LNrqN342VxZpk6yiclxpbj88dlUMR7q5/0X5kw2lgHEMjX3TFFTitpKtFZj4pKq8XTVGcEeaWk=
X-Received: by 2002:a05:651c:1549:b0:372:9bf0:aed6 with SMTP id
 38308e7fff4ca-38121615a12mr2421321fa.25.1766094167979; Thu, 18 Dec 2025
 13:42:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251217160217.15533-1-jack@suse.cz> <20251217161722.6357-5-jack@suse.cz>
 <CAOp=CXkbuuue6N=VVkqOX_vnsR+urtJWcizTTOG9LOWeCeihFA@mail.gmail.com> <j64gvowvjtdgwexf5hl5pneh35fu74o7yloy2zp2bejjig7pbi@ws6ufq2glv4b>
In-Reply-To: <j64gvowvjtdgwexf5hl5pneh35fu74o7yloy2zp2bejjig7pbi@ws6ufq2glv4b>
From: Vincent Fu <vincentfu@gmail.com>
Date: Thu, 18 Dec 2025 16:42:36 -0500
X-Gm-Features: AQt7F2r6w6ndg4JWWSbfYkHxbSDkyw4vOole_VEuoz_ywtaM-ELQkn5XIKuhN0c
Message-ID: <CAOp=CX=KZpjcnd688zsxi8MamR1vJGXR94QtjhD9jS9erCSvhw@mail.gmail.com>
Subject: Re: [PATCH 5/5] Add option to specify ramp period by amount of IO
To: Jan Kara <jack@suse.cz>
Cc: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 18, 2025 at 12:18=E2=80=AFPM Jan Kara <jack@suse.cz> wrote:
>
> On Thu 18-12-25 10:19:12, Vincent Fu wrote:
> > On Wed, Dec 17, 2025 at 11:17=E2=80=AFAM Jan Kara <jack@suse.cz> wrote:
> > >
> > Currently this patch compares the running total of the group's bytes to=
 one
> > job's value for ramp_size and then declares ramp time over for all jobs=
 in
> > the group if the threshold is exceeded. A little more thought should be=
 put
> > into potential use cases here. Should fio allow ramp_size to differ amo=
ng jobs
> > in a reporting group? Consider adding an option to enable/disable conne=
ctions
> > between jobs in the same reporting group.
>
> My intention (somewhat inspired by the steadystate logic) was that IO of
> all jobs in the group gets summed together and the specified limit is the
> amount of IO for the whole group as well. This was motivated by the useca=
se
> where you have multiple tasks doing buffered writes and you want ramp up =
to
> terminate once they together write given amount of data. I didn't even th=
ink
> of a case where ramp_size for different jobs in one group would be differ=
ent.
> Now that I'm checking steadystate logic, it rejects configs where differe=
nt
> jobs in a group have different configurations so if I add this consistenc=
y
> check to ramp_size would you be fine with it?
>
> I think connections between jobs are a bit of an overkill at this point -=
 I
> don't have a usecase for that...
>

Yes, I would be fine with rejecting job files that have differing
ramp_size within a reporting group.

Note that I just merged another pull request that bumped the server version=
.

Vincent
