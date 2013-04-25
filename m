Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ob0-f173.google.com ([209.85.214.173]:57874 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932495Ab3DYOry (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 25 Apr 2013 10:47:54 -0400
Received: by mail-ob0-f173.google.com with SMTP id xn12so2584310obc.18
        for <fio@vger.kernel.org>; Thu, 25 Apr 2013 07:47:53 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 25 Apr 2013 10:47:53 -0400
Message-ID: <CAEzQZ4AEx5ioBUMR2HieVe9eoi2iwu-mFdEPdTkuPci55jBqHQ@mail.gmail.com>
Subject: Random IO pattern ratios
From: Brian Carey <brian@careydrive.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hello all,

I'm fairly new to fio and am trying to vary the ratio of sequential to
random IO per job.  I'm not sure if I'm reading the section of the
HowTo on mixed IO types right or not .  I'm trying to have the first
job do 100% sequential access, the 2nd do 50% sequential/50% random,
and the 3rd do 100% random.  Below is the section of the How To that
I'm referring to as well as a snip of my config.

For the mixed io types, the default is to split them 50/50.
For certain types of io the result may still be skewed a bit,
since the speed may be different. It is possible to specify
a number of IO's to do before getting a new offset, this is
one by appending a ':<nr>' to the end of the string given.
For a random read, it would look like 'rw=randread:8' for
passing in an offset modifier with a value of 8. If the
suffix is used with a sequential IO pattern, then the value
specified will be added to the generated offset for each IO.
For instance, using rw=write:4k will skip 4k for every
write. It turns sequential IO into sequential IO with holes.
See the 'rw_sequencer' option.

[4k 70/30% R/W - 100% seq]
bs=4k
rw=rw
rwmixread=70
rwmixwrite=30
stonewall

[4k 70/30% R/W - 50% seq]
bs=4k
rw=randrw:2
rwmixread=70
rwmixwrite=30
stonewall

[4k 70/30% R/W - 0% seq]
bs=4k
rw=randrw
rwmixread=70
rwmixwrite=30
stonewall
