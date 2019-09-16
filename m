Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38659 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729729AbfIPGct (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 16 Sep 2019 02:32:49 -0400
Received: by mail-wr1-f65.google.com with SMTP id l11so37487463wrx.5
        for <fio@vger.kernel.org>; Sun, 15 Sep 2019 23:32:47 -0700 (PDT)
MIME-Version: 1.0
References: <CABO+gV-fpuOi6u8w8-L5G+sZ7KhvPy9SC3hqXh+q6PReVTxbCA@mail.gmail.com>
 <CALjAwxi3L-N1-fW5PNJbMU0SjY6G2eRXrL4=5Z7egL3w=apPcQ@mail.gmail.com> <CABO+gV-uxLsURnoVBS1QcPPadwBVL2rm1Fo1OeG_PHB_0E16eQ@mail.gmail.com>
In-Reply-To: <CABO+gV-uxLsURnoVBS1QcPPadwBVL2rm1Fo1OeG_PHB_0E16eQ@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Mon, 16 Sep 2019 07:32:29 +0100
Message-ID: <CALjAwxi+Lpzm3yn-nZSaj+zZB8Bjn8=9gCAkP1yqkiBS8_bm6w@mail.gmail.com>
Subject: Re: Disk slows down while empting write buffer
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Elliott Balsley <elliott@altsystems.com>
Cc: fio <fio@vger.kernel.org>

Hi,

On Sun, 15 Sep 2019 at 23:10, Elliott Balsley <elliott@altsystems.com> wrote:
>
> Thanks for your suggestions.  Unfortunately, now I'm not confident in
> these results, because today this behavior is not happening, even with
> the same zpool on the same system.  Now it's writing at a steady rate
> to disks the whole time, instead of starting out very high (3GBps to
> memory) and then dropping to zero at the end.  So essentially the
> fsync doesn't have to sync anything at the end.  Is there some way to
> control this behavior?  I'm not sure if it's fio or the filesystem,
> but why does it write at disk speed today, while it wrote at memory
> speed before?

It's unlikely to be fio unless you're changing your job file (which
might mean we're not the best list to get an answer from). Maybe it's
because you're now overwriting a fully written file - does removing
the file between fio runs make any difference? You didn't post any of
your fio output so there's very little for us to go on - did you know
fio on Linux will try and show you averaged disk stats when it
finishes? We also don't know what kernel you're using etc.

Maybe memory pressure on your system is different to what it was
previously? There are controls like
/proc/sys/vm/dirty_background_ratio ,
/proc/sys/vm/dirty_expire_centisecs etc (see
https://www.kernel.org/doc/Documentation/sysctl/vm.txt for the full
list) that control when writeback starts and it could be you're in a
scenario where the system believes it has to start writeback early
(e.g. you're running a program that chews up huge amounts of memory).
Maybe /proc/meminfo will offer some clues?

Again my recommendation would be to do I/O against the raw block
device representing the RAID (or an individual disk) understanding
that it will destroy any data already there if you do writes. At least
then you will be able to say whether it's an issue going through a
filesystem or whether it's something from the block layer.

-- 
Sitsofe | http://sucs.org/~sits/

