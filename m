Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7B57C433EF
	for <fio@archiver.kernel.org>; Fri, 29 Apr 2022 18:20:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379974AbiD2SYG (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 29 Apr 2022 14:24:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379945AbiD2SX5 (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 29 Apr 2022 14:23:57 -0400
Received: from mailout1.w2.samsung.com (mailout1.w2.samsung.com [211.189.100.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3689333366
        for <fio@vger.kernel.org>; Fri, 29 Apr 2022 11:20:38 -0700 (PDT)
Received: from uscas1p1.samsung.com (unknown [182.198.245.206])
        by mailout1.w2.samsung.com (KnoxPortal) with ESMTP id 20220429182037usoutp0157e0647fdc0cd72ef44938bb36ccd31c~qcPsw28xm1531315313usoutp01V;
        Fri, 29 Apr 2022 18:20:37 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w2.samsung.com 20220429182037usoutp0157e0647fdc0cd72ef44938bb36ccd31c~qcPsw28xm1531315313usoutp01V
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1651256437;
        bh=iiaBLAY3rnKfT9AvRpznCxUTQ6J6Fzv3ozZdkfVIKyo=;
        h=From:To:CC:Subject:Date:In-Reply-To:References:From;
        b=UHJNqkdwz2A0mmoCYTAt4w3A9ti/QGK5C7ADDWKxDHMRjUwmBHQNHztubKBEflR6N
         nAbEa8Au+X7u0Q361z6lBiyDBNT40jGMX1AoIc096G56nu/q34EaZmtFE7sFPvWzON
         NYQVkzHkkiZbs4CQ7cWyW3KHDFJygENh2Tm2PkdM=
Received: from ussmges2new.samsung.com (u111.gpu85.samsung.co.kr
        [203.254.195.111]) by uscas1p1.samsung.com (KnoxPortal) with ESMTP id
        20220429182037uscas1p1b6aa06b85f2c09fce6c40dc8e46e9311~qcPskjuiq1904119041uscas1p14;
        Fri, 29 Apr 2022 18:20:37 +0000 (GMT)
Received: from uscas1p1.samsung.com ( [182.198.245.206]) by
        ussmges2new.samsung.com (USCPEMTA) with SMTP id 03.E8.09642.57C2C626; Fri,
        29 Apr 2022 14:20:37 -0400 (EDT)
Received: from ussmgxs2new.samsung.com (u91.gpu85.samsung.co.kr
        [203.254.195.91]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
        20220429182036uscas1p2bcc8b7a11f758d77f348e5f6d6df3e1c~qcPsIxQym1582715827uscas1p2d;
        Fri, 29 Apr 2022 18:20:36 +0000 (GMT)
X-AuditID: cbfec36f-bfdff700000025aa-9a-626c2c75721e
Received: from SSI-EX3.ssi.samsung.com ( [105.128.2.146]) by
        ussmgxs2new.samsung.com (USCPEXMTA) with SMTP id 68.34.09672.47C2C626; Fri,
        29 Apr 2022 14:20:36 -0400 (EDT)
Received: from SSI-EX3.ssi.samsung.com (105.128.2.228) by
        SSI-EX3.ssi.samsung.com (105.128.2.228) with Microsoft SMTP Server
        (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
        15.1.2375.7; Fri, 29 Apr 2022 11:20:36 -0700
Received: from SSI-EX3.ssi.samsung.com ([105.128.5.228]) by
        SSI-EX3.ssi.samsung.com ([105.128.5.228]) with mapi id 15.01.2375.007; Fri,
        29 Apr 2022 11:20:36 -0700
From:   Vincent Fu <vincent.fu@samsung.com>
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>, Jens Axboe <axboe@kernel.dk>
CC:     Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Niklas Cassel <Niklas.Cassel@wdc.com>,
        fio Mailing List <fio@vger.kernel.org>,
        "GNU/Weeb Mailing List" <gwml@vger.gnuweeb.org>
Subject: RE: [PATCH v1 3/8] engines/net: Add ENOMEM handling on a `malloc()`
 call
Thread-Topic: [PATCH v1 3/8] engines/net: Add ENOMEM handling on a
        `malloc()` call
Thread-Index: AQHYW2LIJGiKZbNsvEOOjWUgCBBNza0HNMgg
Date:   Fri, 29 Apr 2022 18:20:35 +0000
Message-ID: <39a2c859027f491a9bfa7665f0ffd181@samsung.com>
In-Reply-To: <20220429004705.260034-4-ammarfaizi2@gnuweeb.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [105.128.2.176]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBKsWRmVeSWpSXmKPExsWy7djXc7qlOjlJBuuW8Fjc+u1lceP3WiaL
        1Xf72Sw+znrBbHHm7k4Wiwd/HrM7sHkcmLaD1ePy2VKP1kObmTw+b5LzaD/QzRTAGsVlk5Ka
        k1mWWqRvl8CVsX37NdaCNbwVLx5+Zm5gfMrVxcjJISFgIrGlfwYTiC0ksJJRYsafkC5GLiC7
        lUnizr/JjDBFLzafZYNIrGWU+HL3AxOE85FRYsLsC+wQzjJGibNPNgFlODjYBDQl3u4vAOkW
        EXCXmHTqNStIDbPAPkaJFdu+s4AkhAWCJa7tuc0GUi8iECLxaFoSRL2RxJtJ3ewgNouAqsSj
        zTvBRvIKWEm0fAW7lFPATqJp3yqw4xgFxCS+n1oDFmcWEJe49WQ+E8TRghKLZu9hhrDFJP7t
        esgGYStK3P/+kh2iXkdiwe5PbBC2tsSyha/B6nmBek/OfMICUS8pcXDFDRaQ8yUEjnBINC+a
        ATXURWLyvD6oZdISf+8uY4IoameUmLvxC1T3BEaJ60+kIGxriX+d16A280n8/fWIcQKj8iwk
        h89CctQsJEfNQnLUAkaWVYzipcXFuempxUZ5qeV6xYm5xaV56XrJ+bmbGIGJ5/S/w/k7GK/f
        +qh3iJGJg/EQowQHs5II75fdGUlCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeZdlbkgUEkhPLEnN
        Tk0tSC2CyTJxcEo1MG0/GBkR7n9ob1LOJDedgvUJfC6Tenz2NC+8xaw+P88z+ZSc7bWn+/PX
        BE76sXiP+EP1rD4VP+kz1pPqOXXsmL4sWvtn952vDNWXp8pOPqOq6f6GIcdY4d3bp0/Dl0+v
        bz7vw/gh87enwMynniVSAlfWxNj9eCqXFPmzud3rv+7P1eePsc5+cIjz1jkFC4Y4ttr5it7W
        CjGR3x+FuO/73SYtU6+u+PVS+6RrWZeFl/PfnKTQMO1u8K1FCfG/7olxzva5zbNz3umwBVWP
        elgfneHLO6iyID1mpv7D645vZs8TynNudtCJ3/fmyYq9kwKXG1a+C7qnKxngs/Cn/oPzSnnN
        PNOmyO5aIzjt6JeD0T1KLMUZiYZazEXFiQCKt8HGqwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNIsWRmVeSWpSXmKPExsWS2cA0SbdEJyfJ4P9vHYtbv70sbvxey2Sx
        +m4/m8XHWS+YLc7c3cli8eDPY3YHNo8D03awelw+W+rRemgzk8fnTXIe7Qe6mQJYo7hsUlJz
        MstSi/TtErgytm+/xlqwhrfixcPPzA2MT7m6GDk5JARMJF5sPsvWxcjFISSwmlGi8+VkKOcj
        o8STnh4oZxmjxK6Ln1i7GDk42AQ0Jd7uLwDpFhFwl5h06jUrSA2zwD5GiRXbvrOAJIQFgiWu
        7bnNBlEUIrF/y3Z2CNtI4s2kbjCbRUBV4tHmnUwgM3kFrCRavjJB7DrKKPGp4R0TSA2ngJ1E
        075VjCA2o4CYxPdTa8DizALiEreezGeCeEFAYsme88wQtqjEy8f/WCFsRYn731+yQ9TrSCzY
        /YkNwtaWWLbwNVg9r4CgxMmZT1gg6iUlDq64wTKBUXwWkhWzkLTPQtI+C0n7AkaWVYzipcXF
        uekVxUZ5qeV6xYm5xaV56XrJ+bmbGIHxefrf4egdjLdvfdQ7xMjEwXiIUYKDWUmE98vujCQh
        3pTEyqrUovz4otKc1OJDjNIcLErivC+jJsYLCaQnlqRmp6YWpBbBZJk4OKUamCJkDuj/OZ/0
        63DgqrNnE2cH8qzzrClWZktL3MsrLnJhd+ZE2Uu/JvNHPZp+413cMrVliqFNvyddOZv/ofHu
        63jDQ4fSz2q6c22babXl48yn3za2S2bNrxW4fi6kN/XJBJ9zJ3l+Zdqw2DI6HUqZcGTrjhrt
        qybb1x/zfSKa43fYJWbWo+mvO177dk/ZepRlvbK2Sfs0a+P9M7nqdaV//lgqucT2lODy5qw8
        mW3fvsn4nTfQCz7Cc/XCFYEA381l05tWpex//DUsM2765cC5YoqMIsn8dU9ybq576WCplWbk
        6PUzZ42YzS77F/dTzr8K0WMznd2RIjtH+9/bIz8Vnj4wXfk9jEs/U2fD2oS6e++VWIozEg21
        mIuKEwFzxNfbPgMAAA==
X-CMS-MailID: 20220429182036uscas1p2bcc8b7a11f758d77f348e5f6d6df3e1c
CMS-TYPE: 301P
X-CMS-RootMailID: 20220429004738uscas1p1cbf243fac53143fc0843b682a78130ff
References: <20220429004705.260034-1-ammarfaizi2@gnuweeb.org>
        <CGME20220429004738uscas1p1cbf243fac53143fc0843b682a78130ff@uscas1p1.samsung.com>
        <20220429004705.260034-4-ammarfaizi2@gnuweeb.org>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

> -----Original Message-----
> From: Ammar Faizi [mailto:ammarfaizi2@gnuweeb.org]
> Sent: Thursday, April 28, 2022 8:47 PM
> To: Jens Axboe <axboe@kernel.dk>
> Cc: Ammar Faizi <ammarfaizi2@gnuweeb.org>; Alviro Iskandar Setiawan
> <alviro.iskandar@gnuweeb.org>; Niklas Cassel
> <Niklas.Cassel@wdc.com>; fio Mailing List <fio@vger.kernel.org>;
> GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
> Subject: [PATCH v1 3/8] engines/net: Add ENOMEM handling on a
> `malloc()` call
>=20
> From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
>=20
> Replace `malloc()` + `memset()` with `calloc()` to simplify the call.
> `calloc()` zeroes the allocated memory, so we can avoid `memset()`.
> Also, handle the `ENOMEM` case.
>=20
> Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
> ---
>  engines/net.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
>=20
> diff --git a/engines/net.c b/engines/net.c
> index c6cec584..24c1463d 100644
> --- a/engines/net.c
> +++ b/engines/net.c
> @@ -1370,9 +1370,9 @@ static int fio_netio_setup(struct thread_data
> *td)
>  	}
>=20
>  	if (!td->io_ops_data) {
> -		nd =3D malloc(sizeof(*nd));
> -
> -		memset(nd, 0, sizeof(*nd));
> +		nd =3D calloc(1, sizeof(*nd));
> +		if (!nd)
> +			return 1;
>  		nd->listenfd =3D -1;
>  		nd->pipes[0] =3D nd->pipes[1] =3D -1;
>  		td->io_ops_data =3D nd;
> @@ -1391,7 +1391,8 @@ static int fio_netio_setup_splice(struct
> thread_data *td)
>  {
>  	struct netio_data *nd;
>=20
> -	fio_netio_setup(td);
> +	if (fio_netio_setup(td))
> +		return 1;
>=20
>  	nd =3D td->io_ops_data;
>  	if (nd) {
> --
> Ammar Faizi


Looks good.

Reviewed-by: Vincent Fu <vincent.fu@samsung.net>
