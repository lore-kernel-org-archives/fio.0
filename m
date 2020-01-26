Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36271 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725773AbgAZO6j (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 26 Jan 2020 09:58:39 -0500
Received: by mail-wm1-f66.google.com with SMTP id p17so4237675wma.1
        for <fio@vger.kernel.org>; Sun, 26 Jan 2020 06:58:37 -0800 (PST)
MIME-Version: 1.0
References: <CANiA0Zq4ZtgYnBkfyq2yfhCc5mNZJ+R7_kYh8By+hAqWhmwhPw@mail.gmail.com>
In-Reply-To: <CANiA0Zq4ZtgYnBkfyq2yfhCc5mNZJ+R7_kYh8By+hAqWhmwhPw@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Sun, 26 Jan 2020 14:58:11 +0000
Message-ID: <CALjAwxiH756eSTOrHL1biORS9n3HsQPT037fOpwyk3MUmJhrug@mail.gmail.com>
Subject: Re: How to cross compile fio
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sarvani Reddy Kolli <sarvanireddykolli@gmail.com>
Cc: fio <fio@vger.kernel.org>

Hi,

On Sun, 26 Jan 2020 at 01:36, Sarvani Reddy Kolli
<sarvanireddykolli@gmail.com> wrote:
>
> Hi,
> I am trying to compile and build fio 3.15 binary on a development
> machine with Centos and Intel CPU E5-1620 v3 and use it across
> different machines of which few are running with OS's like CentOs ,
> Arch and different CPU architecture like sandybridge, broadwell,
> haswell, skylake but the fio binary fails either
>
> 1. with " illegal hardware instruction (core dumped)"  - on
> sandybridge and Ivybridge CPUs or

Make sure you pass --disable-native to ./configure otherwise it will
assume your compilation machine's microarchitecture is the one to
target (you will see it configure saying something about "Build
march=native") and the binary will fail to work if moved to a lesser
CPU even if the Linux distro the binary is moved to is identical...

> 2.  "--write_hist_log=" requires zlib to run in client/server mode.

I fairly sure configure suggests the package that would have to be installed:

"Consider installing zlib-dev (zlib-devel, some fio features depend on it. "

I think of RPM distros the package that lets you build against zlib is
called zlib-devel but I don't know what it is on distros like Arch...

> Can you  provide steps to compile and build the binary that runs
> across different CPU architectures and different OS.

Building a single binary that works across multiple different Linux
distros is rather out of the scope of this list and is a more general
"building for Linux" question. If you choose to go that route (hint:
it may not be easy) you generally have to look towards bundling
libraries and messing with environment variables/rpath or more likely
switching to static linking (see ./configure --help) but then ALL your
libraries must be present in static form on the build machine). Even
with static linking there are other caveats (you may find you have to
build the binary on the oldest OS, you may find trouble static linking
glibc and start looking to use musl which will bring different
challenges)...

Good luck!

-- 
Sitsofe | http://sucs.org/~sits/

