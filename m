Return-Path: <fio-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:6656 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725968AbgD0X2z (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 27 Apr 2020 19:28:55 -0400
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 5/5] zbd: Introduce thread zbd operations
Date: Mon, 27 Apr 2020 23:28:52 +0000
Message-ID: <BY5PR04MB690026D4957DAD98C24E4022E7AF0@BY5PR04MB6900.namprd04.prod.outlook.com>
References: <20200427184500.GA29918@avx2>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 2020/04/28 3:45, Alexey Dobriyan wrote:=0A=
>> -	if (td->o.zone_mode =3D=3D ZONE_MODE_ZBD) {=0A=
>> -		ret =3D zbd_adjust_block(td, io_u);=0A=
>> -		if (ret =3D=3D io_u_eof)=0A=
>> -			return 1;=0A=
>> -	}=0A=
>> +	ret =3D zbd_adjust_block(td, io_u);=0A=
>> +	if (ret =3D=3D io_u_eof)=0A=
>> +		return 1;=0A=
> =0A=
> This is cleaner code but probably won't result in performance changes=0A=
> because it is trading a branch and a regular function call to a branch=0A=
> and indirect function call.=0A=
> =0A=
=0A=
Yes. I wondered how to best avoid overhead for the regular case. Tried diff=
erent=0A=
things but this one was the cleanest and probably has the least impact on z=
bd=0A=
mode itself. I am starting to think that it may be better to have a=0A=
zbd_fill_io_u() function called in place of the regular fill_io_u(). That w=
ould=0A=
reduce the 3 conditionals we have for zbd to one only, and also allow more=
=0A=
liberty with io_u adjustments for zbd without impacting the regular device =
case.=0A=
Thoughts ?=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

