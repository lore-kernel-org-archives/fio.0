Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f44.google.com ([209.85.213.44]:51267 "EHLO
        mail-vk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750953AbdJAIaw (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 1 Oct 2017 04:30:52 -0400
Received: by mail-vk0-f44.google.com with SMTP id g68so1615252vki.8
        for <fio@vger.kernel.org>; Sun, 01 Oct 2017 01:30:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <6BE86449B829564D9D1E4F45B1C042F3CF3E48C4@S030111.Nanotech.local>
References: <6BE86449B829564D9D1E4F45B1C042F3CF3E48C4@S030111.Nanotech.local>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Sun, 1 Oct 2017 09:30:21 +0100
Message-ID: <CALjAwxhui5ehCsG0CdqH=-wQV0UT4nXz33k1gsx+hiVJy3VcHw@mail.gmail.com>
Subject: Re: Issue regarding using gnuplot
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "kushnir@gsnanotech.com" <kushnir@gsnanotech.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

On 29 September 2017 at 07:10, kushnir@gsnanotech.com
<kushnir@gsnanotech.com> wrote:
>
> I am author of the Github issue #462 "option "runtime". My last question =
was related to using gnuplot in fio. When I try to build plots, using fio_g=
enerate_plots, gnuplot reports error: line 0: Cannot find or open file ":."=
, line 0: no data in plot. Where can be the problem?

You didn't include the command line/jobfile you are running fio with
but can you see if adding --per_job_logs=3D0 helps? fio_generate_plots
looks for log files named like <jobname>_bw.log whereas modern fio
defaults to generating log files with names like
<jobname>_bw.<jobnumber>.log (see
http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-per-job-logs
for details). A potential fix that teaches the tool how to use
per_job_logs=3D1 filenames is over in
https://github.com/sitsofe/fio/tree/fgp_fixes .

fio_generate_plots is fairly old and hasn't really kept up with fio's
changes. Unfortunately as it's mentioned directly in fio's help this
often makes it the first graphing tool people will try to use...

--=20
Sitsofe | http://sucs.org/~sits/
