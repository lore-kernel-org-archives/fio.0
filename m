Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 615EAC433EF
	for <fio@archiver.kernel.org>; Fri, 29 Apr 2022 18:20:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230109AbiD2SXa (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 29 Apr 2022 14:23:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379945AbiD2SX2 (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 29 Apr 2022 14:23:28 -0400
Received: from mailout2.w2.samsung.com (mailout2.w2.samsung.com [211.189.100.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4166FD0A93
        for <fio@vger.kernel.org>; Fri, 29 Apr 2022 11:20:06 -0700 (PDT)
Received: from uscas1p2.samsung.com (unknown [182.198.245.207])
        by mailout2.w2.samsung.com (KnoxPortal) with ESMTP id 20220429182005usoutp02da7545435c03606eb0f08c8ae3182f4b~qcPO7jdR_1658616586usoutp02s;
        Fri, 29 Apr 2022 18:20:05 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w2.samsung.com 20220429182005usoutp02da7545435c03606eb0f08c8ae3182f4b~qcPO7jdR_1658616586usoutp02s
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1651256405;
        bh=uXDT59feP9VMyzO2IaZorSTuqE2P/2NKO07zhVLHgOU=;
        h=From:To:CC:Subject:Date:In-Reply-To:References:From;
        b=lTpgrPrPda/hL0dXjZQX0sCUZdCWI2sSoPTRCUh0iSulWyWcMX36/ohLMLPzX36JJ
         Q59pD9ssHrIxuy1e4e50dLCknAat69Dr+cSAjaOq3T2D3134HKKAvH59HIMopXIP8S
         hbpOXDkQUnNNuU1kqh93XyCT6Lw/1zz02n5DVKh4=
Received: from ussmges3new.samsung.com (u112.gpu85.samsung.co.kr
        [203.254.195.112]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
        20220429182005uscas1p2b207fb2397feb9660011e79caffe3a3e~qcPOvRpzR0834508345uscas1p2l;
        Fri, 29 Apr 2022 18:20:05 +0000 (GMT)
Received: from uscas1p2.samsung.com ( [182.198.245.207]) by
        ussmges3new.samsung.com (USCPEMTA) with SMTP id E5.35.09749.55C2C626; Fri,
        29 Apr 2022 14:20:05 -0400 (EDT)
Received: from ussmgxs2new.samsung.com (u91.gpu85.samsung.co.kr
        [203.254.195.91]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
        20220429182004uscas1p208700c8d1b934acd53921c0cf801b87a~qcPOXM5y63178231782uscas1p26;
        Fri, 29 Apr 2022 18:20:04 +0000 (GMT)
X-AuditID: cbfec370-a6bff70000002615-2c-626c2c553d3e
Received: from SSI-EX4.ssi.samsung.com ( [105.128.2.146]) by
        ussmgxs2new.samsung.com (USCPEXMTA) with SMTP id 56.34.09672.45C2C626; Fri,
        29 Apr 2022 14:20:04 -0400 (EDT)
Received: from SSI-EX3.ssi.samsung.com (105.128.2.228) by
        SSI-EX4.ssi.samsung.com (105.128.2.229) with Microsoft SMTP Server
        (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
        15.1.2375.7; Fri, 29 Apr 2022 11:20:04 -0700
Received: from SSI-EX3.ssi.samsung.com ([105.128.5.228]) by
        SSI-EX3.ssi.samsung.com ([105.128.5.228]) with mapi id 15.01.2375.007; Fri,
        29 Apr 2022 11:20:04 -0700
From:   Vincent Fu <vincent.fu@samsung.com>
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>, Jens Axboe <axboe@kernel.dk>
CC:     Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Niklas Cassel <Niklas.Cassel@wdc.com>,
        fio Mailing List <fio@vger.kernel.org>,
        "GNU/Weeb Mailing List" <gwml@vger.gnuweeb.org>
Subject: RE: [PATCH v1 1/8] cgroup: Add ENOMEM handling on a `malloc()` call
Thread-Topic: [PATCH v1 1/8] cgroup: Add ENOMEM handling on a `malloc()`
        call
Thread-Index: AQHYW2K7yRQ8Gy4g4EqOqM5pbsS0O60HJh5w
Date:   Fri, 29 Apr 2022 18:20:03 +0000
Message-ID: <23ffd48630dd404395218d4b3051d159@samsung.com>
In-Reply-To: <20220429004705.260034-2-ammarfaizi2@gnuweeb.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [105.128.2.176]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBKsWRmVeSWpSXmKPExsWy7djX87qhOjlJBm83clnc+u1lceP3WiaL
        1Xf72Sw+znrBbHHm7k4Wiwd/HrM7sHkcmLaD1ePy2VKP1kObmTw+b5LzaD/QzRTAGsVlk5Ka
        k1mWWqRvl8CVMeWeecF37orfp26wNzCe5+xi5OSQEDCR2NH5lKWLkYtDSGAlo8TL7XuYQRJC
        Aq1MEpdXs8MULfl1Cyq+llGiYwkrRMNHRokHR9ayQzjLGCX+Nv1m6mLk4GAT0JR4u78ApEFE
        wF1i0qnXYA3MAvsYJVZs+84CkhAW8JFY2POBEaLIX6LxyQ4mCNtIYmfvKrBtLAKqEj/+zgWL
        8wpYSVy78ocNxOYUsJNYufsmWC+jgJjE91NrwGqYBcQlbj2ZzwRxtaDEotkQ30gA1fzb9ZAN
        wlaUuP/9JTtEvY7Egt2f2CBsbYllC18zQ+wSlDg58wkLRL2kxMEVN8BBJCFwhENi3b6rUINc
        JD7t74SypSX+3l3GBFHUzigxd+MXqO4JjBLXn0hB2NYS/zqvQW3mk/j76xHjBEblWUgOn4Xk
        qFlIjpqF5KgFjCyrGMVLi4tz01OLjfNSy/WKE3OLS/PS9ZLzczcxAhPP6X+HC3Yw3rr1Ue8Q
        IxMH4yFGCQ5mJRHeL7szkoR4UxIrq1KL8uOLSnNSiw8xSnOwKInzLsvckCgkkJ5YkpqdmlqQ
        WgSTZeLglGpgWuk8canHsVc1WzR+vb1bGVZ42OKHFmdgSobp1D5NlemuTtdXVfb/mNu9+s6t
        Lr73DKecrSalym4T76z68XP28/76d65u925t2+C908772aKLjfW3mRvLq+Xf+OvM5Ghr0nja
        F68o2nFE56PIJa8UrmW37jvPt57zYfOiTu1va7qUb23z+Sl2YJpI9+lzV/cl7ogRKlojuW9n
        2KIJl5ffXqTsY3xNY5nQF2+lIO60ytkXr95teMLglPZaSdRsa+GE6N5PxTvvXHp3e+2BjWyn
        b+umrv3TXbD9x/e9K6xmVX5+f3LRjSv8nDff1CTcq406fvyPtr37pMjdc25VeWvZ/pv7/+Rd
        oRV1d3Mlc+x2rp6gxFKckWioxVxUnAgAuh9bVqsDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFIsWRmVeSWpSXmKPExsWS2cA0STdEJyfJYMktA4tbv70sbvxey2Sx
        +m4/m8XHWS+YLc7c3cli8eDPY3YHNo8D03awelw+W+rRemgzk8fnTXIe7Qe6mQJYo7hsUlJz
        MstSi/TtErgyptwzL/jOXfH71A32BsbznF2MnBwSAiYSS37dYu5i5OIQEljNKHFm5Tco5yOj
        xN+fW9lAqoQEljFKvD1R2sXIwcEmoCnxdn8BSFhEwF1i0qnXrCD1zAL7GCVWbPvOApIQFvCR
        WNjzgRGiyFeid8VtZgjbSGJn7yowm0VAVeLH37lMIDavgJXEtSt/2CAWH2WUuPtjMViCU8BO
        YuXum2CDGAXEJL6fWgMWZxYQl7j1ZD4TxAsCEkv2nGeGsEUlXj7+xwphK0rc//6SHaJeR2LB
        7k9sELa2xLKFr5khFgtKnJz5hAWiXlLi4IobLBMYxWchWTELSfssJO2zkLQvYGRZxSheWlyc
        m15RbJSXWq5XnJhbXJqXrpecn7uJERidp/8djt7BePvWR71DjEwcjIcYJTiYlUR4v+zOSBLi
        TUmsrEotyo8vKs1JLT7EKM3BoiTO+zJqYryQQHpiSWp2ampBahFMlomDU6qBaar1hv4Qnqun
        ePasun2Umauq/MHqn4mu2x0tmxZtYoyXWSnXlrVqScwRzu2TFl1h2bRVZ37fxzPXJ00/bMiu
        asiyQ2FOWVLISVWuNZOE42cc+DFn1nqT1ZV7Hi772iX0mvGOZuFBWeMvkUeUt01OmDhn3/mE
        5ivHSh/vex5xbd6Ees3elDbtG8nyr2rc/3D2yOnKJu2SihRfVX46I+G3ryCDz49utsNvf6wP
        q9t9o/HL532KfUzemyXFI4Km5rRlGflYibyaXnjz7XemhsjZCV8XbHIsPSQ5P74tM+pox7SY
        oxuP6f2Mn7LiSJk9o+JmC0dWGbb1zI23cq47y6fy/buaOouldXPJ9//pX3i2+CmxFGckGmox
        FxUnAgA9Rvx5PQMAAA==
X-CMS-MailID: 20220429182004uscas1p208700c8d1b934acd53921c0cf801b87a
CMS-TYPE: 301P
X-CMS-RootMailID: 20220429004739uscas1p2ac8b689eb5ab7b0e8da9f6bdfdcc3ce7
References: <20220429004705.260034-1-ammarfaizi2@gnuweeb.org>
        <CGME20220429004739uscas1p2ac8b689eb5ab7b0e8da9f6bdfdcc3ce7@uscas1p2.samsung.com>
        <20220429004705.260034-2-ammarfaizi2@gnuweeb.org>
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
> Subject: [PATCH v1 1/8] cgroup: Add ENOMEM handling on a `malloc()`
> call
>=20
> From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
>=20
> Avoid a NULL pointer dereference bug when `ENOMEM`.
>=20
> Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>

Looks good.

Reviewed-by: Vincent Fu <vincent.fu@samsung.net>

> ---
>  cgroup.c | 4 ++++
>  1 file changed, 4 insertions(+)
>=20
> diff --git a/cgroup.c b/cgroup.c
> index 77e31a4d..b559b70f 100644
> --- a/cgroup.c
> +++ b/cgroup.c
> @@ -114,6 +114,8 @@ void cgroup_kill(struct flist_head *clist)
>  static char *get_cgroup_root(struct thread_data *td, struct cgroup_mnt
> *mnt)
>  {
>  	char *str =3D malloc(64);
> +	if (!str)
> +		return NULL;
>=20
>  	if (td->o.cgroup)
>  		sprintf(str, "%s/%s", mnt->path, td->o.cgroup);
> @@ -178,6 +180,8 @@ int cgroup_setup(struct thread_data *td, struct
> flist_head *clist, struct cgroup
>  	 * Create container, if it doesn't exist
>  	 */
>  	root =3D get_cgroup_root(td, *mnt);
> +	if (!root)
> +		return 1;
>  	if (mkdir(root, 0755) < 0) {
>  		int __e =3D errno;
>=20
> --
> Ammar Faizi

