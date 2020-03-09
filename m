Return-Path: <fio-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:63803 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725942AbgCIHJj (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 9 Mar 2020 03:09:39 -0400
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: Fio and zns testing
Date: Mon, 9 Mar 2020 07:09:36 +0000
Message-ID: <BYAPR04MB5816E102A4050BC5A3837229E7FE0@BYAPR04MB5816.namprd04.prod.outlook.com>
References: <CAKwzdDqMHe7HHSPqr49SyFrrGWCZKH+BksNanCYuVBD0CgZ0Sw@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: abhishek koundal <akoundal@gmail.com>, fio <fio@vger.kernel.org>

On 2020/03/05 8:22, abhishek koundal wrote:=0A=
> hi,=0A=
> Just wanted to know if the FIO will be adding the support for the Zone=0A=
> Name Space testing?=0A=
> =0A=
=0A=
NVMe Zoned Namespace devices will be exposed by the kernel as zoned block=
=0A=
devices, exactly like SMR HDDs. This means that most of the "zonemode=3Dzbd=
"=0A=
support added to fio since version 3.9 apply to ZNS. Only a few minor=0A=
modifications will be necessary to generically handle all devices due to so=
me=0A=
minor differences in the interface between SMR HDDs and ZNS SSDs (e.g. the=
=0A=
addition of zone capacity). But nothing major. The current fio zbd support =
will=0A=
work mostly as is.=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

