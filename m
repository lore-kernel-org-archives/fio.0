Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f170.google.com ([209.85.217.170]:35773 "EHLO
        mail-ua0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751355AbeCHM3C (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 8 Mar 2018 07:29:02 -0500
Received: by mail-ua0-f170.google.com with SMTP id c40so3773883uae.2
        for <fio@vger.kernel.org>; Thu, 08 Mar 2018 04:29:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <2B8D69D8-05F3-4500-8A4E-F5DE21356676@nutanix.com>
References: <e044afaa-22ad-c7e2-d041-e2658f49bac8@bluestop.org>
 <CALjAwxjoTtRp1jVhfKMTcbn6wnmEmmCsjkpO7CkBgF5zj4B3Bg@mail.gmail.com>
 <9cf7d62a-5c4a-737a-d119-13763fb42c72@bluestop.org> <CALjAwxhxpLuLeysnp5kC-kQoWH++4hvehCWJxc9yA_Fcsy=pmw@mail.gmail.com>
 <BAE7B5AF-63F9-4E95-940D-7C84CE5AD92E@nutanix.com> <36259BEC-1CF0-45A5-85AE-F557989EDF30@nutanix.com>
 <2B8D69D8-05F3-4500-8A4E-F5DE21356676@nutanix.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Thu, 8 Mar 2018 12:28:31 +0000
Message-ID: <CALjAwxiTX1=7pJKQ1Lz7nDkMXZqVJkMkNZDOA_XJYsEGP7wSfw@mail.gmail.com>
Subject: Re: Windows: FIO randomly hangs using attached script
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Rob Scheepens <rob.scheepens@nutanix.com>
Cc: David Knierim <knierim@nutanix.com>, Rebecca Cran <rebecca@bluestop.org>, fio <fio@vger.kernel.org>

A backtrace would be a good starting point but we need your gdb to be
able to be able to produce that... If you've managed to successfully
attach gdb to fio running something like

set logging file fiobacktrace.txt
set logging on
thread apply all bt
set logging off

and copying the contents of fiobacktrace.txt to here would be helpful.
If possible also take a note of the exact job that failed and send it
over as presumably we can just keep rerunning that to produce the
problem.

On 8 March 2018 at 10:51, Rob Scheepens <rob.scheepens@nutanix.com> wrote:
> Just tested using fio-3.5: the first attempt already hung, at:
>
> PS C:\Python27> python .\profiler_win_dk.py
> * Running job: 'config' (20 secs / spec)
> ** Executing spec 176/405 at 2018-03-08 02:10:25.360000
>
> Instead of trying an large amount of variations to reproduce, which will =
be time-consuming, is there a way to capture a dump using gdb and debug tha=
t? I have very limited gdb skills and when I recently tried to save it off,=
 it gave me an error that seemed to implicate some lib was not implemented =
on Windows.
>
> I left the vm in the current state, in case anyone wants me to get someth=
ing from it.

--=20
Sitsofe | http://sucs.org/~sits/
