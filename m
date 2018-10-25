Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua1-f46.google.com ([209.85.222.46]:40305 "EHLO
        mail-ua1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726633AbeJYOVW (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 25 Oct 2018 10:21:22 -0400
Received: by mail-ua1-f46.google.com with SMTP id f23so1122620uam.7
        for <fio@vger.kernel.org>; Wed, 24 Oct 2018 22:50:12 -0700 (PDT)
MIME-Version: 1.0
References: <CAKiK_mBJvdwd6pLaLb9P4pzGPrsffLwnP2ofTyDgEBXN-sJP+Q@mail.gmail.com>
In-Reply-To: <CAKiK_mBJvdwd6pLaLb9P4pzGPrsffLwnP2ofTyDgEBXN-sJP+Q@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Thu, 25 Oct 2018 06:49:44 +0100
Message-ID: <CALjAwxi=T_R-MTc-fQO=0o1B1XcW5jTmPkJ=JjT_3qGu-HDFyg@mail.gmail.com>
Subject: Re: Question about data verification using FIO
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: taylor4869@gmail.com
Cc: fio <fio@vger.kernel.org>

Hi Taylor,

On Wed, 24 Oct 2018 at 23:29, Taylor Yang <taylor4869@gmail.com> wrote:
>
> I know for the option 'verify', we could specify it when we write and
> read a file. But does it work with the option 'time_base' and
> 'runtime'?

Maybe?

> For example, does the configuration below make sense?
>
> [global]
> direct=1
> ioengine=libaio
> time_based
> numjobs=1
> verify=crc32
> runtime=50000

This doesn't make sense to me because I can't see the rest of the
options / fio invocation you used. So first up there's no job defined
(only global options) so given the above by itself fio will complain
about "No job(s) defined". I also can't tell if you've already made
the file using some other fio invocation and you are intending this
one just to keep verifying it. fio defaults to read jobs when rw isn't
set (https://fio.readthedocs.io/en/latest/fio_man.html#cmdoption-arg-readwrite
) so this will be a pure verification job and if you haven't
previously created/filled the file with fio crc32 verification headers
you'll get an instant mismatch.

> The verification process might not even start if the runtime ends,
> right? If this is the case, what should I do to configure it in such a
> way that it could do the read and write and also data verification in
> some targeted period of time?

If you mean when you set rw=write then your deduction is right and
recent fios will even tell you this:
$ cat write_verify_timebased.fio
[global]
direct=1
ioengine=libaio
time_based
numjobs=1
verify=crc32
runtime=5s

[write_verify_timebased]
size=1M
rw=write
$ fio write_verify_timebased.fio
fio: verification read phase will never start because write phase uses
all of runtime
[...]

As for solutions, you may find doing inline verifies is good enough
for you (see http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-verify-backlog
). See https://github.com/axboe/fio/issues/322#issuecomment-283265965
for some discussion about trying to do time based verification (TLDR;
it can be tricky).



--
Sitsofe | http://sucs.org/~sits/

