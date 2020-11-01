Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725951AbgKAJSk (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 1 Nov 2020 04:18:40 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E5DEC0617A6
        for <fio@vger.kernel.org>; Sun,  1 Nov 2020 01:18:40 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id h62so1770325wme.3
        for <fio@vger.kernel.org>; Sun, 01 Nov 2020 01:18:40 -0800 (PST)
MIME-Version: 1.0
References: <BC3AAB04-870C-4460-8534-D3D91BFEFEBC@altsystems.com>
In-Reply-To: <BC3AAB04-870C-4460-8534-D3D91BFEFEBC@altsystems.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Sun, 1 Nov 2020 09:18:13 +0000
Message-ID: <CALjAwxgH9oQZXp6zoTF5CTUykQ3Ogv2KkD_9E=_SuJwFrEKzog@mail.gmail.com>
Subject: Re: Measuring runtime on Windows
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
List-Id: fio@vger.kernel.org
To: Elliott Balsley <elliott@altsystems.com>
Cc: fio <fio@vger.kernel.org>

On Fri, 11 Sep 2020 at 20:48, Elliott Balsley <elliott@altsystems.com> wrot=
e:
>
> I was trying to use fio in a Python script to get some benchmarks, and I =
compared fio measurements with psutil.disk_io_counters().  On Windows 10, t=
here is a very large discrepancy, but on macOS it=E2=80=99s much closer.  A=
fter some investigation, I think the problem is the measured runtime.  Does=
 anybody know why Windows thinks a command takes longer than fio says it di=
d?
>
> For example on Windows Powershell:
>
> (Measure-Command {fio --name larry --rw write --size 1G --directory D\:\t=
emp | Write-Host}).TotalMilliseconds
>
> Here, fio output shows run=3D4849-4849msec, while Measure-Command shows 6=
779ms (40% extra).
>
> On macOS a similar command:
> time fio --name larry --rw write --size 4G --directory /var/tmp/
>
> Here, fio output shows run=3D6200-6200msec, while time shows 6583ms (real=
).  Only 6% extra.

Process start/destruction overhead might be higher on Windows because
it doesn't use fork. Also, some of the time is going to be consumed
within fio doing things like creating the file, dropping the cache for
it etc. which varies from OS to OS. Have you timed how long it takes
to do fio --version or the smallest possible job?

If the time is disappearing "within" fio you would have to do some
profiling to work out just where it went. fio --thread --debug=3Dall
--name=3Dtest --size=3D4k will print lots of output (the job is purposely
small to limit the output) but that output doesn't have timings so you
would have to modify the fio source to find out just how much time was
spent on each section.

--=20
Sitsofe | http://sucs.org/~sits/

