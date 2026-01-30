Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EC3C2FFFB6
	for <fio@vger.kernel.org>; Fri, 30 Jan 2026 20:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769803324; cv=pass; b=g05SCxQhLMDphMTLwqR60TSMkeNdw4glDc0wtoOkA+9uCnt+FZKy7B50OJbavHAJbocIeOvOU9oIugVXSU0UCqIpZ5wU6oE3BQmjGXaCmjSh+K7k92e4MN7Y09GNvF1n0b6ANmLhqKo2VJIkjEonpfzUpRlTGTZUU3FR4dGo60s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769803324; c=relaxed/simple;
	bh=pA/BsTO2eybF6ZRNcP8L5RU62qSddF5p5oQ1ykJava4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CTYUeeM44YIXLvylNgzqd1tNG6093Os9zoUKJmwyf23AjAFRFhY4+sB2Ri0J+czHPMgFAb5NCZZLJP3rnvAemQvk91llyHV18QYY5aDLyDywf8pZtGNDShWCeZ7mAQYxHPz0Jxa1p8+gmU28imHo60XSj+bo1p8JoXDnSbdvisA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K4x0RzB2; arc=pass smtp.client-ip=209.85.208.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K4x0RzB2"
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-38319cbc8fbso21440441fa.1
        for <fio@vger.kernel.org>; Fri, 30 Jan 2026 12:02:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769803321; cv=none;
        d=google.com; s=arc-20240605;
        b=FOJkaCz4uyCh0CU+QHMwrhz2HgjAnA0xhYdF7ULEjyRrie5baH57wr3vIOpoDTOu/A
         qk66hLdjTw7LAO6KScZHefkp+kLDegsTAG/wx4GsndeCCnMzAPWLA++9Lo1rXoonAVU6
         ncdiUPrDdGWDMu0dsZQF2bj3YLpWGSYahPDhQzx56RICfs8vxYnNkKK8EZdBIsf1x5Ej
         a6ldNM1nS8ixhvFSYE4VOvxwV7aeV1dvQsU4cgN4Gz+2TqafyaJxpbfxmIWeJDUt3isR
         iFKJ2mXVdrY7ttpoH5By3UtyDvCuHu+9eimtmlek/O0Q1jdOjl1I/8sN/6ORGfCf0dI3
         06pQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=0FCogIko4WmoPnhRdlsNVeyIoQZOAsPdxe0vA7h7T6Y=;
        fh=taGlRrOqqf7R71nb5PzI3OXVPEWk3t8O2YxviStmVqk=;
        b=EUyjJfmxFFxRkaPVe8DUamXjvzgB8r0rxymnms4OIx3h3Sp2dKHwCb6RNg/Ijeng8B
         iBL3AFVJYLszLG4qrY6WGPHOwSnYftVUI+oaJI4uPE6HdUBgpBL73KUyURkF6s23Dbpn
         5xh9wywCC81hFMdWfr9I9oxPJcB9YyS2RCzfrA1AlxXxYjU0/ELmervoNKRF+TAVlV2G
         PA7bB38tSpT1EQw10BQE9JWke92iPFGruWib06tuh9NDNHHHwi7hn7o8SVa+cMVH6u4o
         kmGhBcun9LNB07iYiWB1RHy6uVPQmbFdTToGv3O350yNm2UNPdae4u8xWUHzZzZ4IK3Y
         ymDw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769803321; x=1770408121; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0FCogIko4WmoPnhRdlsNVeyIoQZOAsPdxe0vA7h7T6Y=;
        b=K4x0RzB2COLdaSk6DGGj2iZYhflxw3XbebWYfzIoLGhtCxWz5jTpxEmq61RR+54N2w
         W468vhWCHlwgk+Rh0v3V4oZ2d6sOVw2dyCLv/+cA3KAM1UE1xtixIGObvwymCwaAEl36
         lvnHdV/3T9W+5wTC1nO4rbOpywNpzi7ozupRumXoUrbZR07/NAxdkjlfWIO7TQmmmt1k
         fqcbspsZf5jlULMk0Q0rmoY1/E3PpFldA9gx4fWF82mJJbrzEhju3CyrMbY7EQo5+mr3
         R+1nOhNK6/I0arnXV6ANclKT5RpJEIp4UNHmHfOMJH6RbEMh4WpjTAlIXSNRI5TwuD9Y
         Xb1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769803321; x=1770408121;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0FCogIko4WmoPnhRdlsNVeyIoQZOAsPdxe0vA7h7T6Y=;
        b=ZRpbOLHHWYjDtU4TMRZY7OguIRw1pjLhvxBRuapx2kBvzWqZUcmWz0UESvNk64N9IM
         lS4TJeon46j9wYA1G48vo3Pfb15eVSffBfD9hoyHzg32OMOU1YxdG0kZEB4ufgrktm5v
         P0D0emrAPD93KKWHe7Cglr3ae0M6MxZnpb406PwD2zt42ldvzDPOFknUQ884lIMVZCer
         z6JNJjLhwfXWkX2ymKrG8UlxRL8cgo9VEFjgE3opOEuDdjIEGsDTEkLKUSdRt5LT39lO
         eUY39/m9zM6ohZZqZ8okGPcH0Z2qd4d0jazG/PHHkU7Ei3Do8KRS0b6Y2xzA0wS8OKdO
         /R4A==
X-Gm-Message-State: AOJu0YxfMCJspALwp2vcVhI7oFMaiNJwonsixD5wuuPkNrrjaDvlr3OY
	edN6jJ8KiPv4Qao0IVQh/x7+h4bcZR1dPMo9i9XZrzvOgDLL5bnsXBoD48qQwXts3LC6pI825d6
	6AgTTz8dHbcfM2XBJ0S7k9lwehyouDlw=
X-Gm-Gg: AZuq6aIEbuJE2f8t8O1Hub7pcnU3HvXbFzLrbdTQ7tfP3vVQn1FRlhr5qsYFX8H0xeA
	Rtdlsw1mB8UZgZhcHJ4ckeQtI8ep3mUGZNhBVFqDQq+G6PUADaWve4u/BziIkXO66vIaBe/e8qb
	dlTG75yQPLOWyLw5CVI8Fw8j1e+dWqd8a1ZfODvYchA4KrKPxCCY62irnGtA/AfOfXPFkM8ABvD
	YVTVwqRv6CYg6uJ/rgoUo0SMQErIsPtaIv33UZ/yB2bHzkpFSorQMJwyfkz1Yv0IieWCA==
X-Received: by 2002:a05:651c:1501:b0:37f:d484:59b8 with SMTP id
 38308e7fff4ca-38646524548mr14888851fa.7.1769803320988; Fri, 30 Jan 2026
 12:02:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260109023603.2848421-1-shinichiro.kawasaki@wdc.com>
 <20260109023603.2848421-3-shinichiro.kawasaki@wdc.com> <CAOp=CXnX9zorei7vwO54OvxBeFEjsKzgKXZaLqDOmu24-X9bbw@mail.gmail.com>
 <aXgleDJ44YFYDQeF@shinmob>
In-Reply-To: <aXgleDJ44YFYDQeF@shinmob>
From: Vincent Fu <vincentfu@gmail.com>
Date: Fri, 30 Jan 2026 15:01:48 -0500
X-Gm-Features: AZwV_QgAZ0jX3PIL-kmEvIGjUITeUND9nf4RB93H9egsvP5YVSu2WegqYaUK5lo
Message-ID: <CAOp=CXmUB1cf6AgMPqLAVXaKCLxy+B56918MzTGUDtGR1QXTbw@mail.gmail.com>
Subject: Re: [PATCH 02/12] zbd: set norandommap=1 when zonemode=zbd is specified
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, 
	Damien Le Moal <dlemoal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 27, 2026 at 12:05=E2=80=AFAM Shinichiro Kawasaki
<shinichiro.kawasaki@wdc.com> wrote:
>
> Vincent, thanks for the comments.
>
> On Jan 26, 2026 / 20:39, Vincent Fu wrote:
 [...]
> >
> > Perhaps you could instead emit a warning when a random job is run with
> > a random map and then condition the relevant changes in later patches
> > on the absence of a random map.
>
> Actually, I thought about other options as follows to seek for a better
> solution:
>
> 1) Leave the current remainder handling with zone finish operation, and a=
dd the
>    new handling with simple writes. Choose one of the two handlings by a =
new
>    option, and ensure norandommap=3D1 only for the handling with simple w=
rites.
>     -> This can keep the current behavior with norandommap=3D1 workloads,=
 but it
>        comes with the zone finish operation that shows bad performance. I
>        thought this leaves complexity for users and in the code.

The above is my preferred solution. It preserves backward
compatibility albeit at the cost of additional complexity.

We do have many other situations where some technical knowledge and
complexity is required to maximize performance.

Vincent
