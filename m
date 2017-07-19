Return-Path: <fio-owner@vger.kernel.org>
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:44712 "EHLO
        wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754143AbdGSRyX (ORCPT
        <rfc822;fio@vger.kernel.org>); Wed, 19 Jul 2017 13:54:23 -0400
From: Danny Al-Gaaf <danny.al-gaaf@bisect.de>
Subject: iSCSI write performance issues
Reply-To: Danny Al-Gaaf <danny.al-gaaf@bisect.de>
Message-ID: <8b6ac1f2-a6e6-54a2-a439-339df8860e55@bisect.de>
Date: Wed, 19 Jul 2017 19:22:16 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

I'm running into an issue with performance measurements on an iSCSI
volume. The volume has set a QoS value of max. 30.000 iops.

I run tests with the libaio engine against the volume with the following
base parameter:

fio --filename=/dev/sde --ioengine=libaio --direct=1 --buffered=0
--atomic=1 --bs=4k --invalidate=0
--readwrite=[read,write,randwrite,randread] --iodepth=128 --time_based
--runtime=1200  --name=ft --write_iops_log=w_iops_log
--write_bw_log=w_bw_log --write_lat_log=w_lat_log --output=fio_log

With randread/randwrite everything is as expected. The volume reaches
the QoS max value and not more. But with write/read/readwrite I can get
over the max QoS IOPs: ~41k iops.

After some investigation with wireshark it seems with seq r/w packages
are aggregated (e.g. 8k TCP packages instead of 4k), which they are not
with randwrite.

Is there an issue in libaio or in fio? Or is it an expected behavior
from the kernel?

Danny
