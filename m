Return-Path: <fio-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:42067 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729695AbfAIJES (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 9 Jan 2019 04:04:18 -0500
From: Filip Vervloesem <Filip.Vervloesem@wdc.com>
Subject: Combining opendir and numjobs to test randread performance
Date: Wed, 9 Jan 2019 09:04:16 +0000
Message-ID: <MN2PR04MB558480FFAD6F6FF98934E7529B8B0@MN2PR04MB5584.namprd04.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

I'm trying to test random read performance for a specific workload with a s=
et of precreated files of various sizes using the opendir option. When incr=
easing the number of jobs, I get performance results that are way too high =
for the device I'm testing. I assume this is due to caching either at the h=
ost level (although my test set is almost 3 times as large as the available=
 ram) or in the device itself.

In this case, I believe the results would be more reliable if fio would use=
 a different (precreated) input directory for every job clone. I tried usin=
g:

opendir=3D/mountpoint/of/device/$jobnum

But that syntax is currently not supported (tested using fio version fio-3.=
12-3-g46ff7). Is there another way I can test random read performance with =
e.g. numjobs=3D16 and be sure that no single file is read by more than one =
job clone?

Best regards,

Filip Vervloesem=

