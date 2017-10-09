Return-Path: <fio-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:26117 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752400AbdJITZz (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 9 Oct 2017 15:25:55 -0400
From: Jeff Furlong <jeff.furlong@wdc.com>
Subject: fio add trim option
Date: Mon, 9 Oct 2017 19:25:36 +0000
Message-ID: <BN3PR0401MB1457D255502835FE71E990458F740@BN3PR0401MB1457.namprd04.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi All,
Is it possible to allow --rw=3Drandrw to include a trim option?  We already=
 have --rwmixread=3Dint and --rwmixwrite=3Dint, but perhaps we need --rwmix=
trim=3Dint?  Most other parameters already seemed plumbed out for read/writ=
e/trim, such as --bs=3Dint[,int][,int].  Or is there already another way to=
 do a mix of read/write/trim from one job?  Thanks.

Regards,
Jeff
