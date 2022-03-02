Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD298C433EF
	for <fio@archiver.kernel.org>; Wed,  2 Mar 2022 15:28:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243454AbiCBP2x (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 2 Mar 2022 10:28:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243455AbiCBP2w (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 2 Mar 2022 10:28:52 -0500
Received: from mailout1.w2.samsung.com (mailout1.w2.samsung.com [211.189.100.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F0B921E2B
        for <fio@vger.kernel.org>; Wed,  2 Mar 2022 07:28:08 -0800 (PST)
Received: from uscas1p1.samsung.com (unknown [182.198.245.206])
        by mailout1.w2.samsung.com (KnoxPortal) with ESMTP id 20220302152806usoutp01888d7ee0c925c80e14219681d37713a5~YmehHas5q0392603926usoutp01g;
        Wed,  2 Mar 2022 15:28:06 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w2.samsung.com 20220302152806usoutp01888d7ee0c925c80e14219681d37713a5~YmehHas5q0392603926usoutp01g
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1646234886;
        bh=6WFfig8fnL5XFgx7MumPUlVFR7PSvZ5lODb+DRK48I0=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=glAQEL0x5d5g1fbWR+ES0HbK0Qwwx98f2t1FTfVTUO8JzSe7y15mo0tJc1Inh0wDw
         1YZW8D2vX23Gid/hQgLh/vyBtDQzSx5Xzcy4Bc5YLvYlfxTifQGgf14RoPzcztPfeL
         THiaNzhym70L7KAms+E8q35GycAxS2KoBVYfHpdc=
Received: from ussmges2new.samsung.com (u111.gpu85.samsung.co.kr
        [203.254.195.111]) by uscas1p1.samsung.com (KnoxPortal) with ESMTP id
        20220302152806uscas1p163b0807f170342b93210f4da0ffba987~Ymeg7Mlpm0816508165uscas1p15;
        Wed,  2 Mar 2022 15:28:06 +0000 (GMT)
Received: from uscas1p1.samsung.com ( [182.198.245.206]) by
        ussmges2new.samsung.com (USCPEMTA) with SMTP id EB.1E.10104.60D8F126; Wed, 
        2 Mar 2022 10:28:06 -0500 (EST)
Received: from ussmgxs3new.samsung.com (u92.gpu85.samsung.co.kr
        [203.254.195.92]) by uscas1p1.samsung.com (KnoxPortal) with ESMTP id
        20220302152806uscas1p15ec3066c15b2e0d2ce9974e37d80ee2a~Ymegh0dVd0816508165uscas1p14;
        Wed,  2 Mar 2022 15:28:06 +0000 (GMT)
X-AuditID: cbfec36f-2fdff70000002778-e5-621f8d06631e
Received: from SSI-EX3.ssi.samsung.com ( [105.128.2.146]) by
        ussmgxs3new.samsung.com (USCPEXMTA) with SMTP id 73.75.09657.50D8F126; Wed, 
        2 Mar 2022 10:28:05 -0500 (EST)
Received: from SSI-EX3.ssi.samsung.com (105.128.2.228) by
        SSI-EX3.ssi.samsung.com (105.128.2.228) with Microsoft SMTP Server
        (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
        15.1.2242.4; Wed, 2 Mar 2022 07:27:03 -0800
Received: from SSI-EX3.ssi.samsung.com ([fe80::8d80:5816:c578:8c36]) by
        SSI-EX3.ssi.samsung.com ([fe80::8d80:5816:c578:8c36%3]) with mapi id
        15.01.2242.008; Wed, 2 Mar 2022 07:27:03 -0800
From:   Vincent Fu <vincent.fu@samsung.com>
To:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "martin.steigerwald@proact.de" <martin.steigerwald@proact.de>,
        "sandeen@redhat.com" <sandeen@redhat.com>
Subject: RE: [PATCH] docs: generate manpage from README and HOWTO
Thread-Topic: [PATCH] docs: generate manpage from README and HOWTO
Thread-Index: AQHYLklUIgBa7/P1o0S8kmRIpYZxRaysNw9g
Date:   Wed, 2 Mar 2022 15:27:03 +0000
Message-ID: <41bcb630c61d4ecd965654d328e95c96@samsung.com>
In-Reply-To: <20220302152122.64596-1-vincent.fu@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [105.128.2.176]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmleLIzCtJLcpLzFFi42LZduzrOV22Xvkkg4eHxC1W3+1ns/g46wWz
        xaGjvSwW07c4OrB4XD5b6nHq10d2j/f7rrJ5fN4kF8ASxWWTkpqTWZZapG+XwJVx7tc25oIO
        jorbv/+yNjAeYuti5OSQEDCR2DfzMXsXIxeHkMBKRomVLctYIJxWJom+6+uZYarO919gBLGF
        BNYySvx4HgRR9IFR4saHs6wQzn5Gib83tjJ1MXJwsAloSrzdXwASFxE4xChxb/sysH3CAo4S
        7z5sZAWxRQScJJ79fsMGYRtJrJw5EyzOIqAi0b79PxOIzStgJbHg4zd2EJtTwEbi0v6fYDaj
        gJjE91NrwGqYBcQlbj2ZzwRxqaDEotl7oK4Wk/i36yHUn4oS97+/ZIeo15FYsPsTG4StLbFs
        4WtmiF2CEidnPmGBqJeUOLjiBjgoJATmckicfjqdHSLhInFu/X0oW1pi+prLUEWTGSW+brvP
        BuGsZpR4ueASI0SVtcS/zmtQq/kk/v56xAgKIgkBXomONqEJjEqzkDwxC8mBs5AcOAvJgQsY
        WVYxipcWF+empxYb5aWW6xUn5haX5qXrJefnbmIEppfT/w7n72C8fuuj3iFGJg5GYARwMCuJ
        8IpbyycJ8aYkVlalFuXHF5XmpBYfYpTmYFES512WuSFRSCA9sSQ1OzW1ILUIJsvEwSnVwOR7
        3mDnlx5BickpXAvDV/6+8ZXLTtBdayG/vLbdhd4Xzx2e5c1w3izttbgsddqsU7o5/5eYPdj9
        z8u0JvXer7Lkgok9JXlvf56++9r3gt+z8DuPvpr+c3q5cnWjwO/2FAUfz1MpPxvMdNdLMr34
        GR00290l2NZ8m8bNM+IOuzhMa189ecyh7PlE23j5uziXT843Dr++c+PnLYXTDR0snAWrrhby
        SjHtkP/GobMoMXqtkevO+Ykro3qac/M79vhmTJvgyV0Un8CkNj30RWbAF7Z9R62FX3sec3pi
        epNjvVo8m2CAufbb96xqf80rrOSv3XSWniwb+SX/9Jd3JQ/iBZSstwqaqnEetX+1rCnZXIml
        OCPRUIu5qDgRAIsy9JKeAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnkeLIzCtJLcpLzFFi42LJbGCapMvWK59kMMPEYvXdfjaLj7NeMFsc
        OtrLYjF9i6MDi8fls6Uep359ZPd4v+8qm8fnTXIBLFFcNimpOZllqUX6dglcGed+bWMu6OCo
        uP37L2sD4yG2LkZODgkBE4nz/RcYuxi5OIQEVjNK/Jl6mgXC+QDk7LnKBuHsZ5RYfOMkaxcj
        BwebgKbE2/0FIHERgUOMEve2LwMbJSzgKPHuw0ZWEFtEwEni2e83bBC2kcTKmTPB4iwCKhLt
        2/8zgdi8AlYSCz5+YwexhQSsJa4dbAar5xSwkbi0/ydYnFFATOL7qTVg9cwC4hK3nsxngjhb
        QGLJnvPMELaoxMvH/1ghbEWJ+99fskPU60gs2P2JDcLWlli28DUzxF5BiZMzn7BA1EtKHFxx
        g2UCo9gsJCtmIWmfhaR9FpL2BYwsqxjFS4uLc9Mrio3zUsv1ihNzi0vz0vWS83M3MQLj7PS/
        wzE7GO/d+qh3iJGJgxEYVBzMSiK84tbySUK8KYmVValF+fFFpTmpxYcYpTlYlMR5PWInxgsJ
        pCeWpGanphakFsFkmTg4pRqYDLq9I9pPPn+R2p764fSy0COvtq65/iY5ZONHP+P4HttjJedq
        /vn05brMmdgZdOWGUA9vJY/cdD97TfW8I1YrQ1e+1L+jmxA0f/ZlNZ/LMy6krJq1ILLCQGp/
        /XFZhsyrnhM1/Dcv9p8defOCuH+KbdLG7WvTJG+x/iwKrcw+PH9rT+YUbekHexdPOxj2T+T2
        hlkno66c+tVwX3ylfPldVfO4M4zuN1ZUnin7/iPCe9b91rdu5SwP7/ZOPXvzgOKss09jvxbs
        m5/f4njn4M8ThzKWRq8q+5p7ouHi/vnS1n8e/tz0RuaZ52S7qE3Lp1ycspeL8Vf/q4dnXeLO
        bdoR1ys/ZfKjrj7uG9Z7Fy2QuW6nxFKckWioxVxUnAgARlsfFSIDAAA=
X-CMS-MailID: 20220302152806uscas1p15ec3066c15b2e0d2ce9974e37d80ee2a
CMS-TYPE: 301P
X-CMS-RootMailID: 20220302152806uscas1p15ec3066c15b2e0d2ce9974e37d80ee2a
References: <20220302152122.64596-1-vincent.fu@samsung.com>
        <CGME20220302152806uscas1p15ec3066c15b2e0d2ce9974e37d80ee2a@uscas1p1.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

> -----Original Message-----
> From: Vincent Fu
> Sent: Wednesday, March 2, 2022 10:22 AM
> To: fio@vger.kernel.org; axboe@kernel.dk; martin.steigerwald@proact.de;
> sandeen@redhat.com
> Cc: Vincent Fu <vincent.fu@samsung.com>
> Subject: [PATCH] docs: generate manpage from README and HOWTO
>=20
> We have a longstanding problem where fio documentation updates must be
> made to both the HOWTO and manpage.
>=20
> Here is a solution that generates a manpage from the README and HOWTO
> using Sphinx.
>=20
> The downside to being able to maintain only one version of the
> documentation is that this will cause a bit of trouble for those who pack=
age
> fio and users building fio without Sphinx support will no longer have a
> manpage.
>=20
> Does this seem like a reasonable tradeoff? If so, I will follow up with p=
atches
> to remove the original manpage and update the Sphinx-generated manpage
> to have the standard NAME, SYNOPSIS, DESCRIPTION, etc layout.
>=20

Oops, this was intended to be a RFC.
