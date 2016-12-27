Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f172.google.com ([209.85.217.172]:34021 "EHLO
        mail-ua0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754269AbcL0Lrr (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 27 Dec 2016 06:47:47 -0500
Received: by mail-ua0-f172.google.com with SMTP id 34so142168762uac.1
        for <fio@vger.kernel.org>; Tue, 27 Dec 2016 03:47:46 -0800 (PST)
MIME-Version: 1.0
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Tue, 27 Dec 2016 11:47:45 +0000
Message-ID: <CALjAwxgdYU-QHdyRe3B=bgEU7-9zLjGs7ayOts_D-juAq_Uiig@mail.gmail.com>
Subject: Re: Faster fio verification
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Saju Nair <saju.mad.nair@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

On 27 December 2016 at 04:33, Saju Nair <saju.mad.nair@gmail.com> wrote:
>
> > Re verification speed: When you say the speed is one tenth that of
> > regular reads are the "regular" reads also using numjobs=3D1? If not th=
e
> > comparison isn't fair and you need to rerun it with numjobs=3D1
> > everywhere and tell us what the difference was for those runs.
>
> Yes, it was with num_jobs =3D 1 in both cases of "regular read" and "read=
-verify". I think it is understandable that there is a performance drop, si=
nce the compare/verify is done on-the-fly.. Where does FIO store the data r=
ead, before the verify step is executed.

During a verifying read the data of the block read is kept in RAM and
if needed (depends on the verification type) the data to compare
against is regenerated. Because of this very little or no data needs
to be stored during the write phase.

One option to try and speed verification up (assuming you have the
spare CPUs) could be to use verify_async (see the HOWTO). Another
option could be to use faster verification comparisons (see verify=3Dstr
of the HOWTO). For example the verify=3Dcrc32c checksum calculation will
be hardware accelerated on recent x86 machines. Do either of these
make a difference?

--=20
Sitsofe | http://sucs.org/~sits/
