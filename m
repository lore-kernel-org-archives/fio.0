Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wr1-f53.google.com ([209.85.221.53]:41041 "EHLO
        mail-wr1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727368AbfAHKoe (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 8 Jan 2019 05:44:34 -0500
Received: by mail-wr1-f53.google.com with SMTP id x10so3514179wrs.8
        for <fio@vger.kernel.org>; Tue, 08 Jan 2019 02:44:33 -0800 (PST)
From: Paolo Valente <paolo.valente@linaro.org>
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 12.2 \(3445.102.3\))
Subject: question on fio memory handling
Message-Id: <FEB3F53B-C00E-423B-B36B-5F6D11C83BB8@linaro.org>
Date: Tue, 8 Jan 2019 11:44:30 +0100
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio <fio@vger.kernel.org>
Cc: Alessio Masola <alessio.masola@gmail.com>

Hi,
we are using fio to generate interleaved I/O, by making several job read =
from the whole /dev/sda and we are using zoneskip to create the =
interleave among jobs.

But we have bumped into the following issue, shown for just one job. The =
following command:

$ sudo fio --name=3Dreader0 -rw=3Dread --filename=3D/dev/sda =
--zonesize=3D16384 --zonemode=3Dzbd --zoneskip=3D16384
smalloc: OOM. Consider using --alloc-size to increase the shared memory =
available.

In contrast, if we invoke,

sudo fio --name=3Dreader0 -rw=3Dread --filename=3D/dev/sda =
--zonesize=3D16384 --zonemode=3Dstrided --zoneskip=3D16384

(which is ok for our goal at the moment), then we everything seems to =
work fine.

Could you please example me why --zonemode=3Dzbd fails by apparently =
trying to allocate memory for the whole size of the special file =
/dev/sda? Is it (strictly) necessary for doing random I/O among zones?

Thanks,
Paolo=

