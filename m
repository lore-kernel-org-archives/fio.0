Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f171.google.com ([209.85.217.171]:35679 "EHLO
        mail-ua0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754392AbeBGQSv (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 7 Feb 2018 11:18:51 -0500
Received: by mail-ua0-f171.google.com with SMTP id n1so907729uaa.2
        for <fio@vger.kernel.org>; Wed, 07 Feb 2018 08:18:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <BN3PR0401MB14579324E9BF2ACE1436FDBA8FFC0@BN3PR0401MB1457.namprd04.prod.outlook.com>
References: <CAPSTwmSKtMj5yGR2Wb3AY54_CGfWbdEqoWKYy1fKDBiQ3Uo4=Q@mail.gmail.com>
 <CAPSTwmRSGS2xrg=uTtWP-0mU8n0us_1QE8wAF7_tEkUPKJ8CnQ@mail.gmail.com>
 <CALjAwxhb2ozbDNv02CqiaHUzHmCFDYU6+_DNwhde2GnRT2pEcw@mail.gmail.com>
 <CAPSTwmSAFStSizVSp4cMJv8NMnP=wVnfnp_A6SPXTfgOO-FmaQ@mail.gmail.com> <BN3PR0401MB14579324E9BF2ACE1436FDBA8FFC0@BN3PR0401MB1457.namprd04.prod.outlook.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Wed, 7 Feb 2018 16:18:20 +0000
Message-ID: <CALjAwxgCXhoMbYJ7y_qP89GinDTudSZrmoCWXg5DPA5Dm3j8nA@mail.gmail.com>
Subject: Re: Failures noticed in FIO run
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jeff Furlong <jeff.furlong@wdc.com>
Cc: Gnana Sekhar <kgsgnana2020@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

On 7 February 2018 at 01:39, Jeff Furlong <jeff.furlong@wdc.com> wrote:

>> Similarly if I pass offsets that aren't aligned with file system underneath, is there a way to inform fio to round it up
> You may want to look at the offset_align parameter.

If you are specifying an absolute number (i.e. it's not a percentage)
as the offset then I don't think offset_align will fix it up for you -
you asked explicitly for that offset:

"offset_align=int If set to non-zero value, the byte offset generated
by a percentage offset is aligned upwards to this value."

-- 
Sitsofe | http://sucs.org/~sits/
