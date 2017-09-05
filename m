Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f44.google.com ([209.85.213.44]:33775 "EHLO
        mail-vk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753845AbdIETCv (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 5 Sep 2017 15:02:51 -0400
Received: by mail-vk0-f44.google.com with SMTP id t10so8661556vke.0
        for <fio@vger.kernel.org>; Tue, 05 Sep 2017 12:02:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BN3PR0401MB1457E83E1425DFC38C6151048F960@BN3PR0401MB1457.namprd04.prod.outlook.com>
References: <BN3PR0401MB1457AD82F545E4C85F2CA5858F9C0@BN3PR0401MB1457.namprd04.prod.outlook.com>
 <CALjAwxikXWD2WTE5d6+8U3=AQz+G7Wq1+FwBxdrHXeRK1+oDsA@mail.gmail.com> <BN3PR0401MB1457E83E1425DFC38C6151048F960@BN3PR0401MB1457.namprd04.prod.outlook.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Tue, 5 Sep 2017 20:02:20 +0100
Message-ID: <CALjAwxi2dZQemhi67nnsgtJOH9-Vdy=Qo08tgrQ+cw92onNJag@mail.gmail.com>
Subject: Re: fio patch question on filesetup: align layout buffer
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jeff Furlong <jeff.furlong@wdc.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 5 September 2017 at 19:57, Jeff Furlong <jeff.furlong@wdc.com> wrote:
> Right.  A check of memalign or page size can help.  But the patch is no l=
onger compatible with the latest git, given the recent revert.  However, my=
 concern for mem_align still remains.  How does the current git use the mem=
_align parameter in fill_io_buffer(td, b, bs, bs)?  Or is it completley han=
dled elsewhere, namely init_io_u() and allocate_io_mem()?

When the I/O is normal and uncached won't it all be taken care of in the ke=
rnel?

--=20
Sitsofe | http://sucs.org/~sits/
