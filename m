Return-Path: <fio-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:45067 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755805AbcITSDb (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 20 Sep 2016 14:03:31 -0400
From: Jeff Furlong <jeff.furlong@hgst.com>
Subject: fio SGL support
Date: Tue, 20 Sep 2016 18:03:01 +0000
Message-ID: <BN3PR0401MB1457EB6AB90FEEAEA28DF05EF7F70@BN3PR0401MB1457.namprd04.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi All,
Is it possible to add Scatter Gather List (SGL) support to fio?=A0 Suppose =
we have a 16KB write to our device.=A0 I believe fio will allocate memory i=
n 4KB pages (depending upon machine architecture).=A0 For SGL use, it would=
 be valuable to define the SGL descriptors, such that we could control the =
16KB write as (example): 512B, 3.5KB, 4KB, 8KB.=A0 Similarly for reads, we =
may define the SGL descriptors for how to place the IO in memory.

If fio SGL support is possible, then the descriptors would be passed down t=
o the kernel and driver level, where SGL supported drivers would be require=
d.=A0 However, the latest Linux kernels are offering support.

If fio SGL support is possible, adding an option such as sglsplit (similar =
to bssplit) may be an easy way to specify the descriptors.

Thanks.

Regards,
Jeff

