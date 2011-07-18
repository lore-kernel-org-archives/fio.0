Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:36361 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803Ab1GRTfW convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Mon, 18 Jul 2011 15:35:22 -0400
Received: by vws1 with SMTP id 1so2406102vws.19
        for <fio@vger.kernel.org>; Mon, 18 Jul 2011 12:35:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAAZKuFauk_dFsN-H5-r5+PjTL2F1ay1bzkGyYWpY0WVhHAW2uw@mail.gmail.com>
References: <CAAZKuFauk_dFsN-H5-r5+PjTL2F1ay1bzkGyYWpY0WVhHAW2uw@mail.gmail.com>
Date: Mon, 18 Jul 2011 13:35:21 -0600
Message-ID: <CANWz5fg4i5Wj9B2-719H19=7TRJty5SDrZZ=2GQv8YiKPzkWqg@mail.gmail.com>
Subject: Re: fio: when not using a job file, timeouts are not applied
From: Chris Worley <worleys@gmail.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Daniel Farina <daniel@heroku.com>
Cc: fio@vger.kernel.org

Can we see your fio command?  I never use job files, and always use
timeouts successfully.

Chris
On Mon, Jul 18, 2011 at 1:01 PM, Daniel Farina <daniel@heroku.com> wrote:
>
> Hello list,
>
> Recently I found a bug whereby when when the --timeout option is
> utilized yet one does not use a job file (instead packing all the jobs
> into the arguments to fio) that timeouts to not work in fio 1.55.
> Having poked around via gdb it does appear the step whereby the
> timeout is propagated throughout the program does not occur when there
> are precisely 0 job files.
>
> Let me know if I can help with additional details, or it is thought
> that I am in error.
>
> Thanks,
> fdr
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =EF=BF=BDhttp://vger.kernel.org/majordomo-info.html
