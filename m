Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 112A6C64ED8
	for <fio@archiver.kernel.org>; Mon, 27 Feb 2023 17:45:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229471AbjB0Rpz (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 27 Feb 2023 12:45:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbjB0Rpy (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 27 Feb 2023 12:45:54 -0500
Received: from mail-yw1-x1133.google.com (mail-yw1-x1133.google.com [IPv6:2607:f8b0:4864:20::1133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CD4D3A9E
        for <fio@vger.kernel.org>; Mon, 27 Feb 2023 09:45:47 -0800 (PST)
Received: by mail-yw1-x1133.google.com with SMTP id 00721157ae682-536c02eea4dso198247597b3.4
        for <fio@vger.kernel.org>; Mon, 27 Feb 2023 09:45:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A6yLCZGp6K1maNtQHTtMscJ61yaQFuJTtd8KfzT1O3k=;
        b=fRNtWdXUY3nAZIz0w+KG793+9VUlgTNruk71l5brucNz6Wa+ZobwcDqyv7gvpkRWoO
         Hwlc+0PyiAz3bEnXgPYhZ9b/ZhnKjqN9D/KSLi0spaPLA33076USwhbsnv8PXpnkC7xw
         UliBtcRcbIdF7rFWu9pyye8igetPB3Rr9y8y7a07jwmES17fn5MUPlldTgHCWMk46+ax
         14Gbnh4n7e0llS0aQ46+uIV3K7A9GSB2VMtH7t6bRFvDn9exk5p8iR/KwttsO2TkJrN7
         esHC9C6ocKno/C6+YPCQ64NxlikWh0DPpjgTQCJd/BUHSAHUqcH0IlBtrssE/hX6ElXi
         y9mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=A6yLCZGp6K1maNtQHTtMscJ61yaQFuJTtd8KfzT1O3k=;
        b=Z4S8u2ezw/rEYnES16vEU8vuWj8IIGrQkmHh6luPnAs35dbacuIRX1Isg8XkAdWzm3
         83hv26dXO4HZJykv6Dq2e0I+VEYML8a7pKtF3LsO/PovYKg8ld5RitWEC4MnoTXZ1l5G
         Npn+1Nwl0T7B1zADgw6Fnj3MipVcrbgxbMO7aJPBgs40nptMpthSsJry+N6QgJL3KYZo
         YKKtxxZ9rAD6n3YgmQQSHGmINfeMV5lSwwBP37MvKL+3r5KCh1Y7yBjZe6dCjLLqefv/
         yTEQ/YnhFdlRVPN/7DSM7QzU1nszszR5504Dbam4DWiATtqif9OdDS63NTWAMl9tvfuL
         Lj+g==
X-Gm-Message-State: AO0yUKWfhZ0zP2HsAvnvt7bbg/U8TJ5SHVRkS3LWhSLAjc3mrv1EFOSp
        X42Iv2WwdVa6nRsjCotJ/jy4CWZRa5BYhWaHQi3WCy3wXkw=
X-Google-Smtp-Source: AK7set+LetY+IT9isSdETk9GoOIOw5KwzJg3td/ZDZAaoH5SrrodZ209R7e/20RHhuDTyYiv4N0mO48SHuL+O7af77w=
X-Received: by 2002:a05:690c:1d:b0:521:daa4:d687 with SMTP id
 bc29-20020a05690c001d00b00521daa4d687mr8861032ywb.0.1677519946504; Mon, 27
 Feb 2023 09:45:46 -0800 (PST)
MIME-Version: 1.0
References: <CAKJOkCpUwrGbXHF3xnwX_Q_XK7rPekdA+aXLDvZuSMOQKFN4HA@mail.gmail.com>
In-Reply-To: <CAKJOkCpUwrGbXHF3xnwX_Q_XK7rPekdA+aXLDvZuSMOQKFN4HA@mail.gmail.com>
From:   Ankit Kumar <ankit1455@gmail.com>
Date:   Mon, 27 Feb 2023 23:14:39 +0530
Message-ID: <CAKi7+wfVLF7xmk8u3cZ_Ctwhii0c7UqHMfUdEDAhpf4XAJtG3Q@mail.gmail.com>
Subject: Re: thinktime and thinktime_iotime do not work as expected
To:     lokesh jaliminche <lokesh.jaliminche@gmail.com>
Cc:     fio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Hi Lokesh,

Can you please try out with the latest fio master branch.
It should work as per the documentation.

Regards
Ankit Kumar


On Mon, Feb 27, 2023 at 10:58=E2=80=AFPM lokesh jaliminche
<lokesh.jaliminche@gmail.com> wrote:
>
>  Hi Everyone,
>
> As mentioned in the readthedocs, thinktime, and thinktime_iotime
>  can be used to simulate the IO phase followed by the idle phase
>  of the workload. For example, --thinktime_iotime=3D1s --thinktime=3D9s
>  repeat the 10-second cycle with IOs for 1 second and stall for
>  9 seconds. However, in my test for the first 10sec, fio keeps submitting
>  without respecting thinktime and thinktime_iotime. After the first 10
>  seconds fio starts simulating mentioned IO phases according to parameter=
s.
>  Following is my fio script.
>
> [global]
> direct=3D1
> runtime=3D20
> time_based
> [job_1]
> rw=3Drandread
> bs=3D4k
> rate_iops=3D1
> numjobs=3D1
> ioengine=3Dlibaio
> iodepth=3D1
> offset=3D40G
> size=3D30G
> filename=3D/dev/nvme0n1p2
> thinktime_iotime=3D1s
> thinktime=3D9s
> rate_ignore_thinktime=3D1
>
> Results:
> Run status group 0 (all jobs):
> READ: bw=3D2457B/s (2457B/s), 2457B/s-2457B/s (2457B/s-2457B/s),
>  io=3D48.0KiB (49.2kB), run=3D20001-20001msec
>
> From the results, we can see that the total IO is 48KiB it should be
>  ideally 8KiB.
>
> Is this a known issue?
>
> Thanks & Regards,
> Lokesh
