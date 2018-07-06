Return-Path: <fio-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:25003 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932965AbeGFWO7 (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 6 Jul 2018 18:14:59 -0400
From: Jeff Furlong <jeff.furlong@wdc.com>
Subject: fio serialize across jobs
Date: Fri, 6 Jul 2018 22:14:57 +0000
Message-ID: <MWHPR04MB0320ED986E73B1E9994929B38F470@MWHPR04MB0320.namprd04.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi All,
Back in commit 997b5680d139ce82c2034ba3a0d602cfd778b89b "fio: add serialize=
_overlap option" the feature was added to prevent write/trim race condition=
s within the queue.  Can this feature be applied to multiple jobs?  Conside=
r:

fio --ioengine=3Dlibaio --direct=3D1  --filename=3D/dev/nvme0n1 --time_base=
d --name=3Dtest1 --rw=3Drandwrite --runtime=3D5s --name=3Dtest2 --rw=3Drand=
write --runtime=3D5s --serialize_overlap=3D1

Would we have to call in_flight_overlap() in a loop with all thread data po=
inters?

Thanks.

Regards,
Jeff

