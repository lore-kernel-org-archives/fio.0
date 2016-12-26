Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f170.google.com ([209.85.217.170]:32897 "EHLO
        mail-ua0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753917AbcLZQnd (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 26 Dec 2016 11:43:33 -0500
Received: by mail-ua0-f170.google.com with SMTP id i68so61763992uad.0
        for <fio@vger.kernel.org>; Mon, 26 Dec 2016 08:43:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAKV1nBaVHBaFXaKoKVD2Xbqfsejrn7y7ufWGx=rPcd=ekVgKKQ@mail.gmail.com>
References: <CAKV1nBbOg6k3teSbeZkVJ5APhkrmNRYxOQL1UUhdOsqrLejbiQ@mail.gmail.com>
 <CALjAwxip9NM8_=3Vj1xEDWRPnrRVFCELYKhuSr4YMxdkO0ksgQ@mail.gmail.com>
 <CAKV1nBYMEWt0P6jXZvUijcZtMuP7hJ16MBhBFcKszwqt-7OwOA@mail.gmail.com>
 <CALjAwxht_q0WRvJGBA_wxT+0p-yPfmQy8C3k5vwYv2pRtcdSfA@mail.gmail.com>
 <CAKV1nBZ1F1g2t-H5NS4Po9huXnpZ1wfKNQCUXekMCdLmLE-Vig@mail.gmail.com>
 <CALjAwxhoGyBt9=pzzOijtzu3RqRJnoZ3r2fV5pntOqvOgMYhZw@mail.gmail.com>
 <CAKV1nBaM=Cj4qHcyQSJuBmTB4htAupp4Uyh1TEAF_bjk8XJtqQ@mail.gmail.com>
 <CALjAwxgKQ7sPKOszrkjSXtDMiHf+BepyrFZXv=chTdoyFF7cQw@mail.gmail.com>
 <CAKV1nBZ3aXn0VeKzgJCui87-+AE-kMR8KwfQ3o44xtrsq+64oQ@mail.gmail.com>
 <CALjAwxg7x7ae+M7vHAr31BAOZ68a-UNrMqcMyqCeeYmS-N1NTA@mail.gmail.com>
 <CAKV1nBZfDgy_+4nAOYXni0m=Q0WUNrn-_q9J_+XuwWRZR03Enw@mail.gmail.com>
 <CALjAwxhDo2p=LFG-r6ZcGbiEk26sZgO8BAnVCrUFXRDVQ9DTkw@mail.gmail.com> <CAKV1nBaVHBaFXaKoKVD2Xbqfsejrn7y7ufWGx=rPcd=ekVgKKQ@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Mon, 26 Dec 2016 16:43:31 +0000
Message-ID: <CALjAwxiiezsTb0N7g9zQ_9aO0vpW84i03C8P6YV09TH728MyyA@mail.gmail.com>
Subject: Re: FIO -- A few basic questions on Data Integrity.
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Saju Nair <saju.mad.nair@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

(Re-sending take 2 because Google's mobile web client forced HTML mail)

Hi,

I'm glad to hear you got to the bottom of things - were you able to
get dd to return the same data as fio in the end and if so how (it
might help others)? What was the change that solved your HW issue
(again it might help someone else in the future)?

Re verification speed: When you say the speed is one tenth that of
regular reads are the "regular" reads also using numjobs=1? If not the
comparison isn't fair and you need to rerun it with numjobs=1
everywhere and tell us what the difference was for those runs.

Re store data to RAM: as stated in previous emails fio isn't a bulk
data copying/moving tool so you would have to write new code to make
it act as such.

On 26 December 2016 at 05:30, Saju Nair <saju.mad.nair@gmail.com> wrote:
> Thanks.
> Apologies for the delay - Based on  the FIO debug messages, we figured
> out that there was an underlying issue in the drive HW, and eventually
> figured out the problem and fixed it.
> FIO based data integrity works fine for us now, although at lower performance.
> The read-verify step runs at about 1/10-th of the normal "read" performance.
>
> Note that we keep "numjobs=1" - in order to not create any
> complications due to this, in the verify stage.
>
> I am not sure if this is possible, but, can FIO store the data read
> into the RAM of the host machine ?
> If so, one solution we are exploring is to break our existing
> read-verify step to :
>
> break into N smaller # FIO accesses, and foreach of N
>    FIO reads - to RAM of host machine
>    special program to mem-compare against expected data.

-- 
Sitsofe | http://sucs.org/~sits/
