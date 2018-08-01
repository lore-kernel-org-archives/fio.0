Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f174.google.com ([209.85.217.174]:39557 "EHLO
        mail-ua0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730848AbeHAUbx (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 1 Aug 2018 16:31:53 -0400
Received: by mail-ua0-f174.google.com with SMTP id g18-v6so13383516uam.6
        for <fio@vger.kernel.org>; Wed, 01 Aug 2018 11:44:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CANvN+ekqnT6YZ2LHPMzbF5hX4kSy+Tog9=8_+hoG+pz+JOrxsw@mail.gmail.com>
References: <CANvN+ekqnT6YZ2LHPMzbF5hX4kSy+Tog9=8_+hoG+pz+JOrxsw@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Wed, 1 Aug 2018 19:44:15 +0100
Message-ID: <CALjAwxi5b_Zd74VQkxnu4M_sEpLPOHXVs9PUojzypLoTSw=4ag@mail.gmail.com>
Subject: Re: Multi-threaded verification in the partitiioned device case
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Cc: fio <fio@vger.kernel.org>

Hi,

On 1 August 2018 at 18:06, Andrey Kuzmin <andrey.v.kuzmin@gmail.com> wrote:
> As far as I understand, verification in the multi-threaded (num_jobs > 1)
> case is neither supported nor recommended.
>
> I wonder if it also holds for the case of a multiple-threaded job being run
> against a partitioned (using FIO's offset split machinery) device, with
> thread per partition. Partitioning like this should very much avoid  any
> inter-thread overlap, and seems to be safe to run in verify mode. I will
> appreciate a comment on whether the simple reasoning above holds, or
> something extra still needs to be done.

If you can arrange for each "numjob" to write only to a region not
touched by any other numjob/job then you can get a meaningful result.
For example when fio is generating unique files for each numjob by
itself there shouldn't be any problem (or warning). I guess another
example would be using filename so all numjobs are using the same file
but also using offset_increment
(http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-offset-increment
) and an appropriate size together...

-- 
Sitsofe | http://sucs.org/~sits/
