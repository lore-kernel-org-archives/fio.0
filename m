Return-Path: <fio-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:21815 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750814AbdH3W20 (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 30 Aug 2017 18:28:26 -0400
From: Jeff Furlong <jeff.furlong@wdc.com>
Subject: fio patch question on filesetup: align layout buffer
Date: Wed, 30 Aug 2017 22:27:38 +0000
Message-ID: <BN3PR0401MB1457AD82F545E4C85F2CA5858F9C0@BN3PR0401MB1457.namprd04.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi All,
I see the patch at http://git.kernel.dk/cgit/fio/commit/?id=3D8c43ba6259409=
244de64f0b1d388a029e38cf3e5 and just wondered if it is still compatible wit=
h:

.. option:: iomem_align=3Dint, mem_align=3Dint

	This indicates the memory alignment of the I/O memory buffers.  Note that
	the given alignment is applied to the first I/O unit buffer, if using
	:option:`iodepth` the alignment of the following buffers are given by the
	:option:`bs` used. In other words, if using a :option:`bs` that is a
	multiple of the page sized in the system, all buffers will be aligned to
	this value. If using a :option:`bs` that is not page aligned, the alignmen=
t
	of subsequent I/O memory buffers is the sum of the :option:`iomem_align` a=
nd
	:option:`bs` used.

For example, if we set mem_align to something larger than page_size or bs, =
what does fio_memalign use?  And if we set mem_align to something between p=
age_size and bs, what does fio_memalign use?  Thanks.

Regards,
Jeff

