Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FA91C25B0C
	for <fio@archiver.kernel.org>; Mon,  8 Aug 2022 17:52:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229448AbiHHRwB (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 8 Aug 2022 13:52:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243591AbiHHRwA (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 8 Aug 2022 13:52:00 -0400
Received: from mailout2.w2.samsung.com (mailout2.w2.samsung.com [211.189.100.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB2F2DF97
        for <fio@vger.kernel.org>; Mon,  8 Aug 2022 10:51:55 -0700 (PDT)
Received: from uscas1p2.samsung.com (unknown [182.198.245.207])
        by mailout2.w2.samsung.com (KnoxPortal) with ESMTP id 20220808175150usoutp020e7b06c26366a031ec32ba885f3f0b00~JcAaAMnOm2550925509usoutp02d;
        Mon,  8 Aug 2022 17:51:50 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w2.samsung.com 20220808175150usoutp020e7b06c26366a031ec32ba885f3f0b00~JcAaAMnOm2550925509usoutp02d
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1659981110;
        bh=2rxEF6B9P53L90STtdGymGoirT8/oFfyZU7GOwqNcYg=;
        h=From:To:CC:Subject:Date:References:From;
        b=MCqbzM1lA0MxQ+1CH7nKy59Z24uB05Gv1mFWNGkMo23lfX6s4Zgblp6wPI2BHmj9W
         IL88ZpfRt8lTNlkuPMYYisPaSixm5EqJOsPvlVNJlDsxBqoN1Z/Vu3C59RZkcKvjiE
         WOmM/Or2RZRIkO+QTI3kg2e2wuZFstCB4B+bYsb4=
Received: from ussmges2new.samsung.com (u111.gpu85.samsung.co.kr
        [203.254.195.111]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
        20220808175150uscas1p26fbda72e8e92b4461a5f8e3d93d41084~JcAZ484GY0101901019uscas1p2b;
        Mon,  8 Aug 2022 17:51:50 +0000 (GMT)
Received: from uscas1p1.samsung.com ( [182.198.245.206]) by
        ussmges2new.samsung.com (USCPEMTA) with SMTP id 67.B2.09642.63D41F26; Mon, 
        8 Aug 2022 13:51:50 -0400 (EDT)
Received: from ussmgxs2new.samsung.com (u91.gpu85.samsung.co.kr
        [203.254.195.91]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
        20220808175150uscas1p29cea1de374da02264662429884c9eedf~JcAZSFa691723217232uscas1p2c;
        Mon,  8 Aug 2022 17:51:50 +0000 (GMT)
X-AuditID: cbfec36f-bfdff700000025aa-6d-62f14d3644d1
Received: from SSI-EX3.ssi.samsung.com ( [105.128.2.145]) by
        ussmgxs2new.samsung.com (USCPEXMTA) with SMTP id 1E.2A.57470.53D41F26; Mon, 
        8 Aug 2022 13:51:50 -0400 (EDT)
Received: from SSI-EX3.ssi.samsung.com (105.128.2.228) by
        SSI-EX3.ssi.samsung.com (105.128.2.228) with Microsoft SMTP Server
        (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
        15.1.2375.24; Mon, 8 Aug 2022 10:51:49 -0700
Received: from SSI-EX3.ssi.samsung.com ([105.128.5.228]) by
        SSI-EX3.ssi.samsung.com ([105.128.5.228]) with mapi id 15.01.2375.024; Mon,
        8 Aug 2022 10:51:49 -0700
From:   Vincent Fu <vincent.fu@samsung.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "fio@vger.kernel.org" <fio@vger.kernel.org>
CC:     Vincent Fu <vincent.fu@samsung.com>
Subject: [PATCH 0/1] ci: upload tagged AppVeyor installers as GitHub
 releases
Thread-Topic: [PATCH 0/1] ci: upload tagged AppVeyor installers as GitHub
        releases
Thread-Index: AQHYq0+ITAtLrBI/PEym6RyZ0BRk8g==
Date:   Mon, 8 Aug 2022 17:51:49 +0000
Message-ID: <20220808175133.37920-1-vincent.fu@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [105.128.2.176]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKIsWRmVeSWpSXmKPExsWy7djXc7pmvh+TDOb0alqsvtvPZvFx1gtm
        ByaPy2dLPT5vkgtgiuKySUnNySxLLdK3S+DKWNblWXCLraL1dT9TA+NG1i5GTg4JAROJrb+2
        ANlcHEICKxklHu34zwbhtDJJnLm1AcjhAKuau8MQIr6WUWLNmiVQHR8ZJS78X8IC4SxllDjy
        8DkrSAebgKbE2/0FICtEBMIkfj7aDraOWUBd4thGkKGcHMIC/hKnrk9kg6gJkbiyfgsLhK0n
        sXZTL1g9i4CKxM6eF4wgNq+AtUT31fPMIDajgJjE91NrmCBmikvcejKfCeIdQYlFs/cwQ9hi
        Ev92PWSDsBUl7n9/yQ5RrydxY+oUNghbW2LZwtfMEPMFJU7OfMICUS8pcXDFDbC/JAQ+skt0
        TWpkh0i4SCy50gplS0v8vbuMCaKonVFi7sYvUN0TGCWuP5GCsK0l/nVeg9rMJ/H31yNGSJDy
        SnS0CU1gVJqF5IdZSO6bheS+WUjuW8DIsopRvLS4ODc9tdgoL7Vcrzgxt7g0L10vOT93EyMw
        ZZz+dzh/B+P1Wx/1DjEycTAeYpTgYFYS4T2y9n2SEG9KYmVValF+fFFpTmrxIUZpDhYlcd5l
        mRsShQTSE0tSs1NTC1KLYLJMHJxSDUyZHLsCio1vBwrU2n2LzXrPkaxs5Xg/86O888KS5dJr
        1m6c++6mjjAvX8j2M+YHXQ+0SR5be+818+9nDrO/hj5kOTLnfdI3r7qGyJNP5rFn/F3Xevrx
        i9Quw65l081PdMc2vFKN/vfqP/NxJ1bFKTJMmm1h4lkHy/ydf3zLm1Yksr1e6DhzkarK2SjN
        5BsNqzNrXOf9cL4zseiG9JaLnfO/b/O7++TQHEG/PFvleTnx543rDkjc6ovO2TY772OzjPUD
        pfQJnA4eyzb83Xfqi99H1UmCe9jrlt9YUlLK/0TON7v9mOv6nqqzK7MzVjBZPGQ5Ol1eJP3G
        5J/sP5vZNVgsrecufeP7z21uzuvE2+VKLMUZiYZazEXFiQA4G5oriAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLLMWRmVeSWpSXmKPExsWS2cA0UdfM92OSwYzZjBar7/azWXyc9YLZ
        gcnj8tlSj8+b5AKYorhsUlJzMstSi/TtErgylnV5Ftxiq2h93c/UwLiRtYuRg0NCwERi7g7D
        LkYuDiGB1YwSy3ZOYoJwPjJKTG4/xgzhLGWUOHP3NRtIB5uApsTb/QVdjJwcIgJhEj8fbWcF
        sZkF1CWObdzABmILC/hKnF66lhGkXEQgRGLdfR+Icj2JtZt6wcpZBFQkdva8YASxeQWsJbqv
        nmcGsRkFxCS+n1rDBDFSXOLWk/lgtoSAgMSSPRA1EgKiEi8f/2OFsBUl7n9/yQ5RrydxY+oU
        NghbW2LZwtfMEPMFJU7OfMICUS8pcXDFDZYJjKKzkKyYhaR9FpL2WUjaFzCyrGIULy0uzk2v
        KDbKSy3XK07MLS7NS9dLzs/dxAiMkdP/DkfvYLx966PeIUYmDsZDjBIczEoivEfWvk8S4k1J
        rKxKLcqPLyrNSS0+xCjNwaIkzvsyamK8kEB6YklqdmpqQWoRTJaJg1Oqgcml0VtFaFNwja5M
        q+HHeA3hM6n+fde2pl4XdA847b73mIN1wWfu5AUuitceRDSFq7HO7kw3/bUufaOIw6bWzbGR
        sl2q8r3OP7jij8WLpCyz15SatdXPU3XuBWfXMzqCxv8Tzz1TfvcnN6l+i6eB45TLr2dV93Jy
        /F7zdo+h2b1CvsmCgUqNWo3fdfYlNbUXlD57OOPTUs7YfuMUpbVykm+3zfn3pMDrkFzljlYR
        l6w0nRdlhw9oaalFtVWfeqz56NHU9O8dXA+uZmTwO09Yub1W/xt31zTley+/fj3FKOJ6s72j
        dAvDsRZOrn96jr8fb9M8e83bos2tbtKavPCs9LSKyDTNTTwpUrbz868qsRRnJBpqMRcVJwIA
        gITAgQADAAA=
X-CMS-MailID: 20220808175150uscas1p29cea1de374da02264662429884c9eedf
CMS-TYPE: 301P
X-CMS-RootMailID: 20220808175150uscas1p29cea1de374da02264662429884c9eedf
References: <CGME20220808175150uscas1p29cea1de374da02264662429884c9eedf@uscas1p2.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Jens, here is a patch that should allow AppVeyor to upload Windows
installers as GitHub releases. This will require you to change the
authentication key in the patch to get it working.

Here are the steps:

- Go to https://github.com/settings/tokens and generate a GitHub token
  with public_repo scope.
- Go to https://ci.appveyor.com/tools/encrypt (and login) and encrypt
  the GitHub token from the previous step.
- Replace the token in the patch (under auth_token: secure:) with the
  one from the previous step.

To test this, push a tag for a commit on the master branch to GitHub and
we should end up with a Windows installer at
https://github.com/axboe/fio/releases

Vincent Fu (1):
  ci: upload tagged AppVeyor installers as GitHub releases

 .appveyor.yml | 13 +++++++++++++
 1 file changed, 13 insertions(+)

--=20
2.25.1
