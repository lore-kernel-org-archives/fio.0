Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wr0-f181.google.com ([209.85.128.181]:44716 "EHLO
        mail-wr0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751454AbeCPWcH (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 16 Mar 2018 18:32:07 -0400
Received: by mail-wr0-f181.google.com with SMTP id v65so12989308wrc.11
        for <fio@vger.kernel.org>; Fri, 16 Mar 2018 15:32:07 -0700 (PDT)
From: Michael Green <mishagreen@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: random_generator=lfsr overhead with more disks?
Date: Fri, 16 Mar 2018 18:32:03 -0400
References: <9FD577EB-5F83-4AB3-9FBA-704094437C15@gmail.com>
 <BN3PR0401MB145797FEFD095957854800088FD70@BN3PR0401MB1457.namprd04.prod.outlook.com>
 <13EF5126-4D32-4706-8495-B193C124826B@gmail.com>
 <BN3PR0401MB145715070B7B9F0C71A902318FD70@BN3PR0401MB1457.namprd04.prod.outlook.com>
 <902A0A2A-8708-4A94-A09E-5D3C9BFB48FF@gmail.com>
 <SN6PR04MB4064D865EBEB79DE2219218D8FD70@SN6PR04MB4064.namprd04.prod.outlook.com>
In-Reply-To: <SN6PR04MB4064D865EBEB79DE2219218D8FD70@SN6PR04MB4064.namprd04.prod.outlook.com>
Message-Id: <54DB864B-BBFF-4276-B86F-A069F22367F8@gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jeff Furlong <jeff.furlong@wdc.com>, fio@vger.kernel.org

Possibly.  Who can have a look at the code?

> On Mar 16, 2018, at 6:30 PM, Jeff Furlong <jeff.furlong@wdc.com> =
wrote:
>=20
> OK, 61% cpu with lfsr and 82% cpu without lfsr.  But the throughput is =
propositionally higher without lfsr, so perhaps that's why cpu util is =
higher.
>=20
> I'm wondering if the lfsr code is single threaded in nature or stuck =
waiting on a mutex, thereby slowing down the throughput and hence the =
lower latency.
>=20
> Regards,
> Jeff
>=20
>=20

